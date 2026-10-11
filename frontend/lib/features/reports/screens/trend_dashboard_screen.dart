// Màn 19 – Dashboard xu hướng (trend-dashboard). Route: /reports/trends · R2
// Bài: Hoang/08-reports/03-trend-dashboard.md
//
// RP-03 lượt mượn/trả theo 7 ngày / 4 tuần / 6 tháng: gọi GET /reports/trends cho từng khoảng,
// vẽ biểu đồ cột bằng Container. RP-05/06/07: G10 chưa có API -> thẻ "Sắp có", không giả số liệu.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/network/api_client.dart';
import '../../../core/theme/theme_x.dart';
import '../../../core/widgets/state_views.dart';
import '../../../core/widgets/status_chip.dart';
import '../data/report_api.dart';
import '../widgets/stat_tile.dart';

enum _Period { week, month, halfYear }

class _Bucket {
  _Bucket(this.label, this.from, this.to);

  final String label;
  final DateTime from, to;
  int loans = 0, returns = 0;
}

class TrendDashboardScreen extends StatefulWidget {
  const TrendDashboardScreen({super.key});

  @override
  State<TrendDashboardScreen> createState() => _TrendDashboardScreenState();
}

class _TrendDashboardScreenState extends State<TrendDashboardScreen> {
  final _api = ReportApi();
  _Period _period = _Period.week;
  bool _showReturns = true;
  List<_Bucket> _buckets = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  /// Chia khoảng thời gian thành các "rổ" (bucket): 7 ngày / 4 tuần / 6 tháng
  List<_Bucket> _makeBuckets(_Period p) {
    final today = DateUtils.dateOnly(DateTime.now());
    switch (p) {
      case _Period.week:
        return [
          for (var i = 6; i >= 0; i--)
            () {
              final d = today.subtract(Duration(days: i));
              return _Bucket(DateFormat('E', 'vi').format(d), d, d); // "T2", "T3"...
            }(),
        ];
      case _Period.month:
        return [
          for (var i = 3; i >= 0; i--)
            _Bucket('Tuần ${4 - i}', today.subtract(Duration(days: i * 7 + 6)), today.subtract(Duration(days: i * 7))),
        ];
      case _Period.halfYear:
        return [
          for (var i = 5; i >= 0; i--)
            () {
              final start = DateTime(today.year, today.month - i, 1);
              final end = DateTime(start.year, start.month + 1, 0); // ngày cuối tháng
              return _Bucket('T${start.month}', start, end);
            }(),
        ];
    }
  }

