---
type: srs
feature: ops-foundation
status: draft
updated: 2026-10-08
links:
  - docs/features/ops-foundation/brainstorms/ops-foundation-scope.md
  - docs/_product/prd.md
  - docs/_shared/core-spec.md
  - docs/_shared/domain/library-erd.md
  - docs/_shared/id-crosswalk-lmp.md
---

# ops-foundation — Software Requirements Specification

## 1. Scope

Ghi audit cùng giao dịch cho mọi thao tác nhạy cảm (audit lỗi thì thao tác bị hủy); backup hằng ngày giữ 30 bản; diễn tập khôi phục trước go-live.

**Release:** R0

**Ngoài phạm vi:** Màn xem audit (`notification-audit-ui`).

## 2. Actors & Stakeholders

| Actor | Loại (người/hệ thống/ngoài) | Mục tiêu | Trong scope? |
|---|---|---|---|
| Hệ thống | hệ thống | Thực thi kiểm tra, ghi audit | Có |
| Quản trị viên | người | Quản trị dữ liệu, cấu hình, tài khoản | Có |
| Thủ thư trưởng | stakeholder | Duyệt quy định và go-live | Có như stakeholder |
| Owner vận hành | người | Chạy backup, diễn tập khôi phục | Có |

Tên vai trò và mapping với tài liệu nguồn xem `docs/_shared/core-spec.md` Mục 2.

## 3. Functional Requirements (FR)

| ID | Title | Description | Priority | Release | Verify by | Source |
|---|---|---|---|---|---|---|
| FR-ops-foundation-001 | Ghi audit cùng giao dịch | Ghi audit cùng giao dịch với mọi thao tác tạo, sửa, xóa và thao tác nhạy cảm, gồm người làm, thời điểm, đối tượng, kết quả, giá trị trước/sau tối thiểu và lý do khi có; audit chỉ thêm, không sửa xóa. | P0 | R0 | test | Spec cũ (xem id-crosswalk-lmp) |
| FR-ops-foundation-002 | Backup và khôi phục | Hệ thống backup toàn bộ dữ liệu nghiệp vụ hằng ngày, giữ 30 bản gần nhất; khôi phục được từ một bản backup; trước go-live phải diễn tập khôi phục thành công ít nhất một lần và lưu bằng chứng cho GATE-OPS. | P0 | R0 | test | DEC-SF-05 — SRS cũ thiếu |

## 4. Non-Functional Requirements (NFR)

NFR dùng chung (`NFR-core-001..009` — khả dụng, toàn vẹn, phân quyền, riêng tư, audit, quầy dùng được bằng bàn phím, accessibility, log, tương thích) áp dụng cho feature này; xem `docs/_shared/core-spec.md` Mục 4.

## 5. Business Rules

Rule dùng chung áp dụng: BR-core-003 (audit fail thì thao tác fail) (`docs/_shared/core-spec.md` Mục 5).

## 6. Error Matrix

Lỗi dùng chung áp dụng: E-core-007 (`docs/_shared/core-spec.md` Mục 6). Wording xem brainstorm Mục 7.3.

## 7. Success Criteria

| ID | Outcome nghiệp vụ | Đo bằng | Mốc đạt |
|---|---|---|---|
| SC-ops-foundation-01 | Audit phủ hành động nhạy cảm | Trace actor/action/resource/result | 100% sensitive actions audited |
| SC-ops-foundation-02 | Khôi phục được dữ liệu trước go-live | Biên bản diễn tập (GATE-OPS) | ≥ 1 lần khôi phục đạt |

## 8. Data Entities (tóm tắt — chi tiết ở `docs/_shared/domain/library-erd.md`)

`AuditEvent`; bản backup (không phải entity nghiệp vụ).

## 9. Flows (tóm tắt — chi tiết ở `srs/ops-foundation-flows.md`)

Ghi audit trong giao dịch; backup hằng ngày; diễn tập khôi phục.

## 10. Screens (tóm tắt — chi tiết ở `srs/ops-foundation-userflow.md` và `html-wireframe/`)

Không có màn riêng.

## 11. Constraints, Dependencies & Assumptions

__Constraints:__

| Ràng buộc | Source / Owner |
|---|---|
| Backup hằng ngày, giữ 30 bản | SRC-NFR-07 (nguồn), DEC-SF-05 |
| Audit nhất quán theo giao dịch | core-spec Mục 11 |

__Dependencies:__

| Phụ thuộc | Owner | Blocks nếu chưa sẵn |
|---|---|---|
| Owner vận hành | Thủ thư trưởng | Backup, diễn tập, GATE-OPS |
| Chính sách lưu giữ | Legal/DPO | Thời gian lưu audit |

__Assumptions:__

| Giả định | Invalidate nếu sai |
|---|---|
| Backup gồm toàn bộ dữ liệu nghiệp vụ | FR-ops-foundation-002 |

## 12. Open Questions

- [ ] OQ-ops-foundation-001 — Owner vận hành cho backup và diễn tập? Owner: Thủ thư trưởng.
- [ ] OQ-ops-foundation-002 — Mục tiêu thời gian khôi phục và lượng dữ liệu chấp nhận mất tối đa? Owner: vận hành.
