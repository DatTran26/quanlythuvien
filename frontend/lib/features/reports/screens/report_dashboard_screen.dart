// Màn 17 – Dashboard báo cáo vận hành (report-dashboard). Route: /reports
// Bài: Hoang/08-reports/01-report-dashboard.md
//
// 3 tab: Kho (RP-02), Quá hạn (RP-04, xuất Excel/PDF), Tài khoản (RP-01, G11 chưa có API).
// Không có quyền (403) -> báo và quay về dashboard an toàn (E-core-002).

import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/layout/breakpoints.dart';
import '../../../core/network/api_client.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/theme_x.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/snackbar.dart';
import '../../../core/widgets/state_views.dart';
import '../../../core/widgets/status_chip.dart';
import '../../circulation/widgets/status_mapping.dart';
import '../data/report_api.dart';
import '../widgets/stat_tile.dart';

class ReportDashboardScreen extends StatelessWidget {
  const ReportDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Báo cáo vận hành'),
          actions: [
            IconButton(
              tooltip: 'Báo cáo xu hướng',
              icon: const Icon(Icons.trending_up),
              onPressed: () => Navigator.pushNamed(context, AppRoutes.trendDashboard),
            ),
          ],
          // TabBar trong AppBar (nền primary) -> chữ và vạch chỉ báo màu onPrimary
          bottom: TabBar(
            labelColor: context.scheme.onPrimary,
            unselectedLabelColor: context.scheme.onPrimary.withValues(alpha: 0.75),
            indicatorColor: context.scheme.onPrimary,
            tabs: const [Tab(text: 'Kho'), Tab(text: 'Quá hạn'), Tab(text: 'Tài khoản')],
          ),
        ),
        body: const TabBarView(children: [
          _InventoryTab(),
          _OverdueTab(),
          EmptyState(icon: Icons.manage_accounts_outlined, message: 'Báo cáo tài khoản (RP-01) đang được xây dựng.'),
        ]),
      ),
    );
  }
}

class _InventoryTab extends StatefulWidget {
  const _InventoryTab();

  @override
  State<_InventoryTab> createState() => _InventoryTabState();
}

class _InventoryTabState extends State<_InventoryTab> with AutomaticKeepAliveClientMixin {
  final _api = ReportApi();
  List<InventoryCount>? _data;
  String? _error;
  DateTime? _updatedAt;

  @override
  bool get wantKeepAlive => true; // giữ state khi chuyển tab, không tải lại

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final d = await _api.inventory();
      if (mounted) {
        setState(() {
          _data = d;
          _error = null;
          _updatedAt = DateTime.now();
        });
      }
    } on ApiException catch (e) {
      if (!mounted) return;
      if (e.status == 403) {
        showAppSnackBar(context, 'Bạn không có quyền xem báo cáo.', isError: true);
        Navigator.popUntil(context, ModalRoute.withName(AppRoutes.dashboard)); // redirect an toàn
        return;
      }
      setState(() => _error = e.message);
    }
  }

  int _count(String s) => _data!.where((e) => e.status == s).fold(0, (sum, e) => sum + e.count);

  @override
  Widget build(BuildContext context) {
    super.build(context); // bắt buộc khi dùng KeepAlive mixin
    if (_error != null) return ErrorState(message: _error!, onRetry: _load);
    if (_data == null) return const Center(child: CircularProgressIndicator());
    final total = _data!.fold(0, (s, e) => s + e.count);
    if (total == 0) return const EmptyState(icon: Icons.inventory_2_outlined, message: 'Chưa có dữ liệu kho.');

    final c = context.colors;
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(children: [
            Expanded(
              child: Text('Cập nhật ${fmtDateTime(_updatedAt!)} · kéo xuống để làm mới',
                  style: TextStyle(fontSize: 12, color: c.textSecondary)),
            ),
            if (!context.isCompact) IconButton(tooltip: 'Làm mới', icon: const Icon(Icons.refresh), onPressed: _load),
          ]),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: context.isCompact ? 2 : 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.6,
            children: [
              StatTile(label: 'Tổng bản sao', value: '$total', icon: Icons.library_books_outlined),
              StatTile(label: 'Sẵn sàng', value: '${_count('AVAILABLE')}', color: c.success),
              StatTile(label: 'Đang mượn', value: '${_count('ON_LOAN')}', color: c.info),
              StatTile(
                  label: 'Chờ duyệt / sửa',
                  value: '${_count('PENDING_REVIEW') + _count('IN_REPAIR')}',
                  color: c.warning),
            ],
          ),
          const SizedBox(height: 20),
          Text('PHÂN BỔ THEO TRẠNG THÁI', style: context.textTheme.labelLarge?.copyWith(color: c.textSecondary)),
          const SizedBox(height: 8),
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                // [...list] tạo bản sao rồi mới sort, không sửa dữ liệu gốc trong build()
                for (final e in [..._data!]..sort((a, b) => b.count.compareTo(a.count)))
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(children: [
                      SizedBox(width: 120, child: Align(alignment: Alignment.centerLeft, child: copyStatusChip(context, e.status))),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: e.count / total,
                            minHeight: 10,
                            backgroundColor: c.divider,
                            // Thanh mảnh dùng màu CHỮ (đậm) của cặp trạng thái để đủ tương phản 3:1
                            color: c.copyStatus(e.status).foreground,
                            semanticsLabel: e.status,
                            semanticsValue: '${(e.count * 100 / total).round()}%',
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 64,
                        child: Text('${e.count} · ${(e.count * 100 / total).round()}%',
                            textAlign: TextAlign.right, style: const TextStyle(fontSize: 12)),
                      ),
                    ]),
                  ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _OverdueTab extends StatefulWidget {
  const _OverdueTab();

  @override
  State<_OverdueTab> createState() => _OverdueTabState();
}

