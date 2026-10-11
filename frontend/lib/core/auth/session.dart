// Phiên đăng nhập của app. Các màn TV2 đọc role và displayName từ đây.

abstract final class AppSession {
  static int? userId;
  static String role = '';
  static String displayName = '';
  static String email = '';

  static bool get isSignedIn => userId != null;
  static bool get isAdmin => role == 'ADMIN';
  static bool get isStaff => role == 'ADMIN' || role == 'LIBRARIAN';
  static bool get isReader => role == 'READER';

  static String get roleLabel => switch (role) {
        'ADMIN' => 'Quản trị viên',
        'LIBRARIAN' => 'Thủ thư',
        'READER' => 'Người đọc',
        _ => role,
      };

  static void signIn({
    required int id,
    required String nextRole,
    required String name,
    required String nextEmail,
  }) {
    userId = id;
    role = nextRole;
    displayName = name;
    email = nextEmail;
  }

  static void clear() {
    userId = null;
    role = '';
    displayName = '';
    email = '';
  }
}
