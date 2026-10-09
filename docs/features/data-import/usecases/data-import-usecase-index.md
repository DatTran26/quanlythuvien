---
type: usecase-index
feature: data-import
status: draft
updated: 2026-10-08
links:
  - docs/features/data-import/srs/data-import-spec.md
  - docs/features/data-import/srs/data-import-flows.md
---

# data-import — Use Cases Index

## Use cases

| # | Slug | Level | Status | Actor primary | Covers FR | Screens | Errors (E-*) | OQ ref | Priority | Updated |
|---|------|-------|--------|---------------|-----------|---------|--------------|--------|----------|---------|
| 1 | [uc-data-import](uc-data-import.md) | sea | draft | Quản trị viên/Thủ thư | FR-data-import-001 | import-upload, import-report | E-data-import-001, E-core-002, 004, 005, 007 | OQ-data-import-001..003 | P0 | 2026-10-08 |

## Relationships

| Type | From | To | Rationale |
|---|---|---|---|
| include | uc-data-import | uc-audit-capture | Ghi lô import phải có audit |

## Nguồn dữ liệu

- FR, Error Matrix, Open Questions: `docs/features/data-import/srs/data-import-spec.md`
- Entity và vòng đời: `docs/_shared/domain/`
