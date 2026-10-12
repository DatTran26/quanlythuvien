// Màn 10 – Chi tiết báo cáo hư hỏng (damage-report-detail). Route: /damage/detail
// Bài: Hoang/05-damage-lifecycle/02-damage-report-detail.md
//
// Xem báo cáo và để Thủ thư quyết định: Bác bỏ / Đưa đi sửa / Thanh lý (DEC-P2-03, DEC-D3-07).
// Nhân viên chỉ thấy banner "Đang chờ Thủ thư duyệt". Vai trò lấy từ AppSession (sau là /me của TV1).
// Khác bài học: ảnh tải bằng ApiClient.getBytes + Image.memory (bài gợi ý cho web, tránh CORS).

import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/theme_x.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/danger.dart';
import '../../../core/widgets/info_banner.dart';
import '../../../core/widgets/snackbar.dart';
import '../../circulation/data/circulation_api.dart';
import '../../circulation/models/book_copy.dart';
import '../../circulation/widgets/status_mapping.dart';
import '../data/condition_api.dart';
import '../models/damage_report.dart';

/// Dữ liệu truyền vào màn: báo cáo + bản sao (G5: chưa có API lấy chi tiết báo cáo).
typedef DamageDetailArgs = ({DamageReport report, BookCopy copy});

class DamageReportDetailScreen extends StatefulWidget {
  const DamageReportDetailScreen({super.key, required this.args, required this.isLibrarian});

  final DamageDetailArgs args;
  final bool isLibrarian; // TV1 cung cấp vai trò người dùng hiện tại

  @override
  State<DamageReportDetailScreen> createState() => _DamageReportDetailScreenState();
}

class _DamageReportDetailScreenState extends State<DamageReportDetailScreen> {
  final _api = ConditionApi();
  late DamageReport _report = widget.args.report;
  late BookCopy _copy = widget.args.copy;
  late final Future<Uint8List>? _photo =
      widget.args.report.photoPath == null ? null : _api.photoBytes(widget.args.report.photoPath!);
  bool _busy = false;

  bool get _pending => _report.status == 'PENDING';
  bool get _inRepair => _report.status == 'REPAIR' && _copy.status == 'IN_REPAIR';

