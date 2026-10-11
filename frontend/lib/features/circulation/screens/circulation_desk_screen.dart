// Màn 1 – Quầy lưu thông (circulation-desk). Route: /circulation
// Bài: 02-checkout/01-circulation-desk.md · Độ khó ⭐ (làm đầu tiên để khởi động)
//
// Mục đích: điểm vào mọi thao tác tại quầy của Thủ thư / Quản trị viên.
// Đến từ: dashboard-home (TV1). Đi tới: checkout-scan, return-scan,
// damage-report-form, reservation-search, report-dashboard.
//
// TODO:
// - StatelessWidget CirculationDeskScreen, Scaffold + AppBar + Drawer.
// - Lời chào + ngày hôm nay (DateFormat 'vi', nhớ initializeDateFormatting trong main).
// - GridView các DeskActionCard: Mượn sách, Trả sách/Gia hạn, Báo hư hỏng, Đặt trước, Báo cáo.
// - Số cột co giãn theo bề rộng (core/layout/breakpoints.dart, bài 0.6).
// - Nút "Trả sách" LUÔN bật (người đọc bị khóa vẫn trả được, BR-core-001).
