# Tổng quan sản phẩm

## Mục tiêu

Hệ thống Quản lý Thư viện số hóa việc quản lý đầu sách, bản sao vật lý và dịch vụ tại quầy. Sản phẩm hướng tới một thư viện tại Việt Nam; giao diện và định dạng nghiệp vụ ưu tiên tiếng Việt, VND và múi giờ UTC+7.

Mục tiêu chi tiết, phạm vi feature và tiêu chí thành công thuộc [PRD](./_product/prd.md). Hồ sơ về người dùng, vận hành pilot và ràng buộc dữ liệu thuộc [project profile](./_shared/project-profile.md).

## Người dùng

| Nhóm | Mục đích sử dụng |
|---|---|
| Người đọc | Tra cứu, theo dõi thẻ, khoản mượn và các thông tin của chính mình. |
| Nhân viên | Phục vụ tại quầy, quét mã và hỗ trợ giao dịch lưu thông. |
| Thủ thư | Quản lý dữ liệu, tài khoản, quy định, phê duyệt ngoại lệ và báo cáo. |

Tên vai trò, mã hệ thống và phạm vi quyền được quy định tại [role names](./_shared/role-names.md); không suy luận quyền từ tên màn hình hoặc địa chỉ API.

## Ranh giới sản phẩm hiện tại

Baseline phục vụ một cơ sở, vận hành trực tuyến và ưu tiên giao dịch tại quầy. Thanh toán trực tuyến, nhiều chi nhánh, sách điện tử và chế độ offline không thuộc baseline. Các hạng mục mở rộng chỉ là định hướng cho đến khi được phê duyệt trong [roadmap](./_product/roadmap.md).

## Dữ liệu và quyết định

Dữ liệu tài khoản, lịch sử mượn, khoản phạt, ảnh hư hỏng và nhật ký thao tác cần được phân quyền. Chính sách lưu trữ và quyền dữ liệu cá nhân chưa được coi là đã chốt cho tới khi có phê duyệt nghiệp vụ/pháp lý; xem [project profile](./_shared/project-profile.md) và [decision register](./_product/decision-register.md).

## Đọc tiếp

- [Kiến trúc hệ thống](system-architecture.md) cho các thành phần kỹ thuật đang có.
- [Đặc tả lõi](./_shared/core-spec.md) và [mô hình miền](./_shared/domain/) cho quy tắc nghiệp vụ dùng chung.
- [Tài liệu feature](./features/) cho yêu cầu, luồng và checklist của từng chức năng.
