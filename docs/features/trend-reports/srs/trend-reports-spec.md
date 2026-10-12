---
type: srs
feature: trend-reports
status: draft
updated: 2026-10-12
links:
  - docs/features/trend-reports/brainstorms/trend-reports-scope.md
  - docs/_product/prd.md
  - docs/_shared/core-spec.md
  - docs/_shared/domain/library-erd.md
  - docs/_shared/id-crosswalk-lmp.md
---

# trend-reports — Software Requirements Specification

## 1. Scope

Báo cáo xu hướng RP-03 mượn–trả theo thời gian, RP-05 phạt, RP-06 sách được quan tâm, RP-07 hư hỏng và thanh lý; lọc thời gian, xuất Excel/PDF; dùng chung dashboard của `ops-reports`.

**Release:** R2

**Ngoài phạm vi:** RP-08 hoạt động nhân viên (candidate R3).

## 2. Actors & Stakeholders

| Actor | Loại (người/hệ thống/ngoài) | Mục tiêu | Trong scope? |
|---|---|---|---|
| Thủ thư | người | Quản trị, duyệt ngoại lệ | Có |
| Hệ thống | hệ thống | Thực thi rule, job, audit, outbox | Có |

Tên vai trò và mapping với tài liệu nguồn xem `docs/_shared/core-spec.md` Mục 2.

## 3. Functional Requirements (FR)

| ID | Title | Description | Priority | Release | Verify by | Source |
|---|---|---|---|---|---|---|
| FR-trend-reports-001 | Báo cáo xu hướng | Thủ thư xem RP-03 (lượt mượn/trả theo ngày, tháng, năm), RP-05 (phạt phát sinh, đã thu, chưa thu, miễn), RP-06 (top mượn nhiều, hàng chờ dài, không ai mượn trong 12 tháng), RP-07 (hư hỏng theo trạng thái duyệt, thanh lý trong kỳ); lọc thời gian, xuất Excel và PDF. | P1 | R2 | demo/test | Spec cũ (xem id-crosswalk-lmp) |

## 4. Non-Functional Requirements (NFR)

NFR dùng chung (`NFR-core-001..009` — khả dụng, toàn vẹn, phân quyền, riêng tư, audit, quầy dùng được bằng bàn phím, accessibility, log, tương thích) áp dụng cho feature này; xem `docs/_shared/core-spec.md` Mục 4.

## 5. Business Rules

Rule dùng chung áp dụng: BR-core-004 (`docs/_shared/core-spec.md` Mục 5).

## 6. Error Matrix

Lỗi dùng chung áp dụng: E-core-002, E-core-009 (`docs/_shared/core-spec.md` Mục 6). Wording xem brainstorm Mục 7.3.

## 7. Success Criteria

Chưa có tiêu chí đo được — bổ sung khi có số liệu nghiệp vụ.

## 8. Data Entities (tóm tắt — chi tiết ở `docs/_shared/domain/library-erd.md`)

Đọc `Loan`, `Fine`, `FinancialEvent`, `Reservation`, `DamageReport`, `Copy`.

## 9. Flows (tóm tắt — chi tiết ở `srs/trend-reports-flows.md`)

Mở dashboard → chọn báo cáo → lọc → xuất.

## 10. Screens (tóm tắt — chi tiết ở `srs/trend-reports-userflow.md` và `html-wireframe/`)

`report-dashboard` (chủ: `ops-reports`).

## 11. Constraints, Dependencies & Assumptions

__Constraints:__

| Ràng buộc | Source / Owner |
|---|---|
| Chỉ vai trò quản trị xem báo cáo theo nguồn | Nguồn §9 |

__Dependencies:__

| Phụ thuộc | Owner | Blocks nếu chưa sẵn |
|---|---|---|
| Dữ liệu vận hành tích lũy | Pilot | Ý nghĩa xu hướng |
| Dashboard báo cáo | `ops-reports` | Màn hiển thị |

__Assumptions:__

| Giả định | Invalidate nếu sai |
|---|---|
| Chỉ Thủ thư xem | Ma trận quyền |

## 12. Open Questions

- [ ] OQ-trend-reports-001 — Số sách trong danh sách top? Owner: Product Owner.
