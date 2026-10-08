---
type: usecase
feature: fine-collection-adv
status: draft
updated: 2026-10-08
links:
  - docs/features/fine-collection-adv/usecases/fine-collection-adv-usecase-index.md
  - docs/features/fine-collection-adv/srs/fine-collection-adv-spec.md
---

# Use Case: Biên nhận, miễn, điều chỉnh và đối soát phạt (uc-fine-adjustment)

> Scope: fine-collection-adv · Level: sea
> Screens: `financial-events` · Release: R1B (FR-fine-collection-adv-001..003)

## Primary Actor

Quản trị viên (miễn, điều chỉnh, đảo, hoàn). Thủ thư (in biên nhận, đối soát cuối ca).

## Stakeholders & Interests

| Stakeholder | Interest |
|-------------|----------|
| Bộ phận tài chính | Mọi thay đổi có lý do, thẩm quyền, không sửa sự kiện đã ghi |
| Người đọc | Có biên nhận khi nộp phạt |
| Thủ thư trưởng | Tiền mặt cuối ca khớp sổ |

## Trigger

Cần in biên nhận thu phạt; cần miễn, điều chỉnh, đảo, hoàn một khoản phạt; kết thúc ca.

## Preconditions

- Người thao tác đã xác thực (include `uc-access-control`); thao tác tài chính yêu cầu xác thực lại.
- Chính sách tài chính đã được duyệt (OQ-fine-collection-adv-001) — nếu chưa, chức năng miễn/điều chỉnh tắt.

## Guarantees

- **Minimal Guarantee:** Không sửa, xóa sự kiện đã ghi; không thao tác nào vượt quyền; khoản đã đóng không mở lại.
- **Success Guarantee:** Sự kiện mới được ghi với lý do và audit; số dư khớp tổng sự kiện.

## Main Success Scenario

1. Quản trị viên mở `financial-events` của một khoản phạt.
2. Chọn miễn, điều chỉnh, đảo hoặc hoàn; nhập số tiền và lý do.
3. Hệ thống yêu cầu xác thực lại, kiểm quyền, kiểm thẩm quyền theo số tiền, kiểm người thao tác không phải người tạo khoản (BR-fine-collection-adv-001).
4. Hệ thống ghi sự kiện mới và audit trong một giao dịch; số dư về 0 sau miễn thì khoản chuyển Đã miễn.

## Extensions

**2a. Thiếu lý do (E-core-001):** báo lỗi.

**3a. Xác thực lại thất bại:** hủy thao tác.

**3b. Không có quyền hoặc tự duyệt khoản mình tạo (E-core-002):** từ chối, ghi audit.

**3c. Vượt ngưỡng cần duyệt cấp cao:** chờ người duyệt (ngưỡng và người duyệt còn mở).

**4a. Khoản phạt đã đóng (E-core-008):** chỉ cho đảo, hoàn, điều chỉnh có tham chiếu sự kiện gốc.

**4b. Audit lỗi (E-core-007):** hủy thao tác.

**Nhánh R — Biên nhận (FR-fine-collection-adv-001):** Thủ thư in biên nhận cho khoản thu với mã khoản thu.

**Nhánh S — Đối soát cuối ca (FR-fine-collection-adv-003):** Thủ thư nhập tiền mặt thực có; lệch so với tổng khoản thu thì ghi sự kiện đối soát và cảnh báo vận hành.

## Related Requirements

- FR: FR-fine-collection-adv-001, FR-fine-collection-adv-002, FR-fine-collection-adv-003.
- BR: BR-fine-collection-adv-001; dùng chung BR-core-002, BR-core-003, BR-core-004.
- Errors: E-core-001, E-core-002, E-core-004, E-core-005, E-core-007, E-core-008, E-core-009.
- Open: OQ-fine-collection-adv-001..003; DEC-D3-04, DEC-D3-08.
- UC liên quan: `uc-fine-cash-payment` (thu tiền), `uc-lost-found` (đảo, hoàn khi tìm lại).
