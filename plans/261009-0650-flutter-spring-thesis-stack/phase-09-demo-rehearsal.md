---
title: "Phase 9: Dữ liệu demo và diễn tập"
status: todo
---

# Phase 9: Dữ liệu demo và diễn tập

## Overview

Cài dữ liệu và diễn tập buổi bảo vệ trên bản release, mạng 4G, VPS đang chạy. Không thêm feature mới.

## Requirements

- [ ] Seed production-demo: ba tài khoản, vài đầu sách, bản sao có QR, một phiếu quá hạn, một khoản phạt, một bản sao hư chờ duyệt.
- [ ] Mật khẩu demo chỉ nằm trong ghi chú bảo vệ của nhóm, không commit công khai nếu repo có người lạ.
- [ ] Kịch bản 8–10 phút viết thành checklist một trang.
- [ ] Diễn tập một lần trên 4G và ghi thời gian quét QR khi server đã thức.

## Implementation Steps

1. Viết migration hoặc script seed gắn cờ profile `demo`, tách khỏi user dev local.
2. In hoặc hiện sẵn mã QR trong app để phòng camera hội đồng kém. Ô nhập tay vẫn là đường lùi.
3. Viết `deploy/demo-script.md`: đăng nhập thủ thư, quét mượn, trả quá hạn, đăng nhập người đọc xem thông báo, đăng nhập quản trị mở một báo cáo, chỉ một request 409.
4. Snapshot VPS hoặc backup dump ngay trước tuần bảo vệ.
5. Chạy checklist trên điện thoại release. Sửa lỗi kịch bản, không nhét thêm màn.

## Todo

- [ ] Script demo chạy đủ từ đầu đến 409 mà không cần gõ form tạo sách.
- [ ] Quét QR một mã seed, server đã thức, xong trong dưới 1 giây.
- [ ] Dump SQL mới nhất nằm trên volume backup.
- [ ] Ghi chú tài khoản demo nằm ngoài git nếu remote là repo dùng chung.

## Success Criteria

Một lần diễn tập ghi lại: ba vai trò, một mượn, một trả quá hạn, một báo cáo, một thao tác bị từ chối. Health check HTTPS còn 200 sau diễn tập.

## Risk Assessment

VPS chết đúng ngày bảo vệ thì không có phương án free-tier thay thế, vì cold start phá thời gian quét. Giữ dump và biết cách `docker compose up` lại từ máy mang theo.

## Security Considerations

Đổi mật khẩu seed demo nếu video bảo vệ sẽ public. Tắt đăng ký mở nếu không muốn khán giả tạo user vào hệ thống đang chiếu.
