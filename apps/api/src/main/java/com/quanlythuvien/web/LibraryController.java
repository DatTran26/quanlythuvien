package com.quanlythuvien.web;

import com.quanlythuvien.audit.AuditLogRepository;
import com.quanlythuvien.catalog.BookCopy;
import com.quanlythuvien.catalog.CatalogService;
import com.quanlythuvien.catalog.Title;
import com.quanlythuvien.circulation.CirculationService;
import com.quanlythuvien.circulation.LendingPolicy;
import com.quanlythuvien.condition.ConditionService;
import com.quanlythuvien.condition.DamageReport;
import com.quanlythuvien.condition.DamageSeverity;
import com.quanlythuvien.fine.FineService;
import com.quanlythuvien.identity.AuthService;
import com.quanlythuvien.imports.ImportService;
import com.quanlythuvien.notification.AppNotificationRepository;
import com.quanlythuvien.report.ReportService;
import com.quanlythuvien.reservation.ReservationService;
import com.quanlythuvien.shared.ApiException;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.Clock;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Map;

@Tag(name = "library")
@RestController
@RequestMapping("/api")
public class LibraryController {

    private final CatalogService catalog;
    private final CirculationService circulation;
    private final ReservationService reservations;
    private final FineService fines;
    private final ConditionService conditions;
    private final ImportService imports;
    private final ReportService reports;
    private final AuthService auth;
    private final AppNotificationRepository notifications;
    private final AuditLogRepository auditLogs;
    private final Clock clock;

    public LibraryController(CatalogService catalog, CirculationService circulation, ReservationService reservations,
                             FineService fines, ConditionService conditions, ImportService imports, ReportService reports,
                             AuthService auth, AppNotificationRepository notifications, AuditLogRepository auditLogs, Clock clock) {
        this.catalog = catalog;
        this.circulation = circulation;
        this.reservations = reservations;
        this.fines = fines;
        this.conditions = conditions;
        this.imports = imports;
        this.reports = reports;
        this.auth = auth;
        this.notifications = notifications;
        this.auditLogs = auditLogs;
        this.clock = clock;
    }

    /** Kiểm tra API còn sống, không cần đăng nhập. */
    @GetMapping("/health")
    Map<String, String> health() {
        return Map.of("status", "ok");
    }

    /** Tìm đầu sách theo tên, tác giả hoặc ISBN. */
    @GetMapping("/titles")
    java.util.List<Title> titles(@RequestParam(defaultValue = "") String q) {
        return catalog.search(q);
    }

    /** Thêm một đầu sách mới. */
    @PostMapping("/titles")
    @PreAuthorize("hasAnyRole('STAFF','LIBRARIAN')")
    Title createTitle(@RequestBody TitleRequest request) {
        return catalog.createTitle(request.name(), request.author(), request.isbn(), request.category(),
                request.priceVnd(), request.loanable(), actor());
    }

    /** Thêm một bản sao và mã QR cho đầu sách. */
    @PostMapping("/titles/{id}/copies")
    @PreAuthorize("hasAnyRole('STAFF','LIBRARIAN')")
    BookCopy addCopy(@PathVariable long id, @RequestBody CopyRequest request) {
        return catalog.addCopy(id, request.code(), request.shelf(), actor());
    }

    /** Tra một bản sao theo mã, dùng khi quét QR hoặc nhập tay. */
    @GetMapping("/copies/by-code/{code}")
    BookCopy byCode(@PathVariable String code) {
        return catalog.requireCopy(code);
    }

    /** Xem quy định mượn hiện tại: số cuốn, số ngày, mức phạt. */
    @GetMapping("/policy")
    @PreAuthorize("hasAnyRole('STAFF','LIBRARIAN')")
    LendingPolicy policy() {
        return circulation.policy();
    }

    /** Thủ thư sửa quy định mượn. */
    @PutMapping("/policy")
    @PreAuthorize("hasRole('LIBRARIAN')")
    LendingPolicy updatePolicy(@RequestBody LendingPolicy policy) {
        return circulation.updatePolicy(policy, actor());
    }

    /** Nhân viên cho mượn một bản sao. */
    @PostMapping("/loans")
    @PreAuthorize("hasAnyRole('STAFF','LIBRARIAN')")
    CirculationService.LoanView loan(@RequestBody LoanRequest request) {
        return circulation.checkout(request.readerId(), request.copyCode(), actor());
    }

