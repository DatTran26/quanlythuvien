// Màn 3 – Rà soát mượn (checkout-review). Route: /checkout/review
// Bài: Hoang/02-checkout/03-checkout-review.md
//
// Xem lại giỏ, bấm "Xác nhận mượn", thành công thì hiện biên nhận ngay trên màn (FR-checkout-003).
// Lỗ hổng G1: chưa có POST /loans/batch nên gọi POST /loans từng cuốn, dừng ở lỗi đầu tiên
// và báo rõ cuốn nào đã mượn, cuốn nào chưa. Khi có batch chỉ sửa hàm _submit.

import 'package:flutter/material.dart';

import '../../../core/auth/session.dart';
import '../../../core/network/api_client.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/theme_x.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/info_banner.dart';
import '../../../core/widgets/loading_button.dart';
import '../data/circulation_api.dart';
import '../data/error_text.dart';
import '../models/book_copy.dart';
import '../models/checkout_session.dart';
import '../models/loan_view.dart';

class CheckoutReviewScreen extends StatefulWidget {
  const CheckoutReviewScreen({super.key, required this.session});

  final CheckoutSession session; // nhận từ checkout-scan qua arguments

  @override
  State<CheckoutReviewScreen> createState() => _CheckoutReviewScreenState();
}

class _CheckoutReviewScreenState extends State<CheckoutReviewScreen> {
  final _api = CirculationApi();
  late List<BookCopy> _copies = List.of(widget.session.copies);

  bool _submitting = false;
  (String, String?)? _error; // lỗi chặn mượn
  List<LoanView>? _receipt; // != null nghĩa là đã xong -> hiện biên nhận
  DateTime? _receiptTime;

  static const _loanDays = 14; // DEC-SF-10, sau này lấy từ /policy
  DateTime get _expectedDue => DateTime.now().add(const Duration(days: _loanDays));
  bool get _done => _receipt != null;

