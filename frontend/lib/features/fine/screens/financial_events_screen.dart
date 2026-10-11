// Màn 5 – Sự kiện tài chính (financial-events, fine-collection-adv). Route: /fines/:id/events
// Spec: BR-core-002 – mọi thay đổi số dư là sự kiện chỉ thêm; số dư = tổng các sự kiện
// (SC-overdue-fines-01: "số dư khớp sum events").
// Đến từ: fine-detail, fine-receipt.

import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/utils/format.dart';

import '../data/fine_api.dart';
import '../models/fine.dart';
import '../models/fine_transaction.dart';

class FinancialEventsScreen extends StatefulWidget {
  const FinancialEventsScreen({
    super.key,
    required this.api,
    required this.fineId,
  });

  final FineApi api;
  final int fineId;

  @override
  State<FinancialEventsScreen> createState() => _FinancialEventsScreenState();
}

class _FinancialEventsScreenState extends State<FinancialEventsScreen> {
  late final Future<(List<FineTransaction>, Fine)> _future = _load();

  Future<(List<FineTransaction>, Fine)> _load() async => (
    await widget.api.events(widget.fineId),
    (await widget.api.fineDetail(widget.fineId)).fine,
  );

  static String _typeLabel(String type) => switch (type) {
    'ASSESSMENT' => 'Ghi nhận phạt',
    'PAYMENT' => 'Thu tiền mặt',
    'WAIVER' => 'Miễn',
    'ADJUSTMENT' => 'Điều chỉnh',
    _ => type,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sổ khoản phạt #${widget.fineId}')),
      body: FutureBuilder<(List<FineTransaction>, Fine)>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final (events, fine) = snapshot.data!;
          final sum = events.fold<int>(0, (s, e) => s + e.balanceEffect);
          final matches = sum == fine.balanceVnd;
          final colors = Theme.of(context).extension<AppColors>()!;
          final pair = matches
              ? colors.successContainer
              : colors.errorContainer;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                color: pair.background,
                child: ListTile(
                  title: Text(
                    matches ? 'Số dư khớp sổ' : 'Số dư lệch sổ',
                    style: TextStyle(
                      color: pair.foreground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    'Tổng sự kiện ${formatVnd(sum)} · số dư ${formatVnd(fine.balanceVnd)}',
                    style: TextStyle(color: pair.foreground),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              for (final e in events)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(_typeLabel(e.type)),
                  subtitle: Text(
                    [
                      '${formatDate(e.createdAt)} · ${e.actorName}',
                      if (e.receiptNo != null) 'Biên nhận ${e.receiptNo}',
                      if (e.reason != null) e.reason!,
                    ].join('\n'),
                  ),
                  isThreeLine: e.receiptNo != null || e.reason != null,
                  trailing: Text(
                    '${e.balanceEffect > 0 ? '+' : '−'}${formatVnd(e.balanceEffect.abs())}',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
