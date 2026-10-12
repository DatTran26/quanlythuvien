// Màn 4 – Dòng thời gian (history-timeline, notification-audit-ui). Route: /audit/:entityType/:entityId
// Spec: docs/features/notification-audit-ui/srs/ (FR-003): lịch sử sự kiện của một bản ghi
// (bản sao, phiếu mượn, đặt trước, khoản phạt, báo cáo hư hỏng), đã che dữ liệu theo quyền.
// Đến từ: audit-log. Lỗ hổng: T12 (chưa có API lịch sử theo bản ghi, tạm lọc từ audit).

import 'package:flutter/material.dart';
import 'package:frontend/core/utils/format.dart';

import '../data/notification_api.dart';
import '../models/audit_entry.dart';
import '../widgets/access_denied_view.dart';
import '../widgets/audit_labels.dart';

class HistoryTimelineScreen extends StatefulWidget {
  const HistoryTimelineScreen({
    super.key,
    required this.actorId,
    required this.api,
    required this.entityType,
    required this.entityId,
  });

  final int actorId;
  final NotificationApi api;
  final String entityType;
  final String entityId;

  @override
  State<HistoryTimelineScreen> createState() => _HistoryTimelineScreenState();
}

class _HistoryTimelineScreenState extends State<HistoryTimelineScreen> {
  late final Future<List<AuditEntry>> _future = widget.api.history(
    widget.entityType,
    widget.entityId,
    actorId: widget.actorId,
  );

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${auditEntityLabel(widget.entityType)} #${widget.entityId}',
        ),
      ),
      body: FutureBuilder<List<AuditEntry>>(
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
          final events = snapshot.data!;
          if (events.isEmpty) {
            return const Center(child: Text('Chưa có sự kiện nào'));
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: events.length,
            itemBuilder: (context, i) {
              final e = events[i];
              final isLast = i == events.length - 1;
              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Cột timeline: chấm + đường nối xuống sự kiện sau.
                    SizedBox(
                      width: 48,
                      child: Column(
                        children: [
                          Icon(Icons.circle, size: 14, color: colors.primary),
                          if (!isLast)
                            Expanded(
                              child: VerticalDivider(color: colors.outline),
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16, bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              auditActionLabel(e.action),
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            Text('${e.actorName} · ${formatDate(e.createdAt)}'),
                            if (e.detail != null) Text(maskPii(e.detail)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
