---
type: srs
feature: overdue-fines
status: draft
updated: 2026-10-08
links:
  - docs/features/overdue-fines/brainstorms/overdue-fines-scope.md
  - docs/_product/prd.md
  - docs/_shared/core-spec.md
  - docs/_shared/domain/library-erd.md
  - docs/_shared/id-crosswalk-lmp.md
---

# overdue-fines — Software Requirements Specification

## 1. Scope

Job hằng ngày chuyển phiếu quá hạn, cập nhật phạt tạm tính và nhắc người đọc; mọi nghĩa vụ phạt (quá hạn, hư hỏng, mất) ghi vào sổ chỉ thêm, số dư tính từ tổng sự kiện.

**Release:** R1A

**Ngoài phạm vi:** Thu tiền (`fine-collection-basic`); miễn, điều chỉnh (`fine-collection-adv`).

## 2. Actors & Stakeholders

| Actor | Loại (người/hệ thống/ngoài) | Mục tiêu | Trong scope? |
|---|---|---|---|
| Hệ thống | hệ thống | Thực thi rule, job, audit, outbox | Có |
| Người đọc | người | Mượn, trả, theo dõi khoản mượn | Có |
| Bộ phận tài chính | stakeholder | Chính sách phạt, đối soát | Có như stakeholder |

Tên vai trò và mapping với tài liệu nguồn xem `docs/_shared/core-spec.md` Mục 2.

## 3. Functional Requirements (FR)

| ID | Title | Description | Priority | Release | Verify by | Source |
|---|---|---|---|---|---|---|
| FR-overdue-fines-001 | Ghi nhận tiền phạt | Tạo nghĩa vụ tiền phạt khi quá hạn/hư hỏng/mất theo policy; mọi thay đổi số dư là sự kiện tài chính append-only. | P0 | R1A | test | Spec cũ (xem id-crosswalk-lmp) |

## 4. Non-Functional Requirements (NFR)

NFR dùng chung (`NFR-core-001..009` — khả dụng, toàn vẹn, phân quyền, riêng tư, audit, quầy dùng được bằng bàn phím, accessibility, log, tương thích) áp dụng cho feature này; xem `docs/_shared/core-spec.md` Mục 4.

## 5. Business Rules

| ID | Rule | Trigger | Implements FR | Source |
|---|---|---|---|---|
| BR-overdue-fines-001 | Job quá hạn chạy lúc 00:05 và nhắc hạn lúc 08:00 hằng ngày; nhắc trước hạn 2 ngày, nhắc quá hạn ngày đầu rồi mỗi 3 ngày; chạy lại trong cùng kỳ không ghi phạt hay thông báo lần hai. | Job hằng ngày | FR-overdue-fines-001 | Nguồn §8 |

Rule dùng chung áp dụng: BR-core-002 (sổ phạt chỉ thêm), BR-core-003, BR-core-005 (`docs/_shared/core-spec.md` Mục 5).

## 6. Error Matrix

Lỗi dùng chung áp dụng: E-core-007 (`docs/_shared/core-spec.md` Mục 6). Wording xem brainstorm Mục 7.3.

## 7. Success Criteria

| ID | Outcome nghiệp vụ | Đo bằng | Mốc đạt |
|---|---|---|---|
| SC-overdue-fines-01 | Tài chính có thể đối soát | Event ledger đầy đủ, số dư khớp sum events | 100% financial events append-only |

## 8. Data Entities (tóm tắt — chi tiết ở `docs/_shared/domain/library-erd.md`)

`Loan`, `Fine`, `FinancialEvent`, `NotificationEvent`, `PolicyConfig`.

## 9. Flows (tóm tắt — chi tiết ở `srs/overdue-fines-flows.md`)

Job quá hạn 00:05; nhắc hạn 08:00.

## 10. Screens (tóm tắt — chi tiết ở `srs/overdue-fines-userflow.md` và `html-wireframe/`)

Không có màn riêng.

## 11. Constraints, Dependencies & Assumptions

__Constraints:__

| Ràng buộc | Source / Owner |
|---|---|
| Sự kiện tài chính chỉ thêm, không sửa xóa | BR-core-002 |

__Dependencies:__

| Phụ thuộc | Owner | Blocks nếu chưa sẵn |
|---|---|---|
| Tham số quy định | `policy-config` | Hạn mức, hạn mượn, mức phạt |
| Hàng đợi thông báo | `notification-core` | Thông báo cho người đọc |
| Ghi audit cùng giao dịch | `ops-foundation` | Mọi thao tác ghi |
| Owner theo dõi job | Vận hành | Phát hiện job không chạy |

__Assumptions:__

| Giả định | Invalidate nếu sai |
|---|---|
| Phạt tính theo ngày lịch, UTC+7; mỗi phiếu quá hạn một khoản cộng dồn | Công thức phạt |

## 12. Open Questions

- [ ] OQ-overdue-fines-001 — Mức phạt quá hạn và trần phạt chính thức (mặc định nguồn 2.000đ/ngày, trần bằng giá sách)? Owner: Thủ thư trưởng.
- [ ] OQ-overdue-fines-002 — Có thời gian ân hạn trước khi tính phạt không? Owner: Thủ thư trưởng.