  Future<void> _submit() async {
    if (_submitting || _done) return; // chốt chặn bấm lặp
    setState(() {
      _submitting = true;
      _error = null;
    });

    final created = <LoanView>[];
    try {
      // TẠM THỜI (G1): mượn từng cuốn. Khi có /loans/batch thay bằng 1 lời gọi.
      for (final copy in _copies) {
        final loan = await _api.checkout(readerId: widget.session.reader.id, copyCode: copy.code);
        created.add(loan);
      }
      if (!mounted) return;
      setState(() {
        _receipt = created;
        _receiptTime = DateTime.now();
      });
    } on ApiException catch (e) {
      if (!mounted) return;

      // Hai quầy tranh cùng bản sao -> màn xung đột
      if (e.code == 'STALE_COPY' || e.code == 'CONFLICT') {
        final rest = _copies.skip(created.length).toList();
        if (created.isNotEmpty) setState(() => _copies = rest); // cuốn đã ghi thì bỏ khỏi danh sách
        final reload = await Navigator.pushNamed(context, AppRoutes.checkoutConflict, arguments: rest);
        if (reload == true) await _reloadCopies();
        return;
      }

      final (msg, fix) = describeError(e);
      setState(() {
        if (created.isEmpty) {
          _error = (msg, fix);
        } else {
          // Một phần đã ghi (chỉ xảy ra do G1) -> nói thật rõ cho nhân viên
          _error = (
            'Đã mượn ${created.length}/${_copies.length} cuốn. '
                'Cuốn "${_copies[created.length].titleName}" bị từ chối: $msg',
            'Các cuốn đã mượn vẫn có hiệu lực. ${fix ?? ''}'
          );
          _copies = _copies.skip(created.length).toList(); // chỉ giữ lại cuốn chưa mượn
        }
      });
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _reloadCopies() async {
    final fresh = <BookCopy>[];
    for (final c in _copies) {
      fresh.add(await _api.findCopy(c.code));
    }
    if (!mounted) return;
    setState(() => _copies = fresh.where((c) => c.status == 'AVAILABLE' || c.status == 'ON_HOLD').toList());
  }

  void _newTransaction() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.circulationDesk,
      (route) => route.settings.name == AppRoutes.dashboard, // giữ dashboard ở dưới cùng
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_submitting && !_done,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_done ? 'Biên nhận mượn' : 'Rà soát mượn'),
          automaticallyImplyLeading: !_done,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: _done ? _receiptView() : _reviewView(),
        ),
        bottomNavigationBar: _bottomBar(),
      ),
    );
  }

  List<Widget> _reviewView() {
    final reader = widget.session.reader;
    return [
      Card(
        margin: EdgeInsets.zero,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: context.scheme.primaryContainer,
            foregroundColor: context.scheme.onPrimaryContainer,
            child: const Icon(Icons.person),
          ),
          title: Text(reader.displayName, style: context.textTheme.titleMedium),
          subtitle: Text('${_copies.length} cuốn · Hạn trả dự kiến ${fmtDate(_expectedDue)}'),
        ),
      ),
      const SizedBox(height: 20),
      Text('DANH SÁCH SÁCH', style: context.textTheme.labelLarge?.copyWith(color: context.colors.textSecondary)),
      const SizedBox(height: 8),
      Card(
        margin: EdgeInsets.zero,
        child: Column(
          children: [
            for (var i = 0; i < _copies.length; i++) ...[
              if (i > 0) const Divider(height: 1, indent: 16, endIndent: 16),
              _bookRow(i + 1, _copies[i].titleName, _copies[i].code, _expectedDue),
            ],
          ],
        ),
      ),
      const SizedBox(height: 16),
      if (_error != null)
        InfoBanner(
          kind: BannerKind.error,
          title: 'Chưa thể mượn',
          message: '${_error!.$1}${_error!.$2 != null ? '\n${_error!.$2}' : ''}',
        )
      else
        const InfoBanner(
          kind: BannerKind.info,
          message: 'Hạn mượn 14 ngày. Kiểm tra sách trên tay khớp với danh sách trước khi xác nhận.',
        ),
    ];
  }

  Widget _bookRow(int index, String title, String code, DateTime due) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: context.scheme.primaryContainer,
            child: Text('$index', style: TextStyle(fontSize: 13, color: context.scheme.onPrimaryContainer)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.textTheme.bodyLarge),
                Text(code, style: TextStyle(color: context.colors.textSecondary)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Hạn', style: TextStyle(fontSize: 12, color: context.colors.textSecondary)),
              Text(fmtDate(due), style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _receiptView() {
    final r = widget.session.reader;
    return [
      const InfoBanner(
        kind: BannerKind.success,
        message: 'Đã tạo phiếu mượn. Hạn trả được hiển thị trong danh sách sách đang mượn.',
      ),
      const SizedBox(height: 16),
      Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Text('THƯ VIỆN', style: context.textTheme.titleMedium)),
              Center(
                child: Text('BIÊN NHẬN MƯỢN SÁCH',
                    style: TextStyle(color: context.colors.textSecondary, letterSpacing: 1)),
              ),
              const SizedBox(height: 12),
              _kv('Ngày giờ', fmtDateTime(_receiptTime!)),
              _kv('Người đọc', r.displayName),
              _kv('Email', r.email),
              const Divider(height: 24),
              for (final loan in _receipt!) _kv('#${loan.id}  ${loan.titleName}', fmtDate(loan.dueAt)),
              const Divider(height: 24),
              _kv('Nhân viên', AppSession.displayName), // sau lấy từ /me (TV1)
            ],
          ),
        ),
      ),
    ];
  }

  Widget _kv(String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Text(k)),
            const SizedBox(width: 12),
            // Flexible: giá trị dài (email) tự xuống dòng thay vì tràn
            Flexible(child: Text(v, textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.w600))),
          ],
        ),
      );

  Widget _bottomBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_done) // nút tắt phải có lý do (spec 6.3)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text('In biên nhận: chưa cấu hình máy in',
                    style: TextStyle(fontSize: 13, color: context.colors.textSecondary)),
              ),
            Row(
              children: _done
                  ? [
                      const Expanded(
                        child: OutlinedButton(
                          onPressed: null, // OQ-checkout-001: chưa chốt máy in
                          child: Text('In biên nhận'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: FilledButton(onPressed: _newTransaction, child: const Text('Giao dịch mới'))),
                    ]
                  : [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _submitting ? null : () => Navigator.pop(context),
                          child: const Text('Quay lại quét'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2, // nút chính rộng gấp đôi
                        child: LoadingButton(
                          label: 'Xác nhận mượn',
                          loadingLabel: 'Đang ghi phiếu…',
                          loading: _submitting,
                          onPressed: _copies.isEmpty ? null : _submit,
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
