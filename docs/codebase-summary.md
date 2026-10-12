# Điều hướng mã nguồn

| Khu vực | Owner thực thi | Điểm vào |
|---|---|---|
| Ứng dụng Flutter | `frontend/` | `lib/main.dart` khởi tạo ứng dụng; `lib/core/routing/app_router.dart` ánh xạ điều hướng và quyền truy cập. |
| Client API | `frontend/lib/core/network/` | `api_client.dart` chọn mock hoặc REST API theo `REAL_API`. |
| API Spring Boot | `apps/api/` | `LibraryApplication.java` khởi động ứng dụng; controller trong `identity/` và `web/` là biên HTTP. |
| Nghiệp vụ API | `apps/api/src/main/java/com/quanlythuvien/` | Các package theo miền như catalog, circulation, fine, condition, reservation và notification. |
| Schema dữ liệu | `apps/api/src/main/resources/db/migration/` | Flyway quản lý migration theo thứ tự phiên bản. |
| Cấu hình chạy | `apps/api/src/main/resources/application.yml` | Biến môi trường, port, JWT và thư mục lưu tệp. |
| Compose cục bộ | `deploy/` | `docker-compose.yml` dựng PostgreSQL và API; `.env.example` là danh mục biến cho môi trường ngoài Compose. |
| Đặc tả nghiệp vụ | `docs/` | `docs/README.md` là cửa vào tài liệu sản phẩm, miền và feature. |

Các đường dẫn trên là ranh giới điều hướng, không phải danh sách đầy đủ mã nguồn. Tìm theo miền hoặc feature trước khi thêm một abstraction dùng chung.

## Luồng tích hợp chính

Ứng dụng Flutter gọi API dưới `/api`. Mặc định, Flutter dùng backend giả; `REAL_API=true` chuyển client sang Spring Boot thật. Spring Boot xác thực request bằng JWT, áp dụng quyền theo phương thức và lưu dữ liệu nghiệp vụ trong PostgreSQL. Ảnh hư hỏng được lưu qua storage cục bộ do API cấu hình.

OpenAPI được phát sinh khi chạy API tại `/v3/api-docs`; Swagger UI là điểm khám phá hợp đồng HTTP, không duy trì bản sao endpoint trong Markdown.
