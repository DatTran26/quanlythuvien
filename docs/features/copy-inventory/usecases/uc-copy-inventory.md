---
type: usecase
feature: copy-inventory
status: draft
updated: 2026-10-08
links:
  - docs/features/copy-inventory/usecases/copy-inventory-usecase-index.md
  - docs/features/copy-inventory/srs/copy-inventory-spec.md
  - docs/_shared/domain/lifecycle-inventory.md
---

# Use Case: Đăng ký bản sao và in nhãn QR (uc-copy-inventory)

> Scope: copy-inventory · Level: sea
> Screens: `copy-inventory`, `copy-form` · Release: R0 (FR-copy-inventory-001..003)

## Primary Actor

Quản trị viên. Thủ thư dán nhãn sau khi in.

## Stakeholders & Interests

| Stakeholder | Interest |
|-------------|----------|
| Thủ thư | Mỗi cuốn một mã, quét đúng một bản sao |
| Thủ thư trưởng | Kho khớp thực tế |

## Trigger

Có sách mới cần nhập kho, hoặc nhãn cũ hỏng cần in lại.

## Preconditions

- Quản trị viên đã xác thực (include `uc-access-control`).
- Đầu sách tồn tại và đang dùng (`uc-catalog-admin`).

## Guarantees

- **Minimal Guarantee:** Không tạo bản sao trùng mã; tạo N bản sao là tất cả hoặc không.
- **Success Guarantee:** N bản sao ở trạng thái Sẵn sàng (COPY-T00), mỗi bản một mã QR duy nhất, có file in nhãn, có audit.

## Main Success Scenario

1. Quản trị viên mở `copy-inventory` của một đầu sách, chọn thêm bản sao.
2. Nhập số bản, vị trí kệ, tình trạng ban đầu, cờ chỉ đọc tại chỗ nếu khác đầu sách.
3. Hệ thống tạo N bản sao Sẵn sàng, sinh N mã QR duy nhất, ghi audit trong một giao dịch.
4. Quản trị viên xuất file in nhãn; Thủ thư dán nhãn lên sách.

## Extensions

**1a. Đầu sách không tồn tại hoặc đã vô hiệu (E-core-003):** báo không tìm thấy.

**2a. Dữ liệu không hợp lệ (E-core-001):** báo lỗi, giữ dữ liệu.

**3a. Sửa hoặc vô hiệu bản sao đang mượn, đang giữ, hoặc đã thanh lý (E-core-008):** chặn; đổi trạng thái lưu thông chỉ qua feature nghiệp vụ.

**4a. In lại nhãn hỏng:** in đúng mã cũ, không cấp mã mới.

**Any. QR chỉ để tìm bản ghi (BR-copy-inventory-001):** sau khi quét vẫn kiểm tra quyền.

## Related Requirements

- FR: FR-copy-inventory-001, FR-copy-inventory-002, FR-copy-inventory-003.
- BR: BR-copy-inventory-001; dùng chung BR-core-003, BR-core-006.
- Errors: E-core-001, E-core-002, E-core-003, E-core-008.
- Transitions: COPY-T00.
- Open: OQ-copy-inventory-001, OQ-copy-inventory-002.
- UC liên quan: `uc-catalog-admin`, `uc-data-import` (bản sao từ import).
