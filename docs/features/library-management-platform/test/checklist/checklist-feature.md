#1. Xác thực và phiên làm việc

##1.1. Vào đúng phạm vi vai trò

[1] [Yes] CHK-LMP-001 → FR-LMP-006, BR-LMP-015 · Kiểm tra người dùng hợp lệ xác thực thành công thì chỉ mở không gian làm việc đúng vai trò đã cấp
[1] [Yes] CHK-LMP-002 → FR-LMP-006, E-LMP-002 · Kiểm tra người dùng không có quyền thì bị từ chối và không thấy dữ liệu ngoài quyền
[1] [No] CHK-LMP-003 → FR-LMP-006, E-LMP-002 · Kiểm tra lần truy cập bị từ chối được ghi nhận
[1] [Yes] CHK-LMP-004 → FR-LMP-006, E-LMP-016, BR-LMP-015 · Kiểm tra trường nhạy cảm bị che với người không có quyền trường đó

##1.2. Phiên hết hạn và xác thực lại

[1] [Yes] CHK-LMP-005 → FR-LMP-007, E-LMP-017 · Kiểm tra phiên hết hạn thì dữ liệu đã ghi vẫn còn
[1] [Yes] CHK-LMP-006 → FR-LMP-007, E-LMP-017 · Kiểm tra hành động đang dở không được ghi khi phiên hết hạn
[1] [Yes] CHK-LMP-007 → FR-LMP-007, E-LMP-017 · Kiểm tra tác vụ nhạy cảm không chạy khi người dùng chưa xác thực lại

#2. Danh mục và bản sao

##2.1. Hồ sơ thư mục

[1] [Yes] CHK-LMP-008 → FR-LMP-001 · Kiểm tra Quản trị viên lưu hồ sơ thư mục hợp lệ thì mở lại đúng thuộc tính đã lưu
[1] [Yes] CHK-LMP-009 → FR-LMP-001, E-LMP-001 · Kiểm tra hồ sơ thư mục thiếu dữ liệu bắt buộc không được ghi
[2] [Yes] CHK-LMP-010 → FR-LMP-001, E-LMP-001 · Kiểm tra form hồ sơ thư mục giữ dữ liệu đã nhập sau lỗi validation
[1] [Yes] CHK-LMP-011 → FR-LMP-001, E-LMP-003 · Kiểm tra khóa nghiệp vụ đã tồn tại không tạo hồ sơ thư mục thứ hai
[1] [No] CHK-LMP-012 → FR-LMP-001, BR-LMP-017, E-LMP-015 · Kiểm tra hồ sơ thư mục đã có lịch sử không bị xóa cứng
[1] [Yes] CHK-LMP-013 → FR-LMP-001, E-LMP-002 · Kiểm tra người không có quyền catalog không ghi được hồ sơ thư mục

##2.2. Bản sao và mã định vị

[1] [Yes] CHK-LMP-014 → FR-LMP-002, FR-LMP-026 · Kiểm tra đăng ký bản sao gắn đúng một mã định vị chưa trùng
[1] [Yes] CHK-LMP-015 → FR-LMP-026, BR-LMP-011 · Kiểm tra quét mã chỉ mở đúng bản ghi
[1] [Yes] CHK-LMP-016 → FR-LMP-026, BR-LMP-011 · Kiểm tra sau khi quét mã hệ thống vẫn xét quyền người đang thao tác
[1] [Yes] CHK-LMP-017 → FR-LMP-002, E-LMP-003 · Kiểm tra mã định vị đã dùng không tạo bản sao mới
[1] [No] CHK-LMP-018 → FR-LMP-002, BR-LMP-017, E-LMP-015 · Kiểm tra bản sao đã có lịch sử không bị xóa cứng

##2.3. Tra cứu khả dụng

