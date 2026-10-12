// Màn 2 – Quét phiên mượn (checkout-scan). Route: /checkout/scan
// Bài: Hoang/02-checkout/02-checkout-scan.md
//
// Quét thẻ người đọc (D1) rồi quét từng cuốn sách vào giỏ (D2), kiểm tra ngay khi quét.
// Lỗ hổng G2: chưa biết số cuốn đang mượn / nợ phạt ở bước này, chỉ biết khi xác nhận ở màn sau.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // HapticFeedback, phím tắt
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/layout/breakpoints.dart';
import '../../../core/network/api_client.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/theme_x.dart';
import '../../../core/widgets/info_banner.dart';
import '../../../core/widgets/qr_scan_page.dart';
import '../../../core/widgets/snackbar.dart';
import '../../../core/widgets/status_chip.dart';
import '../data/circulation_api.dart';
import '../data/error_text.dart';
import '../models/book_copy.dart';
import '../models/checkout_session.dart';
import '../models/reader.dart';
import '../widgets/status_mapping.dart';

class CheckoutScanScreen extends StatefulWidget {
  const CheckoutScanScreen({super.key});

  @override
  State<CheckoutScanScreen> createState() => _CheckoutScanScreenState();
}

class _CheckoutScanScreenState extends State<CheckoutScanScreen> {
  final _api = CirculationApi();

  // Ô nhập
  final _readerCtrl = TextEditingController();
  final _copyCtrl = TextEditingController();
  final _readerFocus = FocusNode();
  final _copyFocus = FocusNode();

  // Dữ liệu
  Reader? _reader;
  final List<BookCopy> _cart = [];

  // Trạng thái giao diện
  bool _busy = false; // đang gọi API
  String? _readerError; // lỗi dưới ô thẻ
  String? _copyError; // lỗi dưới ô sách
  (String, String?)? _blocked; // (lý do, cách khắc phục) khi người đọc bị chặn

  bool get _readerOk => _reader != null && _blocked == null;
  static const _maxLoans = 5; // DEC-SF-10; sau này lấy từ GET /policy

  @override
  void initState() {
    super.initState();
    // Khôi phục giỏ dở dang sau khi khung hình đầu vẽ xong (cần context để hiện snackbar)
    WidgetsBinding.instance.addPostFrameCallback((_) => _restoreDraft());
  }

