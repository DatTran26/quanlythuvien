---
type: usecase-index
feature: notification-core
status: draft
updated: 2026-10-08
links:
  - docs/features/notification-core/srs/notification-core-spec.md
  - docs/features/notification-core/srs/notification-core-flows.md
---

# notification-core — Use Cases Index

## Use cases

| # | Slug | Level | Status | Actor primary | Covers FR | Screens | Errors (E-*) | OQ ref | Priority | Updated |
|---|------|-------|--------|---------------|-----------|---------|--------------|--------|----------|---------|
| 1 | [uc-notification-outbox](uc-notification-outbox.md) | subfunction | draft | Hệ thống | FR-notification-core-001 | notification-status | E-notification-core-001, 002 | OQ-notification-core-001..004 | P0 | 2026-10-08 |

## Relationships

| Type | From | To | Rationale |
|---|---|---|---|
| include | Mọi UC phát thông báo | uc-notification-outbox | Sự kiện vào hàng đợi cùng giao dịch |

## Nguồn dữ liệu

- FR, Error Matrix, Open Questions: `docs/features/notification-core/srs/notification-core-spec.md`
- Entity và vòng đời: `docs/_shared/domain/`
