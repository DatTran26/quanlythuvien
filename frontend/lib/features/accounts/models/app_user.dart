// Model tài khoản (Quản trị viên, Thủ thư, Người đọc).
// API: GET /me, GET /readers/by-card/{code} -> { id, email, displayName, role, status }
// Mock: shared.users (có thêm createdAt).

class AppUser {
  final int id;
  final String email;
  final String displayName;
  final String role; // ADMIN | LIBRARIAN | READER
  final String status; // PENDING | ACTIVE | LOCKED
  final DateTime createdAt;

  const AppUser({
    required this.id,
    required this.email,
    required this.displayName,
    required this.role,
    required this.status,
    required this.createdAt,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
    id: json['id'] as int,
    email: json['email'] as String,
    displayName: json['displayName'] as String,
    role: json['role'] as String,
    status: json['status'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
  );
}