    /** Nhân viên nhận trả sách. Nếu hư thì lập báo cáo và chặn lưu thông. */
    @PostMapping("/loans/{id}/return")
    @PreAuthorize("hasAnyRole('STAFF','LIBRARIAN')")
    CirculationService.LoanView returnLoan(@PathVariable long id, @RequestBody ReturnRequest request) throws IOException {
        var loan = circulation.returnCopy(id, request.damaged(), request.severity(), request.note(), actor());
        if (request.damaged()) {
            conditions.reportOnReturn(catalog.requireCopy(loan.copyCode()).getId(), loan.readerId(),
                    request.severity(), request.note(), null, actor());
        }
        return loan;
    }

    /** Gia hạn phiếu mượn nếu còn lượt và chưa có người đặt trước. */
    @PostMapping("/loans/{id}/renew")
    CirculationService.LoanView renew(@PathVariable long id) {
        var me = auth.requireCurrent();
        return circulation.renew(id, me.getId());
    }

    /** Ghi nhận mất sách, đóng phiếu và tạo khoản bồi thường. */
    @PostMapping("/loans/{id}/lost")
    @PreAuthorize("hasAnyRole('STAFF','LIBRARIAN')")
    CirculationService.LoanView lost(@PathVariable long id) {
        return circulation.markLost(id, actor());
    }

    /** Người đọc xem các phiếu mượn của mình. */
    @GetMapping("/loans/mine")
    java.util.List<CirculationService.LoanView> myLoans() {
        return circulation.mine(actor());
    }

    /** Đặt trước đầu sách khi không còn bản sẵn sàng. */
    @PostMapping("/reservations")
    com.quanlythuvien.reservation.Reservation place(@RequestBody ReserveRequest request) {
        return reservations.place(actor(), request.titleId());
    }

    /** Người đọc xem các khoản phạt của mình. */
    @GetMapping("/fines/mine")
    java.util.List<com.quanlythuvien.fine.Fine> myFines() {
        return fines.mine(actor());
    }

    /** Nhân viên thu phạt tiền mặt và trả biên nhận. */
    @PostMapping("/fines/{id}/collect")
    @PreAuthorize("hasAnyRole('STAFF','LIBRARIAN')")
    FineService.Receipt collect(@PathVariable long id) {
        return fines.collect(id, actor());
    }

    /** Thủ thư miễn phạt, bắt buộc có lý do. */
    @PostMapping("/fines/{id}/waive")
    @PreAuthorize("hasRole('LIBRARIAN')")
    com.quanlythuvien.fine.Fine waive(@PathVariable long id, @RequestBody WaiveRequest request) {
        return fines.waive(id, request.reason(), actor());
    }

    /** Báo hư hỏng một bản sao, có thể kèm ảnh. Bản sao bị chặn mượn ngay. */
    @PostMapping(value = "/damage-reports", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @PreAuthorize("hasAnyRole('STAFF','LIBRARIAN')")
    DamageReport damage(@RequestParam long copyId, @RequestParam(required = false) DamageSeverity severity,
                        @RequestParam(required = false) String note, @RequestPart(required = false) MultipartFile photo) throws IOException {
        return conditions.report(copyId, severity, note, photo, actor());
    }

    /** Thủ thư duyệt hư hỏng: bác bỏ, đưa đi sửa, hoặc thanh lý. */
    @PostMapping("/damage-reports/{id}/disposition")
    @PreAuthorize("hasRole('LIBRARIAN')")
    DamageReport disposition(@PathVariable long id, @RequestBody DecisionRequest request) {
        return conditions.dispose(id, request.decision(), actor());
    }

    /** Đánh dấu bản sao đã sửa xong và đưa lại kho hoặc hàng chờ. */
    @PostMapping("/copies/{id}/repair-complete")
    @PreAuthorize("hasAnyRole('STAFF','LIBRARIAN')")
    BookCopy repairDone(@PathVariable long id) {
        return conditions.repairDone(id, actor());
    }

    /** Xem ảnh hư hỏng đã lưu. Chỉ nhân viên và thủ thư. */
    @GetMapping("/files/{name}")
    @PreAuthorize("hasAnyRole('STAFF','LIBRARIAN')")
    ResponseEntity<Resource> file(@PathVariable String name) {
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_TYPE, MediaType.IMAGE_JPEG_VALUE)
                .body(new FileSystemResource(conditions.photo(name)));
    }

