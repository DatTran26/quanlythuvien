---
type: srs
feature: ops-reports
status: draft
updated: 2026-10-12
links:
  - docs/features/ops-reports/brainstorms/ops-reports-scope.md
  - docs/_product/prd.md
  - docs/_shared/core-spec.md
  - docs/_shared/domain/library-erd.md
  - docs/_shared/id-crosswalk-lmp.md
---

# ops-reports — Software Requirements Specification

## 1. Scope

Báo cáo vận hành RP-01 tổng quan tài khoản, RP-02 tình trạng kho, RP-04 quá hạn, lọc thời gian, xuất Excel/PDF (R1A); danh sách quá hạn cho Nhân viên (R1B).

**Release:** R1A; R1B (danh sách quá hạn)

**Ngoài phạm vi:** Báo cáo xu hướng (`trend-reports`, R2).

## 2. Actors & Stakeholders

| Actor | Loại (người/hệ thống/ngoài) | Mục tiêu | Trong scope? |
|---|---|---|---|
| Thủ thư | người | Quản trị, duyệt ngoại lệ | Có |
| Nhân viên | người | Vận hành quầy | Có |
| Hệ thống | hệ thống | Thực thi rule, job, audit, outbox | Có |

Tên vai trò và mapping với tài liệu nguồn xem `docs/_shared/core-spec.md` Mục 2.

## 3. Functional Requirements (FR)

| ID | Title | Description | Priority | Release | Verify by | Source |
|---|---|---|---|---|---|---|
| FR-ops-reports-001 | Báo cáo vận hành | Thủ thư xem RP-01 (tài khoản theo trạng thái, người đọc mới theo tháng), RP-02 (bản sao theo trạng thái và tình trạng), RP-04 (phiếu quá hạn, số ngày, người đọc); lọc theo khoảng thời gian, xuất Excel và PDF. | P0 (PRD) / P1 (SRS cũ) | R1A | demo/test | Spec cũ (xem id-crosswalk-lmp) |
| FR-ops-reports-002 | Danh sách quá hạn cho Nhân viên | Nhân viên xem danh sách phiếu quá hạn để nhắc người đọc. | P1 | R1B | demo/test | SRC-FR-S09 (nguồn); brainstorm |

## 4. Non-Functional Requirements (NFR)

NFR dùng chung (`NFR-core-001..009` — khả dụng, toàn vẹn, phân quyền, riêng tư, audit, quầy dùng được bằng bàn phím, accessibility, log, tương thích) áp dụng cho feature này; xem `docs/_shared/core-spec.md` Mục 4.

## 5. Business Rules

Rule dùng chung áp dụng: BR-core-004 (`docs/_shared/core-spec.md` Mục 5).

## 6. Error Matrix

Lỗi dùng chung áp dụng: E-core-002, E-core-009 (`docs/_shared/core-spec.md` Mục 6). Wording xem brainstorm Mục 7.3.

## 7. Success Criteria

Chưa có tiêu chí đo được — bổ sung khi có số liệu nghiệp vụ.

## 8. Data Entities (tóm tắt — chi tiết ở `docs/_shared/domain/library-erd.md`)

Đọc `Reader`, `Copy`, `Loan`.

## 9. Flows (tóm tắt — chi tiết ở `srs/ops-reports-flows.md`)

Mở dashboard → chọn báo cáo → lọc → xuất.

## 10. Screens (tóm tắt — chi tiết ở `srs/ops-reports-userflow.md` và `html-wireframe/`)

`report-dashboard`.

## 11. Constraints, Dependencies & Assumptions

__Constraints:__

| Ràng buộc | Source / Owner |
|---|---|
| Chỉ vai trò quản trị xem báo cáo theo nguồn | Nguồn §9 |

__Dependencies:__

| Phụ thuộc | Owner | Blocks nếu chưa sẵn |
|---|---|---|
| Dữ liệu lưu thông thật | `checkout`, `return-handling` | Số liệu RP-04 |

__Assumptions:__

| Giả định | Invalidate nếu sai |
|---|---|
| Báo cáo đọc dữ liệu thật từ R1A | Kiểm thử báo cáo |

## 12. Open Questions

- [ ] OQ-ops-reports-001 — Nhân viên quầy có quyền xem RP-01, RP-02, RP-04 không? Owner: domain approver.
- [ ] OQ-ops-reports-002 — Priority chính thức P0 (PRD) hay P1 (SRS cũ)? Owner: Product Owner.
