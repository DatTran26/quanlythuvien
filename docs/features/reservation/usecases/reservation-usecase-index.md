---
type: usecase-index
feature: reservation
status: draft
updated: 2026-10-08
links:
  - docs/features/reservation/srs/reservation-spec.md
  - docs/features/reservation/srs/reservation-flows.md
---

# reservation — Use Cases Index

## Use cases

| # | Slug | Level | Status | Actor primary | Covers FR | Screens | Errors (E-*) | OQ ref | Priority | Updated |
|---|------|-------|--------|---------------|-----------|---------|--------------|--------|----------|---------|
| 1 | [uc-reservation](uc-reservation.md) | sea | draft | Người đọc/Thủ thư/Hệ thống | FR-reservation-001..003 | reservation-search, reservation-form, reservation-queue, reservation-pickup | E-reservation-001, E-core-004, 005, 006, 008 | OQ-reservation-001..003 | P1 | 2026-10-08 |

## Relationships

| Type | From | To | Rationale |
|---|---|---|---|
| include | uc-reservation | uc-access-control | Phải đăng nhập |
| extend | uc-reservation | uc-checkout | Nhận sách đặt trước qua quầy mượn |

## Nguồn dữ liệu

- FR, Error Matrix, Open Questions: `docs/features/reservation/srs/reservation-spec.md`
- Entity và vòng đời: `docs/_shared/domain/`
