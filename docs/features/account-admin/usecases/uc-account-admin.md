---
type: usecase
feature: account-admin
status: draft
updated: 2026-10-08
links:
  - docs/features/account-admin/usecases/account-admin-usecase-index.md
  - docs/features/account-admin/srs/account-admin-spec.md
---

# Use Case: Quản trị tài khoản (uc-account-admin)

> Scope: account-admin · Level: sea
> Screens: `reader-list`, `reader-detail`, màn tài khoản Thủ thư · Release: R0 (FR-account-admin-001, 003), R1B (FR-account-admin-002)

## Primary Actor

Quản trị viên (sửa, khóa, vô hiệu tài khoản người đọc; tạo, khóa, đặt lại mật khẩu, vô hiệu tài khoản Thủ thư). Thủ thư (R1B: sửa thông tin, khóa tạm và mở lại người đọc; không được vô hiệu).

## Stakeholders & Interests

| Stakeholder | Interest |
|-------------|----------|
| Người đọc | Trạng thái khóa có lý do rõ ràng |
| Bảo mật/pháp chế | Mọi thay đổi tài khoản có audit; dữ liệu cá nhân hiển thị theo quyền (BR-core-004) |
| Thủ thư trưởng | Không tự nâng quyền, không mất lịch sử nghiệp vụ |

## Trigger

Quản trị viên hoặc Thủ thư cần tra cứu, sửa, khóa, mở hoặc vô hiệu một tài khoản.

## Preconditions

- Người thao tác đã xác thực và có quyền tương ứng (include `uc-access-control`).
- Tài khoản đã tồn tại (cấp mới ở `uc-reader-onboarding`).

## Guarantees

- **Minimal Guarantee:** Không thao tác nào vượt quyền được thực thi; khóa, mở, vô hiệu thiếu lý do bị từ chối; không xóa cứng tài khoản có lịch sử.
- **Success Guarantee:** Thay đổi được lưu nhất quán, có audit cùng giao dịch; khóa có hiệu lực ngay với điều kiện mượn (BR-core-001).

## Main Success Scenario

1. Người thao tác mở `reader-list`, tìm tài khoản; dữ liệu cá nhân hiển thị theo quyền.
2. Mở `reader-detail`: hồ sơ, khoản đang mượn, đặt trước, công nợ.
3. Chọn thao tác: sửa, khóa tạm, mở lại, hoặc vô hiệu (Quản trị viên).
4. Nhập lý do khi khóa, mở, vô hiệu.
5. Hệ thống kiểm quyền, kiểm trạng thái hợp lệ, kiểm không có ai sửa trước, lưu và ghi audit.

## Extensions

**3a. Thao tác không hợp lệ với trạng thái hiện tại (E-core-008):** khóa tài khoản đã khóa, mở tài khoản đang hoạt động → giải thích, chỉ hiện thao tác hợp lệ.

**3b. Thủ thư chọn vô hiệu hoặc thao tác trên tài khoản Thủ thư khác (E-core-002):** từ chối, ghi audit.

**4a. Thiếu lý do (E-core-001):** báo lỗi, giữ dữ liệu đã nhập.

**5a. Vô hiệu khi còn phiếu mượn mở hoặc nợ phạt (E-core-008):** chặn, liệt kê nghĩa vụ tồn đọng.

**5b. Khóa khi người đọc đang có phiếu mượn hoặc đặt trước:** cảnh báo trước khi xác nhận; khóa chỉ chặn giao dịch mới, không hủy nghĩa vụ đang mở.

**5c. Hồ sơ vừa bị người khác sửa (E-core-004):** báo xung đột, hiện bản mới nhất, không ghi đè; người thao tác nhập lại hoặc hủy.

**5d. Audit ghi lỗi (E-core-007):** hủy thao tác, cảnh báo vận hành.

**Nhánh T — Tài khoản Thủ thư (Quản trị viên):** tạo, khóa, đặt lại mật khẩu, vô hiệu; cùng quy tắc lý do, audit, không xóa cứng. Quản lý tài khoản Quản trị viên còn mở (OQ-account-admin-001).

## Related Requirements

- FR: FR-account-admin-001, FR-account-admin-002, FR-account-admin-003.
- BR dùng chung: BR-core-001, BR-core-003, BR-core-004, BR-core-006.
- Errors: E-core-001, E-core-002, E-core-004, E-core-007, E-core-008, E-core-009.
- Open: OQ-account-admin-001.
- UC liên quan: `uc-access-control` (include), `uc-reader-onboarding`.
