---
type: usecase-index
feature: trend-reports
status: draft
updated: 2026-10-08
links:
  - docs/features/trend-reports/srs/trend-reports-spec.md
  - docs/features/trend-reports/srs/trend-reports-flows.md
---

# trend-reports — Use Cases Index

## Use cases

| # | Slug | Level | Status | Actor primary | Covers FR | Screens | Errors (E-*) | OQ ref | Priority | Updated |
|---|------|-------|--------|---------------|-----------|---------|--------------|--------|----------|---------|
| 1 | [uc-trend-reports](uc-trend-reports.md) | sea | draft | Quản trị viên | FR-trend-reports-001 | report-dashboard | E-core-002, 009 | OQ-trend-reports-001 | P1 | 2026-10-08 |

## Relationships

| Type | From | To | Rationale |
|---|---|---|---|
| include | uc-trend-reports | uc-access-control | Phải đăng nhập và có quyền |

## Nguồn dữ liệu

- FR, Error Matrix, Open Questions: `docs/features/trend-reports/srs/trend-reports-spec.md`
- Entity và vòng đời: `docs/_shared/domain/`
