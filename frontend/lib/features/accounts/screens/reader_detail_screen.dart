// Màn 2 – Chi tiết người đọc (reader-detail). Route: /readers/:id
// Bài: TV3 1A (Bước 6, chỉ đọc) · 1B (khóa / mở) · Độ khó ⭐⭐⭐
// Spec: docs/features/account-admin/srs/account-admin-userflow.md, html-wireframe/
//
// Mục đích: xem hồ sơ và nghĩa vụ đang mở; khóa tạm, mở lại tài khoản.
// Đến từ: reader-list, reader-form (sau khi lưu). Đi tới: reader-form (Sửa).
import 'package:flutter/material.dart';
import 'package:frontend/core/auth/session.dart';
import 'package:frontend/core/utils/format.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/theme/app_theme.dart';

import '../widgets/status_change_dialog.dart';
import '../data/account_api.dart';
import '../models/reader_detail.dart';
import '../widgets/account_status.dart';

class ReaderDetailScreen extends StatefulWidget {
  const ReaderDetailScreen({super.key, required this.userId});

  final int userId;

  @override
  State<ReaderDetailScreen> createState() => _ReaderDetailScreenState();
}

class _ReaderDetailScreenState extends State<ReaderDetailScreen> {
  final AccountApi _api = MockAccountApi();
  late Future<ReaderDetail> _future;
  bool _busy = false;

  int get _actorId => AppSession.userId!;

  @override
  void initState() {
    super.initState();
    _future = _api.readerDetail(widget.userId);
  }

  void _reload() {
    setState(() {
      _future = _api.readerDetail(widget.userId);
    });
  }

  /// Cảnh báo khi khóa người còn sách chưa trả, đặt trước hoặc tiền nợ. Khóa không xóa các khoản này.
  String? _warning(ReaderDetail d) {
    final parts = [
      if (d.openLoans > 0) '${d.openLoans} phiếu mượn chưa trả',
      if (d.openReservations > 0) '${d.openReservations} đặt trước',
      if (d.debtVnd > 0) 'nợ ${formatVnd(d.debtVnd)}',
    ];
    if (parts.isEmpty) return null;
    return 'Còn ${parts.join(', ')}. Khóa tài khoản không xóa các khoản này, bạn đọc vẫn phải hoàn tất.';
  }

  Future<void> _changeStatus(ReaderDetail d, {required bool lock}) async {
    final reason = await showStatusChangeDialog(
      context,
      locking: lock,
      name: d.user.displayName,
      warning: lock ? _warning(d) : null,
    );
    if (reason == null || !mounted) return;

    setState(() => _busy = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await _api.setStatus(
        d.user.id,
        lock ? 'LOCKED' : 'ACTIVE',
        reason: reason,
        actorId: _actorId,
      );
      messenger.showSnackBar(
        SnackBar(
          content: Text(lock ? 'Đã khóa tài khoản' : 'Đã mở khóa tài khoản'),
        ),
      );
      _reload();
    } on AccountException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  /// Giải thích vì sao chỉ một thao tác đang bật (E-core-008).
  String _actionHint(String status) => switch (status) {
    'ACTIVE' => 'Tài khoản đang hoạt động nên chỉ có thể khóa.',
    'LOCKED' => 'Tài khoản đang bị khóa nên chỉ có thể mở khóa.',
    'PENDING' => 'Tài khoản chưa kích hoạt nên chưa thể khóa hoặc mở khóa.',
    _ => '',
  };

  Future<void> _activate(ReaderDetail d) async {
    setState(() => _busy = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await _api.activate(d.user.id, actorId: _actorId);
      messenger.showSnackBar(
        const SnackBar(content: Text('Đã kích hoạt tài khoản')),
      );
      _reload();
    } on AccountException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết người đọc')),
      body: FutureBuilder<ReaderDetail>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final d = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(d.user.displayName, style: text.headlineSmall),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: AccountStatusChip(d.user.status),
              ),
              const SizedBox(height: 16),
              _InfoRow(label: 'Email', value: d.user.email),
              _InfoRow(label: 'Mã thẻ', value: d.cardCode ?? 'Chưa có thẻ'),
              const SizedBox(height: 24),
              Text('Chưa hoàn tất', style: text.titleMedium),
              const SizedBox(height: 8),
              Card(
                child: Column(
                  children: [
                    _InfoRow(
                      label: 'Phiếu mượn chưa trả',
                      value: '${d.openLoans}',
                    ),
                    _InfoRow(
                      label: 'Sách đang đặt trước',
                      value: '${d.openReservations}',
                    ),
                    _InfoRow(label: 'Tiền còn nợ', value: formatVnd(d.debtVnd)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text('Thao tác', style: text.titleMedium),
              const SizedBox(height: 8),
              if (d.user.status == 'PENDING')
                Align(
                  alignment: Alignment.centerLeft,
                  child: FilledButton(
                    onPressed: _busy ? null : () => _activate(d),
                    child: const Text('Kích hoạt tài khoản'),
                  ),
                )
              else
                Wrap(
                  spacing: 12,
                  children: [
                    FilledButton(
                      style: AppButtonStyles.danger(context),
                      onPressed: !_busy && d.user.status == 'ACTIVE'
                          ? () => _changeStatus(d, lock: true)
                          : null,
                      child: const Text('Khóa tài khoản'),
                    ),
                    OutlinedButton(
                      onPressed: !_busy && d.user.status == 'LOCKED'
                          ? () => _changeStatus(d, lock: false)
                          : null,
                      child: const Text('Mở khóa'),
                    ),
                  ],
                ),
              // E-core-008: nút bị tắt phải kèm lời giải thích.
              const SizedBox(height: 8),
              Text(
                _actionHint(d.user.status),
                style: text.bodySmall?.copyWith(
                  color: Theme.of(context)
                      .extension<AppColors>()!
                      .textSecondary,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Text(label),
      trailing: Text(value, style: Theme.of(context).textTheme.bodyLarge),
    );
  }
}
