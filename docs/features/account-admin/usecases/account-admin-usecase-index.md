---
type: usecase-index
feature: account-admin
status: draft
updated: 2026-10-08
links:
  - docs/features/account-admin/srs/account-admin-spec.md
  - docs/features/account-admin/srs/account-admin-flows.md
---

# account-admin — Use Cases Index

## Use cases

| # | Slug | Level | Status | Actor primary | Covers FR | Screens | Errors (E-*) | OQ ref | Priority | Updated |
|---|------|-------|--------|---------------|-----------|---------|--------------|--------|----------|---------|
| 1 | [uc-account-admin](uc-account-admin.md) | sea | draft | Quản trị viên/Thủ thư | FR-account-admin-001..003 | reader-list, reader-detail | E-core-001, 002, 004, 007, 008, 009 | OQ-account-admin-001 | P0/P1 | 2026-10-08 |

## Relationships

| Type | From | To | Rationale |
|---|---|---|---|
| include | uc-account-admin | uc-access-control | Phải đăng nhập và có quyền |

## Nguồn dữ liệu

- FR, Error Matrix, Open Questions: `docs/features/account-admin/srs/account-admin-spec.md`
- Entity và vòng đời: `docs/_shared/domain/`
