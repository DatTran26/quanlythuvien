---
type: srs
feature: access-control
status: draft
updated: 2026-10-08
links:
  - docs/features/access-control/brainstorms/access-control-scope.md
  - docs/_product/prd.md
  - docs/_shared/core-spec.md
  - docs/_shared/domain/library-erd.md
  - docs/_shared/id-crosswalk-lmp.md
---

# access-control — Software Requirements Specification

## 1. Scope

Đăng nhập, quên và đặt lại mật khẩu, hồ sơ cá nhân, phân quyền 3 vai trò từ chối mặc định, che dữ liệu nhạy cảm theo quyền, xác thực lại trước tác vụ nhạy cảm, xử lý hết phiên và khóa tạm khi đăng nhập sai liên tiếp.

**Release:** R0

**Ngoài phạm vi:** SSO hoặc dịch vụ danh tính ngoài (chờ OQ-access-control-001); quản lý tài khoản thuộc `account-admin`.

## 2. Actors & Stakeholders

| Actor | Loại (người/hệ thống/ngoài) | Mục tiêu | Trong scope? |
|---|---|---|---|
| Người đọc | người | Tự phục vụ, mượn sách | Có |
| Thủ thư | người | Vận hành quầy | Có |
| Quản trị viên | người | Quản trị dữ liệu, cấu hình, tài khoản | Có |
| Hệ thống | hệ thống | Thực thi kiểm tra, ghi audit | Có |
| Bảo mật/pháp chế | stakeholder | Kiểm soát dữ liệu cá nhân, retention | Có như stakeholder |

Tên vai trò và mapping với tài liệu nguồn xem `docs/_shared/core-spec.md` Mục 2.

## 3. Functional Requirements (FR)

| ID | Title | Description | Priority | Release | Verify by | Source |
|---|---|---|---|---|---|---|
| FR-access-control-001 | Đăng nhập và phân quyền | Chỉ actor hợp lệ được truy cập chức năng theo vai trò và phạm vi dữ liệu được cấp; Hệ thống là bên thực thi kiểm tra. | P0 | R0 | test | Spec cũ (xem id-crosswalk-lmp) |
| FR-access-control-002 | Step-up và session reset | Tác vụ nhạy cảm yêu cầu xác thực lại; hết phiên phải quay về trạng thái an toàn không mất dữ liệu đã lưu; Hệ thống thực thi. | P0 | R0 | test | Spec cũ (xem id-crosswalk-lmp) |
| FR-access-control-003 | Quên và đặt lại mật khẩu | Người dùng yêu cầu đặt lại mật khẩu bằng email; hệ thống gửi hướng dẫn nếu email thuộc một tài khoản và hiển thị cùng một thông báo dù email có tồn tại hay không; link đặt lại dùng một lần và có thời hạn. | P0 | R0 | test | SRC-FR-C02 (nguồn); brainstorm |
| FR-access-control-004 | Hồ sơ cá nhân | Người dùng xem và sửa thông tin của chính mình, đổi mật khẩu. | P0 | R0 | demo/test | SRC-FR-C03 (nguồn); brainstorm |
| FR-access-control-005 | Khóa tạm khi đăng nhập sai | Nếu đăng nhập sai liên tiếp vượt ngưỡng trên cùng tài khoản, thì hệ thống phải khóa tạm tài khoản trong thời gian cấu hình, từ chối mọi lần thử và không tiết lộ lý do; ngưỡng và thời gian khóa chờ OQ-access-control-002. | P0 | R0 | test | uc-access-control ext 2b (cũ); brainstorm |

## 4. Non-Functional Requirements (NFR)

NFR dùng chung (`NFR-core-001..009` — khả dụng, toàn vẹn, phân quyền, riêng tư, audit, quầy dùng được bằng bàn phím, accessibility, log, tương thích) áp dụng cho feature này; xem `docs/_shared/core-spec.md` Mục 4.

## 5. Business Rules

Rule dùng chung áp dụng: BR-core-003 (audit cùng giao dịch), BR-core-004 (quyền trường dữ liệu, từ chối mặc định) (`docs/_shared/core-spec.md` Mục 5).

## 6. Error Matrix

| Error ID | Title | Trigger | Severity | Related FR | Screen state | Recovery |
|---|---|---|---|---|---|---|
| E-access-control-001 | Session expired / step-up required | Phiên hết hạn hoặc tác vụ nhạy cảm cần xác thực lại | major | FR-access-control-002 | Re-auth dialog/route | Sau xác thực quay lại trạng thái an toàn |

Lỗi dùng chung áp dụng: E-core-001, E-core-002, E-core-007, E-core-009 (`docs/_shared/core-spec.md` Mục 6). Wording xem brainstorm Mục 7.3.

## 7. Success Criteria

| ID | Outcome nghiệp vụ | Đo bằng | Mốc đạt |
|---|---|---|---|
| SC-access-control-01 | Truy cập ngoài quyền bị chặn và có dấu vết | Kiểm thử ma trận quyền | 100% truy cập ngoài quyền bị từ chối và có audit |

## 8. Data Entities (tóm tắt — chi tiết ở `docs/_shared/domain/library-erd.md`)

Tài khoản và vai trò người dùng (mô hình tài khoản nhân sự còn mở ở `OQ-core-005`); `AuditEvent` cho mọi lần truy cập bị từ chối.

## 9. Flows (tóm tắt — chi tiết ở `srs/access-control-flows.md`)

Đăng nhập và điều hướng theo vai trò; quên và đặt lại mật khẩu; xác thực lại trước tác vụ nhạy cảm; hết phiên.

## 10. Screens (tóm tắt — chi tiết ở `srs/access-control-userflow.md` và `html-wireframe/`)

`access-login`, `forgot-password`, `reset-password`, `dashboard-home`, `session-expired`. Chuyển màn sang feature khác xem `docs/_shared/navigation-map.md`.

## 11. Constraints, Dependencies & Assumptions

__Constraints:__

| Ràng buộc | Source / Owner |
|---|---|
| Kiểm tra quyền ở phía hệ thống cho mọi thao tác, không chỉ ẩn nút | SRC-NFR-02 (nguồn) |
| QR chỉ là locator, không phải credential | core-spec Mục 11 |

__Dependencies:__

| Phụ thuộc | Owner | Blocks nếu chưa sẵn |
|---|---|---|
| Quyết định mô hình danh tính | Security/IT | Cơ chế đăng nhập, quên mật khẩu |
| Dịch vụ gửi email | Product + technical owner | Quên mật khẩu |
| Ghi audit cùng giao dịch | `ops-foundation` | Mọi thao tác ghi |

__Assumptions:__

| Giả định | Invalidate nếu sai |
|---|---|
| Dùng tài khoản nội bộ (email hoặc mã thẻ + mật khẩu) | FR-access-control-001, 003 |
| Quản trị viên đầu tiên tạo sẵn khi triển khai | `account-admin` |

## 12. Open Questions

- [ ] OQ-access-control-001 — Mô hình danh tính: tài khoản nội bộ, SSO hay dịch vụ danh tính ngoài? Owner: security/IT.
- [ ] OQ-access-control-002 — Ngưỡng đăng nhập sai, thời gian khóa tạm, thời lượng phiên, hiệu lực link đặt lại mật khẩu? Owner: security/IT.
- [ ] OQ-access-control-003 — Quy tắc mật khẩu (độ dài, ký tự)? Owner: security/IT.
- [ ] OQ-access-control-004 — Mở khóa tạm tự động theo thời gian hay chỉ Quản trị viên mở? Owner: security/IT.
