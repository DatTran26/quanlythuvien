# Đồng bộ vai trò theo nghiệp vụ gốc

## Kết quả và phạm vi

Người dùng yêu cầu dùng thống nhất Người đọc (`READER`), Nhân viên (`STAFF`, trực quầy), Thủ thư (`LIBRARIAN`, quản lý nghiệp vụ). Giữ nguyên quyền đang có của từng nhóm, không bổ sung role hay sửa các nghiệp vụ khác. Giữ mọi thay đổi có sẵn trong workspace.

## Các bước

- [x] Đồng bộ enum, phân quyền API, phiên đăng nhập, seed và UI Flutter.
- [x] Thêm migration bảo toàn role cũ trước khi chuyển đổi một lần; ngăn token cũ bị nâng quyền do đổi nghĩa `LIBRARIAN`.
- [x] Đồng bộ tài liệu sống, wireframe, dữ liệu mẫu và nguồn sinh tài liệu; cập nhật quyết định thay thế DEC-SF-01 theo yêu cầu ngày 2026-10-12.
- [x] Kiểm tra migration, quyền từng role, đăng nhập, điều hướng và toàn bộ kiểm thử liên quan; review diff.

## Tiêu chí nghiệm thu

- Tên hiển thị và mã role thống nhất trong mã nguồn, API, tài liệu và dữ liệu mẫu.
- Nhân viên dùng nghiệp vụ quầy; quyền quản lý chỉ dành cho Thủ thư như nhóm quản trị trước đây. Người đọc giữ quyền cá nhân.
- Chuyển `ADMIN` cũ thành `LIBRARIAN`, `LIBRARIAN` cũ thành `STAFF` bằng một câu CASE; sao lưu giá trị cũ trước UPDATE. Không sửa các migration đã áp dụng.
- Token theo bộ tên cũ bị từ chối và yêu cầu đăng nhập lại, tránh nâng quyền vô tình.
- Không đổi tài liệu nghiệp vụ nguồn và các bản ghi lịch sử; ghi rõ bộ tên hiện hành tại tài liệu sở hữu.

## Vận hành và rollback

Docker daemon và PostgreSQL/API local chưa chạy khi kiểm tra; không có database live để migrate. Kiểm thử dùng H2 tạm thời. Trước áp dụng trên database thật, dừng API và sao lưu đầy đủ bằng pg_dump. Migration giữ snapshot id/role/display_name trước đổi. Rollback phải khôi phục cả bản ứng dụng cũ và role từ snapshot hoặc dump, không chỉ đổi riêng mã nguồn.

## Kết quả xác minh

- Maven `verify` với JDK 21: 11 test qua, build JAR thành công. Migration kiểm tra database V3 có tài khoản cũ, snapshot, giữ tên thật/trạng thái và chạy lại không đổi nghĩa role; JWT kiểm tra token cũ bị từ chối.
- `flutter test`: 13 test qua; `flutter analyze`: không có vấn đề. Bao gồm đăng nhập đủ 3 role, chặn cấu hình đối với Nhân viên/Người đọc, quay về trang chủ từ quầy, và xác nhận Nhân viên không thể mở quản trị tài khoản hoặc đọc thông báo của Thủ thư.
- Đối chiếu tự động 27 annotation phân quyền API với bản trước đổi: chỉ thay tên mã, quyền tương ứng giữ nguyên.
- Mock nguồn và asset giống nhau, đúng 3 mã role. Tài liệu sống/UI/wireframe không còn tên Quản trị viên; các ghi chú lịch sử và hướng dẫn chuyển đổi giữ tên cũ để giải thích.
- Không phát sinh link file nội bộ hỏng; `git diff --check` qua. KG dựng lại từ tài liệu; simplifier kiểm tra test migration/JWT và không cần sửa.
- Review trực tiếp luồng API/session/role/migration đã phát hiện và xử lý hai lỗi mock UI: chỉ Thủ thư mới mở được quản trị tài khoản Nhân viên, và thông báo luôn dùng đúng tài khoản trong phiên. Chưa áp dụng migration lên database thật.
