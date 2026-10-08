---
type: usecase
feature: ops-foundation
status: draft
updated: 2026-10-08
links:
  - docs/features/ops-foundation/usecases/ops-foundation-usecase-index.md
  - docs/features/ops-foundation/srs/ops-foundation-spec.md
---

# Use Case: Ghi audit cùng giao dịch (uc-audit-capture)

> Scope: ops-foundation · Level: subfunction
> Screens: — · Release: R0 (FR-ops-foundation-001)

## Primary Actor

Hệ thống.

## Stakeholders & Interests

| Stakeholder | Interest |
|-------------|----------|
| Bảo mật/pháp chế | Mọi thao tác nhạy cảm có dấu vết, dữ liệu cá nhân được che |
| Quản trị viên | Tra được ai làm gì (xem ở `notification-audit-ui`) |

## Trigger

Một thao tác tạo, sửa, xóa hoặc nhạy cảm của bất kỳ feature nào chuẩn bị ghi.

## Preconditions

- Thao tác đã qua kiểm quyền.

## Guarantees

- **Minimal Guarantee:** Không thao tác nhạy cảm nào được ghi mà thiếu audit.
- **Success Guarantee:** Thao tác và bản ghi audit cùng được ghi trong một giao dịch.

## Main Success Scenario

1. Thao tác chuẩn bị ghi; hệ thống tạo bản ghi audit: người làm, thời điểm, đối tượng, kết quả, giá trị trước/sau tối thiểu, lý do nếu có.
2. Hệ thống ghi thao tác và audit trong cùng giao dịch.
3. Giao dịch hoàn tất.

## Extensions

**2a. Audit ghi lỗi (E-core-007):** hủy toàn bộ thao tác, cảnh báo vận hành; chỉ thử lại khi audit hoạt động lại.

## Related Requirements

- FR: FR-ops-foundation-001.
- BR dùng chung: BR-core-003.
- Errors: E-core-007.
- Open: OQ-core-003 (lưu giữ, che dữ liệu).
- UC liên quan: được include bởi mọi UC có thao tác ghi.
