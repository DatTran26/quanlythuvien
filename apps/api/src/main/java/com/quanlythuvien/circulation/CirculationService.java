package com.quanlythuvien.circulation;

import com.quanlythuvien.audit.AuditWriter;
import com.quanlythuvien.catalog.BookCopy;
import com.quanlythuvien.catalog.BookCopyRepository;
import com.quanlythuvien.condition.DamageSeverity;
import com.quanlythuvien.fine.Fine;
import com.quanlythuvien.fine.FineReason;
import com.quanlythuvien.fine.FineRepository;
import com.quanlythuvien.fine.FineStatus;
import com.quanlythuvien.identity.AuthService;
import com.quanlythuvien.identity.UserAccount;
import com.quanlythuvien.notification.NotificationService;
import com.quanlythuvien.reservation.Reservation;
import com.quanlythuvien.reservation.ReservationRepository;
import com.quanlythuvien.reservation.ReservationStatus;
import com.quanlythuvien.shared.ApiException;
import com.quanlythuvien.shared.UserStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Clock;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.EnumSet;
import java.util.List;

@Service
public class CirculationService {

    private static final EnumSet<LoanStatus> OPEN_LOANS = EnumSet.of(LoanStatus.ACTIVE, LoanStatus.OVERDUE);

    private final BookCopyRepository copies;
    private final LoanRepository loans;
    private final LendingPolicyRepository policies;
    private final FineRepository fines;
    private final ReservationRepository reservations;
    private final AuthService authService;
    private final AuditWriter audit;
    private final NotificationService notifications;
    private final Clock clock;

    public CirculationService(BookCopyRepository copies, LoanRepository loans, LendingPolicyRepository policies,
                              FineRepository fines, ReservationRepository reservations, AuthService authService,
                              AuditWriter audit, NotificationService notifications, Clock clock) {
        this.copies = copies;
        this.loans = loans;
        this.policies = policies;
        this.fines = fines;
        this.reservations = reservations;
        this.authService = authService;
        this.audit = audit;
        this.notifications = notifications;
        this.clock = clock;
    }

    /** Lấy bộ quy định mượn đang dùng. */
    public LendingPolicy policy() {
        return policies.findById((short) 1).orElseThrow(() -> ApiException.notFound("Chưa có quy định mượn"));
    }

    @Transactional
    /** Ghi đè quy định mượn và lưu nhật ký. */
    public LendingPolicy updatePolicy(LendingPolicy incoming, long actorId) {
        LendingPolicy policy = policy();
        policy.setMaxActiveLoans(incoming.getMaxActiveLoans());
        policy.setLoanDays(incoming.getLoanDays());
        policy.setMaxRenewals(incoming.getMaxRenewals());
        policy.setRenewDays(incoming.getRenewDays());
        policy.setFinePerDayVnd(incoming.getFinePerDayVnd());
        policy.setFineBlockVnd(incoming.getFineBlockVnd());
        policy.setHoldHours(incoming.getHoldHours());
        policy.setMaxOpenReservations(incoming.getMaxOpenReservations());
        policy.setLostProcessingFeeVnd(incoming.getLostProcessingFeeVnd());
        audit.record(actorId, "POLICY_UPDATE", "policy", "1", null);
        return policy;
    }

