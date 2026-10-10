package com.quanlythuvien.condition;

import com.quanlythuvien.audit.AuditWriter;
import com.quanlythuvien.catalog.BookCopy;
import com.quanlythuvien.catalog.BookCopyRepository;
import com.quanlythuvien.circulation.CirculationService;
import com.quanlythuvien.circulation.CopyStatus;
import com.quanlythuvien.fine.Fine;
import com.quanlythuvien.fine.FineReason;
import com.quanlythuvien.fine.FineRepository;
import com.quanlythuvien.fine.FineStatus;
import com.quanlythuvien.identity.AuthService;
import com.quanlythuvien.shared.ApiException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import javax.imageio.IIOImage;
import javax.imageio.ImageIO;
import javax.imageio.ImageWriteParam;
import javax.imageio.ImageWriter;
import javax.imageio.stream.MemoryCacheImageOutputStream;
import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Clock;
import java.time.LocalDateTime;
import java.util.Iterator;
import java.util.UUID;

@Service
public class ConditionService {

    private final BookCopyRepository copies;
    private final DamageReportRepository reports;
    private final FineRepository fines;
    private final CirculationService circulation;
    private final AuthService authService;
    private final AuditWriter audit;
    private final Clock clock;
    private final Path storageDir;

    public ConditionService(BookCopyRepository copies, DamageReportRepository reports, FineRepository fines,
                            CirculationService circulation, AuthService authService, AuditWriter audit, Clock clock,
                            @Value("${app.storage.dir}") String storageDir) {
        this.copies = copies;
        this.reports = reports;
        this.fines = fines;
        this.circulation = circulation;
        this.authService = authService;
        this.audit = audit;
        this.clock = clock;
        this.storageDir = Path.of(storageDir);
    }

    @Transactional
    /** Báo hư ngoài lúc trả. Bản sao bị chặn mượn ngay. */
    public DamageReport report(long copyId, DamageSeverity severity, String note, MultipartFile photo, long actorId) throws IOException {
        BookCopy copy = copies.findById(copyId).orElseThrow(() -> ApiException.notFound("Không thấy bản sao"));
        circulation.blockForReview(copy);
        return saveReport(copy, severity, note, photo, actorId, null);
    }

    @Transactional
    /** Ghi hư hỏng lúc trả sách và tính phạt cho người mượn nếu mức độ không phải nhẹ. */
    public DamageReport reportOnReturn(long copyId, long readerId, DamageSeverity severity, String note, MultipartFile photo, long actorId) throws IOException {
        BookCopy copy = copies.findById(copyId).orElseThrow(() -> ApiException.notFound("Không thấy bản sao"));
        DamageReport report = saveReport(copy, severity, note, photo, actorId, readerId);
        return report;
    }

    @Transactional
    /** Duyệt báo cáo: bác bỏ, đưa đi sửa, hoặc thanh lý. */
    public DamageReport dispose(long reportId, String decision, long actorId) {
        DamageReport report = reports.findById(reportId).orElseThrow(() -> ApiException.notFound("Không thấy báo cáo"));
        if (report.getStatus() != DamageStatus.PENDING) {
            throw ApiException.conflict("REPORT_CLOSED", "Báo cáo đã được xử lý");
        }
        BookCopy copy = copies.findById(report.getCopyId()).orElseThrow();
        switch (decision) {
            case "REJECT" -> {
                report.setStatus(DamageStatus.REJECTED);
                circulation.applyDisposition(copy, CopyStatus.AVAILABLE);
            }
            case "REPAIR" -> {
                report.setStatus(DamageStatus.REPAIR);
                circulation.applyDisposition(copy, CopyStatus.IN_REPAIR);
            }
            case "DISPOSE" -> {
                report.setStatus(DamageStatus.DISPOSED);
                circulation.applyDisposition(copy, CopyStatus.DISPOSED);
            }
            default -> throw ApiException.badRequest("DECISION", "Quyết định không hợp lệ");
        }
        audit.record(actorId, "DAMAGE_" + decision, "damage", String.valueOf(report.getId()), null);
        return report;
    }

    @Transactional
    /** Kết thúc sửa chữa và xếp lại bản sao. */
    public BookCopy repairDone(long copyId, long actorId) {
        BookCopy copy = copies.findById(copyId).orElseThrow(() -> ApiException.notFound("Không thấy bản sao"));
        circulation.finishRepair(copy);
        audit.record(actorId, "REPAIR_DONE", "copy", String.valueOf(copy.getId()), copy.getCode());
        return copy;
    }

    /** Lấy file ảnh đã lưu. Từ chối tên file có đường dẫn lạ. */
    public Path photo(String name) {
        if (name.contains("..") || name.contains("/") || name.contains("\\")) {
            throw ApiException.badRequest("FILE_NAME", "Tên file không hợp lệ");
        }
        Path path = storageDir.resolve(name);
        if (!Files.exists(path)) {
            throw ApiException.notFound("Không thấy ảnh");
        }
        return path;
    }

