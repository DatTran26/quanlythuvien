// Màn 16 – Nhận sách đặt trước (reservation-pickup). Route: /reservation/pickup · R2
// Bài: Hoang/07-reservation/04-reservation-pickup.md
//
// Thủ thư quét thẻ người đọc + bản sao đang giữ (ON_HOLD), kiểm tra đúng người / còn hạn,
// rồi chuyển sang checkout-review với 1 cuốn (dùng lại màn rà soát). Backend POST /loans tự
// chuyển Reservation sang FULFILLED.

import 'package:flutter/material.dart';

import '../../../core/layout/breakpoints.dart';
import '../../../core/network/api_client.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/theme_x.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/danger.dart';
import '../../../core/widgets/qr_scan_page.dart';
import '../../../core/widgets/snackbar.dart';
import '../../circulation/data/circulation_api.dart';
import '../../circulation/models/book_copy.dart';
import '../../circulation/models/checkout_session.dart';
import '../../circulation/models/reader.dart';
import '../../circulation/widgets/status_mapping.dart';
import '../data/reservation_api.dart';
import '../models/reservation.dart';

class ReservationPickupScreen extends StatefulWidget {
  const ReservationPickupScreen({super.key, this.reservation});

  final Reservation? reservation; // có thì hiện thông tin + hạn nhận

  @override
  State<ReservationPickupScreen> createState() => _ReservationPickupScreenState();
}

class _ReservationPickupScreenState extends State<ReservationPickupScreen> {
  final _api = CirculationApi();
  final _readerCtrl = TextEditingController(), _copyCtrl = TextEditingController();
  final _copyFocus = FocusNode();

  Reader? _reader;
  BookCopy? _copy;
  String? _readerError, _copyError;

  bool? get _isHeld => _copy == null ? null : _copy!.status == 'ON_HOLD';
  bool? get _inTime {
    final until = widget.reservation?.readyUntil;
    return until == null ? null : DateTime.now().isBefore(until);
  }

  bool? get _rightReader {
    final res = widget.reservation;
    if (res == null || _reader == null) return null; // không có reservation -> server kiểm (HOLD_OWNER)
    return res.readerId == _reader!.id;
  }

  bool get _canProceed => _reader != null && _reader!.isActive && _isHeld == true && _inTime != false && _rightReader != false;

  @override
  void dispose() {
    _readerCtrl.dispose();
    _copyCtrl.dispose();
    _copyFocus.dispose();
    super.dispose();
  }

  Future<void> _findReader(String code) async {
    try {
      final r = await _api.findReaderByCard(code.trim());
      if (!mounted) return;
      setState(() {
        _reader = r;
        _readerError = null;
      });
      if (!context.isCompact) _copyFocus.requestFocus(); // web: sang ô sách; điện thoại: dùng camera
    } on ApiException catch (e) {
      if (mounted) setState(() => _readerError = e.message);
    }
  }

  Future<void> _findCopy(String code) async {
    try {
      final c = await _api.findCopy(code.trim().toUpperCase());
      if (mounted) {
        setState(() {
          _copy = c;
          _copyError = null;
        });
      }
    } on ApiException catch (e) {
      if (mounted) setState(() => _copyError = e.message);
    }
  }

  void _proceed() {
    Navigator.pushNamed(context, AppRoutes.checkoutReview,
        arguments: CheckoutSession(reader: _reader!, copies: [_copy!]));
  }

