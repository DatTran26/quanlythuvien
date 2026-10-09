package com.quanlythuvien.circulation;

import com.quanlythuvien.shared.ApiException;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.junit.jupiter.api.Assertions.assertThrows;

class CopyTransitionsTest {

    @Test
    void checkoutAndIllegalMoves() {
        assertDoesNotThrow(() -> CopyTransitions.require(CopyStatus.AVAILABLE, CopyStatus.ON_LOAN));
        assertDoesNotThrow(() -> CopyTransitions.require(CopyStatus.ON_LOAN, CopyStatus.AVAILABLE));
        assertThrows(ApiException.class, () -> CopyTransitions.require(CopyStatus.DISPOSED, CopyStatus.AVAILABLE));
        assertThrows(ApiException.class, () -> CopyTransitions.require(CopyStatus.ON_LOAN, CopyStatus.ON_LOAN));
        assertThrows(ApiException.class, () -> CopyTransitions.require(CopyStatus.LOST, CopyStatus.ON_LOAN));
    }
}
