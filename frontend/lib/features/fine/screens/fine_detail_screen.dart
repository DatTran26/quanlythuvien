// Màn 2 – Chi tiết công nợ (fine-detail, fine-collection-basic). Route: /fines/:id
// Spec: docs/features/fine-collection-basic/srs/
//
// Mục đích: xem số gốc, đã nộp, còn nợ, lý do; chọn hành động được phép.
// Đến từ: fine-list. Đi tới: fine-payment, financial-events, fine-adjust (chỉ Quản trị viên).
// Khoản đã đóng: nút tắt + lời giải thích (E-core-008).

import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/utils/format.dart';

import '../data/fine_api.dart';
import '../widgets/fine_labels.dart';
import 'financial_events_screen.dart';
import 'fine_adjust_screen.dart';
import 'fine_payment_screen.dart';

class FineDetailScreen extends StatefulWidget {
  const FineDetailScreen({
    super.key,
    required this.api,
    required this.actorId,
    required this.fineId,
  });

  final FineApi api;
  final int actorId;
  final int fineId;

  @override
  State<FineDetailScreen> createState() => _FineDetailScreenState();
}

class _FineDetailScreenState extends State<FineDetailScreen> {
  late Future<(FineDetail, bool)> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<(FineDetail, bool)> _load() async => (
    await widget.api.fineDetail(widget.fineId),
    await widget.api.canAdjust(widget.actorId),
  );

  Future<void> _go(Widget screen) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
    setState(() => _future = _load());
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết khoản phạt')),
      body: FutureBuilder<(FineDetail, bool)>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final (detail, isAdmin) = snapshot.data!;
          final fine = detail.fine;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      fineReasonLabel(fine.reason),
                      style: text.headlineSmall,
                    ),
                  ),
                  FineStatusChip(fine.status),
                ],
              ),
              const SizedBox(height: 8),
              _row(
                'Người đọc',
                '${detail.reader.name} · ${detail.reader.cardCode}',
              ),
              if (detail.titleName != null)
                _row('Sách', '${detail.titleName} · ${detail.copyCode ?? '—'}'),
              _row('Ngày ghi nhận', formatDate(fine.createdAt)),
              if (fine.note != null) _row('Ghi chú', fine.note!),
              const Divider(height: 32),
              _row('Số gốc', formatVnd(fine.amountVnd)),
              _row('Đã nộp / miễn', formatVnd(fine.paidVnd)),
              _row('Còn nợ', formatVnd(fine.balanceVnd), strong: true),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: fine.isOpen
                      ? () => _go(
                          FinePaymentScreen(
                            api: widget.api,
                            actorId: widget.actorId,
                            fineId: fine.id,
                          ),
                        )
                      : null,
                  child: const Text('Thu tiền mặt'),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  OutlinedButton(
                    onPressed: () => _go(
                      FinancialEventsScreen(api: widget.api, fineId: fine.id),
                    ),
                    child: const Text('Sổ sự kiện tài chính'),
                  ),
                  // CHK-fine-collection-basic-007: thủ thư không thấy miễn / điều chỉnh.
                  if (isAdmin)
                    OutlinedButton(
                      onPressed: fine.isOpen
                          ? () => _go(
                              FineAdjustScreen(
                                api: widget.api,
                                actorId: widget.actorId,
                                fineId: fine.id,
                              ),
                            )
                          : null,
                      child: const Text('Miễn / điều chỉnh'),
                    ),
                ],
              ),
              if (!fine.isOpen) ...[
                const SizedBox(height: 8),
                Text(
                  'Khoản phạt đã đóng nên không thu, miễn hay điều chỉnh thêm được.',
                  style: text.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .extension<AppColors>()!
                        .textSecondary,
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _row(String label, String value, {bool strong = false}) {
    final style = Theme.of(context).textTheme.bodyLarge;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text(label)),
          Expanded(
            child: Text(
              value,
              style: strong
                  ? style?.copyWith(fontWeight: FontWeight.w600)
                  : style,
            ),
          ),
        ],
      ),
    );
  }
}
