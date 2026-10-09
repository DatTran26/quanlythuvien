---
type: wireframe-html-index
feature: notification-core
status: draft
stage: draft
primary_device: mobile
device_width: 375
flow_hash: 408ffb6b
flows: 1
screens: 1
updated: 2026-10-09
entry: notification-core-wireframe.html
links:
  - docs/features/notification-core/srs/notification-core-userflow.md
  - docs/features/notification-core/srs/notification-core-spec.md
---

# HTML wireframe index — notification-core

Mở [`notification-core-wireframe.html`](notification-core-wireframe.html) để duyệt mục lục và từng flow trong iframe.

## Inventory

| # | Flow | File | Màn hình | Số màn | Release |
|---|------|------|----------|--------|---------|
| 1 | Outbox thông báo | [`notification-status-flow.html`](notification-status-flow.html) | notification-status | 1 | R1A |

**Tổng:** 1 flow, 1 màn hình. Thứ tự màn lấy từ `srs/notification-core-userflow.md` (`flow_hash: 408ffb6b`).

## Open gates

- OQ-notification-core-001 — Kênh bắt buộc: chỉ in-app + email hay thêm kênh khác? Owner: Product Owner.
- OQ-notification-core-002 — Số lần thử lại và khoảng cách thử? Owner: vận hành.
- OQ-notification-core-003 — Danh sách sự kiện quan trọng gửi email? Owner: Product Owner.
- OQ-notification-core-004 — Ai xử lý hàng lỗi, có báo Thủ thư trực quầy (DEC-D3-08)? Owner: Thủ thư trưởng.

## Sources

- `../srs/notification-core-userflow.md`
- `../srs/notification-core-spec.md`
