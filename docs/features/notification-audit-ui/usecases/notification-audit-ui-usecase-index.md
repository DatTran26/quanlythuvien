---
type: usecase-index
feature: notification-audit-ui
status: draft
updated: 2026-10-12
links:
  - docs/features/notification-audit-ui/srs/notification-audit-ui-spec.md
  - docs/features/notification-audit-ui/srs/notification-audit-ui-flows.md
---

# notification-audit-ui — Use Cases Index

## Use cases

| # | Slug | Level | Status | Actor primary | Covers FR | Screens | Errors (E-*) | OQ ref | Priority | Updated |
|---|------|-------|--------|---------------|-----------|---------|--------------|--------|----------|---------|
| 1 | [uc-notification-audit-view](uc-notification-audit-view.md) | sea | draft | Mọi vai trò/Thủ thư | FR-notification-audit-ui-001..003 | audit-log, history-timeline, trung tâm thông báo | E-core-002, 009 | OQ-notification-audit-ui-001 | P1 | 2026-10-08 |

## Relationships

| Type | From | To | Rationale |
|---|---|---|---|
| include | uc-notification-audit-view | uc-access-control | Phải đăng nhập và có quyền |

## Nguồn dữ liệu

- FR, Error Matrix, Open Questions: `docs/features/notification-audit-ui/srs/notification-audit-ui-spec.md`
- Entity và vòng đời: `docs/_shared/domain/`
