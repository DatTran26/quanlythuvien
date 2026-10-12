---
type: usecase-index
feature: catalog-admin
status: draft
updated: 2026-10-12
links:
  - docs/features/catalog-admin/srs/catalog-admin-spec.md
  - docs/features/catalog-admin/srs/catalog-admin-flows.md
---

# catalog-admin — Use Cases Index

## Use cases

| # | Slug | Level | Status | Actor primary | Covers FR | Screens | Errors (E-*) | OQ ref | Priority | Updated |
|---|------|-------|--------|---------------|-----------|---------|--------------|--------|----------|---------|
| 1 | [uc-catalog-admin](uc-catalog-admin.md) | sea | draft | Thủ thư/Nhân viên | FR-catalog-admin-001..003 | catalog-search, bibliographic-detail, bibliographic-form | E-core-001, 002, 003, 004, 008 | OQ-catalog-admin-001, 002 | P0 | 2026-10-08 |

## Relationships

| Type | From | To | Rationale |
|---|---|---|---|
| include | uc-catalog-admin | uc-access-control | Phải đăng nhập và có quyền |

## Nguồn dữ liệu

- FR, Error Matrix, Open Questions: `docs/features/catalog-admin/srs/catalog-admin-spec.md`
- Entity và vòng đời: `docs/_shared/domain/`
