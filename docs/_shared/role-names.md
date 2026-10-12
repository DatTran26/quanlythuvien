# Vai trò theo nghiệp vụ gốc

Ngày 2026-10-12, người dùng yêu cầu dùng lại tên trong tài liệu nghiệp vụ nguồn, thay quyết định đổi tên ngày 2026-10-08. Xem [DEC-SF-01](../_product/decision-register.md) và [ma trận nghiệp vụ gốc](../he_thong_quan_ly_thu_vien.md).

| Tên hiện hành | Mã API / database | Trách nhiệm | Mã trước chuyển đổi |
|---|---|---|---|
| Người đọc | `READER` | Tự phục vụ, dữ liệu cá nhân | `READER` |
| Nhân viên | `STAFF` | Trực quầy, mượn/trả, hỗ trợ người đọc | `LIBRARIAN` |
| Thủ thư | `LIBRARIAN` | Quản lý dữ liệu, tài khoản, quy định, phê duyệt và báo cáo; kế thừa nghiệp vụ quầy | `ADMIN` |

Đây là thay đổi tên và mã, không mở rộng hay thu hẹp quyền. “Quầy lưu thông” là khu vực nghiệp vụ. `AppSession.isStaff` cho biết tài khoản có quyền vào khu vực quầy (Nhân viên hoặc Thủ thư); `isLibrarian` dành cho quyền quản lý. Đường dẫn `/admin/...` và các tên route quản trị vẫn là địa chỉ chức năng, không phải role Admin riêng.

## Nâng cấp database hiện có

Triển khai backend và frontend cùng bộ mã mới. Trước khi chạy backend mới trên database thật, dừng backend cũ và sao lưu đầy đủ. Với Docker Compose của dự án, có thể tạo dump vào trong container rồi chép ra ngoài; chọn tên file mới cho mỗi lần sao lưu:

```powershell
docker compose -f deploy/docker-compose.yml stop api
docker compose -f deploy/docker-compose.yml exec -T db pg_dump -U library -d library -Fc -f /tmp/library-before-role-names.dump
docker compose -f deploy/docker-compose.yml cp db:/tmp/library-before-role-names.dump ./library-before-role-names.dump
```

Chỉ tiếp tục khi cả lệnh dump và copy thành công. Lưu dump ở nơi riêng, không commit vào Git. Database bên ngoài Compose cần dùng thông tin kết nối thực tế và vị trí sao lưu được bảo vệ tương ứng.

Flyway chạy [V4__restore_original_role_names.sql](../../apps/api/src/main/resources/db/migration/V4__restore_original_role_names.sql) trước khi ứng dụng khởi động. Migration sao lưu id, role và tên hiển thị cũ vào `app_user_role_backup`, rồi chuyển cả hai role bằng một câu `CASE` để tránh nâng quyền Nhân viên. Chỉ hai tên hiển thị mặc định của tài khoản demo được đổi; email, mật khẩu, trạng thái, tên người dùng thật và các bản ghi nghiệp vụ giữ nguyên. Không sửa hoặc chạy lại các migration V1–V3.

Token cũ không có claim `roleVocabulary=source` bị từ chối. Người dùng cần đăng nhập lại một lần; nếu chấp nhận token `LIBRARIAN` cũ thì Nhân viên có thể bị hiểu nhầm thành Thủ thư. Không vận hành đồng thời hai phiên bản backend với hai nghĩa role khác nhau.

Database mới nhận bộ role mới từ seed. Các địa chỉ demo cũ giữ nguyên để không làm mất thông tin đăng nhập đang dùng: `admin@library.local` là Thủ thư, `librarian@library.local` là Nhân viên, `reader@library.local` là Người đọc. Tên email không quyết định quyền.

## Rollback

Dừng backend mới trước khi rollback. Khôi phục database từ dump cùng phiên bản backend và frontend trước chuyển đổi. Không chỉ đổi code: `LIBRARIAN` có ý nghĩa khác giữa hai phiên bản. Bảng `app_user_role_backup` là snapshot đối soát tại thời điểm migration, không thay thế bản sao lưu đầy đủ, đặc biệt nếu đã phát sinh tài khoản hay giao dịch sau khi nâng cấp. Không hạ role thủ công trong khi backend còn phục vụ request.