[1] [Yes] CHK-LMP-019 → FR-LMP-003 · Kiểm tra số khả dụng, đang giữ, đang mượn và không khả dụng khớp trạng thái các bản sao
[2] [Yes] CHK-LMP-020 → FR-LMP-003, E-LMP-003 · Kiểm tra tra cứu không khớp không trả một đầu sách giả

#3. Hồ sơ người đọc

##3.1. Tạo và cập nhật

[1] [Yes] CHK-LMP-021 → FR-LMP-004 · Kiểm tra lưu hồ sơ người đọc giữ đúng thông tin liên hệ đã nhập
[1] [Yes] CHK-LMP-022 → FR-LMP-004 · Kiểm tra lưu hồ sơ người đọc giữ đúng trạng thái hoạt động đã chọn
[1] [Yes] CHK-LMP-023 → FR-LMP-004, E-LMP-001 · Kiểm tra hồ sơ người đọc thiếu dữ liệu bắt buộc không được ghi
[1] [Yes] CHK-LMP-024 → FR-LMP-004, E-LMP-003 · Kiểm tra định danh người đọc đã tồn tại không tạo hồ sơ thứ hai
[1] [Yes] CHK-LMP-025 → FR-LMP-004, E-LMP-016, BR-LMP-015 · Kiểm tra trường dữ liệu cá nhân ngoài quyền bị che
[1] [No] CHK-LMP-026 → FR-LMP-004, BR-LMP-017 · Kiểm tra hồ sơ người đọc đã có lịch sử không bị xóa cứng

#4. Cấu hình quy định

##4.1. Hiệu lực theo thời điểm

[1] [Yes] CHK-LMP-027 → FR-LMP-021 · Kiểm tra giao dịch bắt đầu sau thời điểm hiệu lực dùng tham số mới
[1] [No] CHK-LMP-028 → FR-LMP-021 · Kiểm tra giao dịch đã ghi giữ bằng chứng quy định tại thời điểm ghi
[1] [Yes] CHK-LMP-029 → FR-LMP-021, E-LMP-002 · Kiểm tra người không có quyền cấu hình không đổi được quy định đang hiệu lực
[1] [Yes] CHK-LMP-030 → FR-LMP-021, E-LMP-001 · Kiểm tra tham số không hợp lệ theo quy tắc đã phê duyệt không được kích hoạt

#5. Nhập liệu

##5.1. Dry-run

[1] [Yes] CHK-LMP-031 → FR-LMP-022, BR-LMP-014 · Kiểm tra dry-run báo tổng dòng, dòng hợp lệ, dòng lỗi kèm lý do, dòng trùng và dòng bỏ qua
[1] [No] CHK-LMP-032 → FR-LMP-022, BR-LMP-014 · Kiểm tra dry-run không đổi kho chính thức
[1] [Yes] CHK-LMP-033 → FR-LMP-022, E-LMP-014 · Kiểm tra file không đọc được không ghi dữ liệu nghiệp vụ

##5.2. Commit lô

[1] [Yes] CHK-LMP-034 → FR-LMP-022, BR-LMP-014 · Kiểm tra commit lô đã dry-run đạt thì kho nhận đúng lô đó
[1] [Yes] CHK-LMP-035 → FR-LMP-022, FR-LMP-026 · Kiểm tra commit lô cấp mã định vị không trùng
[1] [Yes] CHK-LMP-036 → FR-LMP-022, BR-LMP-014 · Kiểm tra báo cáo đối soát sau commit có số lượng, dòng lỗi và dòng bỏ qua
[1] [Yes] CHK-LMP-037 → FR-LMP-022, BR-LMP-014, E-LMP-014 · Kiểm tra dry-run còn lỗi và chưa có override đã duyệt thì không ghi kho
[1] [No] CHK-LMP-038 → FR-LMP-022, E-LMP-014 · Kiểm tra một dòng commit lỗi làm rollback toàn bộ lô
[1] [Yes] CHK-LMP-039 → FR-LMP-022, E-LMP-006 · Kiểm tra gửi lại cùng operation_id trả kết quả lô gốc
[1] [No] CHK-LMP-040 → FR-LMP-020, BR-LMP-013, E-LMP-013 · Kiểm tra audit không ghi được thì lô import bị rollback

