# Checklist — notification-core

[1] [No] CHK-notification-core-001 → FR-notification-core-001, BR-core-005 · Kiểm tra giao dịch nghiệp vụ vẫn commit khi kênh thông báo chưa gửi xong
[1] [No] CHK-notification-core-002 → FR-notification-core-001, BR-core-005 · Kiểm tra giao dịch đã commit có sự kiện thông báo trong outbox
[1] [Yes] CHK-notification-core-003 → FR-notification-core-001, E-notification-core-001, E-notification-core-002 · Kiểm tra kênh gửi lỗi thì trạng thái gửi được ghi là lỗi
[1] [No] CHK-notification-core-004 → FR-notification-core-001, BR-core-005, E-notification-core-002 · Kiểm tra lỗi gửi thông báo không xóa giao dịch nghiệp vụ đã commit