    /** Xem trước file Excel. Có dòng sai thì báo lỗi, không ghi database. */
    @PostMapping(value = "/import/titles/dry-run", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @PreAuthorize("hasAnyRole('STAFF','LIBRARIAN')")
    ImportService.ImportPreview dryRun(@RequestPart MultipartFile file) throws IOException {
        return imports.dryRun(file.getInputStream());
    }

    /** Ghi file Excel vào kho sau khi mọi dòng đều hợp lệ. */
    @PostMapping(value = "/import/titles/commit", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @PreAuthorize("hasAnyRole('STAFF','LIBRARIAN')")
    ImportService.ImportPreview commit(@RequestPart MultipartFile file) throws IOException {
        return imports.commit(file.getInputStream(), actor());
    }

    /** Danh sách phiếu đang quá hạn. */
    @GetMapping("/reports/overdue")
    @PreAuthorize("hasAnyRole('STAFF','LIBRARIAN')")
    java.util.List<com.quanlythuvien.circulation.Loan> overdue() {
        return reports.overdue();
    }

    /** Đếm bản sao theo từng trạng thái. */
    @GetMapping("/reports/inventory")
    @PreAuthorize("hasAnyRole('STAFF','LIBRARIAN')")
    java.util.List<Object[]> inventory() {
        return reports.inventory();
    }

    /** Đếm số lượt mượn và trả trong một khoảng ngày. */
    @GetMapping("/reports/trends")
    @PreAuthorize("hasAnyRole('STAFF','LIBRARIAN')")
    Map<String, Long> trends(@RequestParam LocalDate from, @RequestParam LocalDate to) {
        return reports.trends(from, to);
    }

    /** Xuất danh sách quá hạn ra file Excel. */
    @GetMapping(value = "/reports/overdue.xlsx", produces = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
    @PreAuthorize("hasAnyRole('STAFF','LIBRARIAN')")
    byte[] overdueExcel() throws IOException {
        return reports.overdueExcel();
    }

    /** Xuất danh sách quá hạn ra file PDF. */
    @GetMapping(value = "/reports/overdue.pdf", produces = MediaType.APPLICATION_PDF_VALUE)
    @PreAuthorize("hasAnyRole('STAFF','LIBRARIAN')")
    byte[] overduePdf() throws IOException {
        return reports.overduePdf();
    }

    /** Xem thông báo của tài khoản đang đăng nhập. */
    @GetMapping("/notifications")
    java.util.List<com.quanlythuvien.notification.AppNotification> notifications() {
        return notifications.findByUserIdOrderByCreatedAtDesc(actor());
    }

    /** Đánh dấu một thông báo là đã đọc. */
    @PostMapping("/notifications/{id}/read")
    void read(@PathVariable long id) {
        var item = notifications.findById(id).orElseThrow(() -> ApiException.notFound("Không thấy thông báo"));
        if (!item.getUserId().equals(actor())) {
            throw ApiException.conflict("NOT_OWNER", "Không đọc thông báo của người khác");
        }
        item.setReadAt(LocalDateTime.now(clock));
        notifications.save(item);
    }

    /** Xem 50 dòng nhật ký thao tác mới nhất. */
    @GetMapping("/audit")
    @PreAuthorize("hasAnyRole('STAFF','LIBRARIAN')")
    java.util.List<com.quanlythuvien.audit.AuditLog> audit() {
        return auditLogs.findAllByOrderByCreatedAtDesc(PageRequest.of(0, 50));
    }

    /** Chạy tay việc quét quá hạn và nhả sách giữ hết giờ. */
    @PostMapping("/admin/jobs/overdue")
    @PreAuthorize("hasRole('LIBRARIAN')")
    Map<String, Integer> runOverdue() {
        return Map.of("marked", circulation.sweepOverdue(), "holdsReleased", circulation.releaseExpiredHolds());
    }

    /** Người đọc xem các phiếu đặt trước của mình. */
    @GetMapping("/reservations/mine")
    java.util.List<com.quanlythuvien.reservation.Reservation> myReservations() {
        return reservations.mine(actor());
    }

    /** Hủy đặt trước. Người đọc chỉ hủy được phiếu của mình. */
    @PostMapping("/reservations/{id}/cancel")
    com.quanlythuvien.reservation.Reservation cancel(@PathVariable long id) {
        var me = auth.requireCurrent();
        boolean ownerOnly = me.getRole() == com.quanlythuvien.shared.Role.READER;
        return reservations.cancel(id, me.getId(), ownerOnly);
    }

    /** Lấy id của người đang gọi API. */
    private long actor() {
        return auth.requireCurrent().getId();
    }

    public record TitleRequest(@NotBlank String name, @NotBlank String author, String isbn, String category,
                               @NotNull Integer priceVnd, boolean loanable) {
    }

    public record CopyRequest(@NotBlank String code, String shelf) {
    }

    public record LoanRequest(@NotNull Long readerId, @NotBlank String copyCode) {
    }

    public record ReturnRequest(boolean damaged, DamageSeverity severity, String note) {
    }

    public record ReserveRequest(@NotNull Long titleId) {
    }

    public record WaiveRequest(@NotBlank String reason) {
    }

    public record DecisionRequest(@NotBlank String decision) {
    }
}
