---
type: usecase
feature: policy-config
status: draft
updated: 2026-10-12
links:
  - docs/features/policy-config/usecases/policy-config-usecase-index.md
  - docs/features/policy-config/srs/policy-config-spec.md
---

# Use Case: Cấu hình quy định (uc-policy-config)

> Scope: policy-config · Level: sea
> Screens: `admin-config` · Release: R0 (FR-policy-config-001)

## Primary Actor

Thủ thư.

## Stakeholders & Interests

| Stakeholder | Interest |
|-------------|----------|
| Thủ thư trưởng | Biết quy định đổi khi nào, ai đổi |
| Nhân viên | Quy định áp đúng tại quầy |

## Trigger

Thủ thư cần đổi một tham số quy định.

## Preconditions

- Thủ thư đã xác thực (include `uc-access-control`).

## Guarantees

- **Minimal Guarantee:** Giá trị ngoài miền không được lưu; giao dịch đã bắt đầu không bị ảnh hưởng.
- **Success Guarantee:** Giá trị mới có hiệu lực từ thời điểm chọn; audit ghi giá trị trước/sau, người đổi, thời điểm.

## Main Success Scenario

1. Thủ thư mở `admin-config`, chọn tham số.
2. Nhập giá trị mới và thời điểm hiệu lực.
3. Hệ thống kiểm tra miền giá trị, lưu, ghi audit.
4. Từ thời điểm hiệu lực, giao dịch mới dùng giá trị mới (BR-policy-config-001).

## Extensions

**3a. Giá trị ngoài miền hoặc thời điểm hiệu lực ở quá khứ (E-core-001):** báo lỗi, không lưu.

**3b. Tham số vừa được người khác sửa (E-core-004):** hiện giá trị mới nhất trước khi lưu.

**3c. Không có quyền (E-core-002):** từ chối, ghi audit.

## Related Requirements

- FR: FR-policy-config-001.
- BR: BR-policy-config-001; dùng chung BR-core-003.
- Errors: E-core-001, E-core-002, E-core-004, E-core-007.
- Open: OQ-policy-config-001, OQ-policy-config-002.
