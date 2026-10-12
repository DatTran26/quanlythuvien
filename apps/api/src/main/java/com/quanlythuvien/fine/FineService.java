package com.quanlythuvien.fine;

import com.quanlythuvien.audit.AuditWriter;
import com.quanlythuvien.shared.ApiException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Clock;
import java.time.LocalDateTime;
import java.util.List;

@Service
public class FineService {

    private final FineRepository fines;
    private final AuditWriter audit;
    private final Clock clock;

    public FineService(FineRepository fines, AuditWriter audit, Clock clock) {
        this.fines = fines;
        this.audit = audit;
        this.clock = clock;
    }

    /** Liệt kê phạt của một người đọc. */
    public List<Fine> mine(long readerId) {
        return fines.findByReaderIdOrderByCreatedAtDesc(readerId);
    }

    @Transactional
    /** Thu hết số tiền còn nợ của một khoản phạt. */
    public Receipt collect(long fineId, long actorId) {
        Fine fine = open(fineId);
        int paid = fine.getBalanceVnd();
        fine.setBalanceVnd(0);
        fine.setStatus(FineStatus.PAID);
        audit.record(actorId, "FINE_COLLECT", "fine", String.valueOf(fine.getId()), String.valueOf(paid));
        return new Receipt(fine.getId(), paid, LocalDateTime.now(clock), actorId);
    }

    @Transactional
    /** Miễn phạt và ghi lý do. */
    public Fine waive(long fineId, String reason, long actorId) {
        if (reason == null || reason.isBlank()) {
            throw ApiException.badRequest("REASON_REQUIRED", "Cần lý do miễn phạt");
        }
        Fine fine = open(fineId);
        fine.setBalanceVnd(0);
        fine.setStatus(FineStatus.WAIVED);
        fine.setNote(reason.trim());
        audit.record(actorId, "FINE_WAIVE", "fine", String.valueOf(fine.getId()), reason.trim());
        return fine;
    }

    /** Lấy khoản phạt còn nợ. Khoản đã đóng thì không thu nữa. */
    private Fine open(long fineId) {
        Fine fine = fines.findById(fineId).orElseThrow(() -> ApiException.notFound("Không thấy khoản phạt"));
        if (fine.getStatus() != FineStatus.OPEN || fine.getBalanceVnd() <= 0) {
            throw ApiException.conflict("FINE_CLOSED", "Khoản phạt đã đóng");
        }
        return fine;
    }

    public record Receipt(long fineId, int amountVnd, LocalDateTime collectedAt, long collectorId) {
    }
}
