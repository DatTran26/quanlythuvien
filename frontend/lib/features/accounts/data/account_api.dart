// Lấy dữ liệu tài khoản / người đọc cho account-admin và reader-onboarding.
// Hiện đọc mock (MockAccountApi). Khi nối backend, viết thêm HttpAccountApi dùng
// ApiClient của TV1 (core/network/api_client.dart), màn hình không phải sửa.
//
// API backend tương ứng:
// - users()            -> chưa có (T1)
// - readers(query)     -> chưa có (T1)
// - readerDetail(id)   -> chưa có (T2), tạm ghép từ GET /readers/by-card + mock
// - setStatus          -> PATCH /admin/users/{id}/status { status }
// - createStaff        -> POST  /admin/staff { email, password, displayName }
// - createReader       -> chưa có (T4)
// - activate           -> POST  /readers/{id}/activate
//
// Lỗ hổng:
// - T1: chưa có GET /admin/users?role=&q= để liệt kê, tìm tài khoản.
// - T2: chưa có API trả số phiếu mở, đặt trước, công nợ của một người đọc.
// - T3: khóa/mở chưa nhận lý do (spec bắt buộc), chưa ghi audit.
// - T4: chưa có POST /readers (nhân viên cấp tài khoản ACTIVE tại quầy, DEC-SF-03).

import 'package:frontend/core/data/mock_db.dart';
import 'package:frontend/features/notification/data/notification_api.dart';

import '../models/app_user.dart';
import '../models/reader_detail.dart';
import '../models/reader_row.dart';

/// Lỗi nghiệp vụ, cùng dạng { code, message } mà backend trả về.
class AccountException implements Exception {
  const AccountException(this.code, this.message);

  final String code;
  final String message;

  @override
  String toString() => message;
}

/// Màn hình chỉ biết interface này, không biết dữ liệu đến từ JSON hay API.
abstract class AccountApi {
  Future<List<AppUser>> users();
  Future<String?> cardCodeOf(int userId);
  Future<List<ReaderRow>> readers({String query = ''});
  Future<ReaderDetail> readerDetail(int userId);
  Future<AppUser> setStatus(
    int userId,
    String status, {
    required String reason,
    required int actorId,
  });
  Future<List<AppUser>> staff();
  Future<AppUser> createStaff({
    required String displayName,
    required String email,
    required String password,
    required int actorId,
  });
  Future<ReaderRow> createReader({
    required String displayName,
    required String email,
    required String password,
    required int actorId,
  });
  Future<AppUser?> userByEmail(String email);
  Future<AppUser> activate(int userId, {required int actorId});
}

class MockAccountApi implements AccountApi {
  // ---- Bài 0 ----
  @override
  Future<List<AppUser>> users() async {
    final db = await MockDb.load();
    return db.table('shared', 'users').map(AppUser.fromJson).toList();
  }

  @override
  Future<String?> cardCodeOf(int userId) async {
    final db = await MockDb.load();
    for (final row in db.table('shared', 'readerProfiles')) {
      if (row['userId'] == userId) return row['cardCode'] as String;
    }
    return null;
  }

  // ---- Bài 1A ----
  @override
  Future<List<ReaderRow>> readers({String query = ''}) async {
    final db = await MockDb.load();
    final cards = {
      for (final row in db.table('shared', 'readerProfiles'))
        row['userId'] as int: row['cardCode'] as String,
    };
    final q = query.trim().toLowerCase();
    final all = await users();
    return all
        .where((u) => u.role == 'READER')
        .map((u) => ReaderRow(user: u, cardCode: cards[u.id]))
        .where(
          (r) =>
              q.isEmpty ||
              r.user.displayName.toLowerCase().contains(q) ||
              r.user.email.toLowerCase().contains(q) ||
              (r.cardCode ?? '').toLowerCase().contains(q),
        )
        .toList();
  }

  @override
  Future<ReaderDetail> readerDetail(int userId) async {
    final db = await MockDb.load();
    final all = await users();
    final user = all.firstWhere((u) => u.id == userId);

    final openLoans = db
        .table('shared', 'loans')
        .where(
          (l) =>
              l['readerId'] == userId &&
              (l['status'] == 'ACTIVE' || l['status'] == 'OVERDUE'),
        )
        .length;

    final openReservations = db
        .table('tv2', 'reservations')
        .where(
          (r) =>
              r['readerId'] == userId &&
              (r['status'] == 'WAITING' || r['status'] == 'READY'),
        )
        .length;

    final debtVnd = db
        .table('shared', 'fines')
        .where((f) => f['readerId'] == userId && f['status'] == 'OPEN')
        .fold<int>(0, (sum, f) => sum + (f['balanceVnd'] as int));

    return ReaderDetail(
      user: user,
      cardCode: await cardCodeOf(userId),
      openLoans: openLoans,
      openReservations: openReservations,
      debtVnd: debtVnd,
    );
  }

