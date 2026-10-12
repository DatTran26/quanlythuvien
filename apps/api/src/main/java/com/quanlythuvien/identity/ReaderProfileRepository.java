package com.quanlythuvien.identity;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface ReaderProfileRepository extends JpaRepository<ReaderProfile, Long> {

    Optional<ReaderProfile> findByCardCode(String cardCode);
}
