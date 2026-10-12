# Changelog – App Flutter

Ghi những thay đổi đáng chú ý của `frontend/`. Mới nhất ở trên.
Mỗi thành viên tự thêm dòng của mình khi mở PR, ghi rõ `[TV1]`, `[TV2]`, `[TV3]`.

Quy ước (theo [Keep a Changelog](https://keepachangelog.com/vi/1.1.0/)):

- Nhóm mục: **Thêm**, **Sửa**, **Đổi**, **Xóa**, **Lỗ hổng API** (chỗ app phải dùng mock vì backend chưa có).
- Viết theo chức năng người dùng thấy, không liệt kê từng file.
- Việc chưa merge nằm ở `[Chưa phát hành]`. Khi merge vào `develop`, đổi thành ngày merge.
- Changelog của tài liệu BA nằm ở `docs/_shared/changelog.md` và do hook ghi, không sửa tay.

## [0.1.0] - 2026-10-12

### Thêm

- [TV3] Lớp đọc mock data dùng chung `core/data/mock_db.dart` (đọc `assets/mock/mock-data.json`, mốc thời gian `referenceNow`). Cần nhóm duyệt.
- [TV3] Khung feature `accounts`, `reader_portal`, `fine`, `notification` theo cấu trúc `models/ data/ widgets/ screens/`, mỗi màn có TODO, route và spec.
- [TV3] `accounts`: model tài khoản, `AccountApi` + `MockAccountApi` (liệt kê, tìm người đọc, chi tiết kèm phiếu mở, đặt trước, công nợ).
- [TV3] Màn danh sách người đọc (`reader-list`): tìm theo tên, email, mã thẻ; đủ trạng thái lỗi / đang tải / rỗng / có dữ liệu.
- [TV3] Màn chi tiết người đọc (`reader-detail`, chỉ đọc): hồ sơ, mã thẻ, nghĩa vụ đang mở (phiếu mượn, đặt trước, công nợ).
- [TV3] Chip trạng thái tài khoản (Hoạt động / Chờ kích hoạt / Đã khóa), màu lấy từ `AppColors` nên đúng cả chế độ sáng và tối.
- [TV3] Hàm `formatVnd` dùng chung (`core/utils/format.dart`, 55000 → "55.000đ"). Cần nhóm duyệt.
- [TV3] Khóa / mở tài khoản người đọc ở màn chi tiết: lý do bắt buộc, cảnh báo nghĩa vụ đang mở trước khi khóa, nút tắt theo trạng thái, ghi audit `USER_LOCK` / `USER_UNLOCK` (mock, trong bộ nhớ).
- [TV3] Hộp thoại dùng chung `status_change_dialog.dart` (Form + validator, nút Danger khi khóa).
- [TV3] `AccountException { code, message }` cùng dạng lỗi backend. Luật chặn giống `AuthService.setStatus`: không tự khóa, không đổi quản trị viên, không đổi tài khoản chờ kích hoạt.
- [TV3] Danh sách người đọc tự tải lại khi quay về từ chi tiết.
- [TV3] Màn tài khoản Thủ thư (`staff-accounts`, mở từ AppBar danh sách người đọc): danh sách thủ thư, khóa / mở dùng lại hộp thoại lý do, tạo tài khoản mới (họ tên, email, mật khẩu tạm ≥ 8 ký tự). Email trùng (không phân biệt hoa thường) báo ngay dưới ô email, hộp thoại không đóng. Ghi audit `STAFF_CREATE`.
- [TV3] Màn cấp tài khoản người đọc tại quầy (`reader-form`, nút "Cấp tài khoản mới" ở danh sách): tài khoản ACTIVE ngay, mã thẻ mới (mock tăng dần R10000008…), ghi audit `READER_CREATE`. Email trùng: báo tại ô và nút "Mở hồ sơ hiện có". Lưu xong `pushReplacement` sang chi tiết.
- [TV3] Nút "Kích hoạt tài khoản" ở chi tiết cho tài khoản chờ kích hoạt, ghi audit `READER_ACTIVATE`.
- [TV3] Thư viện `qr_flutter` (hiện mã QR thẻ người đọc). Thành viên khác chạy `flutter pub get` sau khi kéo code.
- [TV3] Cổng người đọc (`reader_portal`): khung có thanh tab dưới, Thẻ QR (chỉ hiện khi tài khoản hoạt động), Sách đang mượn (hạn gần nhất lên đầu, chip "Còn N ngày" / "Quá hạn N ngày", kéo để tải lại), Lịch sử mượn (lọc theo khoảng ngày). Hàm `formatDate` dùng chung.
- [TV3] Tra cứu sách (`reader-search`, tab đầu của cổng người đọc): tìm theo tên, tác giả, ISBN, **không phân biệt dấu**; chip lọc "Còn sách" và theo thể loại; nhãn "Còn 1/3" / "Hết sách" / "Đọc tại chỗ". Ẩn đầu sách ngưng. Chi tiết đầu sách (`reader-bib-detail`): số bản mượn được, vị trí kệ, nút "Đặt trước" chờ nối route TV2.
- [TV3] Hàm dùng chung `core/utils/text_search.dart` (`foldVietnamese`, `matchesQuery`): so khớp bỏ dấu tiếng Việt, dùng được cho mọi ô tìm kiếm. Cần nhóm duyệt.
- [TV3] Luật phạt quá hạn `features/fine/data/fine_rules.dart` (hàm thuần): số ngày trễ theo ngày lịch, phạt = ngày × mức/ngày có trần giá bìa (OQ-overdue-fines-001), lịch nhắc (2 ngày trước hạn; quá hạn ngày 1 rồi mỗi 3 ngày), chặn mượn khi nợ ≥ `fineBlockVnd`. TV2 dùng chung cho màn trả sách.
- [TV3] Model `Fine` (đọc được cả `readerId` của mock và `reader.id` của API), `FinePolicy`; `FineApi` + `MockFineApi` (quy định phạt, khoản phạt của người đọc, tổng nợ). `MockDb.object()` đọc bản ghi đơn (`lendingPolicy`).
- [TV3] Công nợ của tôi (`reader-my-fines`, tab cuối cổng người đọc): tổng nợ (nền đỏ + cảnh báo khi bị chặn mượn), phạt tạm tính của sách đang trễ (tách khỏi nợ thật, backend ghi nợ khi trả), danh sách khoản phạt có chip trạng thái; chỉ xem, nộp tại quầy (CHK-reader-self-service-005).
- [TV3] Sách đang mượn: thêm dòng "Tạm tính …đ" cho sách trễ hạn.
- [TV3] Thu phạt tại quầy (`fine-collection-basic`): tra công nợ theo mã thẻ, chi tiết khoản phạt, thu tiền mặt (> 0 và ≤ số dư, thu một phần được; số dư về 0 thì "Đã thanh toán"); mỗi lần mở màn có `operationId`, gửi lặp không ghi lần hai (E-core-005); thủ thư chỉ được thu (CHK-007). Ghi sự kiện PAYMENT + audit `FINE_COLLECT`.
- [TV3] `fine-collection-adv`: biên nhận `BL-năm-0001` tăng dần; sổ sự kiện tài chính (ghi nhận, thu, miễn, điều chỉnh) kèm kiểm tra "số dư khớp sổ" (BR-core-002); miễn / điều chỉnh tăng-giảm chỉ Quản trị viên, lý do bắt buộc, hộp thoại xác thực lại tạm (chờ màn session-expired của TV1). Audit `FINE_WAIVE`, `FINE_ADJUST`.
- [TV3] `notification-audit-ui`: trung tâm thông báo cho mọi vai trò (mới nhất trước, chấm chưa đọc, đánh dấu đã đọc / tất cả), chuông có huy hiệu số chưa đọc trên AppBar (cổng người đọc, danh sách người đọc); nhật ký audit chỉ Quản trị viên, lọc theo người làm / đối tượng / khoảng ngày, che email (E-core-009); dòng thời gian của một bản ghi; người không có quyền thấy màn từ chối (E-core-002).
- [TV3] `notification-core`: màn trạng thái gửi (Đã gửi / Đang thử lại / Lỗi hẳn, số lần thử, lỗi cuối – CHK-003); khóa / mở tài khoản phát thông báo cho chủ tài khoản (FR-notification-core-001). Mock data thêm `tv3.notificationOutbox` (docs và assets).
- [TV3] Thư viện `flutter_localizations` (SDK): app dùng tiếng Việt, lịch chọn ngày nhập theo ngày/tháng/năm. `main.dart` của TV1 cần thêm 3 dòng cấu hình (xem README, mục Tiếng Việt).
- [TV3] `frontend/README.md`: hướng dẫn cài thư viện (`flutter pub get`), thêm thư viện, chạy và kiểm tra (`flutter analyze` + checklist thủ công trong `docs/features/*/test/`), cấu trúc thư mục.

### Đổi

- [TV3] `MockAccountApi`: gom code lặp vào `_findUser`, `_insertUser`, `_audit` (refactor, không đổi hành vi).

### Sửa

- [TV3] `core/theme/app_theme.dart` (file của TV1): chip lọc (FilterChip, ChoiceChip) không có màu chữ nên rơi về chữ đen, không đọc được ở chế độ tối. Thêm màu chữ theo trạng thái (thường `onSurface`, đang chọn `onPrimaryContainer`), nền thường `divider`, nền đang chọn `primaryContainer`. Tương phản chữ 7,3–13,9 (≥ 4,5). Chip trạng thái truyền màu riêng nên không bị ảnh hưởng. Cần TV1 duyệt.
- [TV3] Chi tiết người đọc: thêm lời giải thích dưới nút Khóa / Mở khóa / Kích hoạt khi nút bị tắt (E-core-008 "disabled action + explanation").
- [TV3] Hộp thoại tạo thủ thư không còn phình ra khi gõ email dài: cố định chiều rộng nội dung (`SizedBox(width: 360)`), chữ trong ô cuộn ngang.

### Đề xuất cho khung app

- [TV3] Cho người dùng chọn giao diện Sáng / Tối / Theo hệ thống: `themeMode` ở gốc `MaterialApp`, công tắc trong menu, lưu bằng `shared_preferences`. Hiện app chỉ tự theo hệ thống khi gắn cả `theme` và `darkTheme`. Thuộc khung app (TV1).
- [TV3] Bảng màu tối chưa được kiểm tra trên thiết bị thật (`docs/design/color-system.md`). Có thể giả lập trong Chrome DevTools: Emulate CSS prefers-color-scheme: dark.

### Lỗ hổng API

- [TV3] T1–T13: ghi trong đầu các file `features/*/data/*_api.dart`. Chính: chưa có API liệt kê tài khoản (T1), `/me` chưa trả mã thẻ (T5), chưa thu phạt một phần và chưa lưu biên nhận (T8, T10), `/audit` chưa lọc (T12), người đọc chưa đọc được mức phạt / ngưỡng chặn (T14), `/collect` chưa nhận idempotency key (T15).

## 2026-10-10

### Thêm

- [TV1] Theme và màu dùng chung `core/theme/app_colors.dart`, `core/theme/app_theme.dart`.
- [TV2] Khung feature `circulation`, `condition`, `reservation`, `reports`.
- Mock data `docs/_shared/mock-data.json` và bảng phân công `docs/_product/team-assignment.md`.
