// Một dòng nhật ký thao tác.
// API: GET /audit -> { id, actorId, action, entityType, entityId, detail, createdAt } (50 dòng mới nhất)
// Mock: tv3.auditLogs. Backend ghi entityType chữ thường (loan, fine), mock cũ ghi chữ hoa:
// fromJson đưa về chữ thường để so sánh thống nhất.

class AuditEntry {
  final int id;
  final int? actorId;
  final String actorName; // ghép từ danh sách tài khoản, không có trong API
  final String action;
  final String entityType;
  final String entityId;
  final String? detail;
  final DateTime createdAt;

  const AuditEntry({
    required this.id,
    required this.actorId,
    required this.actorName,
    required this.action,
    required this.entityType,
    required this.entityId,
    required this.detail,
    required this.createdAt,
  });

  factory AuditEntry.fromJson(
    Map<String, dynamic> json, {
    required String actorName,
  }) => AuditEntry(
    id: json['id'] as int,
    actorId: json['actorId'] as int?,
    actorName: actorName,
    action: json['action'] as String,
    entityType: (json['entityType'] as String).toLowerCase(),
    entityId: json['entityId'] as String,
    detail: json['detail'] as String?,
    createdAt: DateTime.parse(json['createdAt'] as String),
  );
}
