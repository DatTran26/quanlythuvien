// TẠM THỜI: thông tin người đang đăng nhập.
// TV1 (Đạt) sẽ thay bằng dữ liệu thật từ GET /me sau khi đăng nhập.
// Hiện để ADMIN để thấy đủ nút ở màn chi tiết hư hỏng; đổi 'LIBRARIAN' để xem góc nhìn thủ thư.

abstract final class AppSession {
  static String role = 'ADMIN';
  static String displayName = 'Hoàng';

  static bool get isAdmin => role == 'ADMIN';
}