  Future<void> _decide(String decision, {String? reason}) async {
    setState(() => _busy = true);
    try {
      // reason: backend chưa nhận trường này, cần thêm vào DecisionRequest
      final updated = await _api.decide(_report.id, decision);
      final freshCopy = await CirculationApi().findCopy(_copy.code); // trạng thái bản sao mới
      if (!mounted) return;
      setState(() {
        _report = updated;
        _copy = freshCopy;
      });
      showAppSnackBar(
          context,
          switch (decision) {
            'REJECT' => 'Đã bác bỏ. Bản sao được lưu thông lại.',
            'REPAIR' => 'Đã chuyển bản sao đi sửa.',
            _ => 'Đã thanh lý bản sao.',
          });
    } on ApiException catch (e) {
      if (!mounted) return;
      showAppSnackBar(
          context, e.code == 'REPORT_CLOSED' ? 'Báo cáo đã được người khác xử lý.' : e.message,
          isError: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _dispose() async {
    // 1) Dialog xác nhận + lý do
    final reasonCtrl = TextEditingController();
    final reason = await showDialog<String>(
      context: context,
      builder: (ctx) {
        String? error;
        // StatefulBuilder: cho phép setState BÊN TRONG dialog (hiện lỗi khi lý do trống)
        return StatefulBuilder(
          builder: (ctx, setLocal) => AlertDialog(
            icon: Icon(Icons.warning_amber_rounded, color: ctx.scheme.error),
            title: const Text('Thanh lý bản sao?'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Bản sao ${_copy.code} sẽ bị loại khỏi kho vĩnh viễn. Không thể hoàn tác.'),
                const SizedBox(height: 12),
                TextField(
                  controller: reasonCtrl,
                  autofocus: true,
                  maxLines: 2,
                  decoration: InputDecoration(labelText: 'Lý do thanh lý *', errorText: error),
                ),
              ],
            ),
            actions: [
              OutlinedButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
              FilledButton(
                style: dangerButtonStyle(ctx),
                onPressed: () {
                  if (reasonCtrl.text.trim().length < 5) {
                    setLocal(() => error = 'Nhập lý do ít nhất 5 ký tự');
                    return;
                  }
                  Navigator.pop(ctx, reasonCtrl.text.trim());
                },
                child: const Text('Thanh lý 1 bản sao'),
              ),
            ],
          ),
        );
      },
    );
    reasonCtrl.dispose();
    if (reason == null || !mounted) return;

    // 2) Xác thực lại (step-up) ở màn session-expired của TV1, chờ kết quả true/false
    final verified = await Navigator.pushNamed<bool>(context, AppRoutes.sessionExpired,
        arguments: 'Xác nhận mật khẩu để thanh lý sách');
    if (verified != true || !mounted) return;

    // 3) Ghi quyết định
    await _decide('DISPOSE', reason: reason);
  }

  Future<void> _repairDone() async {
    setState(() => _busy = true);
    try {
      await _api.repairComplete(_copy.id);
      final fresh = await CirculationApi().findCopy(_copy.code);
      if (!mounted) return;
      setState(() => _copy = fresh);
      showAppSnackBar(
          context,
          fresh.status == 'ON_HOLD'
              ? 'Đã sửa xong. Bản sao được giữ cho người đặt trước.'
              : 'Đã sửa xong. Bản sao sẵn sàng cho mượn.');
    } on ApiException catch (e) {
      if (mounted) showAppSnackBar(context, e.message, isError: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Báo cáo #${_report.id}')),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(children: [
                damageStatusChip(context, _report.status),
                const SizedBox(width: 8),
                Text(fmtDateTime(_report.createdAt), style: TextStyle(color: context.colors.textSecondary)),
              ]),
              const SizedBox(height: 12),
              Card(
                margin: EdgeInsets.zero,
                child: Column(children: [
                  ListTile(
                    leading: Icon(Icons.menu_book, color: context.scheme.primary),
                    title: Text(_copy.titleName),
                    subtitle: Text('${_copy.code}${_copy.shelf != null ? ' · Kệ ${_copy.shelf}' : ''}'),
                    trailing: copyStatusChip(context, _copy.status),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(children: [
                      _infoRow(
                          'Mức độ',
                          switch (_report.severity) {
                            'LIGHT' => 'Nhẹ (không tính phí)',
                            'MEDIUM' => 'Vừa (30% giá bìa)',
                            'HEAVY' => 'Nặng (100% giá bìa)',
                            _ => 'Chưa ghi',
                          }),
                      _infoRow('Người báo', 'Nhân viên #${_report.reporterId}'), // API chỉ trả id, chưa có tên
                      _infoRow('Mô tả', _report.note ?? '—'),
                    ]),
                  ),
                ]),
              ),
              _sectionTitle('Ảnh bằng chứng'),
              _photoView(),
              ..._actions(),
            ],
          ),
          if (_busy) ...[
            ModalBarrier(dismissible: false, color: context.scheme.scrim.withValues(alpha: 0.15)),
            const Center(child: CircularProgressIndicator()),
          ],
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 100, child: Text(label, style: TextStyle(color: context.colors.textSecondary))),
            Expanded(child: Text(value)),
          ],
        ),
      );

  Widget _sectionTitle(String t) => Padding(
        padding: const EdgeInsets.fromLTRB(4, 20, 0, 8),
        child: Text(t.toUpperCase(), style: context.textTheme.labelLarge?.copyWith(color: context.colors.textSecondary)),
      );

  Widget _photoView() {
    if (_photo == null) {
      return Text('Không có ảnh.', style: TextStyle(color: context.colors.textSecondary));
    }
    return FutureBuilder<Uint8List>(
      future: _photo, // tạo Future 1 lần (late final), không gọi lại API mỗi lần build
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const SizedBox(height: 200, child: Center(child: CircularProgressIndicator()));
        }
        if (snap.hasError || snap.data == null) {
          return Container(
            height: 160,
            decoration: BoxDecoration(
              color: context.colors.disabledBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Icon(Icons.broken_image_outlined, color: context.colors.textSecondary, size: 40),
          );
        }
        final bytes = snap.data!;
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => showDialog(
              context: context,
              builder: (_) => Dialog(
                insetPadding: const EdgeInsets.all(8),
                child: InteractiveViewer(maxScale: 5, child: Image.memory(bytes)),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(aspectRatio: 4 / 3, child: Image.memory(bytes, fit: BoxFit.cover)),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _actions() {
    final widgets = <Widget>[];

    if (_pending && widget.isLibrarian) {
      widgets.addAll([
        _sectionTitle('Quyết định (Thủ thư)'),
        Row(children: [
          Expanded(child: OutlinedButton(onPressed: () => _decide('REJECT'), child: const Text('Bác bỏ'))),
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton.tonal(
              style: AppButtonStyles.tonal(context),
              onPressed: () => _decide('REPAIR'),
              child: const Text('Đưa đi sửa'),
            ),
          ),
        ]),
        const SizedBox(height: 12),
        FilledButton.icon(
          style: dangerButtonStyle(context),
          onPressed: _dispose,
          icon: const Icon(Icons.delete_forever_outlined),
          label: const Text('Thanh lý sách'),
        ),
        const SizedBox(height: 6),
        Text('Thanh lý cần xác thực lại và nhập lý do.',
            style: TextStyle(fontSize: 12, color: context.colors.textSecondary)),
      ]);
    } else if (_pending) {
      widgets.addAll([
        const SizedBox(height: 16),
        const InfoBanner(kind: BannerKind.info, message: 'Đang chờ Thủ thư duyệt. Bản sao tạm ngừng cho mượn.'),
      ]);
    }

    if (_inRepair) {
      widgets.addAll([
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: _repairDone,
          icon: const Icon(Icons.build_circle_outlined),
          label: const Text('Xác nhận sửa xong'),
        ),
      ]);
    }

    if (!_pending && !_inRepair) {
      widgets.addAll([
        const SizedBox(height: 16),
        const InfoBanner(kind: BannerKind.info, message: 'Báo cáo đã đóng. Không thể thay đổi quyết định.'),
      ]);
    }

    widgets.addAll([
      const Divider(height: 32),
      Text('Tác vụ khác', style: context.textTheme.titleSmall),
      Wrap(spacing: 8, children: [
        TextButton.icon(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.lostRecord, arguments: _copy.code),
          icon: const Icon(Icons.search_off),
          label: const Text('Ghi nhận mất'),
        ),
        TextButton.icon(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.finePayment), // TV3
          icon: const Icon(Icons.payments_outlined),
          label: const Text('Tính phí'),
        ),
      ]),
    ]);
    return widgets;
  }
}
