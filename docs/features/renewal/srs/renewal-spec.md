---
type: srs
feature: renewal
status: draft
updated: 2026-10-08
links:
  - docs/features/renewal/brainstorms/renewal-scope.md
  - docs/_product/prd.md
  - docs/_shared/core-spec.md
  - docs/_shared/domain/library-erd.md
  - docs/_shared/id-crosswalk-lmp.md
---

# renewal — Software Requirements Specification

## 1. Scope

Gia hạn tại quầy (Thủ thư làm thay) và online (người đọc tự làm); chỉ gia hạn khi phiếu chưa quá hạn, còn lượt, không có người đặt trước và người đọc đủ điều kiện; từ chối nêu lý do cụ thể.

**Release:** R1B

**Ngoài phạm vi:** —

## 2. Actors & Stakeholders

| Actor | Loại (người/hệ thống/ngoài) | Mục tiêu | Trong scope? |
|---|---|---|---|
| Người đọc | người | Tự phục vụ | Có |
| Thủ thư | người | Vận hành quầy | Có |
| Hệ thống | hệ thống | Thực thi rule, job, audit, outbox | Có |

Tên vai trò và mapping với tài liệu nguồn xem `docs/_shared/core-spec.md` Mục 2.

## 3. Functional Requirements (FR)

| ID | Title | Description | Priority | Release | Verify by | Source |
|---|---|---|---|---|---|---|
| FR-renewal-001 | Gia hạn tại quầy và online | Thủ thư hoặc người đọc gia hạn khoản mượn đủ điều kiện theo cấu hình; từ chối khi đã quá hạn, có người đặt trước đầu sách hoặc đã hết lượt gia hạn, nêu lý do cụ thể; gia hạn thành công thì cộng hạn trả, tăng đếm lượt, ghi audit, thông báo hạn mới. | P1 | R1B | test | Spec cũ (xem id-crosswalk-lmp) |

## 4. Non-Functional Requirements (NFR)

NFR dùng chung (`NFR-core-001..009` — khả dụng, toàn vẹn, phân quyền, riêng tư, audit, quầy dùng được bằng bàn phím, accessibility, log, tương thích) áp dụng cho feature này; xem `docs/_shared/core-spec.md` Mục 4.

## 5. Business Rules

| ID | Rule | Trigger | Implements FR | Source |
|---|---|---|---|---|
| BR-renewal-001 | Renewal bị từ chối khi quá hạn, có reservation đang chờ hoặc đạt renewal limit. | Renewal | FR-renewal-001 | Spec cũ (xem id-crosswalk-lmp) |

Rule dùng chung áp dụng: BR-core-001 (điều kiện người đọc), BR-core-003, BR-core-005 (`docs/_shared/core-spec.md` Mục 5).

## 6. Error Matrix

Lỗi dùng chung áp dụng: E-core-004, E-core-005, E-core-006, E-core-008 (`docs/_shared/core-spec.md` Mục 6). Wording xem brainstorm Mục 7.3.

## 7. Success Criteria

Chưa có tiêu chí đo được — bổ sung khi có số liệu nghiệp vụ.

## 8. Data Entities (tóm tắt — chi tiết ở `docs/_shared/domain/library-erd.md`)

`Loan`, `LoanItem`, `Reservation` (kiểm hàng chờ), `PolicyConfig`.

## 9. Flows (tóm tắt — chi tiết ở `srs/renewal-flows.md`)

Chọn phiếu → kiểm điều kiện → gia hạn hoặc từ chối.

## 10. Screens (tóm tắt — chi tiết ở `srs/renewal-userflow.md` và `html-wireframe/`)

`renewal-result`; gia hạn online từ cổng `reader-self-service`.

## 11. Constraints, Dependencies & Assumptions

__Constraints:__

| Ràng buộc | Source / Owner |
|---|---|
| Hàng chờ rỗng tới R2 nhưng quy tắc vẫn kiểm | DEC-P2-05 |

__Dependencies:__

| Phụ thuộc | Owner | Blocks nếu chưa sẵn |
|---|---|---|
| Tham số quy định | `policy-config` | Giới hạn và thời hạn |
| Cổng người đọc | `reader-self-service` | Gia hạn online |
| Ghi audit cùng giao dịch | `ops-foundation` | Mọi thao tác ghi |
| Hàng đợi thông báo | `notification-core` | Thông báo |

__Assumptions:__

| Giả định | Invalidate nếu sai |
|---|---|
| Gia hạn tại quầy và online cùng quy tắc | FR-renewal-001 |

## 12. Open Questions

- [ ] OQ-renewal-001 — Số lần gia hạn và thời gian cộng thêm chính thức (mặc định nguồn 1 lần / +7 ngày)? Owner: Thủ thư trưởng.
