// Màn 14 – Biểu mẫu đặt trước (reservation-form). Route: /reservation/form · R2
// Bài: Hoang/07-reservation/02-reservation-form.md
//
// Xác nhận đặt trước một đầu sách. Thành công -> WAITING, xếp cuối hàng chờ FIFO -> sang hàng đợi.
// G8: API luôn đặt cho người đang đăng nhập; nhân viên đặt thay cần backend thêm readerId.

import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/theme_x.dart';
import '../../../core/widgets/info_banner.dart';
import '../../../core/widgets/loading_button.dart';
import '../../../core/widgets/snackbar.dart';
import '../data/reservation_api.dart';
import '../models/title_item.dart';

class ReservationFormScreen extends StatefulWidget {
  const ReservationFormScreen({super.key, required this.title});

  final TitleItem title;

  @override
  State<ReservationFormScreen> createState() => _ReservationFormScreenState();
}

class _ReservationFormScreenState extends State<ReservationFormScreen> {
  final _api = ReservationApi();
  bool _submitting = false;
  ApiException? _error;

  Future<void> _submit() async {
    if (_submitting) return;
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await _api.create(widget.title.id);
      if (!mounted) return;
      showAppSnackBar(context, 'Đã đặt trước "${widget.title.name}". Bạn sẽ nhận thông báo khi có sách.');
      Navigator.pushReplacementNamed(context, AppRoutes.reservationQueue);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.title;
    return Scaffold(
      appBar: AppBar(title: const Text('Xác nhận đặt trước')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            margin: EdgeInsets.zero,
            child: ListTile(
              leading: Icon(Icons.menu_book, color: context.scheme.primary, size: 32),
              title: Text(t.name, style: context.textTheme.titleMedium),
              subtitle: Text([t.author, if (t.isbn != null) 'ISBN ${t.isbn}'].join(' · ')),
            ),
          ),
          const SizedBox(height: 20),
          Text('ĐIỀU KIỆN ĐẶT TRƯỚC',
              style: context.textTheme.labelLarge?.copyWith(color: context.colors.textSecondary)),
          const SizedBox(height: 8),
          for (final c in const [
            'Tài khoản đang hoạt động, không có sách quá hạn',
            'Dưới 3 đặt trước đang mở',
            'Chưa đặt trước đầu sách này',
            'Đầu sách đã hết bản để mượn',
          ])
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(children: [
                Icon(Icons.check_circle_outline, size: 20, color: context.scheme.primary),
                const SizedBox(width: 10),
                Expanded(child: Text(c)),
              ]),
            ),
          const SizedBox(height: 16),
          const InfoBanner(
            kind: BannerKind.info,
            message: 'Bạn được xếp cuối hàng chờ. Khi có sách, bạn nhận thông báo và có 48 giờ để đến nhận.',
          ),
          if (_error != null) ...[const SizedBox(height: 12), _errorBanner(_error!)],
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(children: [
            OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
            const SizedBox(width: 12),
            Expanded(
              child: LoadingButton(
                icon: Icons.bookmark_add_outlined,
                label: 'Gửi yêu cầu đặt trước',
                loadingLabel: 'Đang gửi…',
                loading: _submitting,
                onPressed: _submit,
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _errorBanner(ApiException e) {
    final (msg, Widget? action) = switch (e.code) {
      'STILL_AVAILABLE' => (
          'Đầu sách vẫn còn bản sẵn sàng, không cần đặt trước.',
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Mượn trực tiếp tại quầy')),
        ),
      'RESERVE_LIMIT' => (
          'Bạn đã đủ số đặt trước đang mở. Hủy bớt hoặc chờ nhận sách.',
          TextButton(
            onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.reservationQueue),
            child: const Text('Xem hàng đợi của tôi'),
          ),
        ),
      'CONFLICT' => (
          'Bạn đã có đặt trước đang mở cho đầu sách này.',
          TextButton(
            onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.reservationQueue),
            child: const Text('Xem hàng đợi của tôi'),
          ),
        ),
      'READER_INACTIVE' => ('Tài khoản chưa kích hoạt hoặc đang bị khóa.', null),
      _ => (e.message, null),
    };
    return InfoBanner(kind: BannerKind.error, title: 'Chưa thể đặt trước', message: msg, action: action);
  }
}
