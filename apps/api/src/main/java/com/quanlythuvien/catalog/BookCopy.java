package com.quanlythuvien.catalog;

import com.quanlythuvien.circulation.CopyStatus;
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
import jakarta.persistence.Version;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "book_copy")
@Getter
@Setter
@NoArgsConstructor
public class BookCopy {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "title_id", nullable = false)
    private Title title;

    @Column(nullable = false, unique = true, length = 64)
    private String code;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 32)
    private CopyStatus status;

    @Column(length = 80)
    private String shelf;

    @Column(name = "loanable_override")
    private Boolean loanableOverride;

    @Version
    @Column(nullable = false)
    private long version;

    /** Bản sao có được mượn không. Không ghi riêng thì theo đầu sách. */
    public boolean loanable() {
        if (loanableOverride != null) {
            return loanableOverride;
        }
        return title.isLoanable();
    }
}
