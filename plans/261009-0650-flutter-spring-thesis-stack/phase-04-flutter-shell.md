---
title: "Phase 4: Vỏ app Flutter"
status: todo
---

# Phase 4: Vỏ app Flutter

## Overview

Một app Flutter, sau đăng nhập vào đúng khu vực Người đọc, Thủ thư hoặc Quản trị viên, gọi API HTTPS. Chưa cần đủ màn nghiệp vụ.

## Requirements

- [ ] Project `apps/mobile`, Flutter stable, tiếng Việt.
- [ ] Base URL qua `--dart-define=API_BASE_URL=https://...`. Bản release không dùng HTTP.
- [ ] Token nằm trong secure storage. Hết hạn thì về màn đăng nhập.
- [ ] Router chặn theo role trả về từ `/api/me`.
- [ ] Ba khu vực trống có tên vai trò, đủ để chứng minh phân nhánh.

## Implementation Steps

1. `flutter create` trong `apps/mobile`, bật Android và iOS.
2. Thêm HTTP client và secure storage. Một lớp API đọc `API_BASE_URL`.
3. Màn đăng nhập gọi `POST /api/auth/login` rồi `/api/me`.
4. Router ba nhánh. Deep link hoặc nút back không mở khu vực của vai trò khác.
5. Cài bản release lên điện thoại thật, base URL là domain phase 2, thử trên 4G.

## Todo

- [ ] `flutter analyze` không lỗi.
- [ ] Đăng nhập seed admin vào khu vực quản trị.
- [ ] Đăng nhập seed người đọc không thấy khu vực quản trị.
- [ ] Tắt Wi-Fi, bật 4G, đăng nhập vẫn xong.

## Success Criteria

Ảnh hoặc ghi chú diễn tập: ba tài khoản trên một điện thoại, mạng di động, mỗi tài khoản vào một khu vực. Sai mật khẩu hiện lỗi và không lưu token.

## Risk Assessment

Cleartext bị Android chặn. Nếu phase 2 chưa có HTTPS thật, phase 4 chưa được đánh dấu xong.

## Security Considerations

Không log mật khẩu hay JWT. Không nhúng secret vào app. Phân quyền UI chỉ là điều hướng. API phase 1 vẫn là chỗ từ chối.
