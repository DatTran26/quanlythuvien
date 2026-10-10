# Checklist — data-import

[1] [Yes] CHK-data-import-001 → FR-data-import-001, BR-data-import-001 · Kiểm tra dry-run báo tổng dòng, dòng hợp lệ, dòng lỗi kèm lý do, dòng trùng và dòng bỏ qua
[1] [No] CHK-data-import-002 → FR-data-import-001, BR-data-import-001 · Kiểm tra dry-run không đổi kho chính thức
[1] [Yes] CHK-data-import-003 → FR-data-import-001, E-data-import-001 · Kiểm tra file không đọc được không ghi dữ liệu nghiệp vụ
[1] [Yes] CHK-data-import-004 → FR-data-import-001, BR-data-import-001 · Kiểm tra commit lô đã dry-run đạt thì kho nhận đúng lô đó
[1] [Yes] CHK-data-import-005 → FR-data-import-001, FR-copy-inventory-002 · Kiểm tra commit lô cấp mã định vị không trùng
[1] [Yes] CHK-data-import-006 → FR-data-import-001, BR-data-import-001 · Kiểm tra báo cáo đối soát sau commit có số lượng, dòng lỗi và dòng bỏ qua
[1] [Yes] CHK-data-import-007 → FR-data-import-001, BR-data-import-001, E-data-import-001 · Kiểm tra dry-run còn lỗi và chưa có override đã duyệt thì không ghi kho
[1] [No] CHK-data-import-008 → FR-data-import-001, E-data-import-001 · Kiểm tra một dòng commit lỗi làm rollback toàn bộ lô
[1] [Yes] CHK-data-import-009 → FR-data-import-001, E-core-005 · Kiểm tra gửi lại cùng operation_id trả kết quả lô gốc
