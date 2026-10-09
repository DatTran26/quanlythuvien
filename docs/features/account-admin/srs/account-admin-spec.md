---
type: srs
feature: account-admin
status: draft
updated: 2026-10-08
links:
  - docs/features/account-admin/brainstorms/account-admin-scope.md
  - docs/_product/prd.md
  - docs/_shared/core-spec.md
  - docs/_shared/domain/library-erd.md
  - docs/_shared/id-crosswalk-lmp.md
---

# account-admin — Software Requirements Specification

## 1. Scope

Quản trị viên quản lý vòng đời tài khoản người đọc và tài khoản Thủ thư (sửa, khóa, đặt lại mật khẩu, xóa mềm); từ R1B Thủ thư sửa thông tin, khóa tạm và mở lại người đọc. Mọi thay đổi có lý do khi cần và có audit.

**Release:** R0 (quản trị của Quản trị viên); R1B (Thủ thư khóa tạm)

**Ngoài phạm vi:** Cấp tài khoản người đọc mới (`reader-onboarding`); quản lý tài khoản Quản trị viên (còn mở).

## 2. Actors & Stakeholders

| Actor | Loại (người/hệ thống/ngoài) | Mục tiêu | Trong scope? |
|---|---|---|---|
| Quản trị viên | người | Quản trị dữ liệu, cấu hình, tài khoản | Có |
| Thủ thư | người | Vận hành quầy | Có |
| Người đọc | người | Biết lý do khi bị khóa | Có (gián tiếp) |
| Hệ thống | hệ thống | Thực thi kiểm tra, ghi audit | Có |
| Bảo mật/pháp chế | stakeholder | Kiểm soát dữ liệu cá nhân, retention | Có như stakeholder |

Tên vai trò và mapping với tài liệu nguồn xem `docs/_shared/core-spec.md` Mục 2.

## 3. Functional Requirements (FR)

| ID | Title | Description | Priority | Release | Verify by | Source |
|---|---|---|---|---|---|---|
| FR-account-admin-001 | Cập nhật và xóa mềm tài khoản người đọc | Quản trị viên tra cứu, xem chi tiết (kèm khoản đang mượn, đặt trước, công nợ), cập nhật và vô hiệu hóa tài khoản người đọc; không xóa cứng tài khoản đã có lịch sử; chặn vô hiệu khi còn phiếu mượn mở hoặc nợ phạt. | P0 | R0 | demo/test | Spec cũ (xem id-crosswalk-lmp) |
| FR-account-admin-002 | Khóa/mở người đọc | Cho phép tạm ngưng hoặc khôi phục quyền mượn của người đọc với lý do bắt buộc và audit; quyền theo ma trận nguồn (Nhân viên + Thủ thư đều khóa được). | P1 | R1B | test | Spec cũ (xem id-crosswalk-lmp) |
| FR-account-admin-003 | Quản lý tài khoản Thủ thư | Quản trị viên tạo, khóa, đặt lại mật khẩu và vô hiệu hóa tài khoản Thủ thư; không xóa cứng tài khoản đã có lịch sử; mọi thay đổi có audit. | P0 | R0 | test | DEC-SF-04 — SRS cũ thiếu |

## 4. Non-Functional Requirements (NFR)

NFR dùng chung (`NFR-core-001..009` — khả dụng, toàn vẹn, phân quyền, riêng tư, audit, quầy dùng được bằng bàn phím, accessibility, log, tương thích) áp dụng cho feature này; xem `docs/_shared/core-spec.md` Mục 4.

## 5. Business Rules

Rule dùng chung áp dụng: BR-core-001 (khóa có hiệu lực ngay với điều kiện mượn), BR-core-003, BR-core-004, BR-core-006 (xóa mềm) (`docs/_shared/core-spec.md` Mục 5).

## 6. Error Matrix

Lỗi dùng chung áp dụng: E-core-001, E-core-002, E-core-004, E-core-007, E-core-008, E-core-009 (`docs/_shared/core-spec.md` Mục 6). Wording xem brainstorm Mục 7.3.

## 7. Success Criteria

| ID | Outcome nghiệp vụ | Đo bằng | Mốc đạt |
|---|---|---|---|
| SC-account-admin-01 | Mọi thay đổi tài khoản truy vết được | Kiểm tra audit | 100% thay đổi có audit |
| SC-account-admin-02 | Không mất lịch sử nghiệp vụ | Kiểm tra dữ liệu | 0 tài khoản có lịch sử bị xóa cứng |

## 8. Data Entities (tóm tắt — chi tiết ở `docs/_shared/domain/library-erd.md`)

`Reader`; tài khoản Thủ thư (mô hình tài khoản nhân sự còn mở ở `OQ-core-005`); `AuditEvent`.

## 9. Flows (tóm tắt — chi tiết ở `srs/account-admin-flows.md`)

Sửa tài khoản; khóa tạm và mở lại có lý do; vô hiệu tài khoản khi không còn nghĩa vụ.

## 10. Screens (tóm tắt — chi tiết ở `srs/account-admin-userflow.md` và `html-wireframe/`)

`reader-list`, `reader-detail`; màn tài khoản Thủ thư (thiết kế ở user-flow).

## 11. Constraints, Dependencies & Assumptions

__Constraints:__

| Ràng buộc | Source / Owner |
|---|---|
| Không xóa cứng tài khoản đã có lịch sử | BR-core-006 |
| Thủ thư không được xóa tài khoản | SRC-FR-S10 (nguồn) |

__Dependencies:__

| Phụ thuộc | Owner | Blocks nếu chưa sẵn |
|---|---|---|
| Quyết định quản lý tài khoản Quản trị viên | Security/IT | Quyền tạo/khóa Quản trị viên |
| Ghi audit cùng giao dịch | `ops-foundation` | Mọi thao tác ghi |

__Assumptions:__

| Giả định | Invalidate nếu sai |
|---|---|
| Khóa tạm chỉ chặn giao dịch mới, không hủy nghĩa vụ đang mở | `checkout`, `renewal`, `reservation` |

## 12. Open Questions

- [ ] OQ-account-admin-001 — Ai quản lý tài khoản Quản trị viên và cơ chế chống tự nâng quyền? Owner: security/IT.
