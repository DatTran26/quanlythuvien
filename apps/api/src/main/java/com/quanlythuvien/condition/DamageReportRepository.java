package com.quanlythuvien.condition;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface DamageReportRepository extends JpaRepository<DamageReport, Long> {

    Optional<DamageReport> findFirstByCopyIdAndStatus(Long copyId, DamageStatus status);
}
