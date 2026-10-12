// Màn 1 – Trung tâm thông báo (notification-center, notification-audit-ui). Route: /notifications
// Spec: docs/features/notification-audit-ui/srs/ (FR-001, DEC-SF-09): mọi vai trò xem thông báo
// của chính mình, mới nhất trước, đánh dấu đã đọc, xem số chưa đọc.
// Đến từ: NotificationBell trên AppBar.

import 'package:flutter/material.dart';
import 'package:frontend/core/utils/format.dart';

import '../data/notification_api.dart';
import '../models/app_notification.dart';

class NotificationCenterScreen extends StatefulWidget {
  const NotificationCenterScreen({
    super.key,
    required this.userId,
    required this.api,
  });

  final int userId;
  final NotificationApi api;

  @override
  State<NotificationCenterScreen> createState() =>
      _NotificationCenterScreenState();
}

class _NotificationCenterScreenState extends State<NotificationCenterScreen> {
  late Future<List<AppNotification>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.api.mine(widget.userId);
  }

  Future<void> _reload() async {
    final next = widget.api.mine(widget.userId);
    setState(() => _future = next);
    await next;
  }

  Future<void> _open(AppNotification n) async {
    if (n.isUnread) {
      await widget.api.markRead(n.id, userId: widget.userId);
      await _reload();
    }
  }

  Future<void> _readAll() async {
    await widget.api.markAllRead(widget.userId);
    await _reload();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông báo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            tooltip: 'Đánh dấu đã đọc tất cả',
            onPressed: _readAll,
          ),
        ],
      ),
      body: FutureBuilder<List<AppNotification>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snapshot.data!;
          return RefreshIndicator(
            onRefresh: _reload,
            child: items.isEmpty
                ? ListView(
                    children: const [
                      SizedBox(height: 120),
                      Center(child: Text('Chưa có thông báo')),
                    ],
                  )
                : ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final n = items[i];
                      return ListTile(
                        onTap: () => _open(n),
                        // Chưa đọc: chấm màu + chữ đậm. Không chỉ dựa vào màu (color-system).
                        leading: Icon(
                          n.isUnread ? Icons.circle : Icons.circle_outlined,
                          size: 12,
                          color: n.isUnread ? colors.primary : colors.outline,
                          semanticLabel: n.isUnread ? 'Chưa đọc' : 'Đã đọc',
                        ),
                        title: Text(
                          n.title,
                          style: n.isUnread
                              ? const TextStyle(fontWeight: FontWeight.w600)
                              : null,
                        ),
                        subtitle: Text('${n.body}\n${formatDate(n.createdAt)}'),
                        isThreeLine: true,
                        titleTextStyle: text.bodyLarge,
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}
