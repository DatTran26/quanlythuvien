// Màn 2 – Trạng thái thông báo (notification-status, notification-core). Route: /notifications/status
// Spec: docs/features/notification-core/srs/ (FR-001, E-notification-core-001/002, BR-core-005)
// Checklist: CHK-notification-core-003 – kênh gửi lỗi thì trạng thái gửi được ghi là lỗi.
//
// Mục đích: Thủ thư xem thông báo đã gửi / đang thử lại / lỗi hẳn (dead-letter).
// Chỉ xem: chính sách thử lại chạy ở backend. Lỗ hổng: T13 (backend chưa có outbox).

import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/utils/format.dart';

import '../data/notification_api.dart';
import '../models/outbox_item.dart';
import '../widgets/access_denied_view.dart';

class NotificationStatusScreen extends StatefulWidget {
  const NotificationStatusScreen({
    super.key,
    required this.actorId,
    required this.api,
  });

  final int actorId;
  final NotificationApi api;

  @override
  State<NotificationStatusScreen> createState() =>
      _NotificationStatusScreenState();
}

class _NotificationStatusScreenState extends State<NotificationStatusScreen> {
  late final Future<List<OutboxItem>> _future = widget.api.outbox(
    actorId: widget.actorId,
  );
  String? _status; // null = tất cả

  static const _statuses = [
    ('SENT', 'Đã gửi'),
    ('RETRYING', 'Đang thử lại'),
    ('DEAD', 'Lỗi hẳn'),
  ];

  String _label(String status) => _statuses
      .firstWhere((s) => s.$1 == status, orElse: () => (status, status))
      .$2;

  ColorPair _colors(BuildContext context, String status) {
    final c = Theme.of(context).extension<AppColors>()!;
    return switch (status) {
      'SENT' => c.successContainer,
      'RETRYING' => c.warningContainer,
      _ => c.errorContainer,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trạng thái gửi thông báo')),
      body: FutureBuilder<List<OutboxItem>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.error is NotificationAccessException) {
            return AccessDeniedView(message: snapshot.error.toString());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final all = snapshot.data!;
          final items = all
              .where((o) => _status == null || o.status == _status)
              .toList();
          return Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: Row(
                  children: [
                    ChoiceChip(
                      label: Text('Tất cả (${all.length})'),
                      selected: _status == null,
                      onSelected: (_) => setState(() => _status = null),
                    ),
                    for (final (code, label) in _statuses) ...[
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: Text(
                          '$label (${all.where((o) => o.status == code).length})',
                        ),
                        selected: _status == code,
                        onSelected: (_) => setState(() => _status = code),
                      ),
                    ],
                  ],
                ),
              ),
              Expanded(
                child: items.isEmpty
                    ? const Center(child: Text('Không có thông báo nào'))
                    : ListView.separated(
                        itemCount: items.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (context, i) {
                          final o = items[i];
                          final pair = _colors(context, o.status);
                          return ListTile(
                            title: Text(o.title),
                            subtitle: Text(
                              [
                                '${o.recipientName} · ${o.channel == 'EMAIL' ? 'Email' : 'Trong app'}',
                                'Thử ${o.attempts} lần · ${formatDate(o.updatedAt)}',
                                if (o.lastError != null) 'Lỗi: ${o.lastError}',
                              ].join('\n'),
                            ),
                            isThreeLine: true,
                            trailing: Chip(
                              label: Text(
                                _label(o.status),
                                style: TextStyle(color: pair.foreground),
                              ),
                              backgroundColor: pair.background,
                              side: BorderSide.none,
                              visualDensity: VisualDensity.compact,
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
