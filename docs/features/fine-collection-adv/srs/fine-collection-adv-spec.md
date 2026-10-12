---
type: srs
feature: fine-collection-adv
status: draft
updated: 2026-10-12
links:
  - docs/features/fine-collection-adv/brainstorms/fine-collection-adv-scope.md
  - docs/_product/prd.md
  - docs/_shared/core-spec.md
  - docs/_shared/domain/library-erd.md
  - docs/_shared/id-crosswalk-lmp.md
---

# fine-collection-adv — Software Requirements Specification

## 1. Scope

Biên nhận thu phạt in; Thủ thư miễn, điều chỉnh, đảo, hoàn tiền phạt có lý do, thẩm quyền, xác thực lại và audit; đối soát tiền thu cuối ca.

**Release:** R1B

**Ngoài phạm vi:** Thu một phần (chờ chính sách); thanh toán online (candidate R3).

## 2. Actors & Stakeholders

| Actor | Loại (người/hệ thống/ngoài) | Mục tiêu | Trong scope? |
|---|---|---|---|
| Thủ thư | người | Quản trị, duyệt ngoại lệ | Có |
| Nhân viên | người | Vận hành quầy | Có |
| Bộ phận tài chính | stakeholder | Chính sách tài chính, đối soát | Có như stakeholder |
| Hệ thống | hệ thống | Thực thi rule, job, audit, outbox | Có |

Tên vai trò và mapping với tài liệu nguồn xem `docs/_shared/core-spec.md` Mục 2.

## 3. Functional Requirements (FR)

| ID | Title | Description | Priority | Release | Verify by | Source |
|---|---|---|---|---|---|---|
| FR-fine-collection-adv-001 | Biên nhận thu phạt | In biên nhận cho khoản thu phạt với mã khoản thu duy nhất; mẫu biên nhận chờ OQ-fine-collection-adv-003. | P1 | R1B | test | Spec cũ (xem id-crosswalk-lmp) |
| FR-fine-collection-adv-002 | Miễn/điều chỉnh/hoàn tiền | Cho phép waiver, adjustment, reversal/refund có lý do, quyền và audit; partial-payment policy chờ duyệt. | P1 | R1B | test | Spec cũ (xem id-crosswalk-lmp) |
| FR-fine-collection-adv-003 | Đối soát thu ngân cuối ca | Cuối ca, hệ thống tổng hợp khoản thu của quầy; Nhân viên nhập tiền mặt thực có; lệch thì ghi sự kiện đối soát và cảnh báo vận hành; người duyệt khi lệch chờ OQ-fine-collection-adv-002. | P1 | R1B | test | DEC-D3-08; uc-fine-payment ext 6a (cũ) |

## 4. Non-Functional Requirements (NFR)

NFR dùng chung (`NFR-core-001..009` — khả dụng, toàn vẹn, phân quyền, riêng tư, audit, quầy dùng được bằng bàn phím, accessibility, log, tương thích) áp dụng cho feature này; xem `docs/_shared/core-spec.md` Mục 4.

## 5. Business Rules

| ID | Rule | Trigger | Implements FR | Source |
|---|---|---|---|---|
| BR-fine-collection-adv-001 | Người tạo khoản phạt thủ công không được tự duyệt miễn hoặc điều chỉnh cho chính khoản đó. | Miễn, điều chỉnh | FR-fine-collection-adv-002 | DEC-D3-04 (PROPOSAL) |

Rule dùng chung áp dụng: BR-core-002 (sổ phạt chỉ thêm), BR-core-003, BR-core-004 (`docs/_shared/core-spec.md` Mục 5).

## 6. Error Matrix

Lỗi dùng chung áp dụng: E-core-002, E-core-004, E-core-005, E-core-007, E-core-008, E-core-009 (`docs/_shared/core-spec.md` Mục 6). Wording xem brainstorm Mục 7.3.

## 7. Success Criteria

| ID | Outcome nghiệp vụ | Đo bằng | Mốc đạt |
|---|---|---|---|
| SC-fine-collection-adv-01 | Số dư khớp sổ | Đối chiếu số dư với tổng sự kiện | 100% khoản phạt khớp |

## 8. Data Entities (tóm tắt — chi tiết ở `docs/_shared/domain/library-erd.md`)

`Fine`, `FinancialEvent`, `AuditEvent`.

## 9. Flows (tóm tắt — chi tiết ở `srs/fine-collection-adv-flows.md`)

Miễn/điều chỉnh/đảo/hoàn; in biên nhận; đối soát cuối ca.

## 10. Screens (tóm tắt — chi tiết ở `srs/fine-collection-adv-userflow.md` và `html-wireframe/`)

`financial-events`.

## 11. Constraints, Dependencies & Assumptions

__Constraints:__

| Ràng buộc | Source / Owner |
|---|---|
| Kiểm soát tài chính là hard-stop trước GATE-GNG | DEC-D3-04 |
| Biên nhận thu phạt ở R1B | Roadmap R1A non-goal |

__Dependencies:__

| Phụ thuộc | Owner | Blocks nếu chưa sẵn |
|---|---|---|
| Chính sách tài chính | Finance | Toàn bộ feature |
| Xác thực lại | `access-control` | Tác vụ nhạy cảm |
| Ghi audit cùng giao dịch | `ops-foundation` | Mọi thao tác ghi |

__Assumptions:__

| Giả định | Invalidate nếu sai |
|---|---|
| Chỉ Thủ thư được miễn, điều chỉnh, đảo, hoàn | Ma trận quyền |

## 12. Open Questions

- [ ] OQ-fine-collection-adv-001 — Thu một phần, miễn, điều chỉnh, đảo, hoàn: chính sách và quyền? Owner: finance.
- [ ] OQ-fine-collection-adv-002 — Ai duyệt khi đối soát lệch và ngưỡng duyệt cấp cao? Owner: finance.
- [ ] OQ-fine-collection-adv-003 — Mẫu biên nhận thu phạt? Owner: vận hành.
