// Trạng thái gửi một thông báo qua một kênh (notification-core).
// Mock: tv3.notificationOutbox. Backend chưa có outbox (T13).
//   channel: IN_APP | EMAIL · status: SENT | RETRYING | DEAD

class OutboxItem {
  final int id;
  final int notificationId;
  final String channel;
  final String status;
  final int attempts;
  final String? lastError;
  final DateTime updatedAt;
  final String recipientName; // ghép từ thông báo + tài khoản
  final String title;

  const OutboxItem({
    required this.id,
    required this.notificationId,
    required this.channel,
    required this.status,
    required this.attempts,
    required this.lastError,
    required this.updatedAt,
    required this.recipientName,
    required this.title,
  });

  factory OutboxItem.fromJson(
    Map<String, dynamic> json, {
    required String recipientName,
    required String title,
  }) => OutboxItem(
    id: json['id'] as int,
    notificationId: json['notificationId'] as int,
    channel: json['channel'] as String,
    status: json['status'] as String,
    attempts: json['attempts'] as int,
    lastError: json['lastError'] as String?,
    updatedAt: DateTime.parse(json['updatedAt'] as String),
    recipientName: recipientName,
    title: title,
  );
}
