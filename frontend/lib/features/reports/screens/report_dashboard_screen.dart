// Màn 17 – Dashboard báo cáo vận hành (report-dashboard). Route: /reports
// Bài: 08-reports/01-report-dashboard.md · Độ khó ⭐⭐⭐
//
// Mục đích: Quản trị viên (và thủ thư nếu được cấp quyền) xem báo cáo vận hành.
// Đến từ: ô "Báo cáo" trên dashboard-home (TV1) hoặc thẻ ở quầy.
//
// TODO:
// - TabBar 3 tab:
//   · Kho (RP-02): số bản sao theo trạng thái, thanh tỉ lệ (LinearProgressIndicator) dùng màu CHỮ
//     của cặp trạng thái để đủ tương phản.
//   · Quá hạn (RP-04): tổng số, top quá hạn lâu nhất, nút xuất Excel/PDF,
//     "Xem tất cả" -> overdue-list-staff.
//   · Tài khoản (RP-01): G11 chưa có API -> thẻ "Sắp có".
// - Lối sang trend-dashboard (R2).
// - RefreshIndicator; lưu bộ lọc khoảng thời gian bằng SharedPreferences.
// - 403 không có quyền -> báo rồi quay về dashboard-home an toàn (E-core-002).
// - dart:io không chạy trên web: chặn bằng kIsWeb trước khi dùng File.
