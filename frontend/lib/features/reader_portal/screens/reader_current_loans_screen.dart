// Màn 4 – Đang mượn (reader-current-loans). Route: /portal/loans
// Spec: docs/features/reader-self-service/srs/ (FR-002)
//
// Mục đích: phiếu đang mở, hạn trả, số ngày còn lại hoặc đã quá hạn, phạt tạm tính.
// Đi tới: reader-loan-history. (TV2) gia hạn.

import 'package:flutter/material.dart';
import 'package:frontend/core/utils/format.dart';
import 'package:frontend/features/fine/data/fine_rules.dart';
import 'package:frontend/features/fine/models/fine_policy.dart';

import '../data/portal_api.dart';
import '../models/my_loan.dart';
import '../widgets/due_chip.dart';
import 'reader_loan_history_screen.dart';

typedef _LoansData = ({List<MyLoan> loans, DateTime now, FinePolicy policy});

class ReaderCurrentLoansScreen extends StatefulWidget {
  const ReaderCurrentLoansScreen({
    super.key,
    required this.api,
    this.actions = const [],
  });

  final PortalApi api;

  /// Nút trên AppBar do khung cổng truyền vào (chuông thông báo).
  final List<Widget> actions;

  @override
  State<ReaderCurrentLoansScreen> createState() =>
      _ReaderCurrentLoansScreenState();
}

class _ReaderCurrentLoansScreenState extends State<ReaderCurrentLoansScreen> {
  late Future<_LoansData> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  /// Tải phiếu đang mở + mốc "hôm nay" + mức phạt, xếp hạn gần nhất lên đầu.
  Future<_LoansData> _load() async {
    final loans = await widget.api.myLoans();
    final now = await widget.api.now();
    final policy = await widget.api.finePolicy();
    final open = loans.where((l) => l.isOpen).toList()
      ..sort((a, b) => a.dueAt.compareTo(b.dueAt));
    return (loans: open, now: now, policy: policy);
  }

  Future<void> _refresh() async {
    final next = _load();
    setState(() => _future = next);
    await next;
  }

  /// "BC000010 · Hạn 04/10/2026" + dòng "Tạm tính 12.000đ" nếu đã trễ.
  String _subtitle(MyLoan loan, _LoansData data) {
    final line = '${loan.copyCode} · Hạn ${formatDate(loan.dueAt)}';
    final days = overdueDays(loan.dueAt, data.now);
    final price = loan.priceVnd;
    if (days == 0 || price == null) return line;
    final amount = overdueFine(
      days: days,
      perDayVnd: data.policy.perDayVnd,
      priceVnd: price,
    );
    return '$line\nTạm tính ${formatVnd(amount)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sách đang mượn'),
        actions: [
          ...widget.actions,
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Lịch sử mượn',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ReaderLoanHistoryScreen(api: widget.api),
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<_LoansData>(
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
            child: data.loans.isEmpty
                ? ListView(
                    children: const [
                      SizedBox(height: 120),
                      Center(child: Text('Bạn không mượn cuốn nào')),
                    ],
                  )
                : ListView.separated(
                    itemCount: data.loans.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final loan = data.loans[i];
                      final subtitle = _subtitle(loan, data);
                      return ListTile(
                        title: Text(loan.titleName),
                        subtitle: Text(subtitle),
                        isThreeLine: subtitle.contains('\n'),
                        trailing: DueChip(loan.daysLeft(data.now)),
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}