#6. Audit

##6.1. Bằng chứng hành động nhạy cảm

[1] [Yes] CHK-LMP-041 → FR-LMP-020 · Kiểm tra người có quyền xem được ai thực hiện hành động nhạy cảm đã commit
[1] [Yes] CHK-LMP-042 → FR-LMP-020 · Kiểm tra bằng chứng audit của hành động đã commit có thời điểm, tài nguyên và kết quả
[1] [No] CHK-LMP-043 → FR-LMP-020, BR-LMP-013, E-LMP-013 · Kiểm tra audit thất bại thì hành động nhạy cảm không còn kết quả đã commit
[1] [Yes] CHK-LMP-044 → FR-LMP-020, E-LMP-002, E-LMP-016 · Kiểm tra người không có quyền audit bị từ chối

#7. Mượn tại quầy

##7.1. Phiếu nhiều bản sao

[1] [Yes] CHK-LMP-045 → FR-LMP-008, BR-LMP-001 · Kiểm tra phiếu đủ điều kiện ghi toàn bộ khoản mượn trong một giao dịch
[1] [Yes] CHK-LMP-046 → FR-LMP-008, BR-LMP-001 · Kiểm tra phiếu đủ điều kiện chuyển mọi bản sao trong phiếu sang đang mượn
[1] [Yes] CHK-LMP-047 → FR-LMP-008, BR-LMP-001, BR-LMP-002, E-LMP-004 · Kiểm tra một bản sao không hợp lệ thì không khoản mượn nào trong phiếu được ghi
[1] [Yes] CHK-LMP-048 → FR-LMP-008, BR-LMP-003, E-LMP-007 · Kiểm tra người đọc không đủ điều kiện thì không tạo phiếu
[2] [Yes] CHK-LMP-049 → FR-LMP-008, E-LMP-007 · Kiểm tra người đọc không đủ điều kiện thì màn mượn nêu lý do bị chặn
[1] [Yes] CHK-LMP-050 → FR-LMP-009, E-LMP-006 · Kiểm tra gửi lại cùng yêu cầu mượn không tạo phiếu thứ hai
[1] [No] CHK-LMP-051 → FR-LMP-009, E-LMP-005 · Kiểm tra phiếu thua khi tranh cùng một bản sao không ghi khoản mượn nào
[1] [No] CHK-LMP-052 → FR-LMP-008, BR-LMP-013, E-LMP-013 · Kiểm tra audit thất bại thì phiếu mượn không được giữ
[1] [Yes] CHK-LMP-053 → FR-LMP-026, BR-LMP-011 · Kiểm tra quét mã lúc mượn vẫn phải qua kiểm tra điều kiện mượn

#8. Trả sách

##8.1. Đóng khoản mượn

[1] [Yes] CHK-LMP-054 → FR-LMP-010 · Kiểm tra nhận trả đóng khoản mượn trước khi bản sao nhận trạng thái tiếp theo
[1] [Yes] CHK-LMP-055 → FR-LMP-010 · Kiểm tra người đọc không đủ điều kiện mượn mới vẫn đóng được khoản mượn khi trả
[1] [Yes] CHK-LMP-056 → FR-LMP-010, E-LMP-015 · Kiểm tra trả lại bản sao của khoản đã đóng không nhân đôi kết quả
[1] [No] CHK-LMP-057 → FR-LMP-010, E-LMP-005 · Kiểm tra yêu cầu trả đến sau không đóng phiếu thêm một lần nữa
[1] [No] CHK-LMP-058 → FR-LMP-010, BR-LMP-013, E-LMP-013 · Kiểm tra audit thất bại thì lần trả không đổi khoản mượn

