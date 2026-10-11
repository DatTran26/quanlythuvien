import 'package:frontend/core/auth/session.dart';
import 'package:frontend/core/data/mock_db.dart';
import 'package:frontend/core/network/api_client.dart';
import 'package:frontend/core/network/token_store.dart';

/// Đăng nhập giả lập khi chưa bật backend, hoặc gọi POST /auth/login khi REAL_API=true.
class AuthStore {
  AuthStore._();

  /// Trùng mật khẩu seed của backend (`app.seed-password`).
  static const demoPassword = 'Dev123456';

  /// Mã đặt lại mật khẩu trong môi trường thử, vì chưa có hộp thư thật.
  static const resetCode = 'DEV-RESET';

  static final _passwords = <String, String>{};
  static final _attempts = <String, int>{};
  static final _lockedOut = <String>{};

  static Future<void> login(String identifier, String password) async {
    final typed = identifier.trim();
    if (typed.isEmpty || password.isEmpty) {
      throw AuthException('BAD_CREDENTIALS', 'Email hoặc mật khẩu không đúng.');
    }
    if (ApiClient.useRealApi) {
      await _loginReal(typed, password);
      return;
    }
    await _loginMock(typed, password);
  }

  static Future<bool> checkPassword(String password) async {
    if (!AppSession.isSignedIn) return false;
    if (ApiClient.useRealApi) {
      try {
        await ApiClient.instance.post('/auth/login', {
          'email': AppSession.email,
          'password': password,
        });
        return true;
      } on ApiException {
        return false;
      }
    }
    return password == (_passwords[AppSession.email] ?? demoPassword);
  }

  static Future<void> resetPassword({
    required String email,
    required String code,
    required String password,
  }) async {
    if (code.trim() != resetCode) {
      throw AuthException('RESET_INVALID', 'Liên kết đặt lại không còn hiệu lực.');
    }
    if (password.length < 8) {
      throw AuthException('WEAK_PASSWORD', 'Mật khẩu mới cần ít nhất 8 ký tự.');
    }
    final user = await _find(email);
    if (user == null) return;
    _passwords[user.email] = password;
    _lockedOut.remove(user.email);
    _attempts.remove(user.email);
  }

  static Future<void> signOut() async {
    AppSession.clear();
    await TokenStore.clear();
  }

  static Future<void> restore() async {
    final token = await TokenStore.read();
    if (token == null || token.isEmpty) return;
    if (ApiClient.useRealApi) {
      try {
        final me = await ApiClient.instance.get('/me');
        if (me is! Map || me['status'] != 'ACTIVE') {
          await TokenStore.clear();
          return;
        }
        _applyMe(me);
      } catch (_) {
        await TokenStore.clear();
      }
      return;
    }
    const prefix = 'mock-token-';
    if (!token.startsWith(prefix)) return;
    final id = int.tryParse(token.substring(prefix.length));
    if (id == null) {
      await TokenStore.clear();
      return;
    }
    final user = await _findById(id);
    if (user == null || user.status != 'ACTIVE') {
      await TokenStore.clear();
      return;
    }
    _apply(user);
  }

  static Future<void> _loginReal(String email, String password) async {
    if (!email.contains('@')) {
      throw AuthException('EMAIL_REQUIRED', 'Khi nối backend thật, hãy đăng nhập bằng email.');
    }
    final key = email.toLowerCase();
    if (_lockedOut.contains(key)) {
      throw AuthException('TEMP_LOCK', 'Tài khoản tạm khóa vì đăng nhập sai nhiều lần. Thử lại sau.');
    }
    try {
      final body = await ApiClient.instance.post('/auth/login', {
        'email': email,
        'password': password,
      });
      if (body is! Map || body['accessToken'] is! String) {
        throw AuthException('UNKNOWN', 'Máy chủ không trả token đăng nhập.');
      }
      await TokenStore.save(body['accessToken'] as String);
      final me = await ApiClient.instance.get('/me');
      if (me is! Map) {
        await TokenStore.clear();
        throw AuthException('UNKNOWN', 'Không đọc được hồ sơ tài khoản.');
      }
      final status = me['status'] as String? ?? '';
      if (status != 'ACTIVE') {
        await TokenStore.clear();
        throw AuthException(
          status == 'LOCKED' ? 'LOCKED' : 'PENDING',
          status == 'LOCKED' ? 'Tài khoản đang bị khóa.' : 'Tài khoản chưa được kích hoạt.',
        );
      }
      _attempts.remove(key);
      _applyMe(me);
    } on ApiException catch (e) {
      if (e.code == 'BAD_CREDENTIALS') _fail(key);
      if (e.code == 'LOCKED') {
        throw AuthException('LOCKED', 'Tài khoản đang bị khóa.');
      }
      throw AuthException(e.code, e.message);
    }
  }

