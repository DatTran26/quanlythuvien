---
type: srs
feature: catalog-admin
status: draft
updated: 2026-10-12
links:
  - docs/features/catalog-admin/brainstorms/catalog-admin-scope.md
  - docs/_product/prd.md
  - docs/_shared/core-spec.md
  - docs/_shared/domain/library-erd.md
  - docs/_shared/id-crosswalk-lmp.md
---

# catalog-admin — Software Requirements Specification

## 1. Scope

Thủ thư quản lý đầu sách và danh mục (thể loại, tác giả, nhà xuất bản, vị trí kệ); Nhân viên và Thủ thư tra cứu đầu sách và số bản theo nhóm trạng thái.

**Release:** R0

**Ngoài phạm vi:** Tra cứu phía người đọc (`reader-self-service`); bản sao và QR (`copy-inventory`).

## 2. Actors & Stakeholders

| Actor | Loại (người/hệ thống/ngoài) | Mục tiêu | Trong scope? |
|---|---|---|---|
| Thủ thư | người | Quản trị dữ liệu, cấu hình, tài khoản | Có |
| Nhân viên | người | Vận hành quầy | Có |
| Hệ thống | hệ thống | Thực thi kiểm tra, ghi audit | Có |

Tên vai trò và mapping với tài liệu nguồn xem `docs/_shared/core-spec.md` Mục 2.

## 3. Functional Requirements (FR)

| ID | Title | Description | Priority | Release | Verify by | Source |
|---|---|---|---|---|---|---|
| FR-catalog-admin-001 | Quản lý danh mục sách | Tạo, xem, cập nhật, tìm kiếm bản ghi thư mục gồm tiêu đề, tác giả, thể loại, nhà xuất bản, năm, ISBN và mô tả khi có. | P0 | R0 | demo/test | Spec cũ (xem id-crosswalk-lmp) |
| FR-catalog-admin-002 | Tra cứu khả dụng phía Nhân viên và Thủ thư | Tra cứu đầu sách theo tên, tác giả, ISBN, thể loại; lọc còn hoặc hết; xem số bản sao khả dụng, đang giữ, đang mượn, không khả dụng và vị trí kệ. Số lượng tính từ trạng thái bản sao. | P0 | R0 | test | Spec cũ (xem id-crosswalk-lmp) |
| FR-catalog-admin-003 | Quản lý danh mục | Thủ thư tạo, sửa, vô hiệu thể loại, tác giả, nhà xuất bản, vị trí kệ; danh mục đã được dùng không xóa cứng. | P0 | R0 | demo/test | SRC-FR-L04 (nguồn); brainstorm |

## 4. Non-Functional Requirements (NFR)

| ID | Category | Requirement | Priority | Release | Acceptance |
|---|---|---|---|---|---|
| NFR-catalog-admin-001 | performance | Tra cứu danh mục phổ thông phản hồi trong ngưỡng được phê duyệt; đề xuất ≤2s cho truy vấn thường dùng @50.000 bản sao. | P0 | R1A | Đo P95 môi trường test; ngưỡng là PROPOSAL |

NFR dùng chung (`NFR-core-001..009` — khả dụng, toàn vẹn, phân quyền, riêng tư, audit, quầy dùng được bằng bàn phím, accessibility, log, tương thích) áp dụng cho feature này; xem `docs/_shared/core-spec.md` Mục 4.

## 5. Business Rules

Rule dùng chung áp dụng: BR-core-003, BR-core-006 (`docs/_shared/core-spec.md` Mục 5).

## 6. Error Matrix

Lỗi dùng chung áp dụng: E-core-001, E-core-002, E-core-003, E-core-004, E-core-008 (`docs/_shared/core-spec.md` Mục 6). Wording xem brainstorm Mục 7.3.

## 7. Success Criteria

Chưa có tiêu chí đo được — bổ sung khi có số liệu nghiệp vụ.

## 8. Data Entities (tóm tắt — chi tiết ở `docs/_shared/domain/library-erd.md`)

`BibliographicRecord`; danh mục; số lượng khả dụng suy từ `Copy`.

## 9. Flows (tóm tắt — chi tiết ở `srs/catalog-admin-flows.md`)

Tạo/sửa đầu sách; tra cứu khả dụng; vô hiệu đầu sách.

## 10. Screens (tóm tắt — chi tiết ở `srs/catalog-admin-userflow.md` và `html-wireframe/`)

`catalog-search`, `bibliographic-detail`, `bibliographic-form`; màn danh mục (thiết kế ở user-flow).

## 11. Constraints, Dependencies & Assumptions

__Constraints:__

| Ràng buộc | Source / Owner |
|---|---|
| Số lượng khả dụng luôn tính từ trạng thái bản sao | SRC-BR11 (nguồn) |

__Dependencies:__

| Phụ thuộc | Owner | Blocks nếu chưa sẵn |
|---|---|---|
| File Excel đại diện | Data owner | Bộ trường bắt buộc khớp dữ liệu cũ |
| Ghi audit cùng giao dịch | `ops-foundation` | Mọi thao tác ghi |

__Assumptions:__

| Giả định | Invalidate nếu sai |
|---|---|
| Kiểm trùng theo ISBN khi có; không có ISBN thì theo tiêu đề + tác giả | FR-catalog-admin-001 |

## 12. Open Questions

- [ ] OQ-catalog-admin-001 — Bộ trường bắt buộc và quy tắc ISBN chính thức? Owner: domain approver.
- [ ] OQ-catalog-admin-002 — Đầu sách đã vô hiệu có được kích hoạt lại không? Owner: domain approver.
