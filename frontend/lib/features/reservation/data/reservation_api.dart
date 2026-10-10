// API đặt trước.
// Bài: 07-reservation/01..04
//
// TODO:
// - Future<List<TitleItem>> searchTitles(String q) -> GET  /titles?q=
// - Future<Reservation> create(int titleId)        -> POST /reservations body {titleId}
// - Future<List<Reservation>> mine()               -> GET  /reservations/mine
// - Future<Reservation> cancel(int id)             -> POST /reservations/{id}/cancel
// - Nhận sách: dùng lại checkout() trong circulation_api (POST /loans tự xử lý bản sao ON_HOLD).
//
// Lỗ hổng:
// - G8: chỉ đặt được cho người đang đăng nhập; thủ thư đặt thay cần backend thêm readerId.
// - G9: chưa có vị trí trong hàng chờ (position).