    @Transactional
    /** Cho mượn. Từ chối nếu quá hạn, còn phạt, đủ số cuốn, hoặc bản sao không sẵn sàng. */
    public LoanView checkout(long readerId, String copyCode, long actorId) {
        LendingPolicy policy = policy();
        UserAccount reader = authService.requireReader(readerId);
        if (reader.getStatus() != UserStatus.ACTIVE) {
            throw ApiException.conflict("READER_INACTIVE", "Người đọc chưa được kích hoạt hoặc đang bị khóa");
        }
        if (loans.countByReaderIdAndStatusIn(readerId, List.of(LoanStatus.OVERDUE)) > 0) {
            throw ApiException.conflict("OVERDUE_BLOCK", "Người đọc còn sách quá hạn");
        }
        if (fines.openBalance(readerId) > 0) {
            throw ApiException.conflict("FINE_BLOCK", "Còn phạt chưa thu");
        }
        if (loans.countByReaderIdAndStatusIn(readerId, OPEN_LOANS) >= policy.getMaxActiveLoans()) {
            throw ApiException.conflict("LOAN_LIMIT", "Đã mượn đủ số cuốn");
        }
        BookCopy copy = copies.findByCode(copyCode.trim())
                .orElseThrow(() -> ApiException.notFound("Không thấy bản sao"));
        if (!copy.loanable() || !copy.getTitle().isActive()) {
            throw ApiException.conflict("NOT_LOANABLE", "Bản sao không cho mượn");
        }
        if (loans.countOpenTitle(readerId, copy.getTitle().getId(), OPEN_LOANS) > 0) {
            throw ApiException.conflict("DUPLICATE_TITLE", "Đang mượn đầu sách này");
        }
        if (copy.getStatus() == CopyStatus.ON_HOLD) {
            Reservation hold = reservations.findByHeldCopyIdAndStatus(copy.getId(), ReservationStatus.READY)
                    .orElseThrow(() -> ApiException.conflict("HOLD_MISSING", "Bản sao đang giữ nhưng không có phiếu đặt"));
            if (!hold.getReader().getId().equals(readerId)) {
                throw ApiException.conflict("HOLD_OWNER", "Bản sao đang giữ cho người đọc khác");
            }
            move(copy, CopyStatus.ON_LOAN);
            hold.setStatus(ReservationStatus.FULFILLED);
            hold.setHeldCopyId(null);
        } else {
            move(copy, CopyStatus.ON_LOAN);
        }
        LocalDateTime now = LocalDateTime.now(clock);
        Loan loan = new Loan();
        loan.setCopy(copy);
        loan.setTitle(copy.getTitle());
        loan.setReader(reader);
        loan.setStatus(LoanStatus.ACTIVE);
        loan.setBorrowedAt(now);
        loan.setDueAt(now.plusDays(policy.getLoanDays()));
        loan.setRenewCount(0);
        loans.save(loan);
        audit.record(actorId, "CHECKOUT", "loan", String.valueOf(loan.getId()), copy.getCode());
        notifications.notify(readerId, "Đã mượn sách", copy.getTitle().getName() + " hạn " + loan.getDueAt().toLocalDate());
        return view(loan);
    }

    @Transactional
    /** Nhận trả: tính phạt nếu trễ, rồi đưa bản sao về kệ, hàng chờ, hoặc chờ duyệt hư. */
    public LoanView returnCopy(long loanId, boolean damaged, DamageSeverity severity, String note, long actorId) {
        Loan loan = openLoan(loanId);
        LocalDateTime now = LocalDateTime.now(clock);
        chargeOverdue(loan, now);
        loan.setStatus(LoanStatus.RETURNED);
        loan.setReturnedAt(now);
        BookCopy copy = loan.getCopy();
        if (damaged) {
            move(copy, CopyStatus.PENDING_REVIEW);
        } else {
            settle(copy);
        }
        audit.record(actorId, "RETURN", "loan", String.valueOf(loan.getId()), damaged ? "DAMAGED" : "OK");
        notifications.notify(loan.getReader().getId(), "Đã trả sách", loan.getTitle().getName());
        return view(loan);
    }

    @Transactional
    /** Gia hạn thêm ngày. Không gia hạn khi đã quá hạn hoặc có người đang chờ. */
    public LoanView renew(long loanId, long actorId) {
        Loan loan = loans.findDetailed(loanId).orElseThrow(() -> ApiException.notFound("Không thấy phiếu mượn"));
        if (loan.getStatus() != LoanStatus.ACTIVE) {
            throw ApiException.conflict("RENEW_STATUS", "Chỉ gia hạn phiếu đang mượn, chưa quá hạn");
        }
        LendingPolicy policy = policy();
        if (loan.getRenewCount() >= policy.getMaxRenewals()) {
            throw ApiException.conflict("RENEW_LIMIT", "Đã hết lượt gia hạn");
        }
        if (reservations.existsByTitleIdAndStatus(loan.getTitle().getId(), ReservationStatus.WAITING)) {
            throw ApiException.conflict("RENEW_QUEUE", "Có người đang đặt trước đầu sách này");
        }
        loan.setDueAt(loan.getDueAt().plusDays(policy.getRenewDays()));
        loan.setRenewCount(loan.getRenewCount() + 1);
        audit.record(actorId, "RENEW", "loan", String.valueOf(loan.getId()), null);
        notifications.notify(loan.getReader().getId(), "Đã gia hạn", "Hạn mới " + loan.getDueAt().toLocalDate());
        return view(loan);
    }

