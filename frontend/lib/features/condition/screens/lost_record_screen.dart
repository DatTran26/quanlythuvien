// Màn 11 – Ghi nhận mất (lost-record). Route: /lost/record
// Bài: Hoang/06-lost-handling/01-lost-record.md
//
// Người đọc báo mất sách, nhân viên đối chiếu rồi ghi nhận. Một giao dịch:
// phiếu -> LOST, bản sao -> LOST, phát sinh bồi thường (BR-06: 100% giá sách + phí xử lý).
// Đến từ: return-scan (truyền LoanView), damage-report-detail (truyền mã bản sao) hoặc menu (trống).
// API POST /loans/{id}/lost cần phiếu đang mở: sách mất khi đang trên kệ chưa có API.

import 'package:flutter/material.dart';

import '../../../core/layout/breakpoints.dart';
import '../../../core/layout/content_width.dart';
import '../../../core/network/api_client.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/theme_x.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/danger.dart';
import '../../../core/widgets/info_banner.dart';
import '../../../core/widgets/loading_button.dart';
import '../../../core/widgets/qr_scan_page.dart';
import '../../../core/widgets/snackbar.dart';
import '../../circulation/data/circulation_api.dart';
import '../../circulation/models/book_copy.dart';
import '../../circulation/models/loan_view.dart';
import '../../circulation/widgets/status_mapping.dart';

class LostRecordScreen extends StatefulWidget {
  const LostRecordScreen({super.key, this.args});

  final Object? args; // LoanView hoặc String (mã bản sao) hoặc null

  @override
  State<LostRecordScreen> createState() => _LostRecordScreenState();
}

class _LostRecordScreenState extends State<LostRecordScreen> {
  final _api = CirculationApi();
  final _codeCtrl = TextEditingController();

  LoanView? _loan;
  BookCopy? _copy;
  bool _confirmed = false;
  bool _busy = false, _submitting = false;
  String? _error;
  LoanView? _done; // != null: đã ghi nhận xong

