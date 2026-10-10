package com.quanlythuvien.ops;

import com.quanlythuvien.circulation.CirculationService;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
public class MaintenanceJobs {

    private final CirculationService circulation;

    public MaintenanceJobs(CirculationService circulation) {
        this.circulation = circulation;
    }

    @Scheduled(cron = "0 15 1 * * *", zone = "Asia/Ho_Chi_Minh")
    /** Mỗi đêm quét phiếu quá hạn và nhả sách giữ hết giờ. */
    public void nightly() {
        circulation.sweepOverdue();
        circulation.releaseExpiredHolds();
    }
}
