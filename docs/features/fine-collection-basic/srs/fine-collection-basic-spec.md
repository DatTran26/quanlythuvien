---
type: srs
feature: fine-collection-basic
status: draft
updated: 2026-10-12
links:
  - docs/features/fine-collection-basic/brainstorms/fine-collection-basic-scope.md
  - docs/_product/prd.md
  - docs/_shared/core-spec.md
  - docs/_shared/domain/library-erd.md
  - docs/_shared/id-crosswalk-lmp.md
---

# fine-collection-basic — Software Requirements Specification

## 1. Scope

Nhân viên tra công nợ, thu tiền mặt tại quầy và ghi khoản thu vào sổ chỉ thêm; chống ghi trùng; hai quầy cùng thu thì quầy sau thấy số dư mới.

**Release:** R1A

**Ngoài phạm vi:** Biên nhận thu phạt in, miễn, điều chỉnh, hoàn (`fine-collection-adv`); thanh toán online (candidate R3).

## 2. Actors & Stakeholders

| Actor | Loại (người/hệ thống/ngoài) | Mục tiêu | Trong scope? |
|---|---|---|---|
| Nhân viên | người | Vận hành quầy | Có |
| Người đọc | người | Mượn, trả, theo dõi khoản mượn | Có |
| Bộ phận tài chính | stakeholder | Chính sách phạt, đối soát | Có như stakeholder |
| Hệ thống | hệ thống | Thực thi rule, job, audit, outbox | Có |

Tên vai trò và mapping với tài liệu nguồn xem `docs/_shared/core-spec.md` Mục 2.

## 3. Functional Requirements (FR)

| ID | Title | Description | Priority | Release | Verify by | Source |
|---|---|---|---|---|---|---|
| FR-fine-collection-basic-001 | Thu tiền phạt bằng tiền mặt | Nhân viên ghi nhận thu tiền mặt cho một khoản phạt: số tiền > 0 và ≤ số dư tại thời điểm ghi; khoản thu có mã duy nhất, ghi vào sổ chỉ thêm; số dư về 0 thì khoản phạt Đã thanh toán; lặp yêu cầu không ghi hai lần. | P0 | R1A | test | Spec cũ (xem id-crosswalk-lmp) |

## 4. Non-Functional Requirements (NFR)

NFR dùng chung (`NFR-core-001..009` — khả dụng, toàn vẹn, phân quyền, riêng tư, audit, quầy dùng được bằng bàn phím, accessibility, log, tương thích) áp dụng cho feature này; xem `docs/_shared/core-spec.md` Mục 4.

## 5. Business Rules

| ID | Rule | Trigger | Implements FR | Source |
|---|---|---|---|---|
| BR-fine-collection-basic-001 | Payment retry/double-submit phải dùng idempotency key và không ghi hai payment event cho cùng request. | Payment submit | FR-fine-collection-basic-001 | Spec cũ (xem id-crosswalk-lmp) |

Rule dùng chung áp dụng: BR-core-002, BR-core-003, BR-core-004 (`docs/_shared/core-spec.md` Mục 5).

## 6. Error Matrix

| Error ID | Title | Trigger | Severity | Related FR | Screen state | Recovery |
|---|---|---|---|---|---|---|
| E-fine-collection-basic-001 | Payment failed | Kênh thanh toán hoặc ghi payment thất bại | critical | FR-fine-collection-basic-001 | Payment error | Giữ nghĩa vụ, cho retry idempotent |
| E-fine-collection-basic-002 | Payment duplicate detected | Submit/click payment lặp | minor | FR-fine-collection-basic-001 | Duplicate notice | Hiển thị payment event đã ghi |

Lỗi dùng chung áp dụng: E-core-001, E-core-002, E-core-004, E-core-005, E-core-007, E-core-009 (`docs/_shared/core-spec.md` Mục 6). Wording xem brainstorm Mục 7.3.

## 7. Success Criteria

Chưa có tiêu chí đo được — bổ sung khi có số liệu nghiệp vụ.

## 8. Data Entities (tóm tắt — chi tiết ở `docs/_shared/domain/library-erd.md`)

`Fine`, `FinancialEvent`, `AuditEvent`.

## 9. Flows (tóm tắt — chi tiết ở `srs/fine-collection-basic-flows.md`)

Tra công nợ → chọn khoản → thu tiền → ghi khoản thu.

## 10. Screens (tóm tắt — chi tiết ở `srs/fine-collection-basic-userflow.md` và `html-wireframe/`)

`fine-list`, `fine-detail`, `fine-payment`.

## 11. Constraints, Dependencies & Assumptions

__Constraints:__

| Ràng buộc | Source / Owner |
|---|---|
| Thu tiền mặt tối thiểu ở R1A | DEC-P2-04 |

__Dependencies:__

| Phụ thuộc | Owner | Blocks nếu chưa sẵn |
|---|---|---|
| Sổ phạt | `overdue-fines` | Có khoản để thu |
| Ghi audit cùng giao dịch | `ops-foundation` | Mọi thao tác ghi |

__Assumptions:__

| Giả định | Invalidate nếu sai |
|---|---|
| R1A hiển thị mã khoản thu trên màn; biên nhận thu phạt in ở R1B | FR-fine-collection-adv |

## 12. Open Questions

- [ ] OQ-fine-collection-basic-001 — Có cho thu một phần không, giới hạn số lần (gắn OQ-fine-collection-adv-001)? Owner: finance.
