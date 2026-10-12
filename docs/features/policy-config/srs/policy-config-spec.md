---
type: srs
feature: policy-config
status: draft
updated: 2026-10-12
links:
  - docs/features/policy-config/brainstorms/policy-config-scope.md
  - docs/_product/prd.md
  - docs/_shared/core-spec.md
  - docs/_shared/domain/library-erd.md
  - docs/_shared/id-crosswalk-lmp.md
---

# policy-config — Software Requirements Specification

## 1. Scope

Thủ thư cấu hình tham số mượn, gia hạn, giữ chỗ, phạt, chặn mượn và kênh thông báo có thời điểm hiệu lực; giao dịch đã bắt đầu giữ quy định tại thời điểm đó.

**Release:** R0

**Ngoài phạm vi:** Bộ quy định theo loại người đọc (candidate R3).

## 2. Actors & Stakeholders

| Actor | Loại (người/hệ thống/ngoài) | Mục tiêu | Trong scope? |
|---|---|---|---|
| Thủ thư | người | Quản trị dữ liệu, cấu hình, tài khoản | Có |
| Thủ thư trưởng | stakeholder | Duyệt quy định và go-live | Có như stakeholder |
| Hệ thống | hệ thống | Thực thi kiểm tra, ghi audit | Có |

Tên vai trò và mapping với tài liệu nguồn xem `docs/_shared/core-spec.md` Mục 2.

## 3. Functional Requirements (FR)

| ID | Title | Description | Priority | Release | Verify by | Source |
|---|---|---|---|---|---|---|
| FR-policy-config-001 | Quản trị cấu hình nghiệp vụ | Quản lý tham số hạn mượn, số lần gia hạn, hạn giữ chỗ, vai trò và kênh thông báo. Giá trị mặc định là OQ. | P0 | R0 | demo/test | Spec cũ (xem id-crosswalk-lmp) |

## 4. Non-Functional Requirements (NFR)

NFR dùng chung (`NFR-core-001..009` — khả dụng, toàn vẹn, phân quyền, riêng tư, audit, quầy dùng được bằng bàn phím, accessibility, log, tương thích) áp dụng cho feature này; xem `docs/_shared/core-spec.md` Mục 4.

## 5. Business Rules

| ID | Rule | Trigger | Implements FR | Source |
|---|---|---|---|---|
| BR-policy-config-001 | Thay đổi tham số chỉ áp dụng cho giao dịch bắt đầu sau thời điểm hiệu lực; phiếu đã tạo giữ quy định lúc tạo. | Lưu cấu hình | FR-policy-config-001 | Brainstorm 6.5 (cũ); baseline sản phẩm 6.5 |

Rule dùng chung áp dụng: BR-core-003 (`docs/_shared/core-spec.md` Mục 5).

## 6. Error Matrix

Lỗi dùng chung áp dụng: E-core-001, E-core-002, E-core-004, E-core-007 (`docs/_shared/core-spec.md` Mục 6). Wording xem brainstorm Mục 7.3.

## 7. Success Criteria

| ID | Outcome nghiệp vụ | Đo bằng | Mốc đạt |
|---|---|---|---|
| SC-policy-config-01 | Thay đổi quy định truy vết được | Kiểm tra audit | 100% thay đổi có audit trước/sau |

## 8. Data Entities (tóm tắt — chi tiết ở `docs/_shared/domain/library-erd.md`)

`PolicyConfig` (key catalog ở `docs/_shared/domain/library-erd.md` Mục 3.12).

## 9. Flows (tóm tắt — chi tiết ở `srs/policy-config-flows.md`)

Đổi tham số với thời điểm hiệu lực.

## 10. Screens (tóm tắt — chi tiết ở `srs/policy-config-userflow.md` và `html-wireframe/`)

`admin-config`.

## 11. Constraints, Dependencies & Assumptions

__Constraints:__

| Ràng buộc | Source / Owner |
|---|---|
| Giá trị đã chốt: 5 cuốn, 14 ngày, 50.000đ | DEC-SF-10 |

__Dependencies:__

| Phụ thuộc | Owner | Blocks nếu chưa sẵn |
|---|---|---|
| Giá trị quy định còn lại | Thủ thư trưởng | `overdue-fines`, `renewal`, `reservation` |
| Ghi audit cùng giao dịch | `ops-foundation` | Mọi thao tác ghi |

__Assumptions:__

| Giả định | Invalidate nếu sai |
|---|---|
| Một bộ quy định chung, một cơ sở | Toàn bộ feature lưu thông |

## 12. Open Questions

- [ ] OQ-policy-config-001 — Giá trị chính thức của gia hạn, phạt quá hạn, bồi thường mất, phạt hư hỏng, giới hạn đặt trước, thời gian giữ, SLA (đã chốt hạn mức, hạn mượn, ngưỡng nợ — DEC-SF-10)? Owner: Thủ thư trưởng.
- [ ] OQ-policy-config-002 — Miền giá trị cho phép của từng tham số? Owner: domain approver.
