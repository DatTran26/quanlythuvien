---
type: usecase-index
feature: overdue-fines
status: draft
updated: 2026-10-08
links:
  - docs/features/overdue-fines/srs/overdue-fines-spec.md
  - docs/features/overdue-fines/srs/overdue-fines-flows.md
---

# overdue-fines — Use Cases Index

## Use cases

| # | Slug | Level | Status | Actor primary | Covers FR | Screens | Errors (E-*) | OQ ref | Priority | Updated |
|---|------|-------|--------|---------------|-----------|---------|--------------|--------|----------|---------|
| 1 | [uc-overdue-assessment](uc-overdue-assessment.md) | subfunction | draft | Hệ thống | FR-overdue-fines-001 | — | E-core-007 | OQ-overdue-fines-001, 002 | P0 | 2026-10-08 |

## Relationships

| Type | From | To | Rationale |
|---|---|---|---|
| include | uc-return, uc-damage-report, uc-lost-found | uc-overdue-assessment | Mọi nghĩa vụ phạt ghi vào sổ chung |

## Nguồn dữ liệu

- FR, Error Matrix, Open Questions: `docs/features/overdue-fines/srs/overdue-fines-spec.md`
- Entity và vòng đời: `docs/_shared/domain/`
