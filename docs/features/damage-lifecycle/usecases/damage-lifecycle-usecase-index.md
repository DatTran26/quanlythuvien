---
type: usecase-index
feature: damage-lifecycle
status: draft
updated: 2026-10-12
links:
  - docs/features/damage-lifecycle/srs/damage-lifecycle-spec.md
  - docs/features/damage-lifecycle/srs/damage-lifecycle-flows.md
---

# damage-lifecycle — Use Cases Index

## Use cases

| # | Slug | Level | Status | Actor primary | Covers FR | Screens | Errors (E-*) | OQ ref | Priority | Updated |
|---|------|-------|--------|---------------|-----------|---------|--------------|--------|----------|---------|
| 1 | [uc-damage-report](uc-damage-report.md) | sea | draft | Nhân viên/Thủ thư | FR-damage-lifecycle-001, 002 | damage-report-form, damage-report-detail | E-damage-lifecycle-001, E-core-001, 003, 008 | OQ-damage-lifecycle-001, 002 | P0/P1 | 2026-10-08 |

## Relationships

| Type | From | To | Rationale |
|---|---|---|---|
| include | uc-damage-report | uc-access-control | Phải đăng nhập và có quyền |

## Nguồn dữ liệu

- FR, Error Matrix, Open Questions: `docs/features/damage-lifecycle/srs/damage-lifecycle-spec.md`
- Entity và vòng đời: `docs/_shared/domain/`
