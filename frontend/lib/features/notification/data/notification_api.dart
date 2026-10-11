// API thông báo, trạng thái gửi và nhật ký audit (notification-core, notification-audit-ui).
//
// API backend tương ứng:
// - mine(userId)        -> GET  /notifications (người đang đăng nhập, mới nhất trước)
// - markRead(id)        -> POST /notifications/{id}/read
// - unreadCount         -> chưa có (T11), tạm đếm từ mine()
// - markAllRead         -> chưa có, tạm gọi markRead từng cái
// - outbox()            -> chưa có (T13)
// - audit(...)          -> GET  /audit (T12: chỉ 50 dòng mới nhất, chưa lọc)
// - history(type, id)   -> chưa có (T12)
// - notify(...)         -> phía backend: NotificationService.notify, app không tự gọi.
//                          Mock dùng để các thao tác TV3 (khóa / mở tài khoản) phát thông báo.
//
// Lỗ hổng:
// - T11: chưa có API đếm thông báo chưa đọc.
// - T12: /audit chỉ trả 50 dòng, chưa lọc, chưa phân trang, chưa có lịch sử theo một bản ghi.
// - T13: backend chưa có outbox / retry / dead-letter -> notification-status chỉ dựng bằng mock.

import 'package:frontend/core/data/mock_db.dart';

import '../models/app_notification.dart';
import '../models/audit_entry.dart';
import '../models/outbox_item.dart';

/// Lỗi quyền, cùng dạng { code, message } của backend (E-core-002).
class NotificationAccessException implements Exception {
  const NotificationAccessException(this.code, this.message);

  final String code;
  final String message;

  @override
  String toString() => message;
}

abstract class NotificationApi {
  Future<List<AppNotification>> mine(int userId);
  Future<int> unreadCount(int userId);
  Future<void> markRead(int notificationId, {required int userId});
  Future<void> markAllRead(int userId);
  Future<List<OutboxItem>> outbox({required int actorId});
  Future<List<AuditEntry>> audit({
    required int actorId,
    int? byActorId,
    String? entityType,
    DateTime? from,
    DateTime? to,
  });
  Future<List<AuditEntry>> history(
    String entityType,
    String entityId, {
    required int actorId,
  });
  Future<List<({int id, String name})>> auditActors();
}

class MockNotificationApi implements NotificationApi {
  @override
  Future<List<AppNotification>> mine(int userId) async {
    final db = await MockDb.load();
    final list =
        db
            .table('tv3', 'notifications')
            .where((n) => n['userId'] == userId)
            .map(AppNotification.fromJson)
            .toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  @override
  Future<int> unreadCount(int userId) async =>
      (await mine(userId)).where((n) => n.isUnread).length;

  @override
  Future<void> markRead(int notificationId, {required int userId}) async {
    final db = await MockDb.load();
    final row = db
        .table('tv3', 'notifications')
        .firstWhere((n) => n['id'] == notificationId);
    // Giống backend: không đánh dấu thông báo của người khác (NOT_OWNER).
    if (row['userId'] != userId) {
      throw const NotificationAccessException(
        'NOT_OWNER',
        'Không đọc thông báo của người khác',
      );
    }
    row['readAt'] ??= db.now.toIso8601String();
  }

  @override
  Future<void> markAllRead(int userId) async {
    for (final n in await mine(userId)) {
      if (n.isUnread) await markRead(n.id, userId: userId);
    }
  }

  @override
  Future<List<OutboxItem>> outbox({required int actorId}) async {
    final db = await MockDb.load();
    await _requireAdmin(db, actorId);
    final names = _userNames(db);
    final notifications = {
      for (final n in db.table('tv3', 'notifications')) n['id'] as int: n,
    };
    return [
      for (final o in db.table('tv3', 'notificationOutbox'))
        OutboxItem.fromJson(
          o,
          recipientName:
              names[notifications[o['notificationId']]?['userId']] ?? '—',
          title: notifications[o['notificationId']]?['title'] as String? ?? '—',
        ),
    ]..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  @override
  Future<List<AuditEntry>> audit({
    required int actorId,
    int? byActorId,
    String? entityType,
    DateTime? from,
    DateTime? to,
  }) async {
    final db = await MockDb.load();
    await _requireAdmin(db, actorId);
    final names = _userNames(db);
    return db
        .table('tv3', 'auditLogs')
        .map(
          (a) => AuditEntry.fromJson(
            a,
            actorName: names[a['actorId']] ?? 'Hệ thống',
          ),
        )
        .where((e) => byActorId == null || e.actorId == byActorId)
        .where((e) => entityType == null || e.entityType == entityType)
        .where((e) => from == null || !e.createdAt.isBefore(from))
        // Bao trọn ngày "đến": so với 0 giờ ngày hôm sau.
        .where(
          (e) =>
              to == null ||
              e.createdAt.isBefore(to.add(const Duration(days: 1))),
        )
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<List<AuditEntry>> history(
    String entityType,
    String entityId, {
    required int actorId,
  }) async {
    final all = await audit(
      actorId: actorId,
      entityType: entityType.toLowerCase(),
    );
    return all.where((e) => e.entityId == entityId).toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  @override
  Future<List<({int id, String name})>> auditActors() async {
    final db = await MockDb.load();
    final ids = {for (final a in db.table('tv3', 'auditLogs')) a['actorId']}
        .whereType<int>();
    final names = _userNames(db);
    return [for (final id in ids) (id: id, name: names[id] ?? '#$id')];
  }

  /// Ghi một thông báo in-app + một dòng outbox email (mock của NotificationService.notify).
  /// Thông báo không làm hỏng giao dịch chính (BR-core-005): lỗi ở đây chỉ ghi trạng thái.
  static Future<void> notify(int userId, String title, String body) async {
    final db = await MockDb.load();
    final notifications = db.table('tv3', 'notifications');
    final id = notifications.length + 1;
    final now = db.now.toIso8601String();
    notifications.add({
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
      'readAt': null,
      'createdAt': now,
    });
    final outbox = db.table('tv3', 'notificationOutbox');
    outbox.add({
      'id': outbox.length + 1,
      'notificationId': id,
      'channel': 'EMAIL',
      'status': 'RETRYING', // mock không gửi email thật: chờ thử lại
      'attempts': 0,
      'lastError': null,
      'updatedAt': now,
    });
  }

  Map<int, String> _userNames(MockDb db) => {
    for (final u in db.table('shared', 'users'))
      u['id'] as int: u['displayName'] as String,
  };

  /// FR-notification-audit-ui-002: nhật ký và trạng thái gửi chỉ Quản trị viên xem (E-core-002).
  Future<void> _requireAdmin(MockDb db, int actorId) async {
    final actor = db
        .table('shared', 'users')
        .where((u) => u['id'] == actorId)
        .firstOrNull;
    if (actor?['role'] != 'ADMIN') {
      throw const NotificationAccessException(
        'FORBIDDEN',
        'Chỉ Quản trị viên được xem nhật ký và trạng thái gửi thông báo',
      );
    }
  }
}