  Future<void> _cancelHold(Reservation res) async {
    final ok = await confirmDanger(context,
        title: 'Hủy lượt giữ?',
        message: 'Sách sẽ được giữ cho người kế tiếp trong hàng chờ.',
        actionLabel: 'Hủy lượt giữ');
    if (!ok) return;
    try {
      await ReservationApi().cancel(res.id);
      if (mounted) Navigator.pop(context, true);
    } on ApiException catch (e) {
      if (mounted) showAppSnackBar(context, e.message, isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final res = widget.reservation;
    return Scaffold(
      appBar: AppBar(title: const Text('Nhận sách đặt trước')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (res != null) ...[
            Card(
              margin: EdgeInsets.zero,
              child: ListTile(
                title: Text(res.titleName),
                subtitle: Text('Đặt bởi ${res.readerName} · Đặt trước #${res.id}'),
                trailing: reservationStatusChip(context, res.status),
              ),
            ),
            const SizedBox(height: 16),
          ],
          TextField(
            controller: _readerCtrl,
            autofocus: !context.isCompact,
            textCapitalization: TextCapitalization.characters,
            onSubmitted: _findReader,
            decoration: InputDecoration(
              labelText: 'Mã thẻ người đọc *',
              hintText: 'VD: R10000005',
              prefixIcon: const Icon(Icons.badge_outlined),
              errorText: _readerError,
              suffixIcon: IconButton(
                tooltip: 'Quét thẻ bằng camera',
                icon: const Icon(Icons.qr_code_scanner),
                onPressed: () async {
                  final code = await scanQrOnce(context, title: 'Quét thẻ người đọc');
                  if (code == null) return;
                  _readerCtrl.text = code;
                  await _findReader(code);
                  // tìm thấy người đọc -> mở camera quét sách luôn
                  if (!context.mounted || _reader == null) return;
                  final copy = await scanQrOnce(context, title: 'Quét sách đang giữ');
                  if (copy != null) {
                    _copyCtrl.text = copy;
                    _findCopy(copy);
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _copyCtrl,
            focusNode: _copyFocus,
            textCapitalization: TextCapitalization.characters,
            onSubmitted: _findCopy,
            decoration: InputDecoration(
              labelText: 'Mã bản sao đang giữ *',
              hintText: 'VD: BC000007',
              prefixIcon: const Icon(Icons.qr_code_2),
              errorText: _copyError,
              suffixIcon: IconButton(
                tooltip: 'Quét sách bằng camera',
                icon: const Icon(Icons.qr_code_scanner),
                onPressed: () async {
                  final code = await scanQrOnce(context, title: 'Quét sách đang giữ');
                  if (code != null) {
                    _copyCtrl.text = code;
                    _findCopy(code);
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('KIỂM TRA', style: context.textTheme.labelLarge?.copyWith(color: context.colors.textSecondary)),
          const SizedBox(height: 8),
          _checkRow(_reader?.isActive,
              _reader == null ? 'Người đọc' : 'Người đọc: ${_reader!.displayName}',
              failText: 'Người đọc chưa kích hoạt hoặc đang bị khóa'),
          _checkRow(_rightReader, 'Đúng người đã đặt trước', failText: 'Sách đang giữ cho người đọc khác'),
          _checkRow(_isHeld, 'Bản sao đang được giữ',
              failText: _copy == null ? null : 'Bản sao đang ở trạng thái khác (không phải "Đang giữ")'),
          if (_copy != null && _isHeld == false)
            Padding(
              padding: const EdgeInsets.only(left: 30, bottom: 4),
              child: Align(alignment: Alignment.centerLeft, child: copyStatusChip(context, _copy!.status)),
            ),
          _checkRow(_inTime, res?.readyUntil == null ? 'Còn hạn nhận' : 'Còn hạn nhận (đến ${fmtDateTime(res!.readyUntil!)})',
              failText: 'Lượt giữ đã hết hạn. Đặt lại hoặc mượn trực tiếp nếu sách đã về kệ.'),
          if (res != null && res.status == 'READY')
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(onPressed: () => _cancelHold(res), child: const Text('Hủy lượt giữ')),
            ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            if (!_canProceed)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text('Quét thẻ và bản sao, mọi mục kiểm tra phải đạt',
                    style: TextStyle(fontSize: 13, color: context.colors.textSecondary)),
              ),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _canProceed ? _proceed : null,
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Xác nhận nhận sách và mượn'),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  /// ok: null = chưa kiểm, true = đạt, false = không đạt
  Widget _checkRow(bool? ok, String text, {String? failText}) {
    final (icon, color) = switch (ok) {
      true => (Icons.check_circle, context.colors.success),
      false => (Icons.cancel, context.scheme.error),
      null => (Icons.radio_button_unchecked, context.colors.textSecondary),
    };
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 10),
        Expanded(
          child: Text(ok == false && failText != null ? failText : text,
              style: TextStyle(color: ok == false ? context.scheme.error : null)),
        ),
      ]),
    );
  }
}