    @Transactional
    /** Đóng phiếu vì mất sách và tạo khoản bồi thường. */
    public LoanView markLost(long loanId, long actorId) {
        Loan loan = openLoan(loanId);
        LendingPolicy policy = policy();
        loan.setStatus(LoanStatus.LOST);
        loan.setReturnedAt(LocalDateTime.now(clock));
        move(loan.getCopy(), CopyStatus.LOST);
        int amount = loan.getTitle().getPriceVnd() + policy.getLostProcessingFeeVnd();
        addFine(loan, FineReason.LOST, amount, "Bồi thường mất sách");
        audit.record(actorId, "LOST", "loan", String.valueOf(loan.getId()), null);
        notifications.notify(loan.getReader().getId(), "Ghi nhận mất sách", loan.getTitle().getName());
        return view(loan);
    }

    @Transactional(readOnly = true)
    /** Liệt kê phiếu mượn của một người đọc. */
    public List<LoanView> mine(long readerId) {
        return loans.findByReader(readerId).stream().map(this::view).toList();
    }

    /** Rút thông tin phiếu để trả về API, không lộ dữ liệu thừa. */
    private LoanView view(Loan loan) {
        return new LoanView(loan.getId(), loan.getReader().getId(), loan.getCopy().getCode(),
                loan.getTitle().getName(), loan.getStatus().name(), loan.getDueAt(), loan.getRenewCount());
    }

    public record LoanView(long id, long readerId, String copyCode, String titleName, String status,
                           LocalDateTime dueAt, int renewCount) {
    }

    @Transactional
    /** Đánh dấu các phiếu đến hạn thành quá hạn. */
    public int sweepOverdue() {
        LocalDateTime now = LocalDateTime.now(clock);
        List<Loan> due = loans.findByStatusAndDueAtBefore(LoanStatus.ACTIVE, now);
        for (Loan loan : due) {
            loan.setStatus(LoanStatus.OVERDUE);
            notifications.notify(loan.getReader().getId(), "Sách quá hạn", loan.getTitle().getName());
        }
        return due.size();
    }

    @Transactional
    /** Nhả bản sao đang giữ quá giờ và chuyển cho người chờ kế tiếp nếu có. */
    public int releaseExpiredHolds() {
        List<Reservation> expired = reservations.findByStatusAndReadyUntilBefore(
                ReservationStatus.READY, LocalDateTime.now(clock));
        int count = 0;
        for (Reservation reservation : expired) {
            BookCopy copy = copies.findById(reservation.getHeldCopyId()).orElse(null);
            reservation.setStatus(ReservationStatus.EXPIRED);
            reservation.setHeldCopyId(null);
            if (copy != null && copy.getStatus() == CopyStatus.ON_HOLD) {
                settle(copy);
            }
            count++;
        }
        return count;
    }

    @Transactional
    /** Chặn bản sao vì vừa bị báo hư. Nếu đang giữ chỗ thì trả người đó về hàng chờ. */
    public void blockForReview(BookCopy copy) {
        if (copy.getStatus() == CopyStatus.ON_HOLD) {
            reservations.findByHeldCopyIdAndStatus(copy.getId(), ReservationStatus.READY).ifPresent(hold -> {
                hold.setStatus(ReservationStatus.WAITING);
                hold.setHeldCopyId(null);
                hold.setReadyUntil(null);
            });
        }
        move(copy, CopyStatus.PENDING_REVIEW);
    }

