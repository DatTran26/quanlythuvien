---
type: usecase-index
feature: renewal
status: draft
updated: 2026-10-12
links:
  - docs/features/renewal/srs/renewal-spec.md
  - docs/features/renewal/srs/renewal-flows.md
---

# renewal — Use Cases Index

## Use cases

| # | Slug | Level | Status | Actor primary | Covers FR | Screens | Errors (E-*) | OQ ref | Priority | Updated |
|---|------|-------|--------|---------------|-----------|---------|--------------|--------|----------|---------|
| 1 | [uc-renewal](uc-renewal.md) | sea | draft | Nhân viên/Người đọc | FR-renewal-001 | renewal-result | E-core-004, 005, 006, 008 | OQ-renewal-001 | P1 | 2026-10-08 |

## Relationships

| Type | From | To | Rationale |
|---|---|---|---|
| include | uc-renewal | uc-access-control | Phải đăng nhập và có quyền |

## Nguồn dữ liệu

- FR, Error Matrix, Open Questions: `docs/features/renewal/srs/renewal-spec.md`
- Entity và vòng đời: `docs/_shared/domain/`
