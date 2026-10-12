# Hướng dẫn thiết kế giao diện

Ứng dụng Flutter là giao diện chính cho người đọc, nhân viên và thủ thư. Ngôn ngữ hiển thị mặc định là tiếng Việt; giao diện cần truyền đạt trạng thái nghiệp vụ bằng nhãn, không chỉ bằng màu sắc.

Nguồn có thẩm quyền cho màu, typography, component và khả năng truy cập là [Hệ thống màu và nút bấm](./design/color-system.md). Token được triển khai tại `frontend/lib/core/theme/app_colors.dart` và theme Material tại `frontend/lib/core/theme/app_theme.dart`.

Khi tạo hoặc sửa màn hình:

- Giữ hành vi và mức quyền phù hợp role trong [role names](./_shared/role-names.md).
- Dùng component/theme sẵn có trước khi tạo style riêng.
- Giữ luồng mobile có thể thao tác bằng cảm ứng; luồng web vẫn phải hỗ trợ bàn phím và trạng thái focus.
- Ghi nhận thay đổi thiết kế bền vững vào `color-system.md`; không tạo tài liệu token trùng lặp.

Wireframe, user flow và yêu cầu theo từng chức năng được tổ chức trong `docs/features/<feature>/`.
