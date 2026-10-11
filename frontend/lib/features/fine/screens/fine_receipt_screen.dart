// Màn 4 – Biên nhận thu phạt (fine-receipt, fine-collection-adv). Route: /fines/receipts/:no
// Spec: docs/features/fine-collection-adv/srs/ (FR-001), CHK-fine-collection-adv-001.
// Mẫu biên nhận chính thức chờ OQ-fine-collection-adv-003: hiện các trường tối thiểu.

import 'package:flutter/material.dart';
import 'package:frontend/core/utils/format.dart';

import '../data/fine_api.dart';
import '../models/fine_transaction.dart';
import 'financial_events_screen.dart';

class FineReceiptScreen extends StatelessWidget {
  const FineReceiptScreen({
    super.key,
    required this.api,
    required this.transaction,
    required this.reader,
  });

  final FineApi api;
  final FineTransaction transaction;
  final FineReader reader;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final t = transaction;
    final time =
        '${formatDate(t.createdAt)} '
        '${t.createdAt.hour.toString().padLeft(2, '0')}:${t.createdAt.minute.toString().padLeft(2, '0')}';
    return Scaffold(
      appBar: AppBar(title: const Text('Biên nhận')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('BIÊN NHẬN THU PHẠT', style: text.titleMedium),
                  Text(t.receiptNo ?? '—', style: text.headlineSmall),
                  const Divider(height: 24),
                  _line('Người nộp', '${reader.name} · ${reader.cardCode}'),
                  _line('Số tiền', formatVnd(t.amountVnd)),
                  _line('Hình thức', 'Tiền mặt'),
                  _line('Khoản phạt', '#${t.fineId}'),
                  _line('Người thu', t.actorName),
                  _line('Thời điểm', time),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) =>
                    FinancialEventsScreen(api: api, fineId: t.fineId),
              ),
            ),
            child: const Text('Xem sổ sự kiện tài chính'),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Xong'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _line(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      children: [
        SizedBox(width: 100, child: Text(label)),
        Expanded(child: Text(value)),
      ],
    ),
  );
}
