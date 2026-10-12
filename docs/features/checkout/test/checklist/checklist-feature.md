# Checklist — checkout

[1] [Yes] CHK-checkout-001 → FR-checkout-001, BR-checkout-001 · Kiểm tra phiếu đủ điều kiện ghi toàn bộ khoản mượn trong một giao dịch
[1] [Yes] CHK-checkout-002 → FR-checkout-001, BR-checkout-001 · Kiểm tra phiếu đủ điều kiện chuyển mọi bản sao trong phiếu sang đang mượn
[1] [Yes] CHK-checkout-003 → FR-checkout-001, BR-checkout-001, BR-checkout-002, E-checkout-001 · Kiểm tra một bản sao không hợp lệ thì không khoản mượn nào trong phiếu được ghi
[1] [Yes] CHK-checkout-004 → FR-checkout-001, BR-core-001, E-core-006 · Kiểm tra người đọc không đủ điều kiện thì không tạo phiếu
[2] [Yes] CHK-checkout-005 → FR-checkout-001, E-core-006 · Kiểm tra người đọc không đủ điều kiện thì màn mượn nêu lý do bị chặn
[1] [Yes] CHK-checkout-006 → FR-checkout-002, E-core-005 · Kiểm tra gửi lại cùng yêu cầu mượn không tạo phiếu thứ hai
[1] [No] CHK-checkout-007 → FR-checkout-002, E-core-004 · Kiểm tra phiếu thua khi tranh cùng một bản sao không ghi khoản mượn nào
[1] [No] CHK-checkout-008 → FR-checkout-001, BR-core-003, E-core-007 · Kiểm tra audit thất bại thì phiếu mượn không được giữ
[2] [Yes] CHK-checkout-009 → FR-checkout-001 · Kiểm tra tải lại trang khi phiếu mượn chưa xác nhận không tạo khoản mượn
[2] [No] CHK-checkout-010 → FR-checkout-001, NFR-core-002 · Kiểm tra mất mạng lúc xác nhận phiếu mượn không để phiếu ghi một phần