class _OverdueTabState extends State<_OverdueTab> with AutomaticKeepAliveClientMixin {
  final _api = ReportApi();
  List<OverdueLoan>? _data;
  String? _error;
  String? _exporting; // 'xlsx' | 'pdf' | null

  @override
  bool get wantKeepAlive => true;

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
          _data = d;
          _error = null;
        });
      }
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    }
  }

  Future<void> _export(String ext) async {
    if (_exporting != null) return;
    setState(() => _exporting = ext);
    try {
      final bytes = await _api.overdueFile(ext);
      if (kIsWeb) {
        // Web không có dart:io File: cần tạo thẻ <a download> (bài tập). Tạm thông báo.
        if (mounted) showAppSnackBar(context, 'Bản web chưa tải file được, dùng nút tải trên Swagger.');
        return;
      }
      final dir = await getApplicationDocumentsDirectory();
      final name = 'qua-han-${DateTime.now().millisecondsSinceEpoch}.$ext';
      final file = File('${dir.path}/$name');
      await file.writeAsBytes(bytes);
      if (!mounted) return;
      showAppSnackBar(context, 'Đã lưu $name',
          action: SnackBarAction(label: 'Mở', onPressed: () => OpenFilex.open(file.path)));
    } on ApiException catch (e) {
      if (mounted) showAppSnackBar(context, e.message, isError: true);
    } finally {
      if (mounted) setState(() => _exporting = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_error != null) return ErrorState(message: _error!, onRetry: _load);
    if (_data == null) return const Center(child: CircularProgressIndicator());
    final data = _data!;

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SizedBox(
            height: 110,
            child: StatTile(
              label: 'Phiếu đang quá hạn',
              value: '${data.length}',
              color: data.isEmpty ? context.colors.success : context.scheme.error,
              icon: Icons.schedule,
            ),
          ),
          if (data.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6, left: 4),
              child: Text('Lâu nhất: ${data.first.daysLate} ngày', style: TextStyle(color: context.colors.textSecondary)),
            ),
          const SizedBox(height: 20),
          if (data.isEmpty)
            const EmptyState(icon: Icons.celebration_outlined, message: 'Không có phiếu quá hạn. Tuyệt vời!')
          else ...[
            Text('QUÁ HẠN LÂU NHẤT', style: context.textTheme.labelLarge?.copyWith(color: context.colors.textSecondary)),
            const SizedBox(height: 8),
            Card(
              margin: EdgeInsets.zero,
              child: Column(children: [
                for (final l in data.take(5))
                  ListTile(
                    title: Text(l.readerName),
                    subtitle: Text(l.titleName, maxLines: 1, overflow: TextOverflow.ellipsis),
                    trailing: StatusChip(label: '${l.daysLate} ngày', pair: context.colors.statusDanger),
                  ),
              ]),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.overdueList),
                child: Text('Xem tất cả ${data.length} phiếu'),
              ),
            ),
          ],
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: _exportButton('xlsx', 'Xuất Excel', Icons.table_view_outlined, data.isEmpty)),
            const SizedBox(width: 12),
            Expanded(child: _exportButton('pdf', 'Xuất PDF', Icons.picture_as_pdf_outlined, data.isEmpty)),
          ]),
          if (data.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text('Không có phiếu quá hạn để xuất.',
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: context.colors.textSecondary)),
            ),
        ],
      ),
    );
  }

  Widget _exportButton(String ext, String label, IconData icon, bool empty) => OutlinedButton.icon(
        onPressed: empty || _exporting != null ? null : () => _export(ext),
        icon: _exporting == ext
            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
            : Icon(icon),
        label: Text(_exporting == ext ? 'Đang xuất…' : label),
      );
}