  Future<void> _load() async {
    final buckets = _makeBuckets(_period);
    setState(() {
      _loading = _buckets.isEmpty;
      _error = null;
    });
    try {
      // Gọi song song cho từng khoảng
      final results = await Future.wait(buckets.map((b) => _api.trends(b.from, b.to)));
      for (var i = 0; i < buckets.length; i++) {
        buckets[i].loans = results[i]['loans']!;
        buckets[i].returns = results[i]['returns']!;
      }
      if (mounted) {
        setState(() {
          _buckets = buckets;
          _loading = false;
        });
      }
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _error = e.message;
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalLoans = _buckets.fold(0, (s, b) => s + b.loans);
    final totalReturns = _buckets.fold(0, (s, b) => s + b.returns);

    return Scaffold(
      appBar: AppBar(title: const Text('Xu hướng')),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SizedBox(
              width: double.infinity,
              child: CupertinoSlidingSegmentedControl<_Period>(
                groupValue: _period,
                backgroundColor: context.scheme.primaryContainer,
                thumbColor: context.scheme.surface,
                children: const {
                  _Period.week: Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('7 ngày')),
                  _Period.month: Text('4 tuần'),
                  _Period.halfYear: Text('6 tháng'),
                },
                onValueChanged: (p) {
                  if (p == null) return;
                  setState(() => _period = p);
                  _load();
                },
              ),
            ),
            const SizedBox(height: 16),
            if (_loading)
              const Padding(padding: EdgeInsets.all(48), child: Center(child: CircularProgressIndicator()))
            else if (_error != null)
              ErrorState(message: _error!, onRetry: _load)
            else ...[
              SizedBox(
                height: 100,
                child: Row(children: [
                  Expanded(child: StatTile(label: 'Lượt mượn', value: '$totalLoans', icon: Icons.output)),
                  const SizedBox(width: 12),
                  Expanded(child: StatTile(label: 'Lượt trả', value: '$totalReturns', icon: Icons.input)),
                ]),
              ),
              const SizedBox(height: 20),
              Row(children: [
                Expanded(
                  child: Text('RP-03 LƯỢT MƯỢN / TRẢ',
                      style: context.textTheme.labelLarge?.copyWith(color: context.colors.textSecondary)),
                ),
                Text('Hiện trả', style: TextStyle(color: context.colors.textSecondary)),
                Switch.adaptive(value: _showReturns, onChanged: (v) => setState(() => _showReturns = v)),
              ]),
              Card(
                margin: EdgeInsets.zero,
                child: Padding(padding: const EdgeInsets.fromLTRB(12, 16, 12, 12), child: _barChart()),
              ),
            ],
            const SizedBox(height: 16),
            _comingSoon('RP-05 Phạt', 'Phát sinh · đã thu · chưa thu · miễn', Icons.payments_outlined),
            _comingSoon('RP-06 Top / không mượn', 'Sách được quan tâm nhất', Icons.star_outline),
            _comingSoon('RP-07 Hư hỏng', 'Duyệt · thanh lý trong kỳ', Icons.report_outlined),
            const SizedBox(height: 8),
            const Row(children: [
              Expanded(child: OutlinedButton(onPressed: null, child: Text('Xuất Excel'))),
              SizedBox(width: 12),
              Expanded(child: OutlinedButton(onPressed: null, child: Text('Xuất PDF'))),
            ]),
            const SizedBox(height: 6),
            Text('Chưa hỗ trợ xuất báo cáo xu hướng.',
                textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: context.colors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _barChart() {
    const chartHeight = 160.0;
    final maxValue = _buckets.fold<int>(
        1, (m, b) => [m, b.loans, if (_showReturns) b.returns].reduce((a, c) => a > c ? a : c));
    final loanColor = context.scheme.primary;
    final returnColor = context.colors.info;

    Widget bar(int value, Color color, String tip) => Tooltip(
          message: tip,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            width: _showReturns ? 10 : 18,
            height: chartHeight * value / maxValue, // cao theo tỉ lệ với giá trị lớn nhất
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            ),
          ),
        );

    return Semantics(
      label: 'Biểu đồ lượt mượn và trả: '
          '${_buckets.map((b) => '${b.label} mượn ${b.loans} trả ${b.returns}').join(', ')}',
      child: Column(children: [
        SizedBox(
          height: chartHeight + 28, // cột cao tối đa chartHeight + khoảng 4 + nhãn 1 dòng
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end, // mọi cột đứng chung đáy
            children: [
              for (final b in _buckets)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          bar(b.loans, loanColor, '${b.label}: ${b.loans} lượt mượn'),
                          if (_showReturns) ...[
                            const SizedBox(width: 3),
                            bar(b.returns, returnColor, '${b.label}: ${b.returns} lượt trả'),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(b.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 11, color: context.colors.textSecondary)),
                    ],
                  ),
                ),
            ],
          ),
        ),
        Divider(color: context.colors.divider),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          _legend(loanColor, 'Mượn'),
          if (_showReturns) ...[const SizedBox(width: 16), _legend(returnColor, 'Trả')],
        ]),
      ]),
    );
  }

  Widget _legend(Color c, String label) => Row(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(3))),
        const SizedBox(width: 6),
        Text(label),
      ]);

  Widget _comingSoon(String title, String sub, IconData icon) => Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          leading: Icon(icon, color: context.colors.textSecondary),
          title: Text(title),
          subtitle: Text(sub),
          trailing: StatusChip(label: 'Sắp có', pair: context.colors.statusNeutral),
        ),
      );
}
