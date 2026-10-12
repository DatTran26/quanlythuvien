# Hướng dẫn cài đặt và vận hành

## Cài đặt cục bộ

Yêu cầu Docker Desktop có Docker Compose. Để chạy toàn bộ API và PostgreSQL cục bộ:

```powershell
cd deploy
docker compose up --build
```

Compose công khai dịch vụ API tại cổng 8080 và PostgreSQL tại cổng 5432. Kiểm tra API bằng `http://localhost:8080/api/health`; dùng `http://localhost:8080/swagger-ui.html` để xem OpenAPI khi phát triển.

Để dừng stack, dùng `docker compose down` trong thư mục `deploy`. Việc này không xóa named volume; chỉ dùng `down -v` khi chủ động muốn xóa dữ liệu cục bộ.

## Chạy từng thành phần

API cần Java 21 nếu chạy ngoài Docker:

```powershell
cd apps/api
.\mvnw.cmd spring-boot:run
```

Ứng dụng Flutter cần Flutter SDK tương thích Dart `^3.13.3`:

```powershell
cd frontend
flutter pub get
flutter run -d chrome
```

Flutter mặc định dùng mock. Chỉ bật API thật sau khi API cục bộ đang chạy:

```powershell
flutter run -d chrome --dart-define=REAL_API=true
```

Trên Android emulator, client đã chọn địa chỉ emulator cho API; khi chạy trên thiết bị thật, cần một URL API mà thiết bị truy cập được. Không đổi mã nguồn chỉ để thay endpoint cục bộ.

## Cấu hình và an toàn

`apps/api/src/main/resources/application.yml` sở hữu danh sách cấu hình API. `deploy/.env.example` mô tả các biến cần khi dựng môi trường không dùng giá trị mặc định. Không commit `.env`, JWT secret, mật khẩu database, tệp khóa hay dữ liệu sao lưu.

`deploy/docker-compose.yml` là stack phát triển/demo: nó bật seed và dùng giá trị cục bộ. Không dùng nguyên cấu hình này cho production. Khi chạy profile `prod`, API tự chặn seed hoặc JWT secret mẫu qua `ProdGuard`.

## Kiểm thử trước khi đưa thay đổi lên nhánh dùng chung

```powershell
cd apps/api
.\mvnw.cmd verify

cd ..\..\frontend
flutter analyze
flutter test
```

## Production

Chưa có deployment target, credential store, backup/restore route hay quy trình rollback production nào được xác minh trong repository. Không suy diễn các thông tin này từ Docker Compose cục bộ. Khi một môi trường được thiết lập, ghi lại route không nhạy cảm gồm phạm vi môi trường, cách xác minh, quyền cần thiết và fallback trong tài liệu vận hành được kiểm soát truy cập.
