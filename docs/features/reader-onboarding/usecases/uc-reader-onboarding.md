---
type: usecase
feature: reader-onboarding
status: draft
updated: 2026-10-08
links:
  - docs/features/reader-onboarding/usecases/reader-onboarding-usecase-index.md
  - docs/features/reader-onboarding/srs/reader-onboarding-spec.md
---

# Use Case: Cấp và kích hoạt tài khoản người đọc tại quầy (uc-reader-onboarding)

> Scope: reader-onboarding · Level: sea
> Screens: `reader-form` · Release: R0 (FR-reader-onboarding-001)

## Primary Actor

Thủ thư (đã xác thực qua `uc-access-control`).

## Stakeholders & Interests

| Stakeholder | Interest |
|-------------|----------|
| Người đọc | Nhận thẻ QR dùng được ngay |
| Bảo mật/pháp chế | Chỉ lưu bộ thông tin tối thiểu (OQ-core-003) |
| Thủ thư trưởng | Không có hồ sơ trùng định danh |

## Trigger

Người đọc đến quầy xin cấp thẻ.

## Preconditions

- Thủ thư đã đăng nhập, có quyền cấp tài khoản (DEC-SF-03; xác nhận lại ở OQ-reader-onboarding-003).
- Người đọc chưa có hồ sơ, hoặc hồ sơ đã có từ import nhưng chưa kích hoạt.

## Guarantees

- **Minimal Guarantee:** Không ghi hồ sơ thiếu trường bắt buộc hoặc trùng định danh; dữ liệu nhập được giữ để sửa.
- **Success Guarantee:** Hồ sơ được lưu, tài khoản đang hoạt động, thẻ QR có hiệu lực, có audit cùng giao dịch (BR-core-003).

## Main Success Scenario

1. Thủ thư mở `reader-form`, nhập mã độc giả, họ tên, thông tin liên hệ, hạn thẻ nếu có.
2. Hệ thống kiểm tra trường bắt buộc và định dạng.
3. Hệ thống kiểm trùng mã độc giả và mã QR thẻ.
4. Thủ thư xác nhận; hệ thống lưu hồ sơ, kích hoạt tài khoản, sinh thẻ QR, ghi audit trong một giao dịch.
5. Thủ thư giao thẻ QR cho người đọc.

## Extensions

**2a. Thiếu trường bắt buộc hoặc sai định dạng (E-core-001):**
- 2a1. Báo lỗi tại trường, giữ dữ liệu đã nhập; không ghi.

**3a. Mã độc giả hoặc mã QR đã tồn tại (E-core-003):**
- 3a1. Báo trùng, cho mở hồ sơ hiện có; không tạo hồ sơ thứ hai.
- 3a2. Hồ sơ có sẵn từ import nhưng chưa kích hoạt → Thủ thư mở hồ sơ đó và kích hoạt (bước 4).

**4a. Hai quầy cùng cấp cho một người (E-core-004):**
- 4a1. Chỉ lần lưu đầu thành công; quầy sau thấy báo trùng.

**4b. Audit ghi lỗi (E-core-007):**
- 4b1. Hủy giao dịch, không có hồ sơ nào được ghi; cảnh báo vận hành.

**Any. Người thao tác không có quyền (E-core-002):**
- Từ chối, ghi audit.

## Related Requirements

- FR: FR-reader-onboarding-001.
- BR dùng chung: BR-core-003, BR-core-004.
- Errors: E-core-001, E-core-002, E-core-003, E-core-004, E-core-007.
- Open: OQ-reader-onboarding-001, OQ-reader-onboarding-002, OQ-reader-onboarding-003.
- UC liên quan: `uc-access-control` (include), `uc-account-admin` (quản trị sau khi cấp), `uc-data-import` (hồ sơ có sẵn).
