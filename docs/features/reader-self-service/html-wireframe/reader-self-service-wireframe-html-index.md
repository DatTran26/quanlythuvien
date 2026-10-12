---
type: wireframe-html-index
feature: reader-self-service
status: draft
stage: draft
primary_device: mobile
device_width: 375
flow_hash: 44e3cbf5
flows: 1
screens: 6
updated: 2026-10-09
entry: reader-self-service-wireframe.html
links:
  - docs/features/reader-self-service/srs/reader-self-service-userflow.md
  - docs/features/reader-self-service/srs/reader-self-service-spec.md
---

# HTML wireframe index — reader-self-service

Mở [`reader-self-service-wireframe.html`](reader-self-service-wireframe.html) để duyệt mục lục và từng flow trong iframe.

## Inventory

| # | Flow | File | Màn hình | Số màn | Release |
|---|------|------|----------|--------|---------|
| 1 | Cổng người đọc | [`reader-portal-flow.html`](reader-portal-flow.html) | reader-search → reader-bib-detail → reader-qr → reader-current-loans → reader-loan-history → reader-my-fines | 6 | R1A/R1B |

**Tổng:** 1 flow, 6 màn hình. Thứ tự màn lấy từ `srs/reader-self-service-userflow.md` (`flow_hash: 44e3cbf5`).

## Open gates

- OQ-reader-self-service-001 — Thiết bị và hình thức cổng người đọc (mobile-first hay responsive)? Owner: Product Owner.
- OQ-reader-self-service-002 — Màn công nợ R1B làm tối thiểu hay chờ cổng đầy đủ? Owner: Product Owner.
- OQ-reader-self-service-003 — Người đọc bị khóa có đăng nhập cổng được không? Owner: domain approver.
- OQ-reader-self-service-004 — Ai được xem lịch sử mượn, có tự xóa sau N năm (OQ-12 nguồn)? Owner: pháp chế.

## Sources

- `../srs/reader-self-service-userflow.md`
- `../srs/reader-self-service-spec.md`