  @override
  void initState() {
    super.initState();
    // Pattern matching theo KIỂU của arguments: một màn nhận 2 kiểu dữ liệu từ 2 màn khác nhau
    switch (widget.args) {
      case LoanView l:
        _codeCtrl.text = l.copyCode;
        _lookup(l.copyCode, knownLoan: l);
      case String code:
        _codeCtrl.text = code;
        _lookup(code);
      default:
        break; // mở trống, chờ quét
    }
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  Future<void> _lookup(String raw, {LoanView? knownLoan}) async {
    final code = raw.trim().toUpperCase();
    if (code.isEmpty) return;
    setState(() {
      _busy = true;
      _error = null;
      _loan = null;
      _copy = null;
      _confirmed = false;
    });
    try {
      final copy = await _api.findCopy(code);
      final loan = knownLoan ?? await _api.findOpenLoanByCopy(code); // G3
      if (!mounted) return;
      setState(() {
        _copy = copy;
        _loan = loan;
        if (copy.status == 'LOST') {
          _error = 'Bản sao này đã được ghi nhận mất trước đó.';
        } else if (loan == null) {
          _error = 'Chỉ ghi nhận mất cho sách đang được mượn. Bản sao hiện ở trạng thái khác.';
        }
      });
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _submit() async {
    if (_loan == null || !_confirmed || _submitting) return;
    // Lớp xác nhận thứ 2: thao tác không hoàn tác
    final ok = await confirmDanger(
      context,
      title: 'Ghi nhận mất sách?',
      message: 'Phiếu #${_loan!.id} sẽ đóng vĩnh viễn, bản sao ${_loan!.copyCode} chuyển trạng thái "Mất" '
          'và người đọc phát sinh nghĩa vụ bồi thường. Không thể hoàn tác.',
      actionLabel: 'Ghi nhận mất 1 bản sao',
    );
    if (!ok || !mounted) return;

    setState(() => _submitting = true);
    try {
      final result = await _api.markLost(_loan!.id);
      if (mounted) setState(() => _done = result);
    } on ApiException catch (e) {
      if (!mounted) return;
      showAppSnackBar(context, e.code == 'LOAN_CLOSED' ? 'Phiếu đã đóng trước đó, không ghi nhận lặp.' : e.message,
          isError: true);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final canSubmit = _loan != null && _error == null && _confirmed;
    return Scaffold(
      appBar: AppBar(title: const Text('Ghi nhận mất sách')),
      body: ContentWidth(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (_done == null)
              TextField(
                controller: _codeCtrl,
                autofocus: widget.args == null && !context.isCompact,
                textCapitalization: TextCapitalization.characters,
                onSubmitted: _lookup,
                decoration: InputDecoration(
                  labelText: 'Mã bản sao',
                  prefixIcon: const Icon(Icons.qr_code_2),
                  errorText: _error,
                  errorMaxLines: 3,
                  suffixIcon: _busy
                      ? const Padding(
                          padding: EdgeInsets.all(14),
                          child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                        )
                      : IconButton(
                          tooltip: 'Quét bằng camera',
                          icon: const Icon(Icons.qr_code_scanner),
                          onPressed: () async {
                            final code = await scanQrOnce(context, title: 'Quét sách bị mất');
                            if (code == null) return;
                            _codeCtrl.text = code;
                            _lookup(code);
                          },
                        ),
                ),
              ),
            if (_loan != null && _copy != null) ...[
              const SizedBox(height: 12),
              Card(
                margin: EdgeInsets.zero,
                child: ListTile(
                  leading: Icon(Icons.menu_book, color: context.scheme.primary),
                  title: Text(_loan!.titleName),
                  subtitle: Text('${_loan!.copyCode} · Phiếu #${_loan!.id}\n'
                      'Người đọc #${_loan!.readerId} · Hạn ${fmtDate(_loan!.dueAt)}'),
                  isThreeLine: true,
                  trailing: loanStatusChip(context, (_done ?? _loan!).status),
                ),
              ),
              const SizedBox(height: 12),
              _compensation(_copy!.priceVnd),
            ],
            if (_loan != null && _done == null && _error == null) ...[
              const SizedBox(height: 8),
              // "Cổng an toàn": buộc nhân viên xác nhận đã đối chiếu -> giảm ghi nhầm
              CheckboxListTile(
                value: _confirmed,
                onChanged: (v) => setState(() => _confirmed = v ?? false),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                title: const Text('Đã đối chiếu với người đọc và xác nhận sách bị mất'),
              ),
            ],
            if (_done != null) ...[
              const SizedBox(height: 12),
              InfoBanner(
                kind: BannerKind.success,
                message: 'Đã ghi nhận mất. Phiếu #${_done!.id} đã đóng, bản sao chuyển trạng thái "Mất".',
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: ContentWidth(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: _done != null
                ? Row(children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.popUntil(context, ModalRoute.withName(AppRoutes.circulationDesk)),
                        child: const Text('Về quầy'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => Navigator.pushNamed(context, AppRoutes.finePayment, arguments: _done!.readerId),
                        child: const Text('Thu bồi thường'),
                      ),
                    ),
                  ])
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!canSubmit) // nút tắt -> luôn kèm 1 dòng lý do (spec 6.3)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text(
                            _loan == null || _error != null
                                ? 'Quét mã sách đang được mượn'
                                : 'Tích xác nhận đối chiếu để tiếp tục',
                            style: TextStyle(fontSize: 13, color: context.colors.textSecondary),
                          ),
                        ),
                      SizedBox(
                        width: double.infinity,
                        child: LoadingButton(
                          style: dangerButtonStyle(context),
                          icon: Icons.search_off,
                          label: 'Ghi nhận mất',
                          loadingLabel: 'Đang ghi nhận…',
                          loading: _submitting,
                          onPressed: canSubmit ? _submit : null,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  /// Cho nhân viên thấy hậu quả tài chính TRƯỚC khi bấm.
  Widget _compensation(int price) {
    Widget row(String k, String v, {bool strong = false}) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(children: [
            Expanded(child: Text(k)),
            Text(v,
                style: TextStyle(
                  fontWeight: strong ? FontWeight.w700 : FontWeight.w500,
                  color: strong ? context.scheme.error : null,
                )),
          ]),
        );
    return InfoBanner(
      kind: BannerKind.warning,
      title: 'Nghĩa vụ bồi thường',
      message: 'Giá trị đề xuất, chờ chốt chính sách (OQ-04).',
      action: Column(children: [
        row('Giá sách', fmtMoney(price)),
        row('Phí xử lý', 'Chưa chốt'),
        const Divider(height: 12),
        row('Dự kiến', '≥ ${fmtMoney(price)}', strong: true),
      ]),
    );
  }
}
