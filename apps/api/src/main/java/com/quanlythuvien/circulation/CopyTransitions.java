package com.quanlythuvien.circulation;

import com.quanlythuvien.shared.ApiException;

import java.util.EnumMap;
import java.util.EnumSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

public final class CopyTransitions {

    private static final Map<CopyStatus, Set<CopyStatus>> ALLOWED = new EnumMap<>(CopyStatus.class);

    static {
        allow(CopyStatus.AVAILABLE, CopyStatus.ON_LOAN, CopyStatus.PENDING_REVIEW, CopyStatus.DISPOSED);
        allow(CopyStatus.ON_HOLD, CopyStatus.ON_LOAN, CopyStatus.PENDING_REVIEW, CopyStatus.AVAILABLE);
        allow(CopyStatus.ON_LOAN, CopyStatus.AVAILABLE, CopyStatus.ON_HOLD, CopyStatus.PENDING_REVIEW, CopyStatus.LOST);
        allow(CopyStatus.PENDING_REVIEW, CopyStatus.AVAILABLE, CopyStatus.IN_REPAIR, CopyStatus.DISPOSED);
        allow(CopyStatus.IN_REPAIR, CopyStatus.AVAILABLE, CopyStatus.ON_HOLD, CopyStatus.DISPOSED);
        allow(CopyStatus.LOST, CopyStatus.AVAILABLE, CopyStatus.ON_HOLD);
        allow(CopyStatus.DISPOSED);
    }

    private CopyTransitions() {
    }

    /** Cho phép hoặc từ chối một bước đổi trạng thái bản sao. */
    public static void require(CopyStatus from, CopyStatus to) {
        if (from == to && from == CopyStatus.ON_HOLD) {
            return;
        }
        if (from == to || !ALLOWED.get(from).contains(to)) {
            throw ApiException.conflict("INVALID_TRANSITION",
                    "Không chuyển bản sao từ " + from + " sang " + to);
        }
    }

    /** Khai báo các trạng thái được phép đi tới từ một trạng thái. */
    private static void allow(CopyStatus from, CopyStatus... targets) {
        ALLOWED.put(from, targets.length == 0 ? EnumSet.noneOf(CopyStatus.class) : EnumSet.copyOf(List.of(targets)));
    }
}
