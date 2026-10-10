package com.quanlythuvien.fine;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface FineRepository extends JpaRepository<Fine, Long> {

    boolean existsByLoanIdAndReason(Long loanId, FineReason reason);

    List<Fine> findByReaderIdOrderByCreatedAtDesc(Long readerId);

    @Query("select coalesce(sum(f.balanceVnd), 0) from Fine f where f.reader.id = :readerId and f.status = com.quanlythuvien.fine.FineStatus.OPEN")
    long openBalance(Long readerId);
}