  // ---- Bài 1B ----
  @override
  Future<AppUser> setStatus(
    int userId,
    String status, {
    required String reason,
    required int actorId,
  }) async {
    final db = await MockDb.load();
    final actor = _findUser(db, actorId);
    final actorRole = actor['role'];
    final cleanReason = reason.trim();
    if (cleanReason.isEmpty) {
      throw const AccountException('REASON_REQUIRED', 'Cần nhập lý do');
    }
    if (userId == actorId) {
      throw const AccountException(
        'SELF_LOCK',
        'Không khóa chính tài khoản đang dùng',
      );
    }
    final row = _findUser(db, userId);
    if (actorRole != 'STAFF' && actorRole != 'LIBRARIAN') {
      throw const AccountException('FORBIDDEN', 'Không có quyền quản lý tài khoản');
    }
    if (row['role'] == 'LIBRARIAN') {
      throw const AccountException(
        'ADMIN_PROTECTED',
        'Không đổi trạng thái thủ thư khác',
      );
    }
    if (row['role'] == 'STAFF' && actorRole != 'LIBRARIAN') {
      throw const AccountException('FORBIDDEN', 'Chỉ Thủ thư được quản lý tài khoản Nhân viên');
    }
    final current = row['status'] as String;
    if (current == 'PENDING') {
      throw const AccountException('NOT_ACTIVATED', 'Tài khoản chưa kích hoạt');
    }
    if (current == status) {
      throw const AccountException(
        'STATUS_UNCHANGED',
        'Tài khoản đã ở trạng thái này',
      );
    }

    // Đổi ngay trên dữ liệu trong bộ nhớ. Tắt app là mất, file JSON không đổi.
    row['status'] = status;
    _audit(
      db,
      actorId,
      status == 'LOCKED' ? 'USER_LOCK' : 'USER_UNLOCK',
      userId,
      cleanReason,
    );
    // FR-notification-core-001: khóa / mở tài khoản phải phát thông báo cho chủ tài khoản.
    // Ghi sau khi đã đổi trạng thái: thông báo lỗi không làm hỏng việc khóa (BR-core-005).
    await MockNotificationApi.notify(
      userId,
      status == 'LOCKED' ? 'Tài khoản bị khóa' : 'Tài khoản được mở khóa',
      status == 'LOCKED'
          ? 'Tài khoản của bạn tạm thời bị khóa. Lý do: $cleanReason. Vui lòng liên hệ quầy thư viện.'
          : 'Tài khoản của bạn đã được mở khóa, có thể mượn sách trở lại.',
    );
    return AppUser.fromJson(row);
  }

  // ---- Bài 1C ----
  @override
  Future<List<AppUser>> staff() async {
    final all = await users();
    return all.where((u) => u.role == 'STAFF').toList();
  }

  @override
  Future<AppUser> createStaff({
    required String displayName,
    required String email,
    required String password,
    required int actorId,
  }) async {
    final db = await MockDb.load();
    _requireLibrarian(db, actorId);
    final row = _insertUser(
      db,
      displayName: displayName,
      email: email,
      password: password,
      role: 'STAFF',
    );
    _audit(
      db,
      actorId,
      'STAFF_CREATE',
      row['id'] as int,
      row['email'] as String,
    );
    return AppUser.fromJson(row);
  }

  // ---- Bài 2 ----
  @override
  Future<ReaderRow> createReader({
    required String displayName,
    required String email,
    required String password,
    required int actorId,
  }) async {
    final db = await MockDb.load();
    _requireDeskStaff(db, actorId);
    final row = _insertUser(
      db,
      displayName: displayName,
      email: email,
      password: password,
      role: 'READER',
    );
    final userId = row['id'] as int;
    final card = _nextCardCode(db);
    db.table('shared', 'readerProfiles').add({
      'userId': userId,
      'cardCode': card,
    });
    _audit(db, actorId, 'READER_CREATE', userId, card);
    return ReaderRow(user: AppUser.fromJson(row), cardCode: card);
  }

