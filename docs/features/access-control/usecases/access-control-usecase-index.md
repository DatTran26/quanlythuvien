---
type: usecase-index
feature: access-control
status: draft
updated: 2026-10-08
links:
  - docs/features/access-control/srs/access-control-spec.md
  - docs/features/access-control/srs/access-control-flows.md
---

# access-control — Use Cases Index

## Use cases

| # | Slug | Level | Status | Actor primary | Covers FR | Screens | Errors (E-*) | OQ ref | Priority | Updated |
|---|------|-------|--------|---------------|-----------|---------|--------------|--------|----------|---------|
| 1 | [uc-access-control](uc-access-control.md) | sea | draft | Người đọc/Thủ thư/Quản trị viên | FR-access-control-001..005 | access-login, forgot-password, reset-password, dashboard-home, session-expired | E-access-control-001, E-core-002, E-core-009 | OQ-access-control-001, 002 | P0 | 2026-10-08 |

## Relationships

| Type | From | To | Rationale |
|---|---|---|---|
| include | uc-checkout, uc-return, uc-fine-cash-payment và mọi UC có thao tác | uc-access-control | Mọi thao tác phải qua phiên hợp lệ và kiểm quyền |

## Nguồn dữ liệu

- FR, Error Matrix, Open Questions: `docs/features/access-control/srs/access-control-spec.md`
- Entity và vòng đời: `docs/_shared/domain/`
