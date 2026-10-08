# Checklist — fine-collection-basic

[1] [Yes] CHK-fine-collection-basic-001 → FR-fine-collection-basic-001, BR-core-002, BR-fine-collection-basic-001 · Kiểm tra thu tiền mặt hợp lệ ghi đúng một FinancialEvent PAYMENT
[1] [Yes] CHK-fine-collection-basic-002 → FR-fine-collection-basic-001 · Kiểm tra Fine chuyển sang PAID khi số dư sau khoản thu bằng 0
[1] [Yes] CHK-fine-collection-basic-003 → FR-fine-collection-basic-001, BR-fine-collection-basic-001, E-core-005, E-fine-collection-basic-002 · Kiểm tra cùng operation_id không tạo PAYMENT thứ hai
[1] [Yes] CHK-fine-collection-basic-004 → FR-fine-collection-basic-001, E-fine-collection-basic-001 · Kiểm tra ghi PAYMENT thất bại thì Fine giữ nghĩa vụ cũ
[1] [No] CHK-fine-collection-basic-005 → FR-fine-collection-basic-001, E-core-004 · Kiểm tra khoản thu đến sau không ghi số tiền vượt số dư tại lúc commit
[1] [No] CHK-fine-collection-basic-006 → FR-fine-collection-basic-001, BR-core-003, E-core-007 · Kiểm tra audit thất bại thì PAYMENT bị rollback
[1] [Yes] CHK-fine-collection-basic-007 → FR-fine-collection-basic-001, E-core-009 · Kiểm tra Thủ thư quầy không ghi được event tài chính ngoài PAYMENT
