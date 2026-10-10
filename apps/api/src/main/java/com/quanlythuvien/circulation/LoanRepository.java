package com.quanlythuvien.circulation;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.time.LocalDateTime;
import java.util.Collection;
import java.util.List;
import java.util.Optional;

public interface LoanRepository extends JpaRepository<Loan, Long> {

    @Query("select l from Loan l join fetch l.copy c join fetch c.title where l.id = :id")
    Optional<Loan> findDetailed(Long id);

    @Query("select l from Loan l join fetch l.copy join fetch l.title where l.reader.id = :readerId order by l.borrowedAt desc")
    List<Loan> findByReader(Long readerId);

    long countByReaderIdAndStatusIn(Long readerId, Collection<LoanStatus> statuses);

    @Query("""
            select count(l) from Loan l
            where l.reader.id = :readerId and l.title.id = :titleId and l.status in :statuses
            """)
    long countOpenTitle(Long readerId, Long titleId, Collection<LoanStatus> statuses);

    List<Loan> findByStatusAndDueAtBefore(LoanStatus status, LocalDateTime dueAt);

    @Query("""
            select l from Loan l join fetch l.reader join fetch l.copy join fetch l.title
            where l.status = com.quanlythuvien.circulation.LoanStatus.OVERDUE
            order by l.dueAt
            """)
    List<Loan> findOverdue();

    List<Loan> findByBorrowedAtBetween(LocalDateTime from, LocalDateTime to);

    List<Loan> findByReturnedAtBetween(LocalDateTime from, LocalDateTime to);
}
