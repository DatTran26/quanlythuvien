---
type: usecase-index
feature: reader-self-service
status: draft
updated: 2026-10-08
links:
  - docs/features/reader-self-service/srs/reader-self-service-spec.md
  - docs/features/reader-self-service/srs/reader-self-service-flows.md
---

# reader-self-service — Use Cases Index

## Use cases

| # | Slug | Level | Status | Actor primary | Covers FR | Screens | Errors (E-*) | OQ ref | Priority | Updated |
|---|------|-------|--------|---------------|-----------|---------|--------------|--------|----------|---------|
| 1 | [uc-reader-self-service](uc-reader-self-service.md) | sea | draft | Người đọc | FR-reader-self-service-001..005 | Màn tự phục vụ (thiết kế ở user-flow) | E-core-002, 008, 009 | OQ-reader-self-service-001..004 | P0/P1 | 2026-10-08 |

## Relationships

| Type | From | To | Rationale |
|---|---|---|---|
| include | uc-reader-self-service | uc-access-control | Người đọc phải đăng nhập |

## Nguồn dữ liệu

- FR, Error Matrix, Open Questions: `docs/features/reader-self-service/srs/reader-self-service-spec.md`
- Entity và vòng đời: `docs/_shared/domain/`
