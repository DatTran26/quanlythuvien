// Thẻ thư viện của người đọc đang đăng nhập.
// API: GET /me -> { id, email, displayName, role, status } (chưa có cardCode, hạn thẻ: T5)

class MyCard {
  final String displayName;
  final String status; // PENDING | ACTIVE | LOCKED
  final String? cardCode;

  const MyCard({
    required this.displayName,
    required this.status,
    required this.cardCode,
  });

  /// Spec FR-004: chỉ hiện QR khi tài khoản đã kích hoạt (và thẻ còn hạn – chưa có dữ liệu hạn thẻ).
  bool get canShowQr => status == 'ACTIVE' && cardCode != null;
}
