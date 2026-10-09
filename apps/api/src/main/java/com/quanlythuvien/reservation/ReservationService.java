package com.quanlythuvien.reservation;

import com.quanlythuvien.audit.AuditWriter;
import com.quanlythuvien.catalog.BookCopyRepository;
import com.quanlythuvien.catalog.TitleRepository;
import com.quanlythuvien.circulation.CirculationService;
import com.quanlythuvien.circulation.CopyStatus;
import com.quanlythuvien.circulation.LendingPolicy;
import com.quanlythuvien.circulation.LendingPolicyRepository;
import com.quanlythuvien.identity.AuthService;
import com.quanlythuvien.identity.UserAccount;
import com.quanlythuvien.shared.ApiException;
import com.quanlythuvien.shared.UserStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Clock;
import java.time.LocalDateTime;
import java.util.EnumSet;
import java.util.List;

@Service
public class ReservationService {

    private static final EnumSet<ReservationStatus> OPEN = EnumSet.of(ReservationStatus.WAITING, ReservationStatus.READY);

    private final ReservationRepository reservations;
    private final TitleRepository titles;
    private final BookCopyRepository copies;
    private final LendingPolicyRepository policies;
    private final AuthService authService;
    private final AuditWriter audit;
    private final Clock clock;
    private final CirculationService circulation;

    public ReservationService(ReservationRepository reservations, TitleRepository titles, BookCopyRepository copies,
                              LendingPolicyRepository policies, AuthService authService, AuditWriter audit, Clock clock,
                              CirculationService circulation) {
        this.reservations = reservations;
        this.titles = titles;
        this.copies = copies;
        this.policies = policies;
        this.authService = authService;
        this.audit = audit;
        this.clock = clock;
        this.circulation = circulation;
    }

    /** Liệt kê đặt trước của một người đọc. */
    public List<Reservation> mine(long readerId) {
        return reservations.findByReaderIdOrderByCreatedAtDesc(readerId);
    }

    @Transactional
    /** Đặt trước khi hết bản sẵn sàng và người đọc chưa vượt số phiếu cho phép. */
    public Reservation place(long readerId, long titleId) {
        UserAccount reader = authService.requireReader(readerId);
        if (reader.getStatus() != UserStatus.ACTIVE) {
            throw ApiException.conflict("READER_INACTIVE", "Người đọc chưa được kích hoạt");
        }
        var title = titles.findById(titleId).orElseThrow(() -> ApiException.notFound("Không thấy đầu sách"));
        long available = copies.findByTitleId(titleId).stream()
                .filter(copy -> copy.getStatus() == CopyStatus.AVAILABLE && copy.loanable())
                .count();
        if (available > 0) {
            throw ApiException.conflict("STILL_AVAILABLE", "Đầu sách còn bản sẵn sàng, hãy mượn trực tiếp");
        }
        LendingPolicy policy = policies.findById((short) 1).orElseThrow();
        if (reservations.countByReaderIdAndStatusIn(readerId, OPEN) >= policy.getMaxOpenReservations()) {
            throw ApiException.conflict("RESERVE_LIMIT", "Đã đủ số đặt trước đang mở");
        }
        Reservation reservation = new Reservation();
        reservation.setTitle(title);
        reservation.setReader(reader);
        reservation.setStatus(ReservationStatus.WAITING);
        reservation.setCreatedAt(LocalDateTime.now(clock));
        reservations.save(reservation);
        audit.record(readerId, "RESERVE", "reservation", String.valueOf(reservation.getId()), title.getName());
        return reservation;
    }

    @Transactional
    /** Hủy đặt trước. Nếu sách đang giữ cho người này thì nhả bản sao. */
    public Reservation cancel(long reservationId, long actorId, boolean ownerOnly) {
        Reservation reservation = reservations.findById(reservationId).orElseThrow(() -> ApiException.notFound("Không thấy đặt trước"));
        if (ownerOnly && !reservation.getReader().getId().equals(actorId)) {
            throw ApiException.conflict("NOT_OWNER", "Không hủy đặt trước của người khác");
        }
        if (reservation.getStatus() != ReservationStatus.WAITING && reservation.getStatus() != ReservationStatus.READY) {
            throw ApiException.conflict("RESERVE_CLOSED", "Phiếu đặt trước đã đóng");
        }
        Long heldCopyId = reservation.getHeldCopyId();
        reservation.setStatus(ReservationStatus.CANCELLED);
        reservation.setHeldCopyId(null);
        reservation.setReadyUntil(null);
        circulation.releaseHeldCopy(heldCopyId);
        audit.record(actorId, "RESERVE_CANCEL", "reservation", String.valueOf(reservation.getId()), null);
        return reservation;
    }
}