  static Future<void> _loginMock(String identifier, String password) async {
    final user = await _find(identifier);
    final key = user?.email ?? identifier.toLowerCase();
    if (_lockedOut.contains(key)) {
      throw AuthException('TEMP_LOCK', 'Tài khoản tạm khóa vì đăng nhập sai nhiều lần. Thử lại sau.');
    }
    final expected = user == null ? null : (_passwords[user.email] ?? demoPassword);
    if (user == null || password != expected) _fail(key);
    if (user.status == 'LOCKED') {
      throw AuthException('LOCKED', 'Tài khoản đang bị khóa.');
    }
    if (user.status != 'ACTIVE') {
      throw AuthException('PENDING', 'Tài khoản chưa được kích hoạt.');
    }
    _attempts.remove(key);
    await TokenStore.save('mock-token-${user.id}');
    _apply(user);
  }

  static Never _fail(String key) {
    final count = (_attempts[key] ?? 0) + 1;
    _attempts[key] = count;
    if (count >= 5) {
      _lockedOut.add(key);
      throw AuthException('TEMP_LOCK', 'Tài khoản tạm khóa vì đăng nhập sai nhiều lần. Thử lại sau.');
    }
    throw AuthException('BAD_CREDENTIALS', 'Email hoặc mật khẩu không đúng.');
  }

  static void _apply(_AuthUser user) {
    AppSession.signIn(id: user.id, nextRole: user.role, name: user.displayName, nextEmail: user.email);
  }

  static void _applyMe(Map<dynamic, dynamic> me) {
    AppSession.signIn(
      id: (me['id'] as num).toInt(),
      nextRole: me['role'] as String,
      name: me['displayName'] as String,
      nextEmail: (me['email'] as String).toLowerCase(),
    );
  }

  static Future<_AuthUser?> _find(String identifier) async {
    final needle = identifier.trim().toLowerCase();
    if (needle.contains('@')) {
      for (final user in await _users()) {
        if (user.email == needle) return user;
      }
      return null;
    }
    final db = await MockDb.load();
    int? userId;
    for (final row in db.table('shared', 'readerProfiles')) {
      if ((row['cardCode'] as String).toLowerCase() == needle) {
        userId = row['userId'] as int;
        break;
      }
    }
    if (userId == null) return null;
    return _findById(userId);
  }

  static Future<_AuthUser?> _findById(int id) async {
    for (final user in await _users()) {
      if (user.id == id) return user;
    }
    return null;
  }

  static Future<List<_AuthUser>> _users() async {
    final db = await MockDb.load();
    return db.table('shared', 'users').map(_AuthUser.fromJson).toList();
  }
}

class AuthException implements Exception {
  AuthException(this.code, this.message);

  final String code;
  final String message;

  @override
  String toString() => message;
}

class _AuthUser {
  _AuthUser({
    required this.id,
    required this.email,
    required this.displayName,
    required this.role,
    required this.status,
  });

  final int id;
  final String email;
  final String displayName;
  final String role;
  final String status;

  factory _AuthUser.fromJson(Map<String, dynamic> json) => _AuthUser(
        id: json['id'] as int,
        email: (json['email'] as String).toLowerCase(),
        displayName: json['displayName'] as String,
        role: json['role'] as String,
        status: json['status'] as String,
      );
}
