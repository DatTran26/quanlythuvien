---
type: usecase
feature: notification-audit-ui
status: draft
updated: 2026-10-08
links:
  - docs/features/notification-audit-ui/usecases/notification-audit-ui-usecase-index.md
  - docs/features/notification-audit-ui/srs/notification-audit-ui-spec.md
---

# Use Case: Xem thông báo, nhật ký và lịch sử (uc-notification-audit-view)

> Scope: notification-audit-ui · Level: sea
> Screens: trung tâm thông báo, `audit-log`, `history-timeline` · Release: R1B (FR-notification-audit-ui-001..003)

## Primary Actor

Mọi vai trò (trung tâm thông báo). Quản trị viên (nhật ký audit, dòng thời gian lịch sử).

## Stakeholders & Interests

| Stakeholder | Interest |
|-------------|----------|
| Người đọc, Thủ thư | Xem lại thông báo đã lỡ |
| Bảo mật/pháp chế | Nhật ký chỉ đọc, che dữ liệu theo quyền |

## Trigger

Người dùng mở trung tâm thông báo; Quản trị viên cần tra ai đã làm gì.

## Preconditions

- Người dùng đã đăng nhập (include `uc-access-control`).

## Guarantees

- **Minimal Guarantee:** Không hiện thông báo của người khác; nhật ký không sửa được; dữ liệu nhạy cảm che theo quyền.
- **Success Guarantee:** Người dùng thấy đúng thông báo của mình; Quản trị viên lọc được nhật ký và xem lịch sử một đối tượng.

## Main Success Scenario

1. Người dùng mở trung tâm thông báo; hệ thống hiện thông báo mới nhất trước và số chưa đọc.
2. Mở một thông báo; hệ thống đánh dấu đã đọc.
3. Quản trị viên mở `audit-log`, lọc theo người làm, đối tượng, thời gian.
4. Mở một đối tượng để xem `history-timeline`: chuyển trạng thái, sự kiện tài chính, báo cáo hư hỏng, kết quả thông báo.

## Extensions

**3a. Không có quyền xem nhật ký (E-core-002):** từ chối, ghi audit.

**3b. Trường nhạy cảm ngoài quyền (E-core-009):** che, ghi audit.

**1a. Chưa có thông báo:** hiện trạng thái trống.

## Related Requirements

- FR: FR-notification-audit-ui-001..003.
- BR dùng chung: BR-core-004.
- Errors: E-core-002, E-core-009.
- Open: OQ-notification-audit-ui-001, OQ-core-003.
- UC liên quan: `uc-notification-outbox`, `uc-audit-capture`.
