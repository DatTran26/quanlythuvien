---
type: srs
feature: reader-onboarding
status: draft
updated: 2026-10-08
links:
  - docs/features/reader-onboarding/brainstorms/reader-onboarding-scope.md
  - docs/_product/prd.md
  - docs/_shared/core-spec.md
  - docs/_shared/domain/library-erd.md
  - docs/_shared/id-crosswalk-lmp.md
---

# reader-onboarding — Software Requirements Specification

## 1. Scope

Thủ thư cấp tài khoản người đọc tại quầy: nhập hồ sơ, kiểm trùng định danh, kích hoạt và cấp thẻ QR. Không có tự đăng ký online (DEC-SF-03).

**Release:** R0

**Ngoài phạm vi:** Cập nhật, khóa, xóa mềm tài khoản (`account-admin`); import hàng loạt (`data-import`).

## 2. Actors & Stakeholders

| Actor | Loại (người/hệ thống/ngoài) | Mục tiêu | Trong scope? |
|---|---|---|---|
| Thủ thư | người | Vận hành quầy | Có |
| Người đọc | người | Nhận thẻ QR có hiệu lực | Có (gián tiếp) |
| Hệ thống | hệ thống | Thực thi kiểm tra, ghi audit | Có |
| Bảo mật/pháp chế | stakeholder | Kiểm soát dữ liệu cá nhân, retention | Có như stakeholder |

Tên vai trò và mapping với tài liệu nguồn xem `docs/_shared/core-spec.md` Mục 2.

## 3. Functional Requirements (FR)

| ID | Title | Description | Priority | Release | Verify by | Source |
|---|---|---|---|---|---|---|
| FR-reader-onboarding-001 | Cấp và kích hoạt tài khoản người đọc tại quầy | Thủ thư tạo hồ sơ người đọc gồm mã độc giả, họ tên, thông tin liên hệ tối thiểu và hạn thẻ nếu có; hệ thống kiểm trùng mã độc giả và mã QR thẻ, kích hoạt tài khoản và cấp thẻ QR trong một giao dịch có audit. | P0 | R0 | demo/test | Spec cũ (xem id-crosswalk-lmp) |

## 4. Non-Functional Requirements (NFR)

NFR dùng chung (`NFR-core-001..009` — khả dụng, toàn vẹn, phân quyền, riêng tư, audit, quầy dùng được bằng bàn phím, accessibility, log, tương thích) áp dụng cho feature này; xem `docs/_shared/core-spec.md` Mục 4.

## 5. Business Rules

Rule dùng chung áp dụng: BR-core-003, BR-core-004 (`docs/_shared/core-spec.md` Mục 5).

## 6. Error Matrix

Lỗi dùng chung áp dụng: E-core-001, E-core-002, E-core-003, E-core-004, E-core-007, E-core-009 (`docs/_shared/core-spec.md` Mục 6). Wording xem brainstorm Mục 7.3.

## 7. Success Criteria

| ID | Outcome nghiệp vụ | Đo bằng | Mốc đạt |
|---|---|---|---|
| SC-reader-onboarding-01 | Không có hồ sơ trùng định danh | Kiểm tra trùng sau pilot | 0 hồ sơ trùng mã độc giả |

## 8. Data Entities (tóm tắt — chi tiết ở `docs/_shared/domain/library-erd.md`)

`Reader` (định danh, liên hệ tối thiểu, trạng thái, hạn thẻ); `AuditEvent`.

## 9. Flows (tóm tắt — chi tiết ở `srs/reader-onboarding-flows.md`)

Cấp tài khoản tại quầy: nhập → kiểm trùng → kích hoạt → cấp thẻ QR.

## 10. Screens (tóm tắt — chi tiết ở `srs/reader-onboarding-userflow.md` và `html-wireframe/`)

`reader-form` (tạo mới). Danh sách và chi tiết người đọc thuộc `account-admin`.

## 11. Constraints, Dependencies & Assumptions

__Constraints:__

| Ràng buộc | Source / Owner |
|---|---|
| Chỉ cấp tài khoản tại quầy, không tự đăng ký online | DEC-SF-03 |
| Chỉ lưu bộ thông tin tối thiểu cho tới khi có chính sách lưu giữ | OQ-core-003 |

__Dependencies:__

| Phụ thuộc | Owner | Blocks nếu chưa sẵn |
|---|---|---|
| Chính sách lưu giữ dữ liệu cá nhân | Legal/DPO | Bộ trường hồ sơ chính thức |
| Ghi audit cùng giao dịch | `ops-foundation` | Mọi thao tác ghi |

__Assumptions:__

| Giả định | Invalidate nếu sai |
|---|---|
| Thẻ có hạn 1 năm, không thu phí (mặc định OQ-05 nguồn) | Trường hạn thẻ, job hết hạn thẻ |
| Thủ thư được cấp tài khoản theo DEC-SF-03 | Ma trận quyền RBAC |

## 12. Open Questions

- [ ] OQ-reader-onboarding-001 — Bộ thông tin liên hệ bắt buộc của người đọc? Owner: domain approver.
- [ ] OQ-reader-onboarding-002 — Thẻ có thời hạn và có thu phí không (OQ-05 nguồn)? Owner: Thủ thư trưởng.
- [ ] OQ-reader-onboarding-003 — Thủ thư được cấp tài khoản thay vì chỉ vai trò quản trị như ma trận nguồn — Thủ thư trưởng xác nhận theo DEC-SF-03? Owner: Thủ thư trưởng.
