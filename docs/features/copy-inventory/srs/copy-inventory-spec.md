---
type: srs
feature: copy-inventory
status: draft
updated: 2026-10-08
links:
  - docs/features/copy-inventory/brainstorms/copy-inventory-scope.md
  - docs/_product/prd.md
  - docs/_shared/core-spec.md
  - docs/_shared/domain/library-erd.md
  - docs/_shared/id-crosswalk-lmp.md
---

# copy-inventory — Software Requirements Specification

## 1. Scope

Đăng ký bản sao vật lý của đầu sách, sinh mã QR duy nhất hàng loạt và xuất file in nhãn; QR chỉ để tìm bản ghi.

**Release:** R0

**Ngoài phạm vi:** Đổi trạng thái lưu thông của bản sao (thuộc các feature nghiệp vụ).

## 2. Actors & Stakeholders

| Actor | Loại (người/hệ thống/ngoài) | Mục tiêu | Trong scope? |
|---|---|---|---|
| Quản trị viên | người | Quản trị dữ liệu, cấu hình, tài khoản | Có |
| Thủ thư | người | Vận hành quầy | Có |
| Hệ thống | hệ thống | Thực thi kiểm tra, ghi audit | Có |

Tên vai trò và mapping với tài liệu nguồn xem `docs/_shared/core-spec.md` Mục 2.

## 3. Functional Requirements (FR)

| ID | Title | Description | Priority | Release | Verify by | Source |
|---|---|---|---|---|---|---|
| FR-copy-inventory-001 | Quản lý bản sao sách | Đăng ký bản sao vật lý với mã định danh, vị trí, tình trạng ban đầu và trạng thái khả dụng. | P0 | R0 | demo/test | Spec cũ (xem id-crosswalk-lmp) |
| FR-copy-inventory-002 | QR/barcode locator | Quét mã bản sao/phiếu chỉ để định vị bản ghi; mã không được dùng như bằng chứng uỷ quyền. | P0 | R0 | test/security | Spec cũ (xem id-crosswalk-lmp) |
| FR-copy-inventory-003 | Sinh QR hàng loạt và in nhãn | Quản trị viên nhập N bản sao cho một đầu sách; hệ thống sinh N mã QR duy nhất và xuất file in nhãn; in lại nhãn hỏng dùng đúng mã cũ. | P0 | R0 | demo/test | SRC-FR-L03 (nguồn); brainstorm |

## 4. Non-Functional Requirements (NFR)

NFR dùng chung (`NFR-core-001..009` — khả dụng, toàn vẹn, phân quyền, riêng tư, audit, quầy dùng được bằng bàn phím, accessibility, log, tương thích) áp dụng cho feature này; xem `docs/_shared/core-spec.md` Mục 4.

## 5. Business Rules

| ID | Rule | Trigger | Implements FR | Source |
|---|---|---|---|---|
| BR-copy-inventory-001 | QR/barcode là locator; phải xác thực actor và quyền sau khi locate, không coi scan là authorization. | Scan lookup | FR-copy-inventory-002 | Spec cũ (xem id-crosswalk-lmp) |

Rule dùng chung áp dụng: BR-core-003, BR-core-006 (`docs/_shared/core-spec.md` Mục 5).

## 6. Error Matrix

Lỗi dùng chung áp dụng: E-core-001, E-core-002, E-core-003, E-core-008 (`docs/_shared/core-spec.md` Mục 6). Wording xem brainstorm Mục 7.3.

## 7. Success Criteria

| ID | Outcome nghiệp vụ | Đo bằng | Mốc đạt |
|---|---|---|---|
| SC-copy-inventory-01 | Mỗi cuốn sách có đúng một mã | Kiểm tra trùng + đối soát dán nhãn | 0 mã QR trùng |

## 8. Data Entities (tóm tắt — chi tiết ở `docs/_shared/domain/library-erd.md`)

`Copy` (mã QR, vị trí, tình trạng, trạng thái, cờ chỉ đọc tại chỗ); vòng đời ở `docs/_shared/domain/library-states.md`.

## 9. Flows (tóm tắt — chi tiết ở `srs/copy-inventory-flows.md`)

Nhập bản sao và in nhãn.

## 10. Screens (tóm tắt — chi tiết ở `srs/copy-inventory-userflow.md` và `html-wireframe/`)

`copy-inventory`, `copy-form`.

## 11. Constraints, Dependencies & Assumptions

__Constraints:__

| Ràng buộc | Source / Owner |
|---|---|
| QR chỉ là locator, không phải bằng chứng ủy quyền | BR-copy-inventory-001 |

__Dependencies:__

| Phụ thuộc | Owner | Blocks nếu chưa sẵn |
|---|---|---|
| Duyệt vòng đời bản sao | Domain approver | Trạng thái khởi tạo (DEC-D3-01) |
| Ghi audit cùng giao dịch | `ops-foundation` | Mọi thao tác ghi |

__Assumptions:__

| Giả định | Invalidate nếu sai |
|---|---|
| Bản sao mới ở trạng thái Sẵn sàng | COPY-T00, DEC-D3-01 |
| Mã QR đã dùng không cấp lại | FR-copy-inventory-003 |

## 12. Open Questions

- [ ] OQ-copy-inventory-001 — Trạng thái khởi tạo và cờ chỉ đọc tại chỗ (DEC-D3-01, DEC-D3-09)? Owner: domain approver.
- [ ] OQ-copy-inventory-002 — Mẫu nhãn in (kích thước, thông tin)? Owner: vận hành.
