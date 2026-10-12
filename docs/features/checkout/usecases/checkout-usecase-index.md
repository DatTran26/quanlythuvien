---
type: usecase-index
feature: checkout
status: draft
updated: 2026-10-12
links:
  - docs/features/checkout/srs/checkout-spec.md
  - docs/features/checkout/srs/checkout-flows.md
---

# checkout — Use Cases Index

## Use cases

| # | Slug | Level | Status | Actor primary | Covers FR | Screens | Errors (E-*) | OQ ref | Priority | Updated |
|---|------|-------|--------|---------------|-----------|---------|--------------|--------|----------|---------|
| 1 | [uc-checkout](uc-checkout.md) | sea | draft | Nhân viên | FR-checkout-001..003 | circulation-desk, checkout-scan, checkout-review, checkout-conflict | E-checkout-001, E-core-001, 003, 004, 005, 006, 008 | OQ-checkout-001 | P0 | 2026-10-08 |

## Relationships

| Type | From | To | Rationale |
|---|---|---|---|
| include | uc-checkout | uc-access-control | Phải đăng nhập và có quyền |
| extend | uc-reservation | uc-checkout | Nhận sách đặt trước đúng lượt (từ R2) |

## Nguồn dữ liệu

- FR, Error Matrix, Open Questions: `docs/features/checkout/srs/checkout-spec.md`
- Entity và vòng đời: `docs/_shared/domain/`
