---
type: usecase
feature: catalog-admin
status: draft
updated: 2026-10-12
links:
  - docs/features/catalog-admin/usecases/catalog-admin-usecase-index.md
  - docs/features/catalog-admin/srs/catalog-admin-spec.md
---

# Use Case: Quản trị đầu sách và danh mục (uc-catalog-admin)

> Scope: catalog-admin · Level: sea
> Screens: `catalog-search`, `bibliographic-detail`, `bibliographic-form` · Release: R0 (FR-catalog-admin-001..003)

## Primary Actor

Thủ thư (tạo, sửa, vô hiệu đầu sách và danh mục). Nhân viên (tra cứu).

## Stakeholders & Interests

| Stakeholder | Interest |
|-------------|----------|
| Nhân viên | Tra cứu nhanh số bản theo trạng thái |
| Thủ thư trưởng | Dữ liệu kho tin cậy, mọi thay đổi có audit |

## Trigger

Thủ thư cần tạo, sửa, vô hiệu đầu sách hoặc danh mục; Nhân viên cần tra cứu đầu sách.

## Preconditions

- Người thao tác đã xác thực (include `uc-access-control`); chỉ Thủ thư ghi được.
- Danh mục (thể loại, tác giả, nhà xuất bản, vị trí kệ) đã có hoặc được tạo cùng lúc.

## Guarantees

- **Minimal Guarantee:** Dữ liệu không hợp lệ không được ghi, dữ liệu nhập được giữ; không thao tác vượt quyền.
- **Success Guarantee:** Đầu sách được lưu nhất quán, không trùng, có audit; số khả dụng tra cứu được luôn tính từ trạng thái bản sao.

## Main Success Scenario

1. Người thao tác mở `catalog-search`, tìm theo tên, tác giả, ISBN, thể loại; lọc còn/hết (dưới 2 giây ở 50.000 bản sao — NFR-catalog-admin-001).
2. Mở `bibliographic-detail`: thông tin đầu sách, số bản khả dụng, đang giữ, đang mượn, không khả dụng, vị trí kệ.
3. Thủ thư mở `bibliographic-form`, tạo hoặc sửa đầu sách.
4. Hệ thống kiểm trường bắt buộc, định dạng, kiểm trùng; lưu và ghi audit trong một giao dịch.

## Extensions

**3a. Người thao tác không có quyền ghi (E-core-002):** từ chối, ghi audit, quay về chế độ chỉ đọc.

**4a. Thiếu trường hoặc sai định dạng (E-core-001):** báo lỗi tại trường, giữ dữ liệu.

**4b. Trùng đầu sách (E-core-003):** báo trùng, cho mở bản ghi hiện có.

**4c. Bản ghi vừa bị người khác sửa (E-core-004):** báo xung đột, hiện bản mới nhất, không ghi đè.

**5a. Vô hiệu đầu sách hoặc danh mục đã có lịch sử (BR-core-006):** chỉ vô hiệu, không xóa cứng; còn bản sao đang mượn hoặc đang giữ thì chặn (E-core-008).

**Nhánh D — Danh mục (FR-catalog-admin-003):** tạo, sửa, vô hiệu thể loại, tác giả, nhà xuất bản, vị trí kệ; cùng quy tắc kiểm trùng, audit, không xóa cứng.

## Related Requirements

- FR: FR-catalog-admin-001, FR-catalog-admin-002, FR-catalog-admin-003.
- NFR: NFR-catalog-admin-001.
- BR dùng chung: BR-core-003, BR-core-006.
- Errors: E-core-001, E-core-002, E-core-003, E-core-004, E-core-008.
- Open: OQ-catalog-admin-001, OQ-catalog-admin-002.
- UC liên quan: `uc-access-control` (include), `uc-copy-inventory` (bản sao của đầu sách).
