---
type: usecase-index
feature: ops-reports
status: draft
updated: 2026-10-12
links:
  - docs/features/ops-reports/srs/ops-reports-spec.md
  - docs/features/ops-reports/srs/ops-reports-flows.md
---

# ops-reports — Use Cases Index

## Use cases

| # | Slug | Level | Status | Actor primary | Covers FR | Screens | Errors (E-*) | OQ ref | Priority | Updated |
|---|------|-------|--------|---------------|-----------|---------|--------------|--------|----------|---------|
| 1 | [uc-ops-reports](uc-ops-reports.md) | sea | draft | Thủ thư/Nhân viên | FR-ops-reports-001, 002 | report-dashboard | E-core-002, 009 | OQ-ops-reports-001, 002 | P0/P1 | 2026-10-08 |

## Relationships

| Type | From | To | Rationale |
|---|---|---|---|
| include | uc-ops-reports | uc-access-control | Phải đăng nhập và có quyền |

## Nguồn dữ liệu

- FR, Error Matrix, Open Questions: `docs/features/ops-reports/srs/ops-reports-spec.md`
- Entity và vòng đời: `docs/_shared/domain/`
