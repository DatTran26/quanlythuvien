---
type: wireframe-html-index
feature: reservation
status: draft
stage: draft
primary_device: mobile
device_width: 375
flow_hash: 80295690
flows: 1
screens: 4
updated: 2026-10-09
entry: reservation-wireframe.html
links:
  - docs/features/reservation/srs/reservation-userflow.md
  - docs/features/reservation/srs/reservation-spec.md
---

# HTML wireframe index — reservation

Mở [`reservation-wireframe.html`](reservation-wireframe.html) để duyệt mục lục và từng flow trong iframe.

## Inventory

| # | Flow | File | Màn hình | Số màn | Release |
|---|------|------|----------|--------|---------|
| 1 | Đặt trước trọn vòng | [`reservation-flow.html`](reservation-flow.html) | reservation-search → reservation-form → reservation-queue → reservation-pickup | 4 | R2 |

**Tổng:** 1 flow, 4 màn hình. Thứ tự màn lấy từ `srs/reservation-userflow.md` (`flow_hash: 80295690`).

## Open gates

- OQ-reservation-001 — Đặt trước thuộc R2 (DEC-P2-05) cần Product Owner duyệt. Owner: Product Owner.
- OQ-reservation-002 — Giới hạn đặt trước và thời gian giữ chính thức (mặc định nguồn 3 yêu cầu / 48 giờ)? Owner: Thủ thư trưởng.
- OQ-reservation-003 — Có thời gian ân hạn khi đến nhận sát hạn? Owner: Thủ thư trưởng.

## Sources

- `../srs/reservation-userflow.md`
- `../srs/reservation-spec.md`
