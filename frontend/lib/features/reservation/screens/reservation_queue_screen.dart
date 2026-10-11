// Màn 15 – Hàng đợi đặt trước (reservation-queue). Route: /reservation/queue · R2
// Bài: Hoang/07-reservation/03-reservation-queue.md
//
// Người đọc xem đặt trước của mình theo 3 tab: Sẵn sàng (đếm ngược 48h), Đang chờ, Lịch sử.
// G9: chưa có vị trí trong hàng chờ -> chỉ hiện ngày đặt.

import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/layout/breakpoints.dart';
import '../../../core/network/api_client.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/theme_x.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/danger.dart';
import '../../../core/widgets/snackbar.dart';
import '../../../core/widgets/state_views.dart';
import '../../circulation/widgets/status_mapping.dart';
import '../data/reservation_api.dart';
import '../models/reservation.dart';

class ReservationQueueScreen extends StatefulWidget {
  const ReservationQueueScreen({super.key});

  @override
  State<ReservationQueueScreen> createState() => _ReservationQueueScreenState();
}

class _ReservationQueueScreenState extends State<ReservationQueueScreen> {
  final _api = ReservationApi();
  List<Reservation> _all = [];
  bool _loading = true;
  String? _error;

  List<Reservation> get _ready => _all.where((r) => r.status == 'READY').toList();
  List<Reservation> get _waiting =>
      _all.where((r) => r.status == 'WAITING').toList()..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  List<Reservation> get _history => _all.where((r) => !['READY', 'WAITING'].contains(r.status)).toList();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = _all.isEmpty; // lần sau chỉ làm mới, không che màn
      _error = null;
    });
    try {
      final list = await _api.mine();
      if (!mounted) return;
      setState(() {
        _all = list;
        _loading = false;
      });
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _error = e.message;
          _loading = false;
        });
      }
    }
  }

  Future<void> _cancel(Reservation r) async {
    final isReady = r.status == 'READY';
    final ok = await confirmDanger(
      context,
      title: 'Hủy đặt trước?',
      message: isReady
          ? 'Sách đang được giữ cho bạn. Hủy sẽ nhường sách cho người kế tiếp và không thể lấy lại lượt.'
          : 'Bạn sẽ rời khỏi hàng chờ "${r.titleName}".',
      actionLabel: 'Hủy đặt trước',
    );
    if (!ok) return;
    try {
      await _api.cancel(r.id);
      if (!mounted) return;
      showAppSnackBar(context, 'Đã hủy đặt trước "${r.titleName}".');
      _load();
    } on ApiException catch (e) {
      if (!mounted) return;
      showAppSnackBar(context, e.code == 'RESERVE_CLOSED' ? 'Đặt trước đã kết thúc trước đó. Đang tải lại.' : e.message,
          isError: true);
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Đặt trước của tôi'),
          actions: [
            // Web: kéo để làm mới bằng chuột không tự nhiên -> có nút làm mới (bài 0.6)
            if (!context.isCompact) IconButton(tooltip: 'Làm mới', icon: const Icon(Icons.refresh), onPressed: _load),
            IconButton(
              tooltip: 'Nhận sách đặt trước',
              icon: const Icon(Icons.how_to_reg_outlined),
              onPressed: () => Navigator.pushNamed(context, AppRoutes.reservationPickup),
            ),
          ],
          // TabBar trong AppBar (nền primary) -> chữ và vạch chỉ báo màu onPrimary
          bottom: TabBar(
            labelColor: context.scheme.onPrimary,
            unselectedLabelColor: context.scheme.onPrimary.withValues(alpha: 0.75),
            indicatorColor: context.scheme.onPrimary,
            tabs: [
              Tab(text: 'Sẵn sàng (${_ready.length})'),
              Tab(text: 'Đang chờ (${_waiting.length})'),
              const Tab(text: 'Lịch sử'),
            ],
          ),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? ErrorState(message: _error!, onRetry: _load)
                : TabBarView(children: [
                    _list(_ready, 'Chưa có sách nào sẵn sàng để nhận.'),
                    _list(_waiting, 'Bạn không có đặt trước nào đang chờ.'),
                    _list(_history, 'Chưa có lịch sử đặt trước.'),
                  ]),
      ),
    );
  }

  Widget _list(List<Reservation> items, String emptyText) {
    return RefreshIndicator(
      onRefresh: _load,
      child: items.isEmpty
          ? ListView(children: [
              const SizedBox(height: 100),
              EmptyState(
                icon: Icons.bookmark_border,
                message: emptyText,
                action: TextButton(
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.reservationSearch),
                  child: const Text('Tạo đặt trước mới'),
                ),
              ),
            ])
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (_, i) => _ReservationCard(
                key: ValueKey(items[i].id),
                reservation: items[i],
                onCancel: ['READY', 'WAITING'].contains(items[i].status) ? () => _cancel(items[i]) : null,
              ),
            ),
    );
  }
}

/// Thẻ có đếm ngược. Timer đặt ở thẻ (không ở màn cha) để chỉ thẻ READY vẽ lại mỗi 30 giây.
class _ReservationCard extends StatefulWidget {
  const _ReservationCard({super.key, required this.reservation, this.onCancel});

  final Reservation reservation;
  final VoidCallback? onCancel;

  @override
  State<_ReservationCard> createState() => _ReservationCardState();
}

class _ReservationCardState extends State<_ReservationCard> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.reservation.status == 'READY') {
      // Vẽ lại mỗi 30s để cập nhật "Còn x giờ y phút"
      _timer = Timer.periodic(const Duration(seconds: 30), (_) => setState(() {}));
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // BẮT BUỘC: không hủy là rò bộ nhớ + lỗi setState after dispose
    super.dispose();
  }

  String _remaining(Duration d) {
    if (d.isNegative) return 'Đã quá hạn nhận';
    final h = d.inHours, m = d.inMinutes % 60;
    return h > 0 ? 'Còn $h giờ $m phút' : 'Còn $m phút';
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.reservation;
    final left = r.readyUntil?.difference(DateTime.now());
    final urgent = left != null && left.inHours < 2;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Expanded(child: Text(r.titleName, style: context.textTheme.titleMedium)),
              reservationStatusChip(context, r.status),
            ]),
            const SizedBox(height: 6),
            if (r.status == 'READY' && left != null) ...[
              Row(children: [
                Icon(Icons.timer_outlined, size: 18, color: urgent ? context.scheme.error : context.colors.textSecondary),
                const SizedBox(width: 6),
                Text(_remaining(left),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: urgent ? context.scheme.error : context.scheme.onSurface,
                    )),
              ]),
              Text('Hạn nhận: ${fmtDateTime(r.readyUntil!)}', style: TextStyle(color: context.colors.textSecondary)),
            ] else
              Text('Đặt lúc ${fmtDateTime(r.createdAt)}', style: TextStyle(color: context.colors.textSecondary)),
            Row(children: [
              Expanded(
                child: Text(
                  switch (r.status) {
                    'READY' => 'Đến quầy để nhận sách.',
                    'WAITING' => 'Bạn sẽ được thông báo khi có sách.',
                    'FULFILLED' => 'Đã nhận sách.',
                    'EXPIRED' => 'Hết hạn giữ, sách đã chuyển cho người khác.',
                    _ => 'Đã hủy.',
                  },
                  style: TextStyle(fontSize: 13, color: context.colors.textSecondary),
                ),
              ),
              if (widget.onCancel != null) TextButton(onPressed: widget.onCancel, child: const Text('Hủy')),
            ]),
          ],
        ),
      ),
    );
  }
}
