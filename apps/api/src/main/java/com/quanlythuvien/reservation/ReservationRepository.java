package com.quanlythuvien.reservation;

import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDateTime;
import java.util.Collection;
import java.util.List;
import java.util.Optional;

public interface ReservationRepository extends JpaRepository<Reservation, Long> {

    Optional<Reservation> findFirstByTitleIdAndStatusOrderByCreatedAtAsc(Long titleId, ReservationStatus status);

    Optional<Reservation> findByHeldCopyIdAndStatus(Long heldCopyId, ReservationStatus status);

    long countByReaderIdAndStatusIn(Long readerId, Collection<ReservationStatus> statuses);

    boolean existsByTitleIdAndStatus(Long titleId, ReservationStatus status);

    List<Reservation> findByReaderIdOrderByCreatedAtDesc(Long readerId);

    List<Reservation> findByStatusAndReadyUntilBefore(ReservationStatus status, LocalDateTime moment);
}
