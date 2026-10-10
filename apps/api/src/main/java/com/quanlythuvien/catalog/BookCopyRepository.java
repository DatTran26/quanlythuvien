package com.quanlythuvien.catalog;

import com.quanlythuvien.circulation.CopyStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface BookCopyRepository extends JpaRepository<BookCopy, Long> {

    @Query("select c from BookCopy c join fetch c.title where c.code = :code")
    Optional<BookCopy> findByCode(String code);

    boolean existsByCode(String code);

    long countByTitleIdAndStatus(Long titleId, CopyStatus status);

    List<BookCopy> findByTitleId(Long titleId);

    @Query("select c.status, count(c) from BookCopy c group by c.status")
    List<Object[]> countByStatus();
}
