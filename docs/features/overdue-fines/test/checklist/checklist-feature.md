# Checklist — overdue-fines

[1] [No] CHK-overdue-fines-001 → FR-overdue-fines-001, BR-core-002 · Kiểm tra trả quá hạn ghi đúng một FinancialEvent ASSESSMENT
[1] [Yes] CHK-overdue-fines-002 → FR-overdue-fines-001, BR-core-002 · Kiểm tra sau khi ghi phạt quá hạn thì Fine ở trạng thái UNPAID
[1] [No] CHK-overdue-fines-003 → FR-overdue-fines-001, BR-core-002 · Kiểm tra event phạt đã ghi không bị sửa trực tiếp
[1] [Yes] CHK-overdue-fines-004 → FR-overdue-fines-001, E-core-008 · Kiểm tra trả lặp không tạo ASSESSMENT thứ hai
[1] [No] CHK-overdue-fines-005 → FR-overdue-fines-001, BR-core-003, E-core-007 · Kiểm tra audit thất bại thì Fine và ASSESSMENT của lần phạt bị rollback
