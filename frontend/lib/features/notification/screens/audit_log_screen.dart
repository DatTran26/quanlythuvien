// Màn 3 – Nhật ký audit (audit-log, notification-audit-ui). Route: /audit
// Spec: docs/features/notification-audit-ui/srs/ (FR-002): Thủ thư tra cứu theo người làm,
// đối tượng, thời gian; chỉ đọc; che trường nhạy cảm.
// Checklist: CHK-notification-audit-ui-001 (người có quyền xem được ai làm gì),
//            CHK-notification-audit-ui-002 (người không có quyền bị từ chối, E-core-002).
// Đi tới: history-timeline (bấm một dòng). Lỗ hổng: T12.

import 'package:flutter/material.dart';
import 'package:frontend/core/utils/format.dart';

import '../data/notification_api.dart';
import '../models/audit_entry.dart';
import '../widgets/access_denied_view.dart';
import '../widgets/audit_labels.dart';
import 'history_timeline_screen.dart';

class AuditLogScreen extends StatefulWidget {
  const AuditLogScreen({super.key, required this.actorId, required this.api});

  final int actorId;
  final NotificationApi api;

  @override
  State<AuditLogScreen> createState() => _AuditLogScreenState();
}

class _AuditLogScreenState extends State<AuditLogScreen> {
  late Future<List<AuditEntry>> _future;
  late final Future<List<({int id, String name})>> _actors = widget.api
      .auditActors();
  int? _byActorId;
  String? _entityType;
  DateTimeRange? _range;

  static const _entityTypes = ['user', 'loan', 'fine', 'damage_report'];

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<AuditEntry>> _load() => widget.api.audit(
    actorId: widget.actorId,
    byActorId: _byActorId,
    entityType: _entityType,
    from: _range?.start,
    to: _range?.end,
  );

  void _apply(VoidCallback change) {
    setState(() {
      change();
      _future = _load();
    });
  }

  Future<void> _pickRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      initialDateRange: _range,
      fieldStartLabelText: 'Từ ngày',
      fieldEndLabelText: 'Đến ngày',
      fieldStartHintText: 'dd/mm/yyyy',
      fieldEndHintText: 'dd/mm/yyyy',
    );
    if (picked != null) _apply(() => _range = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nhật ký thao tác')),
      body: FutureBuilder<List<AuditEntry>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.error is NotificationAccessException) {
            return AccessDeniedView(message: snapshot.error.toString());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }
          return Column(
            children: [
              _filters(),
              Expanded(child: _list(snapshot)),
            ],
          );
        },
      ),
    );
  }

  Widget _filters() {
    final range = _range;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder<List<({int id, String name})>>(
            future: _actors,
            builder: (context, snapshot) => DropdownButtonFormField<int?>(
              initialValue: _byActorId,
              decoration: const InputDecoration(labelText: 'Người thực hiện'),
              items: [
                const DropdownMenuItem(value: null, child: Text('Tất cả')),
                for (final a
                    in snapshot.data ?? const <({int id, String name})>[])
                  DropdownMenuItem(value: a.id, child: Text(a.name)),
              ],
              onChanged: (v) => _apply(() => _byActorId = v),
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ChoiceChip(
                  label: const Text('Mọi đối tượng'),
                  selected: _entityType == null,
                  onSelected: (_) => _apply(() => _entityType = null),
                ),
                for (final type in _entityTypes) ...[
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: Text(auditEntityLabel(type)),
                    selected: _entityType == type,
                    onSelected: (_) => _apply(() => _entityType = type),
                  ),
                ],
              ],
            ),
          ),
          Row(
            children: [
              TextButton.icon(
                onPressed: _pickRange,
                icon: const Icon(Icons.date_range),
                label: Text(
                  range == null
                      ? 'Mọi thời gian'
                      : '${formatDate(range.start)} – ${formatDate(range.end)}',
                ),
              ),
              if (range != null)
                IconButton(
                  icon: const Icon(Icons.close),
                  tooltip: 'Bỏ lọc thời gian',
                  onPressed: () => _apply(() => _range = null),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _list(AsyncSnapshot<List<AuditEntry>> snapshot) {
    if (!snapshot.hasData) {
      return const Center(child: CircularProgressIndicator());
    }
    final entries = snapshot.data!;
    if (entries.isEmpty) {
      return const Center(child: Text('Không có thao tác nào khớp'));
    }
    return ListView.separated(
      itemCount: entries.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final e = entries[i];
        final detail = maskPii(e.detail);
        return ListTile(
          title: Text(
            '${auditActionLabel(e.action)} · ${auditEntityLabel(e.entityType)} #${e.entityId}',
          ),
          subtitle: Text(
            [
              '${e.actorName} · ${formatDate(e.createdAt)} '
                  '${e.createdAt.hour.toString().padLeft(2, '0')}:'
                  '${e.createdAt.minute.toString().padLeft(2, '0')}',
              if (detail.isNotEmpty) detail,
            ].join('\n'),
          ),
          isThreeLine: detail.isNotEmpty,
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => HistoryTimelineScreen(
                actorId: widget.actorId,
                api: widget.api,
                entityType: e.entityType,
                entityId: e.entityId,
              ),
            ),
          ),
        );
      },
    );
  }
}
