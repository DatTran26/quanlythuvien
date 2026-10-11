// Màn 5 – Lịch sử mượn (reader-loan-history). Route: /portal/history
// Bài: TV3 3 · Độ khó ⭐⭐
//
// Mục đích: phiếu đã đóng (RETURNED, LOST), lọc theo khoảng thời gian.
//
// TODO:
// - Danh sách phiếu đã đóng, mới nhất trước: tên sách, ngày mượn, ngày trả / "Đã báo mất".
// - Lọc thời gian bằng showDateRangePicker.
//
// Lỗ hổng: T6 (API chưa có borrowedAt, returnedAt).
// Màn 5 – Lịch sử mượn (reader-loan-history). Route: /portal/history
// Spec: docs/features/reader-self-service/srs/ (FR-005)
//
// Mục đích: phiếu đã đóng (RETURNED, LOST), lọc theo khoảng thời gian.
// Lỗ hổng: T6 (API chưa có borrowedAt, returnedAt).

import 'package:flutter/material.dart';
import 'package:frontend/core/utils/format.dart';

import '../data/portal_api.dart';
import '../models/my_loan.dart';

class ReaderLoanHistoryScreen extends StatefulWidget {
  const ReaderLoanHistoryScreen({super.key, required this.api});

  final PortalApi api;

  @override
  State<ReaderLoanHistoryScreen> createState() =>
      _ReaderLoanHistoryScreenState();
}

class _ReaderLoanHistoryScreenState extends State<ReaderLoanHistoryScreen> {
  late final Future<List<MyLoan>> _future;
  DateTimeRange? _range;

  @override
  void initState() {
    super.initState();
    _future = widget.api.myLoans();
  }

  /// Phiếu đã đóng, mới nhất trước, lọc theo ngày mượn nếu có chọn khoảng.
  List<MyLoan> _visible(List<MyLoan> all) {
    final closed = all.where((l) => !l.isOpen).where((l) {
      final range = _range;
      final borrowed = l.borrowedAt;
      if (range == null || borrowed == null) return true;
      final day = DateTime(borrowed.year, borrowed.month, borrowed.day);
      return !day.isBefore(range.start) && !day.isAfter(range.end);
    }).toList();
    closed.sort(
      (a, b) => (b.borrowedAt ?? b.dueAt).compareTo(a.borrowedAt ?? a.dueAt),
    );
    return closed;
  }

  Future<void> _pickRange() async {
    final now = await widget.api.now();
    if (!mounted) return;
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 3),
      lastDate: now,
      initialDateRange: _range,
      // Gợi ý mặc định của Flutter tiếng Việt vẫn ghi "mm/dd/yyyy" dù cách đọc là ngày/tháng/năm.
      fieldStartLabelText: 'Từ ngày',
      fieldEndLabelText: 'Đến ngày',
      fieldStartHintText: 'dd/mm/yyyy',
      fieldEndHintText: 'dd/mm/yyyy',
    );
    if (picked != null) setState(() => _range = picked);
  }

  /// "Mượn 01/08/2026 · Trả 14/08/2026" hoặc "Mượn 20/08/2026 · Đã báo mất".
  String _describe(MyLoan loan) {
    final borrowed = loan.borrowedAt;
    final returned = loan.returnedAt;
    final parts = [
      if (borrowed != null) 'Mượn ${formatDate(borrowed)}',
      if (loan.status == 'LOST')
        'Đã báo mất'
      else if (returned != null)
        'Trả ${formatDate(returned)}'
      else
        'Đã trả',
    ];
    return parts.join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    final range = _range;
    return Scaffold(
      appBar: AppBar(title: const Text('Lịch sử mượn')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              children: [
                OutlinedButton.icon(
                  onPressed: _pickRange,
                  icon: const Icon(Icons.date_range),
                  label: Text(
                    range == null
                        ? 'Chọn khoảng thời gian'
                        : '${formatDate(range.start)} – ${formatDate(range.end)}',
                  ),
                ),
                if (range != null)
                  IconButton(
                    icon: const Icon(Icons.close),
                    tooltip: 'Bỏ lọc',
                    onPressed: () => setState(() => _range = null),
                  ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<MyLoan>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Lỗi: ${snapshot.error}'));
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final loans = _visible(snapshot.data!);
                if (loans.isEmpty) {
                  return const Center(child: Text('Không có phiếu nào'));
                }
                return ListView.separated(
                  itemCount: loans.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final loan = loans[i];
                    return ListTile(
                      title: Text(loan.titleName),
                      subtitle: Text(_describe(loan)),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
