package com.quanlythuvien.identity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "reader_profile")
@Getter
@Setter
@NoArgsConstructor
public class ReaderProfile {

    @Id
    @Column(name = "user_id")
    private Long userId;

    @Column(name = "card_code", nullable = false, unique = true, length = 40)
    private String cardCode;
}
