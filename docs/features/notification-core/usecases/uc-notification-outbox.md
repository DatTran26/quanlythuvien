---
type: usecase
feature: notification-core
status: draft
updated: 2026-10-08
links:
  - docs/features/notification-core/usecases/notification-core-usecase-index.md
  - docs/features/notification-core/srs/notification-core-spec.md
---

# Use Case: Phát và gửi thông báo (uc-notification-outbox)

> Scope: notification-core · Level: subfunction
> Screens: `notification-status` · Release: R1A (FR-notification-core-001)

## Primary Actor

Hệ thống. Quản trị viên theo dõi trạng thái gửi.

## Stakeholders & Interests

| Stakeholder | Interest |
|-------------|----------|
| Người đọc | Nhận thông báo đúng sự kiện, đúng lúc |
| Vận hành | Không mất thông báo khi kênh lỗi; hàng lỗi có người xử lý |

## Trigger

Một giao dịch nghiệp vụ có phát sinh thông báo hoàn tất; hoặc job nhắc hạn chạy.

## Preconditions

- Kênh thông báo hiệu lực có trong `PolicyConfig`; in-app luôn có.

## Guarantees

- **Minimal Guarantee:** Gửi thông báo lỗi không làm hỏng giao dịch chính (BR-core-005).
- **Success Guarantee:** Mọi giao dịch có sự kiện thông báo; thông báo được gửi hoặc nằm ở hàng lỗi có cảnh báo.

## Main Success Scenario

1. Giao dịch ghi sự kiện thông báo vào hàng đợi bền cùng giao dịch.
2. Hệ thống lấy sự kiện chờ, gửi in-app; sự kiện quan trọng gửi thêm email.
3. Kênh xác nhận: đánh dấu đã gửi.

## Extensions

**3a. Kênh từ chối hoặc hết giờ (E-notification-core-001):** đánh dấu lỗi, thử lại theo chính sách; quá số lần thì chuyển hàng lỗi và cảnh báo vận hành.

**3b. Toàn bộ kênh ngoài ngưng (E-notification-core-002):** sự kiện tích lũy trong hàng đợi, gửi tiếp khi kênh phục hồi.

**3c. Địa chỉ nhận sai hoặc trống:** lỗi có lý do riêng; thông báo vẫn nằm trong in-app.

**1a. Job gửi chạy lại:** không gửi lại thông báo đã gửi.

## Related Requirements

- FR: FR-notification-core-001.
- NFR: NFR-notification-core-001.
- BR dùng chung: BR-core-005.
- Errors: E-notification-core-001, E-notification-core-002.
- Open: OQ-notification-core-001..004.
- UC liên quan: include bởi `uc-checkout`, `uc-return`, `uc-overdue-assessment`, `uc-damage-report`, `uc-lost-found`, `uc-account-admin`.