    /** Lưu báo cáo và ảnh. Có người mượn thì mới tạo phạt. */
    private DamageReport saveReport(BookCopy copy, DamageSeverity severity, String note, MultipartFile photo, long actorId, Long readerId) throws IOException {
        DamageReport report = new DamageReport();
        report.setCopyId(copy.getId());
        report.setReporterId(actorId);
        report.setStatus(DamageStatus.PENDING);
        report.setSeverity(severity == null ? DamageSeverity.LIGHT : severity);
        report.setNote(note);
        report.setCreatedAt(LocalDateTime.now(clock));
        if (photo != null && !photo.isEmpty()) {
            report.setPhotoPath(store(photo));
        }
        reports.save(report);
        if (readerId != null && report.getSeverity() != DamageSeverity.LIGHT) {
            charge(copy, report, readerId, actorId);
        }
        audit.record(actorId, "DAMAGE_REPORT", "damage", String.valueOf(report.getId()), copy.getCode());
        return report;
    }

    /** Tính tiền hư theo mức: nhẹ 0%, vừa 30%, nặng 100% giá sách. */
    private void charge(BookCopy copy, DamageReport report, long readerId, long actorId) {
        int percent = switch (report.getSeverity()) {
            case LIGHT -> 0;
            case MEDIUM -> 30;
            case HEAVY -> 100;
        };
        int amount = copy.getTitle().getPriceVnd() * percent / 100;
        if (amount <= 0) {
            return;
        }
        Fine fine = new Fine();
        fine.setReader(authService.requireReader(readerId));
        fine.setAmountVnd(amount);
        fine.setBalanceVnd(amount);
        fine.setReason(FineReason.DAMAGE);
        fine.setStatus(FineStatus.OPEN);
        fine.setNote("Hư hỏng " + report.getSeverity());
        fine.setCreatedAt(LocalDateTime.now(clock));
        fines.save(fine);
        audit.record(actorId, "DAMAGE_FINE", "fine", String.valueOf(fine.getId()), null);
    }

    /** Nén ảnh rồi lưu ra đĩa, trả về tên file. */
    private String store(MultipartFile photo) throws IOException {
        byte[] jpeg = shrink(photo.getBytes());
        Files.createDirectories(storageDir);
        String name = UUID.randomUUID() + ".jpg";
        Files.write(storageDir.resolve(name), jpeg);
        return name;
    }

    /** Thu nhỏ ảnh đến khi còn khoảng 500 KB. */
    private static byte[] shrink(byte[] source) throws IOException {
        BufferedImage image = ImageIO.read(new ByteArrayInputStream(source));
        if (image == null) {
            throw ApiException.badRequest("IMAGE", "File không phải ảnh");
        }
        BufferedImage current = image;
        float quality = 0.75f;
        byte[] encoded = encode(current, quality);
        while (encoded.length > 500_000 && (current.getWidth() > 64 || quality > 0.4f)) {
            if (encoded.length > 500_000 && current.getWidth() > 64) {
                current = scale(current, 0.7);
            } else {
                quality -= 0.1f;
            }
            encoded = encode(current, quality);
        }
        if (encoded.length > 500_000) {
            throw ApiException.badRequest("IMAGE_SIZE", "Ảnh sau nén vẫn lớn hơn 500 KB");
        }
        return encoded;
    }

    /** Thu nhỏ kích thước ảnh. */
    private static BufferedImage scale(BufferedImage source, double ratio) {
        int width = Math.max(1, (int) (source.getWidth() * ratio));
        int height = Math.max(1, (int) (source.getHeight() * ratio));
        Image scaled = source.getScaledInstance(width, height, Image.SCALE_SMOOTH);
        BufferedImage output = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
        Graphics2D graphics = output.createGraphics();
        graphics.drawImage(scaled, 0, 0, null);
        graphics.dispose();
        return output;
    }

    /** Ghi ảnh ra JPEG với chất lượng cho trước. */
    private static byte[] encode(BufferedImage image, float quality) throws IOException {
        Iterator<ImageWriter> writers = ImageIO.getImageWritersByFormatName("jpeg");
        ImageWriter writer = writers.next();
        ByteArrayOutputStream output = new ByteArrayOutputStream();
        ImageWriteParam param = writer.getDefaultWriteParam();
        param.setCompressionMode(ImageWriteParam.MODE_EXPLICIT);
        param.setCompressionQuality(quality);
        writer.setOutput(new MemoryCacheImageOutputStream(output));
        writer.write(null, new IIOImage(image, null, null), param);
        writer.dispose();
        return output.toByteArray();
    }
}
