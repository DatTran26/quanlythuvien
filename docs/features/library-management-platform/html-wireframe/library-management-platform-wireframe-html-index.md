---
type: wireframe-html-index
feature: library-management-platform
stage: draft
primary_device: mobile
device_width: 375
flow_hash: c4d1b86d
flows: 11
screens: 38
updated: 2026-10-08
entry: library-management-platform-wireframe.html
---

# HTML wireframe index — Library Management Platform

Mở [`library-management-platform-wireframe.html`](library-management-platform-wireframe.html) để duyệt mục lục, flow map và từng wireframe trong iframe. Không dùng file flow rời làm cửa-vào chính.

## Inventory

| # | Flow | File | Canonical screens | Số màn | Release / trạng thái |
|---|------|------|-------------------|--------|----------------------|
| 1 | Xác thực và điều hướng | [`auth-flow.html`](auth-flow.html) | access-login → forgot-password → reset-password → dashboard-home → session-expired | 5 | R0 |
| 2 | Danh mục và bản sao | [`catalog-admin-flow.html`](catalog-admin-flow.html) | catalog-search → bibliographic-detail → bibliographic-form → copy-inventory → copy-form | 5 | R0 |
| 3 | Quản lý người đọc | [`reader-admin-flow.html`](reader-admin-flow.html) | reader-list → reader-form → reader-detail | 3 | R1B; OQ-LMP-016 còn mở |
| 4 | Checkout tại quầy | [`checkout-flow.html`](checkout-flow.html) | circulation-desk → checkout-scan → checkout-review → checkout-conflict | 4 | R1A |
| 5 | Trả và gia hạn | [`return-renewal-flow.html`](return-renewal-flow.html) | return-scan → return-result → renewal-result | 3 | R1A/R1B |
| 6 | Đặt trước | [`reservation-flow.html`](reservation-flow.html) | reservation-search → reservation-form → reservation-queue → reservation-pickup | 4 | R2 / PROPOSAL |
| 7 | Công nợ và thanh toán | [`fine-payment-flow.html`](fine-payment-flow.html) | fine-list → fine-detail → fine-payment → financial-events | 4 | R1A/R1B; policy OQ-LMP-005 |
| 8 | Hư hỏng, mất và tìm lại | [`damage-lost-found-flow.html`](damage-lost-found-flow.html) | damage-report-form → damage-report-detail → lost-found | 3 | R1A/R1B |
| 9 | Thông báo và audit | [`notification-audit-flow.html`](notification-audit-flow.html) | notification-status → audit-log → history-timeline | 3 | R1A/R1B |
| 10 | Cấu hình và import | [`admin-import-flow.html`](admin-import-flow.html) | admin-config → import-upload → import-report | 3 | R0; OQ-LMP-002/018 còn mở |
| 11 | Báo cáo vận hành | [`reports-flow.html`](reports-flow.html) | report-dashboard | 1 | R1A/R2; OQ-LMP-017 còn mở |

**Tổng:** 11 flow, 38 màn hình. Screen order và transition lấy từ `srs/library-management-platform-userflow.md` (`stage: flow-approved`, `flow_hash: c4d1b86d`).

## Rendering contract

- Khung thiết bị: Mobile 375 theo quyết định người dùng và canonical userflow.
- HTML self-contained, đen trắng; mỗi screen có `id="sN"` và nhãn screen canonical.
- Mỗi flow có breadcrumb quay về cửa-vào; breadcrumb tự ẩn khi flow được nhúng trong iframe.
- Mỗi flow có một bảng mô tả 5 cột: `# / Items / Control type / Data type / Description`.
- Nội dung chưa có nguồn được giữ dưới dạng `Open`, `OQ-*` hoặc `PROPOSAL`; wireframe không tự duyệt policy.

## Open gates

- OQ-LMP-002: representative Excel source và mapping schema.
- OQ-LMP-005: chính sách fine nâng cao.
- OQ-LMP-015/016: reader portal và owner/release của reader self-service.
- OQ-LMP-017: quyền Thủ thư quầy xem reports.
- OQ-LMP-018: approver, điều kiện và evidence của import override.

Các gate trên không ngăn việc review layout nhưng ngăn tuyên bố business baseline/go-live ready.

## Sources

- `../srs/library-management-platform-userflow.md`
- `../srs/library-management-platform-spec.md`
- `../usecases/library-management-platform-usecase-index.md`
- `../usecases/uc-admin-import.md`
