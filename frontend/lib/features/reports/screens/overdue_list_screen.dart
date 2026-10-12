// Màn 18 – Danh sách quá hạn (overdue-list-staff). Route: /reports/overdue · R1B
// Bài: Hoang/08-reports/02-overdue-list-staff.md
//
// Nhân viên xem toàn bộ phiếu quá hạn để nhắc người đọc. Lọc theo tên, sắp xếp theo số ngày / tên.

import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../../core/theme/theme_x.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/snackbar.dart';
import '../../../core/widgets/state_views.dart';
import '../../../core/widgets/status_chip.dart';
import '../data/report_api.dart';

enum _Sort { daysDesc, daysAsc, reader }

class OverdueListScreen extends StatefulWidget {
  const OverdueListScreen({super.key});

  @override
  State<OverdueListScreen> createState() => _OverdueListScreenState();
}

class _OverdueListScreenState extends State<OverdueListScreen> {
  final _api = ReportApi();
  List<OverdueLoan> _all = [];
  bool _loading = true;
  String? _error;
  String _filter = '';
  _Sort _sort = _Sort.daysDesc;

  /// Danh sách hiển thị = lọc + sắp xếp. Tính lại mỗi lần build (dữ liệu nhỏ nên nhẹ)
  List<OverdueLoan> get _visible {
    final f = _filter.toLowerCase();
    final list = _all
        .where((l) => f.isEmpty || l.readerName.toLowerCase().contains(f) || l.titleName.toLowerCase().contains(f))
        .toList();
    switch (_sort) {
      case _Sort.daysDesc:
        list.sort((a, b) => b.daysLate.compareTo(a.daysLate));
      case _Sort.daysAsc:
        list.sort((a, b) => a.daysLate.compareTo(b.daysLate));
      case _Sort.reader:
        list.sort((a, b) => a.readerName.compareTo(b.readerName));
    }
    return list;
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final d = await _api.overdue();
      if (mounted) {
        setState(() {
          _all = d;
          _loading = false;
          _error = null;
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
    final items = _visible;
    return Scaffold(
      appBar: AppBar(
        title: Text('Phiếu quá hạn${_loading ? '' : ' (${_all.length})'}'),
        actions: [
          PopupMenuButton<_Sort>(
            tooltip: 'Sắp xếp',
            icon: const Icon(Icons.sort),
            initialValue: _sort,
            onSelected: (s) => setState(() => _sort = s),
            itemBuilder: (_) => const [
              PopupMenuItem(value: _Sort.daysDesc, child: Text('Trễ lâu nhất trước')),
              PopupMenuItem(value: _Sort.daysAsc, child: Text('Trễ ít nhất trước')),
              PopupMenuItem(value: _Sort.reader, child: Text('Theo tên người đọc')),
            ],
          ),
          IconButton(
            tooltip: 'Xuất Excel',
            icon: const Icon(Icons.download_outlined),
            // Dùng chung cách lưu file với tab Quá hạn ở report-dashboard
            onPressed: () => showAppSnackBar(context, 'Xuất Excel ở tab Quá hạn của màn Báo cáo vận hành.'),
          ),
        ],
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: TextField(
            onChanged: (t) => setState(() => _filter = t.trim()),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.filter_list),
              hintText: 'Lọc theo người đọc hoặc tên sách',
              isDense: true,
            ),
          ),
        ),
        Expanded(child: _body(items)),
      ]),
    );
  }

  Widget _body(List<OverdueLoan> items) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) return ErrorState(message: _error!, onRetry: _load);
    if (_all.isEmpty) return const EmptyState(icon: Icons.celebration_outlined, message: 'Không có phiếu quá hạn.');
    if (items.isEmpty) return EmptyState(icon: Icons.search_off, message: 'Không có kết quả cho "$_filter".');

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        itemCount: items.length,
        itemBuilder: (_, i) {
          final l = items[i];
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              isThreeLine: true,
              leading: CircleAvatar(
                backgroundColor: context.scheme.primaryContainer,
                foregroundColor: context.scheme.onPrimaryContainer,
                child: Text(l.readerName.isEmpty ? '?' : l.readerName.characters.first.toUpperCase()),
              ),
              title: Text(l.readerName),
              subtitle: Text('${l.titleName} · ${l.copyCode}\nHạn ${fmtDate(l.dueAt)}',
                  maxLines: 2, overflow: TextOverflow.ellipsis),
              trailing: StatusChip(
                label: '${l.daysLate} ngày',
                pair: context.colors.statusDanger,
                icon: l.daysLate > 30 ? Icons.priority_high : null,
              ),
              onTap: () => _showDetail(l),
            ),
          );
        },
      ),
    );
  }

  void _showDetail(OverdueLoan l) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l.readerName, style: ctx.textTheme.titleLarge),
              const SizedBox(height: 8),
              Text('${l.titleName} (${l.copyCode})'),
              Text('Hạn trả ${fmtDate(l.dueAt)} · trễ ${l.daysLate} ngày',
                  style: TextStyle(color: ctx.scheme.error, fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () => Navigator.pop(ctx), // gửi nhắc: API thông báo của TV3
                icon: const Icon(Icons.notifications_active_outlined),
                label: const Text('Gửi nhắc trả sách'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
