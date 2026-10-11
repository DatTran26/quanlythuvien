// Model thông báo trong app.
// API: GET /notifications -> { id, userId, title, body, readAt, createdAt }
// Mock: tv3.notifications

class AppNotification {
  final int id;
  final int userId;
  final String title;
  final String body;
  final DateTime? readAt;
  final DateTime createdAt;

  const AppNotification({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.readAt,
    required this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      AppNotification(
        id: json['id'] as int,
        userId: json['userId'] as int,
        title: json['title'] as String,
        body: json['body'] as String,
        readAt: json['readAt'] == null
            ? null
            : DateTime.parse(json['readAt'] as String),
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  bool get isUnread => readAt == null;
}
