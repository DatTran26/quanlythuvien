// Màn 6 – Công nợ của tôi (reader-my-fines). Route: /portal/fines
// Spec: docs/features/reader-self-service/srs/ (FR-003, R1B)
// Checklist: CHK-reader-self-service-005 – chỉ xem, không thu online.
//
// Mục đích: người đọc xem tổng nợ, từng khoản phạt, phạt tạm tính của sách đang trễ.
// Thu tiền mặt tại quầy (project-profile: MVP thu phạt tại quầy bằng tiền mặt).

import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/utils/format.dart';
import 'package:frontend/features/fine/data/fine_rules.dart';
import 'package:frontend/features/fine/models/fine.dart';
import 'package:frontend/features/fine/models/fine_policy.dart';
import 'package:frontend/features/fine/widgets/fine_labels.dart';

import '../data/portal_api.dart';
import '../models/my_loan.dart';

/// Mọi dữ liệu màn cần, tải một lần.
typedef _MyFinesData = ({
  List<Fine> fines,
  List<MyLoan> overdueLoans,
  DateTime now,
  FinePolicy policy,
});

class ReaderMyFinesScreen extends StatefulWidget {
  const ReaderMyFinesScreen({
    super.key,
    required this.api,
    this.actions = const [],
  });

  final PortalApi api;

  /// Nút trên AppBar do khung cổng truyền vào (chuông thông báo).
  final List<Widget> actions;

  @override
  State<ReaderMyFinesScreen> createState() => _ReaderMyFinesScreenState();
}

class _ReaderMyFinesScreenState extends State<ReaderMyFinesScreen> {
  late Future<_MyFinesData> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_MyFinesData> _load() async {
    final fines = await widget.api.myFines();
    final loans = await widget.api.myLoans();
    final now = await widget.api.now();
    final policy = await widget.api.finePolicy();
    // Sách đang mượn đã quá hạn: phạt chưa ghi nợ, chỉ tạm tính (backend ghi khi trả sách).
    final overdue = loans
        .where((l) => l.isOpen && overdueDays(l.dueAt, now) > 0)
        .toList();
    return (fines: fines, overdueLoans: overdue, now: now, policy: policy);
  }

  Future<void> _refresh() async {
    final next = _load();
    setState(() => _future = next);
    await next;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Công nợ của tôi'),
        actions: widget.actions,
      ),
      body: FutureBuilder<_MyFinesData>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data!;
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _summary(data),
                if (data.overdueLoans.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _sectionTitle('Phạt tạm tính (sách đang trễ)'),
                  for (final loan in data.overdueLoans)
                    _provisionalTile(loan, data),
                  Text(
                    'Số tiền chính thức được tính khi bạn trả sách.',
                    style: _hint(context),
                  ),
                ],
                const SizedBox(height: 24),
                _sectionTitle('Các khoản phạt'),
                if (data.fines.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text('Bạn không có khoản phạt nào.'),
                  )
                else
                  for (final fine in data.fines) _fineTile(fine),
                const SizedBox(height: 24),
                // CHK-reader-self-service-005: chỉ xem, không có nút thanh toán.
                Text(
                  'Vui lòng nộp tiền mặt tại quầy thư viện. '
                  'Ứng dụng không hỗ trợ thanh toán trực tuyến.',
                  style: _hint(context),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Ô tổng nợ + cảnh báo bị chặn mượn.
  Widget _summary(_MyFinesData data) {
    final debt = data.fines
        .where((f) => f.isOpen)
        .fold<int>(0, (sum, f) => sum + f.balanceVnd);
    final blocked = isBlockedByDebt(debt, data.policy.blockVnd);
    final colors = Theme.of(context).extension<AppColors>()!;
    final pair = blocked ? colors.errorContainer : colors.successContainer;
    return Card(
      color: pair.background,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Đang nợ', style: TextStyle(color: pair.foreground)),
            const SizedBox(height: 4),
            Text(
              formatVnd(debt),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: pair.foreground,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (blocked) ...[
              const SizedBox(height: 8),
              Text(
                'Bạn tạm thời không mượn được sách mới vì nợ từ '
                '${formatVnd(data.policy.blockVnd)} trở lên.',
                style: TextStyle(color: pair.foreground),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _provisionalTile(MyLoan loan, _MyFinesData data) {
    final days = overdueDays(loan.dueAt, data.now);
    final price = loan.priceVnd;
    // Không biết giá bìa (API chưa trả, T6) thì không áp được trần: chỉ ghi số ngày.
    final amount = price == null
        ? null
        : overdueFine(
            days: days,
            perDayVnd: data.policy.perDayVnd,
            priceVnd: price,
          );
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(loan.titleName),
      subtitle: Text('Trễ $days ngày · hạn ${formatDate(loan.dueAt)}'),
      trailing: amount == null ? null : Text(formatVnd(amount)),
    );
  }

  Widget _fineTile(Fine fine) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        '${fineReasonLabel(fine.reason)} · ${formatVnd(fine.amountVnd)}',
      ),
      // Ngày ghi nhận + ghi chú của thủ thư (có thể đã nói "đã nộp ..."), không tự ghép thêm.
      subtitle: Text(
        [
          formatDate(fine.createdAt),
          if (fine.note != null) fine.note!,
        ].join(' · '),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FineStatusChip(fine.status),
          if (fine.isOpen) Text('Còn ${formatVnd(fine.balanceVnd)}'),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Text(text, style: Theme.of(context).textTheme.titleMedium),
  );

  TextStyle? _hint(BuildContext context) => Theme.of(context)
      .textTheme
      .bodySmall
      ?.copyWith(
        color: Theme.of(context).extension<AppColors>()!.textSecondary,
      );
}