  @override
  void dispose() {
    // Controller và FocusNode giữ tài nguyên -> PHẢI hủy khi đóng màn
    _readerCtrl.dispose();
    _copyCtrl.dispose();
    _readerFocus.dispose();
    _copyFocus.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------ D1: người đọc

  Future<void> _lookupReader(String raw) async {
    final code = raw.trim();
    if (code.isEmpty) {
      setState(() => _readerError = 'Nhập hoặc quét mã thẻ người đọc');
      return;
    }
    setState(() {
      _busy = true;
      _readerError = null;
      _blocked = null;
    });
    try {
      final reader = await _api.findReaderByCard(code);
      if (!mounted) return;
      setState(() {
        _reader = reader;
        if (!reader.isActive) {
          _blocked = (
            'Người đọc chưa được kích hoạt hoặc đang bị khóa.',
            'Mở hồ sơ người đọc để kích hoạt/mở khóa, hoặc đổi người đọc khác.'
          );
        }
      });
      if (reader.isActive) {
        HapticFeedback.lightImpact();
        // Web: ô sách vừa bật -> focus sau khi khung hình mới vẽ xong.
        // Điện thoại: không focus (tránh bật bàn phím), nhân viên dùng camera.
        if (!context.isCompact) {
          WidgetsBinding.instance.addPostFrameCallback((_) => _copyFocus.requestFocus());
        }
      } else {
        HapticFeedback.heavyImpact();
      }
    } on ApiException catch (e) {
      if (!mounted) return;
      HapticFeedback.heavyImpact();
      setState(() => _readerError = e.code == 'NOT_FOUND'
          ? 'Không tìm thấy người đọc với mã này. Quét lại hoặc nhập tay.'
          : describeError(e).$1);
      // Bôi đen mã sai để quét lại là đè luôn, khỏi phải xóa
      _readerCtrl.selection = TextSelection(baseOffset: 0, extentOffset: _readerCtrl.text.length);
      if (!context.isCompact) _readerFocus.requestFocus();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _changeReader() {
    setState(() {
      _reader = null;
      _blocked = null;
      _cart.clear(); // giỏ gắn với người đọc -> đổi người thì làm lại
      _readerCtrl.clear();
    });
    _saveDraft();
    // Ô thẻ vừa được bật lại ở lần vẽ tới -> đợi vẽ xong mới focus được
    WidgetsBinding.instance.addPostFrameCallback((_) => _readerFocus.requestFocus());
  }

  // ------------------------------------------------------------ D2: sách

  /// fromCamera = true: không đụng tới ô nhập, không hiện snackbar (màn camera tự hiện kết quả).
  Future<ScanFeedback> _addCopy(String raw, {bool fromCamera = false}) async {
    final code = raw.trim().toUpperCase();
    if (code.isEmpty) return const ScanFeedback.error('Mã trống');

    // Kiểm tra phía client TRƯỚC khi gọi API (nhanh, đỡ tốn mạng)
    if (_cart.any((c) => c.code == code)) {
      return _rejectCopy('Cuốn này đã có trong giỏ.', fromCamera);
    }
    if (_cart.length >= _maxLoans) {
      return _rejectCopy('Giỏ đã đủ $_maxLoans cuốn, giới hạn tối đa mỗi người đọc.', fromCamera);
    }

    setState(() {
      _busy = true;
      _copyError = null;
    });
    try {
      final copy = await _api.findCopy(code);
      if (!mounted) return const ScanFeedback.error('Màn hình đã đóng');

      final problem = _copyProblem(copy);
      if (problem != null) return _rejectCopy(problem, fromCamera);

      setState(() => _cart.add(copy));
      _saveDraft();
      if (!fromCamera) {
        _copyCtrl.clear();
        HapticFeedback.lightImpact();
        showAppSnackBar(
          context,
          'Đã thêm "${copy.titleName}"',
          action: SnackBarAction(label: 'Hoàn tác', onPressed: () => _removeCopy(copy)),
        );
      }
      return ScanFeedback.ok('Đã thêm "${copy.titleName}" (${_cart.length}/$_maxLoans)');
    } on ApiException catch (e) {
      if (!mounted) return ScanFeedback.error(e.message);
      return _rejectCopy(
          e.code == 'NOT_FOUND'
              ? 'Không tìm thấy bản sao với mã này. Kiểm tra tem QR hoặc nhập tay.'
              : describeError(e).$1,
          fromCamera);
    } finally {
      if (mounted) {
        setState(() => _busy = false);
        // Chỉ đưa con trỏ về ô sách khi đang dùng bàn phím, không bật bàn phím ảo đè lên camera
        if (!fromCamera && !context.isCompact) _copyFocus.requestFocus();
      }
    }
  }

  /// Trả về câu lỗi nếu bản sao KHÔNG được thêm vào giỏ, null nếu ổn.
  String? _copyProblem(BookCopy copy) {
    if (_cart.any((c) => c.titleId == copy.titleId)) {
      return 'Đã có một cuốn "${copy.titleName}" trong giỏ. Mỗi đầu sách chỉ mượn 1 cuốn.';
    }
    if (!copy.isLoanable) return 'Cuốn này chỉ đọc tại chỗ, không cho mượn về.';
    return switch (copy.status) {
      'AVAILABLE' => null,
      'ON_HOLD' => null, // đang giữ: server sẽ kiểm tra có đúng người đặt không (HOLD_OWNER)
      'ON_LOAN' => 'Cuốn này đang được người khác mượn. Kiểm tra lại sách trên tay.',
      'PENDING_REVIEW' => 'Cuốn này đang chờ duyệt hư hỏng, không cho mượn.',
      'IN_REPAIR' => 'Cuốn này đang sửa chữa, không cho mượn.',
      'LOST' => 'Cuốn này đã ghi nhận mất. Nếu tìm thấy, xử lý ở mục Mất/Tìm lại.',
      'DISPOSED' => 'Cuốn này đã thanh lý.',
      _ => 'Trạng thái "${copy.status}" không cho mượn.',
    };
  }

  ScanFeedback _rejectCopy(String message, bool fromCamera) {
    if (!fromCamera) {
      HapticFeedback.heavyImpact();
      setState(() => _copyError = message);
      _copyCtrl.selection = TextSelection(baseOffset: 0, extentOffset: _copyCtrl.text.length);
    }
    return ScanFeedback.error(message); // màn camera hiện ✗ + câu này
  }

  void _removeCopy(BookCopy copy) {
    setState(() => _cart.removeWhere((c) => c.code == copy.code));
    _saveDraft();
  }

  // ------------------------------------------------------------ camera (bài 0.5)

  Future<void> _scanReaderByCamera() async {
    final code = await scanQrOnce(context, title: 'Quét thẻ người đọc');
    if (code == null || !mounted) return;
    _readerCtrl.text = code;
    await _lookupReader(code);
    // Tìm thấy người đọc hợp lệ -> mở luôn camera quét sách, đỡ 1 lần bấm
    if (mounted && _readerOk) _scanBooksByCamera();
  }

  Future<void> _scanBooksByCamera() async {
    await scanQrContinuous(
      context,
      title: 'Quét sách vào giỏ',
      onCode: (code) => _addCopy(code, fromCamera: true),
    );
    // Đóng camera xong, giỏ đã cập nhật sẵn nhờ setState trong _addCopy
  }

  // ------------------------------------------------------------ điều hướng

  void _goReview() {
    if (_cart.isEmpty || !_readerOk) return;
    Navigator.pushNamed(
      context,
      AppRoutes.checkoutReview,
      arguments: CheckoutSession(reader: _reader!, copies: List.of(_cart)), // bản sao danh sách
    );
  }

  Future<void> _confirmLeave() async {
    final leave = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hủy phiên mượn?'),
        content: Text('Giỏ đang có ${_cart.length} cuốn chưa ghi phiếu. Thoát sẽ bỏ giỏ này.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Ở lại')),
          OutlinedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Bỏ giỏ và thoát')),
        ],
      ),
    );
    if (leave == true && mounted) {
      await _clearDraft();
      setState(_cart.clear); // giỏ rỗng -> PopScope cho thoát
      if (mounted) Navigator.pop(context);
    }
  }

  // ------------------------------------------------------------ lưu nháp giỏ

  static const _draftKey = 'checkout_draft';

  Future<void> _saveDraft() async {
    final prefs = await SharedPreferences.getInstance();
    if (_reader == null || _cart.isEmpty) {
      await prefs.remove(_draftKey);
      return;
    }
    // Chỉ lưu MÃ, không lưu cả object: khôi phục thì tra lại API vì trạng thái sách có thể đã đổi
    await prefs.setString(
        _draftKey,
        jsonEncode({
          'readerCard': _readerCtrl.text.trim(),
          'copies': _cart.map((c) => c.code).toList(),
        }));
  }

  Future<void> _clearDraft() async => (await SharedPreferences.getInstance()).remove(_draftKey);

  Future<void> _restoreDraft() async {
    final raw = (await SharedPreferences.getInstance()).getString(_draftKey);
    if (raw == null || !mounted) return;
    final draft = jsonDecode(raw) as Map<String, dynamic>;
    final codes = (draft['copies'] as List).cast<String>();
    showAppSnackBar(
      context,
      'Có giỏ mượn dở dang (${codes.length} cuốn).',
      action: SnackBarAction(
        label: 'Khôi phục',
        onPressed: () async {
          _readerCtrl.text = draft['readerCard'] as String;
          await _lookupReader(_readerCtrl.text);
          for (final code in codes) {
            await _addCopy(code); // tra lại từng cuốn -> trạng thái MỚI NHẤT
          }
        },
      ),
    );
  }

  // ------------------------------------------------------------ giao diện

  @override
  Widget build(BuildContext context) {
    final body = context.isExpanded
        // Máy tính >= 1024px: trái là người đọc + ô quét, phải là giỏ (bài 0.6)
        ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: ListView(padding: const EdgeInsets.all(24), children: _scanSection())),
            VerticalDivider(width: 1, color: context.colors.divider),
            Expanded(child: ListView(padding: const EdgeInsets.all(24), children: _cartSection())),
          ])
        : ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [..._scanSection(), const SizedBox(height: 12), ..._cartSection()],
          );

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.f2): () =>
            _reader == null ? _scanReaderByCamera() : (_readerOk ? _scanBooksByCamera() : null),
        const SingleActivator(LogicalKeyboardKey.enter, control: true): _goReview,
      },
      child: PopScope(
        canPop: _cart.isEmpty, // giỏ rỗng thì cho thoát luôn
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) _confirmLeave();
        },
        child: Scaffold(
          appBar: AppBar(title: const Text('Quét phiên mượn')),
          body: Stack(
            children: [
              body,
              if (_busy) const Positioned(top: 0, left: 0, right: 0, child: LinearProgressIndicator()),
            ],
          ),
          bottomNavigationBar: _bottomBar(),
        ),
      ),
    );
  }

  List<Widget> _scanSection() => [
        _sectionTitle('① Người đọc'),
        const SizedBox(height: 8),
        TextField(
          controller: _readerCtrl,
          focusNode: _readerFocus,
          // Web: con trỏ sẵn trong ô để gõ. Điện thoại: KHÔNG autofocus (tránh bật bàn phím che màn).
          autofocus: !context.isCompact,
          enabled: _reader == null, // đã chọn thì khóa, muốn đổi bấm "Đổi người đọc"
          textCapitalization: TextCapitalization.characters,
          textInputAction: TextInputAction.search,
          onSubmitted: _lookupReader, // Enter / máy quét gửi Enter
          decoration: InputDecoration(
            labelText: 'Mã thẻ người đọc *',
            hintText: 'VD: R10000001',
            prefixIcon: const Icon(Icons.badge_outlined),
            errorText: _readerError,
            errorMaxLines: 2,
            suffixIcon: IconButton(
              tooltip: 'Quét bằng camera (F2)',
              icon: const Icon(Icons.qr_code_scanner),
              onPressed: _reader == null ? _scanReaderByCamera : null,
            ),
          ),
        ),
        if (_reader == null) ...[
          const SizedBox(height: 8),
          FilledButton.tonalIcon(
            style: AppButtonStyles.tonal(context), // Tonal: hành động phụ cần nổi bật (spec 6.2)
            onPressed: _scanReaderByCamera,
            icon: const Icon(Icons.photo_camera_outlined),
            label: const Text('Quét thẻ bằng camera'),
          ),
        ],
        if (_reader != null) ...[
          const SizedBox(height: 12),
          _ReaderCard(reader: _reader!, eligible: _blocked == null, onChange: _changeReader),
        ],
        if (_blocked != null) ...[
          const SizedBox(height: 12),
          InfoBanner(
            kind: BannerKind.error,
            title: 'Không thể mượn',
            message: '${_blocked!.$1}\n${_blocked!.$2 ?? ''}',
          ),
        ],
        const SizedBox(height: 24),
        _sectionTitle('② Sách (${_cart.length}/$_maxLoans cuốn)'),
        const SizedBox(height: 8),
        TextField(
          controller: _copyCtrl,
          focusNode: _copyFocus,
          enabled: _readerOk,
          textCapitalization: TextCapitalization.characters,
          textInputAction: TextInputAction.done,
          onSubmitted: _addCopy,
          decoration: InputDecoration(
            labelText: 'Mã bản sao *',
            hintText: _readerOk ? 'Quét liên tục, mỗi lần 1 cuốn' : 'Quét thẻ người đọc trước',
            prefixIcon: const Icon(Icons.qr_code_2),
            errorText: _copyError,
            errorMaxLines: 3,
            suffixIcon: IconButton(
              tooltip: 'Quét bằng camera (F2)',
              icon: const Icon(Icons.qr_code_scanner),
              onPressed: _readerOk ? _scanBooksByCamera : null,
            ),
          ),
        ),
        if (_readerOk) ...[
          const SizedBox(height: 8),
          FilledButton.tonalIcon(
            style: AppButtonStyles.tonal(context), // đúng ví dụ "Quét thêm sách" trong color-system 6.2
            onPressed: _cart.length < _maxLoans ? _scanBooksByCamera : null,
            icon: const Icon(Icons.photo_camera_outlined),
            label: Text(_cart.isEmpty ? 'Quét sách bằng camera' : 'Quét thêm sách'),
          ),
        ],
      ];

  List<Widget> _cartSection() => [
        if (context.isExpanded) ...[
          _sectionTitle('Giỏ (${_cart.length}/$_maxLoans cuốn)'),
          const SizedBox(height: 8),
        ],
        if (_cart.isEmpty) _emptyCart() else for (final copy in _cart) _dismissibleItem(copy),
      ];

  Widget _dismissibleItem(BookCopy copy) => Dismissible(
        key: ValueKey(copy.code), // key duy nhất cho mỗi dòng
        direction: DismissDirection.endToStart,
        background: _dismissBackground(),
        onDismissed: (_) {
          _removeCopy(copy);
          showAppSnackBar(context, 'Đã bỏ "${copy.titleName}" khỏi giỏ',
              action: SnackBarAction(
                  label: 'Hoàn tác',
                  onPressed: () {
                    setState(() => _cart.add(copy));
                    _saveDraft();
                  }));
        },
        child: _CartItem(copy: copy, onRemove: () => _removeCopy(copy)),
      );

  Widget _sectionTitle(String text) => Text(
        text.toUpperCase(),
        style: context.textTheme.labelLarge?.copyWith(
          color: context.colors.textSecondary,
          letterSpacing: 0.6,
        ),
      );

  Widget _emptyCart() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            Icon(Icons.shopping_basket_outlined, size: 40, color: context.colors.textSecondary),
            const SizedBox(height: 8),
            Text('Giỏ trống. Quét mã trên tem sách để thêm.',
                textAlign: TextAlign.center, style: TextStyle(color: context.colors.textSecondary)),
          ],
        ),
      );

  Widget _dismissBackground() => Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: context.scheme.errorContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.delete_outline, color: context.scheme.onErrorContainer),
      );

  Widget _bottomBar() {
    final canReview = _readerOk && _cart.isNotEmpty;
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        decoration: BoxDecoration(
          color: context.scheme.surface,
          border: Border(top: BorderSide(color: context.colors.divider)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!canReview) // nút tắt -> luôn kèm 1 dòng lý do (spec 6.3)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  _reader == null
                      ? 'Quét thẻ người đọc để bắt đầu'
                      : !_readerOk
                          ? 'Người đọc chưa đủ điều kiện mượn'
                          : 'Quét ít nhất 1 cuốn sách',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 13),
                ),
              ),
            Row(
              children: [
                TextButton(
                  onPressed: () => _cart.isEmpty ? Navigator.pop(context) : _confirmLeave(),
                  child: const Text('Hủy phiên'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: canReview ? _goReview : null,
                    icon: const Icon(Icons.arrow_forward),
                    label: Text('Rà soát ${_cart.length} cuốn'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ReaderCard extends StatelessWidget {
  const _ReaderCard({required this.reader, required this.eligible, required this.onChange});

  final Reader reader;
  final bool eligible;
  final VoidCallback onChange;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: context.scheme.primaryContainer,
                  foregroundColor: context.scheme.onPrimaryContainer,
                  child: Text(reader.displayName.characters.first),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(reader.displayName, style: context.textTheme.titleMedium),
                      Text(reader.email, style: TextStyle(color: c.textSecondary), overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                StatusChip(
                  label: eligible ? 'Đủ điều kiện' : 'Bị chặn',
                  pair: eligible ? c.statusAvailable : c.statusDanger,
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onChange,
                icon: const Icon(Icons.swap_horiz),
                label: const Text('Đổi người đọc'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartItem extends StatelessWidget {
  const _CartItem({required this.copy, required this.onRemove});

  final BookCopy copy;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(Icons.menu_book, color: context.scheme.primary),
        title: Text(copy.titleName, maxLines: 2, overflow: TextOverflow.ellipsis),
        // Chip để dưới tên sách (Wrap tự xuống dòng), phần bên phải chỉ còn nút ✕ -> không tràn ở 375px
        subtitle: Wrap(
          spacing: 8,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text('${copy.code}${copy.shelf != null ? ' · Kệ ${copy.shelf}' : ''}'),
            copyStatusChip(context, copy.status),
          ],
        ),
        // Nút ✕ riêng: vuốt để xóa không dùng được bằng chuột (bài 0.6)
        trailing: IconButton(
          tooltip: 'Bỏ khỏi giỏ',
          icon: const Icon(Icons.close),
          onPressed: onRemove,
        ),
      ),
    );
  }
}
