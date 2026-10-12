# Quy ước phát triển

## Nguyên tắc chung

- Giữ thay đổi trong đúng module và hợp đồng bị ảnh hưởng; không đưa bí mật, dữ liệu cá nhân hoặc bản sao lưu vào Git.
- Tên và quyền vai trò phải lấy từ [role names](./_shared/role-names.md). Thay đổi mã role cần tương thích giữa API, Flutter, migration và test.
- Schema PostgreSQL được quản lý bằng Flyway tại `apps/api/src/main/resources/db/migration/`. Chỉ thêm migration mới; không sửa migration đã áp dụng cho dữ liệu dùng chung.
- Giao diện Flutter dùng token và quy ước tại [color system](./design/color-system.md), thay vì thêm mã màu tùy ý vào màn hình.

## Kiểm thử và chất lượng

Chạy kiểm thử nhỏ nhất có thể chứng minh thay đổi, sau đó mở rộng khi ảnh hưởng hợp đồng dùng chung:

```powershell
cd apps/api
.\mvnw.cmd verify

cd ..\..\frontend
flutter analyze
flutter test
```

Test backend dùng profile `test` với H2; cấu hình nằm ở `apps/api/src/test/resources/application-test.yml`. Không hướng test vào database phát triển hoặc production. Checklist nghiệp vụ và kiểm thử thủ công của từng feature nằm tại `docs/features/<feature>/test/`.

## Tổ chức mã

- `frontend/lib/core/` chứa các thành phần dùng chung; feature mới thuộc `frontend/lib/features/<feature>/` theo ranh giới hiện có.
- `apps/api/src/main/java/com/quanlythuvien/` nhóm code theo miền nghiệp vụ. Controller là biên HTTP; service chịu trách nhiệm quy tắc nghiệp vụ; repository truy cập dữ liệu.
- Thay đổi public API phải đi cùng kiểm thử hợp đồng và cập nhật điểm vào tài liệu phù hợp, thay vì tạo danh sách endpoint thủ công thứ hai.

## Quy trình Git

Luồng nhánh, pull request và quy ước commit thuộc [CONTRIBUTING.md](../CONTRIBUTING.md). Mọi thay đổi public cần giữ `README.md`, tài liệu kiến trúc hoặc hướng dẫn vận hành nhất quán khi hợp đồng người dùng hoặc cách cài đặt thay đổi.
