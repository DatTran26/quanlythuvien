---
type: usecase-index
feature: lost-handling
status: draft
updated: 2026-10-12
links:
  - docs/features/lost-handling/srs/lost-handling-spec.md
  - docs/features/lost-handling/srs/lost-handling-flows.md
---

# lost-handling — Use Cases Index

## Use cases

| # | Slug | Level | Status | Actor primary | Covers FR | Screens | Errors (E-*) | OQ ref | Priority | Updated |
|---|------|-------|--------|---------------|-----------|---------|--------------|--------|----------|---------|
| 1 | [uc-lost-found](uc-lost-found.md) | sea | draft | Nhân viên | FR-lost-handling-001, 002 | lost-found | E-core-007, 008 | OQ-lost-handling-001, 002 | P0/P1 | 2026-10-08 |

## Relationships

| Type | From | To | Rationale |
|---|---|---|---|
| include | uc-lost-found | uc-access-control | Phải đăng nhập và có quyền |

## Nguồn dữ liệu

- FR, Error Matrix, Open Questions: `docs/features/lost-handling/srs/lost-handling-spec.md`
- Entity và vòng đời: `docs/_shared/domain/`
