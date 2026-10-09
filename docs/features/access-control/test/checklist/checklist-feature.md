# Checklist — access-control

[1] [Yes] CHK-access-control-001 → FR-access-control-001, BR-core-004 · Kiểm tra người dùng hợp lệ xác thực thành công thì chỉ mở không gian làm việc đúng vai trò đã cấp
[1] [Yes] CHK-access-control-002 → FR-access-control-001, E-core-002 · Kiểm tra người dùng không có quyền thì bị từ chối và không thấy dữ liệu ngoài quyền
[1] [No] CHK-access-control-003 → FR-access-control-001, E-core-002 · Kiểm tra lần truy cập bị từ chối được ghi nhận
[1] [Yes] CHK-access-control-004 → FR-access-control-001, E-core-009, BR-core-004 · Kiểm tra trường nhạy cảm bị che với người không có quyền trường đó
[1] [Yes] CHK-access-control-005 → FR-access-control-002, E-access-control-001 · Kiểm tra phiên hết hạn thì dữ liệu đã ghi vẫn còn
[1] [Yes] CHK-access-control-006 → FR-access-control-002, E-access-control-001 · Kiểm tra hành động đang dở không được ghi khi phiên hết hạn
[1] [Yes] CHK-access-control-007 → FR-access-control-002, E-access-control-001 · Kiểm tra tác vụ nhạy cảm không chạy khi người dùng chưa xác thực lại
[2] [Yes] CHK-access-control-008 → FR-access-control-001, E-access-control-001 · Kiểm tra quay lại từ màn kết quả sau khi phiên hết hạn không mở lại giao dịch dở
