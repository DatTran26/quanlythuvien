---
type: usecase-index
feature: return-handling
status: draft
updated: 2026-10-12
links:
  - docs/features/return-handling/srs/return-handling-spec.md
  - docs/features/return-handling/srs/return-handling-flows.md
---

# return-handling — Use Cases Index

## Use cases

| # | Slug | Level | Status | Actor primary | Covers FR | Screens | Errors (E-*) | OQ ref | Priority | Updated |
|---|------|-------|--------|---------------|-----------|---------|--------------|--------|----------|---------|
| 1 | [uc-return](uc-return.md) | sea | draft | Nhân viên | FR-return-handling-001 | return-scan, return-result | E-core-003, 004, 006, 007, 008 | OQ-return-handling-001 | P0 | 2026-10-08 |

## Relationships

| Type | From | To | Rationale |
|---|---|---|---|
| include | uc-return | uc-access-control | Phải đăng nhập và có quyền |
| include | uc-return | uc-overdue-assessment | Trả quá hạn phải ghi phạt |
| extend | uc-damage-report | uc-return | Trả có hư hỏng |

## Nguồn dữ liệu

- FR, Error Matrix, Open Questions: `docs/features/return-handling/srs/return-handling-spec.md`
- Entity và vòng đời: `docs/_shared/domain/`
