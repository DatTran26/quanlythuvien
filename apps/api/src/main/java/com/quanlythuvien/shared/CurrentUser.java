package com.quanlythuvien.shared;

import org.springframework.security.core.context.SecurityContextHolder;

public final class CurrentUser {

    private CurrentUser() {
    }

    /** Lấy email của người đang gọi API. */
    public static String email() {
        var authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || authentication.getPrincipal() == null) {
            throw ApiException.badRequest("UNAUTHENTICATED", "Cần đăng nhập");
        }
        return authentication.getName();
    }
}
