---
type: wireframe-html-index
feature: access-control
status: draft
stage: draft
primary_device: mobile
device_width: 375
flow_hash: d00261d8
flows: 1
screens: 5
updated: 2026-10-12
entry: access-control-wireframe.html
links:
  - docs/features/access-control/srs/access-control-userflow.md
  - docs/features/access-control/srs/access-control-spec.md
---

# HTML wireframe index — access-control

Mở [`access-control-wireframe.html`](access-control-wireframe.html) để duyệt mục lục và từng flow trong iframe.

## Inventory

| # | Flow | File | Màn hình | Số màn | Release |
|---|------|------|----------|--------|---------|
| 1 | Xác thực và điều hướng | [`auth-flow.html`](auth-flow.html) | access-login → forgot-password → reset-password → dashboard-home → session-expired | 5 | R0 |

**Tổng:** 1 flow, 5 màn hình. Thứ tự màn và chuyển màn lấy từ `srs/access-control-userflow.md` (`flow_hash: d00261d8`).

## Open gates

- OQ-access-control-001: Mô hình danh tính: tài khoản nội bộ, SSO hay dịch vụ danh tính ngoài?
- OQ-access-control-002: Ngưỡng đăng nhập sai, thời gian khóa tạm, thời lượng phiên, hiệu lực link đặt lại mật khẩu?
- OQ-access-control-003: Quy tắc mật khẩu (độ dài, ký tự)?
- OQ-access-control-004: Mở khóa tạm tự động theo thời gian hay chỉ Thủ thư mở?

## Sources

- `../srs/access-control-userflow.md`
- `../srs/access-control-spec.md`
- `../usecases/access-control-usecase-index.md`
