---
type: usecase-index
feature: reader-onboarding
status: draft
updated: 2026-10-08
links:
  - docs/features/reader-onboarding/srs/reader-onboarding-spec.md
  - docs/features/reader-onboarding/srs/reader-onboarding-flows.md
---

# reader-onboarding — Use Cases Index

## Use cases

| # | Slug | Level | Status | Actor primary | Covers FR | Screens | Errors (E-*) | OQ ref | Priority | Updated |
|---|------|-------|--------|---------------|-----------|---------|--------------|--------|----------|---------|
| 1 | [uc-reader-onboarding](uc-reader-onboarding.md) | sea | draft | Thủ thư | FR-reader-onboarding-001 | reader-form | E-core-001, 002, 003, 004, 007 | OQ-reader-onboarding-001..003 | P0 | 2026-10-08 |

## Relationships

| Type | From | To | Rationale |
|---|---|---|---|
| include | uc-reader-onboarding | uc-access-control | Phải đăng nhập và có quyền |

## Nguồn dữ liệu

- FR, Error Matrix, Open Questions: `docs/features/reader-onboarding/srs/reader-onboarding-spec.md`
- Entity và vòng đời: `docs/_shared/domain/`