  @override
  Future<AppUser?> userByEmail(String email) async {
    final mail = email.trim().toLowerCase();
    for (final user in await users()) {
      if (user.email == mail) return user;
    }
    return null;
  }

  @override
  Future<AppUser> activate(int userId, {required int actorId}) async {
    final db = await MockDb.load();
    _requireDeskStaff(db, actorId);
    final row = _findUser(db, userId);
    if (row['role'] != 'READER') {
      throw const AccountException(
        'NOT_READER',
        'Chỉ kích hoạt tài khoản người đọc',
      );
    }
    if (row['status'] != 'PENDING') {
      throw const AccountException(
        'STATUS_UNCHANGED',
        'Tài khoản không ở trạng thái chờ kích hoạt',
      );
    }
    row['status'] = 'ACTIVE';
    _audit(db, actorId, 'READER_ACTIVATE', userId, null);
    return AppUser.fromJson(row);
  }

  // ---- Hàm dùng chung trong file ----

  /// Tìm dòng tài khoản theo id. Không thấy thì báo lỗi nghiệp vụ.
  Map<String, dynamic> _findUser(MockDb db, int userId) {
    return db
        .table('shared', 'users')
        .firstWhere(
          (u) => u['id'] == userId,
          orElse: () =>
              throw const AccountException('NOT_FOUND', 'Không thấy tài khoản'),
        );
  }

  void _requireDeskStaff(MockDb db, int actorId) {
    final role = _findUser(db, actorId)['role'];
    if (role != 'STAFF' && role != 'LIBRARIAN') {
      throw const AccountException('FORBIDDEN', 'Không có quyền quản lý người đọc');
    }
  }

  void _requireLibrarian(MockDb db, int actorId) {
    if (_findUser(db, actorId)['role'] != 'LIBRARIAN') {
      throw const AccountException('FORBIDDEN', 'Chỉ Thủ thư được quản lý tài khoản Nhân viên');
    }
  }

  /// Kiểm tra dữ liệu, chặn email trùng rồi thêm tài khoản ACTIVE vào bộ nhớ.
  /// Dùng chung cho tạo nhân viên (1C) và cấp tài khoản người đọc (2).
  Map<String, dynamic> _insertUser(
    MockDb db, {
    required String displayName,
    required String email,
    required String password,
    required String role,
  }) {
    final name = displayName.trim();
    final mail = email.trim().toLowerCase();
    if (name.isEmpty) {
      throw const AccountException('VALIDATION', 'Cần nhập họ tên');
    }
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(mail)) {
      throw const AccountException('VALIDATION', 'Email không hợp lệ');
    }
    if (password.length < 8) {
      throw const AccountException('VALIDATION', 'Mật khẩu tối thiểu 8 ký tự');
    }
    final users = db.table('shared', 'users');
    if (users.any((u) => u['email'] == mail)) {
      throw const AccountException(
        'EMAIL_TAKEN',
        'Email đã được dùng cho tài khoản khác',
      );
    }

    final nextId =
        users.map((u) => u['id'] as int).reduce((a, b) => a > b ? a : b) + 1;
    final row = <String, dynamic>{
      'id': nextId,
      'email': mail,
      'displayName': name,
      'role': role,
      'status': 'ACTIVE',
      'createdAt': db.now.toIso8601String(),
    };
    // Mock không lưu mật khẩu. Backend băm mật khẩu bằng BCrypt.
    users.add(row);
    return row;
  }

  /// Mã thẻ kế tiếp: R + 8 số, lớn hơn mã lớn nhất đang có.
  /// Backend sinh ngẫu nhiên; mock tăng dần để test biết trước kết quả.
  String _nextCardCode(MockDb db) {
    final numbers = db
        .table('shared', 'readerProfiles')
        .map((p) => int.parse((p['cardCode'] as String).substring(1)));
    final next = numbers.isEmpty
        ? 10000001
        : numbers.reduce((a, b) => a > b ? a : b) + 1;
    return 'R$next';
  }

  /// Ghi một dòng nhật ký vào tv3.auditLogs.
  void _audit(
    MockDb db,
    int actorId,
    String action,
    int entityId,
    String? detail,
  ) {
    final logs = db.table('tv3', 'auditLogs');
    logs.add({
      'id': logs.length + 1,
      'actorId': actorId,
      'action': action,
      'entityType': 'user',
      'entityId': '$entityId',
      'detail': detail,
      'createdAt': db.now.toIso8601String(),
    });
  }
}
