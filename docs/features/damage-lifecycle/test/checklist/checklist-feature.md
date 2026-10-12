# Checklist — damage-lifecycle

[1] [Yes] CHK-damage-lifecycle-001 → FR-damage-lifecycle-001 · Kiểm tra báo cáo hư hỏng lưu mức độ, mô tả và trạng thái chờ xử lý
[1] [Yes] CHK-damage-lifecycle-002 → FR-damage-lifecycle-001, BR-damage-lifecycle-001 · Kiểm tra báo cáo chờ xử lý không tự đóng khi chưa có disposition
[1] [Yes] CHK-damage-lifecycle-003 → FR-damage-lifecycle-001, BR-damage-lifecycle-002, E-damage-lifecycle-001 · Kiểm tra tệp bằng chứng rủi ro không được lưu
[1] [No] CHK-damage-lifecycle-004 → FR-damage-lifecycle-001, BR-core-003, E-core-007 · Kiểm tra audit thất bại thì báo cáo hư hỏng bị rollback
[1] [Yes] CHK-damage-lifecycle-005 → FR-damage-lifecycle-001, BR-damage-lifecycle-001 · Kiểm tra chọn bác bỏ thì báo cáo đóng và có audit
[1] [Yes] CHK-damage-lifecycle-006 → FR-damage-lifecycle-001, BR-damage-lifecycle-001 · Kiểm tra chọn sửa thì báo cáo đóng và có audit
[1] [Yes] CHK-damage-lifecycle-007 → FR-damage-lifecycle-001, BR-damage-lifecycle-001 · Kiểm tra chọn thanh lý thì báo cáo đóng và có audit
[1] [Yes] CHK-damage-lifecycle-008 → FR-damage-lifecycle-001, E-core-002 · Kiểm tra Nhân viên quầy không đóng được báo cáo bằng disposition
[1] [Yes] CHK-damage-lifecycle-009 → FR-damage-lifecycle-001, E-core-008 · Kiểm tra disposition không hợp lệ với trạng thái hiện tại không đổi báo cáo
[1] [No] CHK-damage-lifecycle-010 → FR-damage-lifecycle-001, E-core-004 · Kiểm tra disposition đến sau không ghi đè disposition đã commit
[1] [No] CHK-damage-lifecycle-011 → FR-damage-lifecycle-001, BR-core-003, E-core-007 · Kiểm tra audit thất bại thì disposition không được giữ