#9. Phạt và thu tiền mặt

##9.1. Ghi nhận phạt quá hạn

[1] [No] CHK-LMP-059 → FR-LMP-014, BR-LMP-007 · Kiểm tra trả quá hạn ghi đúng một FinancialEvent ASSESSMENT
[1] [Yes] CHK-LMP-060 → FR-LMP-014, BR-LMP-007 · Kiểm tra sau khi ghi phạt quá hạn thì Fine ở trạng thái UNPAID
[1] [No] CHK-LMP-061 → FR-LMP-014, BR-LMP-007 · Kiểm tra event phạt đã ghi không bị sửa trực tiếp
[1] [Yes] CHK-LMP-062 → FR-LMP-014, E-LMP-015 · Kiểm tra trả lặp không tạo ASSESSMENT thứ hai
[1] [No] CHK-LMP-063 → FR-LMP-014, BR-LMP-013, E-LMP-013 · Kiểm tra audit thất bại thì Fine và ASSESSMENT của lần phạt bị rollback

##9.2. Thu tiền mặt

[1] [Yes] CHK-LMP-064 → FR-LMP-015, BR-LMP-007, BR-LMP-008 · Kiểm tra thu tiền mặt hợp lệ ghi đúng một FinancialEvent PAYMENT
[1] [Yes] CHK-LMP-065 → FR-LMP-015 · Kiểm tra Fine chuyển sang PAID khi số dư sau khoản thu bằng 0
[1] [Yes] CHK-LMP-066 → FR-LMP-015, BR-LMP-008, E-LMP-006, E-LMP-010 · Kiểm tra cùng operation_id không tạo PAYMENT thứ hai
[1] [Yes] CHK-LMP-067 → FR-LMP-015, E-LMP-009 · Kiểm tra ghi PAYMENT thất bại thì Fine giữ nghĩa vụ cũ
[1] [No] CHK-LMP-068 → FR-LMP-015, E-LMP-005 · Kiểm tra khoản thu đến sau không ghi số tiền vượt số dư tại lúc commit
[1] [No] CHK-LMP-069 → FR-LMP-015, BR-LMP-013, E-LMP-013 · Kiểm tra audit thất bại thì PAYMENT bị rollback
[1] [Yes] CHK-LMP-070 → FR-LMP-015, E-LMP-016 · Kiểm tra Thủ thư quầy không ghi được event tài chính ngoài PAYMENT

#10. Hư hỏng và mất sách

##10.1. Báo cáo hư hỏng

[1] [Yes] CHK-LMP-071 → FR-LMP-017 · Kiểm tra báo cáo hư hỏng lưu mức độ, mô tả và trạng thái chờ xử lý
[1] [Yes] CHK-LMP-072 → FR-LMP-017, BR-LMP-009 · Kiểm tra báo cáo chờ xử lý không tự đóng khi chưa có disposition
[1] [Yes] CHK-LMP-073 → FR-LMP-017, BR-LMP-012, E-LMP-011 · Kiểm tra tệp bằng chứng rủi ro không được lưu
[1] [No] CHK-LMP-074 → FR-LMP-017, BR-LMP-013, E-LMP-013 · Kiểm tra audit thất bại thì báo cáo hư hỏng bị rollback
[1] [Yes] CHK-LMP-075 → FR-LMP-017, BR-LMP-009 · Kiểm tra chọn bác bỏ thì báo cáo đóng và có audit
[1] [Yes] CHK-LMP-076 → FR-LMP-017, BR-LMP-009 · Kiểm tra chọn sửa thì báo cáo đóng và có audit
[1] [Yes] CHK-LMP-077 → FR-LMP-017, BR-LMP-009 · Kiểm tra chọn thanh lý thì báo cáo đóng và có audit
[1] [Yes] CHK-LMP-078 → FR-LMP-017, E-LMP-002 · Kiểm tra Thủ thư quầy không đóng được báo cáo bằng disposition
[1] [Yes] CHK-LMP-079 → FR-LMP-017, E-LMP-015 · Kiểm tra disposition không hợp lệ với trạng thái hiện tại không đổi báo cáo
[1] [No] CHK-LMP-080 → FR-LMP-017, E-LMP-005 · Kiểm tra disposition đến sau không ghi đè disposition đã commit
[1] [No] CHK-LMP-081 → FR-LMP-017, BR-LMP-013, E-LMP-013 · Kiểm tra audit thất bại thì disposition không được giữ

