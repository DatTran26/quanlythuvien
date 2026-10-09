package com.quanlythuvien.circulation;

import com.quanlythuvien.catalog.BookCopy;
import com.quanlythuvien.catalog.Title;
import com.quanlythuvien.identity.UserAccount;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@Entity
@Table(name = "loan")
@Getter
@Setter
@NoArgsConstructor
public class Loan {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "copy_id", nullable = false)
    private BookCopy copy;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "title_id", nullable = false)
    private Title title;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "reader_id", nullable = false)
    private UserAccount reader;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private LoanStatus status;

    @Column(name = "borrowed_at", nullable = false)
    private LocalDateTime borrowedAt;

    @Column(name = "due_at", nullable = false)
    private LocalDateTime dueAt;

    @Column(name = "returned_at")
    private LocalDateTime returnedAt;

    @Column(name = "renew_count", nullable = false)
    private int renewCount;
}