    @Transactional
    /** Đổi trạng thái bản sao theo quyết định duyệt hư hỏng. */
    public void applyDisposition(BookCopy copy, CopyStatus target) {
        move(copy, target);
    }

    @Transactional
    /** Bỏ giữ một bản sao rồi xếp lại cho người chờ hoặc trả về kệ. */
    public void releaseHeldCopy(Long copyId) {
        if (copyId == null) {
            return;
        }
        copies.findById(copyId).ifPresent(copy -> {
            if (copy.getStatus() == CopyStatus.ON_HOLD) {
                settle(copy);
            }
        });
    }

    @Transactional
    /** Sửa xong: về kệ, hoặc giữ cho người đang chờ. */
    public void finishRepair(BookCopy copy) {
        if (copy.getStatus() != CopyStatus.IN_REPAIR) {
            throw ApiException.conflict("NOT_IN_REPAIR", "Bản sao không đang sửa");
        }
        settle(copy);
    }

    /** Đổi trạng thái bản sao. Trạng thái không hợp lệ thì báo lỗi. */
    public void move(BookCopy copy, CopyStatus target) {
        CopyTransitions.require(copy.getStatus(), target);
        copy.setStatus(target);
    }

    /** Sau khi sách rảnh: giữ cho người chờ lâu nhất, không có thì để sẵn sàng. */
    private void settle(BookCopy copy) {
        var next = reservations.findFirstByTitleIdAndStatusOrderByCreatedAtAsc(
                copy.getTitle().getId(), ReservationStatus.WAITING);
        if (next.isPresent()) {
            move(copy, CopyStatus.ON_HOLD);
            Reservation reservation = next.get();
            reservation.setStatus(ReservationStatus.READY);
            reservation.setHeldCopyId(copy.getId());
            reservation.setReadyUntil(LocalDateTime.now(clock).plusHours(policy().getHoldHours()));
            notifications.notify(reservation.getReader().getId(), "Sách sẵn sàng", copy.getTitle().getName());
        } else {
            move(copy, CopyStatus.AVAILABLE);
        }
    }

    /** Lấy phiếu còn mở. Phiếu đã trả hoặc mất thì không xử lý tiếp. */
    private Loan openLoan(long loanId) {
        Loan loan = loans.findDetailed(loanId).orElseThrow(() -> ApiException.notFound("Không thấy phiếu mượn"));
        if (loan.getStatus() != LoanStatus.ACTIVE && loan.getStatus() != LoanStatus.OVERDUE) {
            throw ApiException.conflict("LOAN_CLOSED", "Phiếu mượn đã đóng");
        }
        return loan;
    }

    /** Tính phạt trễ hạn một lần cho phiếu này. */
    private void chargeOverdue(Loan loan, LocalDateTime now) {
        long days = ChronoUnit.DAYS.between(loan.getDueAt().toLocalDate(), now.toLocalDate());
        if (days <= 0 || fines.existsByLoanIdAndReason(loan.getId(), FineReason.OVERDUE)) {
            return;
        }
        int amount = (int) Math.min(days * policy().getFinePerDayVnd(), loan.getTitle().getPriceVnd());
        addFine(loan, FineReason.OVERDUE, amount, "Phạt quá hạn " + days + " ngày");
    }

    /** Thêm một khoản phạt nếu số tiền lớn hơn 0 và chưa có khoản cùng lý do. */
    private void addFine(Loan loan, FineReason reason, int amount, String note) {
        if (amount <= 0 || fines.existsByLoanIdAndReason(loan.getId(), reason)) {
            return;
        }
        Fine fine = new Fine();
        fine.setLoanId(loan.getId());
        fine.setReader(loan.getReader());
        fine.setAmountVnd(amount);
        fine.setBalanceVnd(amount);
        fine.setReason(reason);
        fine.setStatus(FineStatus.OPEN);
        fine.setNote(note);
        fine.setCreatedAt(LocalDateTime.now(clock));
        fines.save(fine);
        notifications.notify(loan.getReader().getId(), "Phát sinh phạt", note);
    }
}
