---
type: srs
feature: return-handling
status: draft
updated: 2026-10-12
links:
  - docs/features/return-handling/brainstorms/return-handling-scope.md
  - docs/_product/prd.md
  - docs/_shared/core-spec.md
  - docs/_shared/domain/library-erd.md
  - docs/_shared/id-crosswalk-lmp.md
---

# return-handling — Software Requirements Specification

## 1. Scope

Nhân viên quét sách trả; hệ thống tìm phiếu đang mở, ghi tình trạng, đóng phiếu, ghi phạt quá hạn, chuyển bản sao về Sẵn sàng hoặc Chờ duyệt trong một giao dịch; quét lặp không tính phạt hai lần.

**Release:** R1A

**Ngoài phạm vi:** Phân bổ hàng chờ đặt trước khi trả (R2, D5 luôn 'không có hàng chờ' ở R1A — DEC-P2-05); ghi nhận mất (`lost-handling`).

## 2. Actors & Stakeholders

| Actor | Loại (người/hệ thống/ngoài) | Mục tiêu | Trong scope? |
|---|---|---|---|
| Nhân viên | người | Vận hành quầy | Có |
| Người đọc | người | Mượn, trả, theo dõi khoản mượn | Có |
| Hệ thống | hệ thống | Thực thi rule, job, audit, outbox | Có |

Tên vai trò và mapping với tài liệu nguồn xem `docs/_shared/core-spec.md` Mục 2.

## 3. Functional Requirements (FR)

| ID | Title | Description | Priority | Release | Verify by | Source |
|---|---|---|---|---|---|---|
| FR-return-handling-001 | Trả sách | Ghi nhận trả một hoặc nhiều bản sao, cập nhật trạng thái bản sao và phiếu mượn, phát hiện quá hạn/hư hỏng để tạo nghĩa vụ tiếp theo. | P0 | R1A | demo/test | Spec cũ (xem id-crosswalk-lmp) |

## 4. Non-Functional Requirements (NFR)

NFR dùng chung (`NFR-core-001..009` — khả dụng, toàn vẹn, phân quyền, riêng tư, audit, quầy dùng được bằng bàn phím, accessibility, log, tương thích) áp dụng cho feature này; xem `docs/_shared/core-spec.md` Mục 4.

## 5. Business Rules

Rule dùng chung áp dụng: BR-core-002 (sổ phạt chỉ thêm), BR-core-003, BR-core-005 (`docs/_shared/core-spec.md` Mục 5).

## 6. Error Matrix

Lỗi dùng chung áp dụng: E-core-003, E-core-004, E-core-006, E-core-007, E-core-008 (`docs/_shared/core-spec.md` Mục 6). Wording xem brainstorm Mục 7.3.

## 7. Success Criteria

| ID | Outcome nghiệp vụ | Đo bằng | Mốc đạt |
|---|---|---|---|
| SC-return-handling-01 | Hoàn tất mượn/trả tại quầy nhanh và chính xác — phần trả | Thời gian trung bình/giao dịch, tỷ lệ lỗi state | Ngưỡng cuối cùng OQ-policy-config-001; proposal: ≤2 phút/giao dịch |

## 8. Data Entities (tóm tắt — chi tiết ở `docs/_shared/domain/library-erd.md`)

`Loan`, `LoanItem`, `Copy`, `Fine`, `FinancialEvent`, `DamageReport`, `AuditEvent`, `NotificationEvent`.

## 9. Flows (tóm tắt — chi tiết ở `srs/return-handling-flows.md`)

Trả sách: quét → tìm phiếu (D1) → ghi tình trạng (D2) → đóng phiếu + phạt (D3) → bản sao (D4 hàng chờ, chỉ R2).

## 10. Screens (tóm tắt — chi tiết ở `srs/return-handling-userflow.md` và `html-wireframe/`)

`return-scan`, `return-result`. Gia hạn từ kết quả trả thuộc `renewal`.

## 11. Constraints, Dependencies & Assumptions

__Constraints:__

| Ràng buộc | Source / Owner |
|---|---|
| Thứ tự đóng phiếu và tính phạt trước khi đổi trạng thái bản sao | SRC (nguồn §6.2) — FACT |
| R1A không phân bổ hàng chờ | DEC-P2-05 |

__Dependencies:__

| Phụ thuộc | Owner | Blocks nếu chưa sẵn |
|---|---|---|
| Tạo báo cáo hư hỏng | `damage-lifecycle` | Nhánh trả hư hỏng |
| Sổ phạt | `overdue-fines` | Phạt quá hạn |
| Ghi audit cùng giao dịch | `ops-foundation` | Mọi thao tác ghi |
| Hàng đợi thông báo | `notification-core` | Thông báo cho người đọc |

__Assumptions:__

| Giả định | Invalidate nếu sai |
|---|---|
| Bản sao trả hư hỏng bị chặn lưu thông ngay (OQ-11 nguồn) | Nhánh hư hỏng |

## 12. Open Questions

- [ ] OQ-return-handling-001 — Luồng trả dựng lại (DEC-D3-02) cần domain approver duyệt. Owner: Thủ thư trưởng.
