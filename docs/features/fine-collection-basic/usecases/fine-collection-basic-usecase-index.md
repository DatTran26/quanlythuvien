---
type: usecase-index
feature: fine-collection-basic
status: draft
updated: 2026-10-08
links:
  - docs/features/fine-collection-basic/srs/fine-collection-basic-spec.md
  - docs/features/fine-collection-basic/srs/fine-collection-basic-flows.md
---

# fine-collection-basic — Use Cases Index

## Use cases

| # | Slug | Level | Status | Actor primary | Covers FR | Screens | Errors (E-*) | OQ ref | Priority | Updated |
|---|------|-------|--------|---------------|-----------|---------|--------------|--------|----------|---------|
| 1 | [uc-fine-cash-payment](uc-fine-cash-payment.md) | sea | draft | Thủ thư | FR-fine-collection-basic-001 | fine-list, fine-detail, fine-payment | E-fine-collection-basic-001, 002, E-core-004, 005, 007, 009 | OQ-fine-collection-basic-001 | P0 | 2026-10-08 |

## Relationships

| Type | From | To | Rationale |
|---|---|---|---|
| include | uc-fine-cash-payment | uc-access-control | Phải đăng nhập và có quyền |

## Nguồn dữ liệu

- FR, Error Matrix, Open Questions: `docs/features/fine-collection-basic/srs/fine-collection-basic-spec.md`
- Entity và vòng đời: `docs/_shared/domain/`
