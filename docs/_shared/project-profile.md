---
type: project-profile
status: draft
updated: 2026-10-05
links:
  - docs/he_thong_quan_ly_thu_vien.md
---

# Hồ sơ dự án Hệ thống Quản lý Thư viện

## Domain

Sản phẩm số hóa hoạt động của một thư viện vật lý: quản lý đầu sách và từng bản sao, định danh bằng QR, phục vụ mượn–trả–đặt trước, kiểm soát quá hạn/phạt/hư hỏng và cung cấp báo cáo vận hành. Bản đầu ưu tiên một cơ sở và các nghiệp vụ cần để quầy mượn–trả hoạt động an toàn với dữ liệu thật.

## Người dùng & thuật ngữ

| Nhóm | Thuật ngữ dùng trong tài liệu | Nhu cầu chính | Ngày xác lập |
|---|---|---|---|
| Thành viên thư viện | Người đọc | Tra cứu, xem thẻ QR, theo dõi khoản mượn, tự phục vụ | 2026-10-05 |
| Người trực quầy | Nhân viên | Quét QR, mượn–trả, xử lý ngoại lệ và hỗ trợ người đọc | 2026-10-05 |
| Người quản lý nghiệp vụ | Thủ thư | Quản lý kho, quy định, tài khoản, báo cáo và phê duyệt ngoại lệ | 2026-10-05 |
| Người chịu trách nhiệm sản phẩm | Thủ thư trưởng | Chốt quy định, phạm vi pilot và quyết định go-live | 2026-10-05 |

## Thị trường & ngôn ngữ

- Thị trường mục tiêu ban đầu: một thư viện tại Việt Nam.
- Ngôn ngữ sản phẩm: tiếng Việt.
- Tiền tệ: VND; ngày hiển thị theo `dd/mm/yyyy`; múi giờ nghiệp vụ UTC+7.
- Kênh sử dụng nền: web responsive; nhân viên có thể dùng camera điện thoại hoặc nhập mã thủ công.

## Compliance

- Dữ liệu hồ sơ, lịch sử mượn, khoản phạt, ảnh hư hỏng và nhật ký thao tác được xem là dữ liệu cần kiểm soát quyền truy cập.
- Chỉ thu thập và hiển thị dữ liệu cần cho nghiệp vụ của từng vai trò.
- Thời hạn lưu, quyền yêu cầu xem/sửa/xóa dữ liệu và việc xử lý dữ liệu người chưa thành niên phải được người phụ trách pháp lý hoặc quản trị dữ liệu phê duyệt trước go-live.
- Không coi một thời hạn lưu cụ thể là đã được phê duyệt khi chưa có căn cứ pháp lý và chính sách nội bộ.

## Mô hình vận hành

- Pilot tại một cơ sở, dự kiến hai quầy phục vụ.
- Thủ thư trưởng là Product Owner; đại diện nhân viên quầy tham gia UAT.
- Một bộ quy định mượn chung trong MVP; khả năng phân loại người đọc được để sau khi có nhu cầu thực tế.
- Thu phạt tại quầy bằng tiền mặt trong MVP.
- Không hỗ trợ offline, thanh toán trực tuyến, sách điện tử hoặc nhiều chi nhánh trong baseline đầu tiên.

## Baseline đề xuất (chưa phê duyệt)

| Chủ đề | Đề xuất | Trạng thái | Ngày |
|---|---|---|---|
| Đăng ký người đọc | Tự đăng ký; chỉ được mượn sau khi nhân viên kích hoạt | `PROPOSAL` — chờ GATE-DEC | 2026-10-05 |
| Phiếu mượn | Một bản sao tương ứng một Loan; biên nhận nhóm theo lần xác nhận | `PROPOSAL` — chờ domain approval | 2026-10-05 |
| Thông báo | Trong ứng dụng và email cho sự kiện quan trọng; chưa có SMS/Zalo/push | `PROPOSAL` — chờ GATE-DEC | 2026-10-05 |
| Hư hỏng | Bản sao bị chặn lưu thông ngay khi báo cáo và chờ thủ thư xử lý | `PROPOSAL` — chờ domain approval | 2026-10-05 |
| Import | Có nhập Excel cho đầu sách và bản sao, kèm dry-run và đối soát | `PROPOSAL` — file đại diện còn thiếu | 2026-10-05 |
| Mở rộng | Attendance, online payment, multi-branch và offline là candidate, chưa cam kết | `PROPOSAL` — chưa cam kết release | 2026-10-05 |
