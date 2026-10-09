---
type: usecase-index
feature: fine-collection-adv
status: draft
updated: 2026-10-08
links:
  - docs/features/fine-collection-adv/srs/fine-collection-adv-spec.md
  - docs/features/fine-collection-adv/srs/fine-collection-adv-flows.md
---

# fine-collection-adv — Use Cases Index

## Use cases

| # | Slug | Level | Status | Actor primary | Covers FR | Screens | Errors (E-*) | OQ ref | Priority | Updated |
|---|------|-------|--------|---------------|-----------|---------|--------------|--------|----------|---------|
| 1 | [uc-fine-adjustment](uc-fine-adjustment.md) | sea | draft | Quản trị viên/Thủ thư | FR-fine-collection-adv-001..003 | financial-events | E-core-002, 004, 005, 007, 008, 009 | OQ-fine-collection-adv-001..003 | P1 | 2026-10-08 |

## Relationships

| Type | From | To | Rationale |
|---|---|---|---|
| include | uc-fine-adjustment | uc-access-control | Xác thực lại trước thao tác tài chính |

## Nguồn dữ liệu

- FR, Error Matrix, Open Questions: `docs/features/fine-collection-adv/srs/fine-collection-adv-spec.md`
- Entity và vòng đời: `docs/_shared/domain/`
