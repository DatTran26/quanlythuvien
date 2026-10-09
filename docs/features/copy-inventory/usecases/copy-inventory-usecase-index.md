---
type: usecase-index
feature: copy-inventory
status: draft
updated: 2026-10-08
links:
  - docs/features/copy-inventory/srs/copy-inventory-spec.md
  - docs/features/copy-inventory/srs/copy-inventory-flows.md
---

# copy-inventory — Use Cases Index

## Use cases

| # | Slug | Level | Status | Actor primary | Covers FR | Screens | Errors (E-*) | OQ ref | Priority | Updated |
|---|------|-------|--------|---------------|-----------|---------|--------------|--------|----------|---------|
| 1 | [uc-copy-inventory](uc-copy-inventory.md) | sea | draft | Quản trị viên | FR-copy-inventory-001..003 | copy-inventory, copy-form | E-core-001, 002, 003, 008 | OQ-copy-inventory-001, 002 | P0 | 2026-10-08 |

## Relationships

| Type | From | To | Rationale |
|---|---|---|---|
| include | uc-copy-inventory | uc-access-control | Phải đăng nhập và có quyền |

## Nguồn dữ liệu

- FR, Error Matrix, Open Questions: `docs/features/copy-inventory/srs/copy-inventory-spec.md`
- Entity và vòng đời: `docs/_shared/domain/`
