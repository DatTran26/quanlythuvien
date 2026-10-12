# Checklist — return-handling

[1] [Yes] CHK-return-handling-001 → FR-return-handling-001 · Kiểm tra nhận trả đóng khoản mượn trước khi bản sao nhận trạng thái tiếp theo
[1] [Yes] CHK-return-handling-002 → FR-return-handling-001 · Kiểm tra người đọc không đủ điều kiện mượn mới vẫn đóng được khoản mượn khi trả
[1] [Yes] CHK-return-handling-003 → FR-return-handling-001, E-core-008 · Kiểm tra trả lại bản sao của khoản đã đóng không nhân đôi kết quả
[1] [No] CHK-return-handling-004 → FR-return-handling-001, E-core-004 · Kiểm tra yêu cầu trả đến sau không đóng phiếu thêm một lần nữa
[1] [No] CHK-return-handling-005 → FR-return-handling-001, BR-core-003, E-core-007 · Kiểm tra audit thất bại thì lần trả không đổi khoản mượn
