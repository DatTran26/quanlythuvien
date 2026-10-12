# Checklist — copy-inventory

[1] [Yes] CHK-copy-inventory-001 → FR-copy-inventory-001, FR-copy-inventory-002 · Kiểm tra đăng ký bản sao gắn đúng một mã định vị chưa trùng
[1] [Yes] CHK-copy-inventory-002 → FR-copy-inventory-002, BR-copy-inventory-001 · Kiểm tra quét mã chỉ mở đúng bản ghi
[1] [Yes] CHK-copy-inventory-003 → FR-copy-inventory-002, BR-copy-inventory-001 · Kiểm tra sau khi quét mã hệ thống vẫn xét quyền người đang thao tác
[1] [Yes] CHK-copy-inventory-004 → FR-copy-inventory-001, E-core-003 · Kiểm tra mã định vị đã dùng không tạo bản sao mới
[1] [No] CHK-copy-inventory-005 → FR-copy-inventory-001, BR-core-006, E-core-008 · Kiểm tra bản sao đã có lịch sử không bị xóa cứng
[1] [Yes] CHK-copy-inventory-006 → FR-copy-inventory-002, BR-copy-inventory-001 · Kiểm tra quét mã lúc mượn vẫn phải qua kiểm tra điều kiện mượn
