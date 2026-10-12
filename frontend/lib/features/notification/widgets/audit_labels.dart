// Nhãn tiếng Việt cho nhật ký audit và che dữ liệu cá nhân khi hiển thị.
// Spec: notification-audit-ui FR-002 "che trường nhạy cảm theo quyền", E-core-009, BR-core-004.

/// Tên hành động dễ đọc. Mã lạ thì giữ nguyên để không mất thông tin.
String auditActionLabel(String action) => switch (action) {
  'USER_LOCK' => 'Khóa tài khoản',
  'USER_UNLOCK' => 'Mở khóa tài khoản',
  'STAFF_CREATE' => 'Tạo tài khoản nhân viên',
  'READER_CREATE' => 'Cấp tài khoản người đọc',
  'READER_ACTIVATE' => 'Kích hoạt người đọc',
  'LOGIN' => 'Đăng nhập',
  'CHECKOUT' => 'Cho mượn',
  'RETURN' => 'Nhận trả',
  'RENEW' => 'Gia hạn',
  'LOST' || 'LOST_MARK' => 'Ghi nhận mất',
  'DAMAGE_REPORT' => 'Báo hư hỏng',
  'FINE_COLLECT' => 'Thu tiền phạt',
  'FINE_WAIVE' => 'Miễn phạt',
  'FINE_ADJUST' => 'Điều chỉnh phạt',
  'POLICY_UPDATE' => 'Sửa quy định',
  'IMPORT' || 'IMPORT_COMMIT' => 'Nhập dữ liệu',
  _ => action,
};

/// Tên loại đối tượng. Mã đã được đưa về chữ thường ở AuditEntry.fromJson.
String auditEntityLabel(String entityType) => switch (entityType) {
  'user' => 'Tài khoản',
  'loan' => 'Phiếu mượn',
  'fine' => 'Khoản phạt',
  'copy' => 'Bản sao',
  'title' => 'Đầu sách',
  'damage' || 'damage_report' => 'Báo cáo hư hỏng',
  'reservation' => 'Đặt trước',
  'policy' || 'lending_policy' => 'Quy định',
  'import_batch' => 'Lô nhập',
  _ => entityType,
};

final _email = RegExp(r'([A-Za-z0-9._%+-])[A-Za-z0-9._%+-]*@([A-Za-z0-9.-]+)');

/// Che email trong chi tiết audit: "thuthu2@library.local" -> "t***@library.local".
/// Chưa có ma trận quyền theo trường (OQ-core-003) nên che mặc định (deny mặc định, BR-core-004).
String maskPii(String? text) => text == null
    ? ''
    : text.replaceAllMapped(_email, (m) => '${m[1]}***@${m[2]}');
