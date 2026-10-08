---
type: usecase-index
feature: ops-foundation
status: draft
updated: 2026-10-08
links:
  - docs/features/ops-foundation/srs/ops-foundation-spec.md
  - docs/features/ops-foundation/srs/ops-foundation-flows.md
---

# ops-foundation — Use Cases Index

## Use cases

| # | Slug | Level | Status | Actor primary | Covers FR | Screens | Errors (E-*) | OQ ref | Priority | Updated |
|---|------|-------|--------|---------------|-----------|---------|--------------|--------|----------|---------|
| 1 | [uc-audit-capture](uc-audit-capture.md) | subfunction | draft | Hệ thống | FR-ops-foundation-001 | — | E-core-007 | OQ-core-003 | P0 | 2026-10-08 |
| 2 | [uc-backup-restore](uc-backup-restore.md) | sea | draft | Hệ thống/Owner vận hành | FR-ops-foundation-002 | — | — | OQ-ops-foundation-001, 002 | P0 | 2026-10-08 |

## Relationships

| Type | From | To | Rationale |
|---|---|---|---|
| include | Mọi UC có thao tác ghi | uc-audit-capture | Audit cùng giao dịch, audit lỗi thì thao tác lỗi |

## Nguồn dữ liệu

- FR, Error Matrix, Open Questions: `docs/features/ops-foundation/srs/ops-foundation-spec.md`
- Entity và vòng đời: `docs/_shared/domain/`