##10.2. Mất và tìm lại

[1] [No] CHK-LMP-082 → FR-LMP-018, FR-LMP-014, BR-LMP-007 · Kiểm tra ghi nhận mất tạo đúng một ASSESSMENT bồi thường
[1] [Yes] CHK-LMP-083 → FR-LMP-018 · Kiểm tra ghi nhận mất đánh dấu bản sao đã mất
[1] [Yes] CHK-LMP-084 → FR-LMP-018, E-LMP-015 · Kiểm tra ghi nhận mất lặp không tạo ASSESSMENT thứ hai
[1] [No] CHK-LMP-085 → FR-LMP-018, BR-LMP-010 · Kiểm tra tìm lại sách không xóa nghĩa vụ bồi thường đã ghi
[1] [No] CHK-LMP-086 → FR-LMP-018, BR-LMP-013, E-LMP-013 · Kiểm tra audit thất bại thì ghi nhận mất bị rollback

#11. Thông báo

##11.1. Outbox không làm mất giao dịch

[1] [No] CHK-LMP-087 → FR-LMP-019, BR-LMP-016 · Kiểm tra giao dịch nghiệp vụ vẫn commit khi kênh thông báo chưa gửi xong
[1] [No] CHK-LMP-088 → FR-LMP-019, BR-LMP-016 · Kiểm tra giao dịch đã commit có sự kiện thông báo trong outbox
[1] [Yes] CHK-LMP-089 → FR-LMP-019, E-LMP-012, E-LMP-018 · Kiểm tra kênh gửi lỗi thì trạng thái gửi được ghi là lỗi
[1] [No] CHK-LMP-090 → FR-LMP-019, BR-LMP-016, E-LMP-018 · Kiểm tra lỗi gửi thông báo không xóa giao dịch nghiệp vụ đã commit

#12. Chất lượng nền

##12.1. Trạng thái đang xử lý

[2] [Yes] CHK-LMP-091 → NFR-LMP-008 · Kiểm tra màn quầy đang xử lý giao dịch thì hiện trạng thái đang xử lý trước khi có kết quả

##12.2. Bàn phím và nhãn

[2] [Yes] CHK-LMP-092 → NFR-LMP-008, NFR-LMP-009 · Kiểm tra điều khiển chính trên màn quầy có tên đọc được
[2] [Yes] CHK-LMP-093 → NFR-LMP-009 · Kiểm tra focus trên điều khiển chính của màn quầy nhìn thấy được khi dùng bàn phím

##12.3. Khung Mobile 375

[2] [Yes] CHK-LMP-094 → NFR-LMP-012 · Kiểm tra khung Mobile 375 vẫn hiện hành động chính của màn quầy

##12.4. Gián đoạn thao tác

[2] [Yes] CHK-LMP-095 → FR-LMP-008 · Kiểm tra tải lại trang khi phiếu mượn chưa xác nhận không tạo khoản mượn
[2] [No] CHK-LMP-096 → FR-LMP-008, NFR-LMP-003 · Kiểm tra mất mạng lúc xác nhận phiếu mượn không để phiếu ghi một phần
[2] [Yes] CHK-LMP-097 → FR-LMP-006, E-LMP-017 · Kiểm tra quay lại từ màn kết quả sau khi phiên hết hạn không mở lại giao dịch dở
