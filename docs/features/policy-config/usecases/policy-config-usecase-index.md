---
type: usecase-index
feature: policy-config
status: draft
updated: 2026-10-08
links:
  - docs/features/policy-config/srs/policy-config-spec.md
  - docs/features/policy-config/srs/policy-config-flows.md
---

# policy-config — Use Cases Index

## Use cases

| # | Slug | Level | Status | Actor primary | Covers FR | Screens | Errors (E-*) | OQ ref | Priority | Updated |
|---|------|-------|--------|---------------|-----------|---------|--------------|--------|----------|---------|
| 1 | [uc-policy-config](uc-policy-config.md) | sea | draft | Quản trị viên | FR-policy-config-001 | admin-config | E-core-001, 002, 004, 007 | OQ-policy-config-001, 002 | P0 | 2026-10-08 |

## Relationships

| Type | From | To | Rationale |
|---|---|---|---|
| include | uc-policy-config | uc-audit-capture | Đổi cấu hình phải có audit |

## Nguồn dữ liệu

- FR, Error Matrix, Open Questions: `docs/features/policy-config/srs/policy-config-spec.md`
- Entity và vòng đời: `docs/_shared/domain/`
