# Hệ thống Quản lý Thư viện

Ứng dụng hỗ trợ thư viện quản lý đầu sách, từng bản sao, người đọc và các nghiệp vụ lưu thông. Dự án gồm ứng dụng Flutter cho ba vai trò nghiệp vụ, REST API Spring Boot và PostgreSQL.

> Phạm vi sản phẩm và trạng thái từng hạng mục được quản lý tại [PRD](docs/_product/prd.md) và [roadmap](docs/_product/roadmap.md). Không phải mọi hạng mục trong các tài liệu này đã được phát hành.

## Bắt đầu nhanh

### Điều kiện cần

- Docker Desktop có Docker Compose.
- Java 21 để chạy API ngoài Docker.
- Flutter SDK tương thích Dart `^3.13.3` để chạy ứng dụng khách.

### Chạy API và cơ sở dữ liệu cục bộ

Từ thư mục `deploy`, khởi động PostgreSQL và API bằng Docker Compose:

```powershell
cd deploy
docker compose up --build
```

Khi API sẵn sàng, kiểm tra tại `http://localhost:8080/api/health` hoặc mở Swagger UI tại `http://localhost:8080/swagger-ui.html`.

### Chạy Flutter

```powershell
cd frontend
flutter pub get
flutter run -d chrome
```

Ứng dụng mặc định dùng dữ liệu giả để phát triển giao diện. Để gọi API cục bộ thật khi chạy trên web, thêm cờ sau:

```powershell
flutter run -d chrome --dart-define=REAL_API=true
```

Hướng dẫn cài đặt, biến môi trường, kiểm thử và giới hạn triển khai nằm trong [deployment guide](docs/deployment-guide.md).

## Kiểm thử

```powershell
cd apps/api
.\mvnw.cmd verify

cd ..\..\frontend
flutter analyze
flutter test
```

## Kiến trúc

```text
Flutter (web / Android)
        │ REST + JWT
        ▼
Spring Boot API ─── PostgreSQL
        │
        └── local file storage (tệp đính kèm)
```

- [Tổng quan kiến trúc](docs/system-architecture.md)
- [Điều hướng mã nguồn](docs/codebase-summary.md)
- [Quy ước phát triển](docs/code-standards.md)
- [Hướng dẫn thiết kế giao diện](docs/design-guidelines.md)
- [Toàn bộ tài liệu](docs/README.md)

## Đóng góp

Đọc [CONTRIBUTING.md](CONTRIBUTING.md) trước khi tạo nhánh hoặc pull request. Không commit tệp `.env`, khóa riêng, token, dữ liệu sao lưu hay thông tin đăng nhập thật.

## Giấy phép

Dự án được phát hành theo [MIT License](LICENSE).
