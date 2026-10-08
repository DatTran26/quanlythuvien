---
type: wireframe-html-index
feature: checkout
status: draft
stage: draft
primary_device: mobile
device_width: 375
flow_hash: 57f70e31
flows: 1
screens: 4
updated: 2026-10-09
entry: checkout-wireframe.html
links:
  - docs/features/checkout/srs/checkout-userflow.md
  - docs/features/checkout/srs/checkout-spec.md
---

# HTML wireframe index — checkout

Mở [`checkout-wireframe.html`](checkout-wireframe.html) để duyệt mục lục và từng flow trong iframe.

## Inventory

| # | Flow | File | Màn hình | Số màn | Release |
|---|------|------|----------|--------|---------|
| 1 | Mượn tại quầy | [`checkout-flow.html`](checkout-flow.html) | circulation-desk → checkout-scan → checkout-review → checkout-conflict | 4 | R1A |

**Tổng:** 1 flow, 4 màn hình. Thứ tự màn lấy từ `srs/checkout-userflow.md` (`flow_hash: 57f70e31`).

## Open gates

- OQ-checkout-001 — Khổ giấy và loại máy in biên nhận tại quầy? Owner: vận hành.

## Sources

- `../srs/checkout-userflow.md`
- `../srs/checkout-spec.md`
