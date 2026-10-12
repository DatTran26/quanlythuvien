package com.quanlythuvien.circulation;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "lending_policy")
@Getter
@Setter
@NoArgsConstructor
public class LendingPolicy {

    @Id
    private Short id;

    @Column(name = "max_active_loans", nullable = false)
    private int maxActiveLoans;

    @Column(name = "loan_days", nullable = false)
    private int loanDays;

    @Column(name = "max_renewals", nullable = false)
    private int maxRenewals;

    @Column(name = "renew_days", nullable = false)
    private int renewDays;

    @Column(name = "fine_per_day_vnd", nullable = false)
    private int finePerDayVnd;

    @Column(name = "fine_block_vnd", nullable = false)
    private int fineBlockVnd;

    @Column(name = "hold_hours", nullable = false)
    private int holdHours;

    @Column(name = "max_open_reservations", nullable = false)
    private int maxOpenReservations;

    @Column(name = "lost_processing_fee_vnd", nullable = false)
    private int lostProcessingFeeVnd;
}
