// Màn 5 – Quét trả sách (return-scan). Route: /return/scan
// Bài: Hoang/03-return-handling/01-return-scan.md
//
// Quét mã sách -> tìm phiếu mượn đang mở -> chọn tình trạng (bình thường / hư hỏng) -> Ghi nhận trả.
// Người đọc bị khóa VẪN trả được: không kiểm tra điều kiện người đọc ở đây.
// Lỗ hổng G3: tìm phiếu theo mã sách dùng GET /loans/open?copyCode= (backend thật chưa có).

import 'package:flutter/material.dart';

import '../../../core/layout/breakpoints.dart';
import '../../../core/layout/content_width.dart';
import '../../../core/network/api_client.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/theme_x.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/loading_button.dart';
import '../../../core/widgets/qr_scan_page.dart';
import '../../../core/widgets/snackbar.dart';
import '../../fine/data/fine_api.dart';
import '../data/circulation_api.dart';
import '../data/error_text.dart';
import '../models/loan_view.dart';
import '../models/return_outcome.dart';
import '../widgets/status_mapping.dart';

class ReturnScanScreen extends StatefulWidget {
  const ReturnScanScreen({super.key, this.openCamera = false});

  /// true: mở camera ngay khi vào màn (đến từ nút "Quét cuốn tiếp" trên điện thoại).
  final bool openCamera;

  @override
  State<ReturnScanScreen> createState() => _ReturnScanScreenState();
}

class _ReturnScanScreenState extends State<ReturnScanScreen> {
  final _api = CirculationApi();
  final _formKey = GlobalKey<FormState>();
  final _codeCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  final _codeFocus = FocusNode();

  LoanView? _loan;
  bool _damaged = false;
  String? _severity; // LIGHT / MEDIUM / HEAVY
  bool _busy = false;
  bool _submitting = false;
  String? _codeError;

  int get _overdueDays {
    if (_loan == null) return 0;
    final d = DateTime.now().difference(_loan!.dueAt).inDays;
    return d > 0 ? d : 0;
  }

  @override
  void initState() {
    super.initState();
    if (widget.openCamera) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && context.isCompact) _scanByCamera();
      });
    }
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _noteCtrl.dispose();
    _codeFocus.dispose();
    super.dispose();
  }

  Future<void> _lookup(String raw) async {
    final code = raw.trim().toUpperCase();
    if (code.isEmpty) return;
    setState(() {
      _busy = true;
      _codeError = null;
      _loan = null;
      _damaged = false;
      _severity = null;
      _noteCtrl.clear();
    });
    try {
      final loan = await _api.findOpenLoanByCopy(code);
      if (!mounted) return;
      if (loan == null) {
        setState(() => _codeError =
            'Không tìm thấy phiếu mượn đang mở cho cuốn này. Kiểm tra tem QR hoặc lịch sử bản sao.');
        _codeFocus.requestFocus();
        return;
      }
      setState(() => _loan = loan);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _codeError = e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  /// Vừa = 30% giá bìa, nặng = 100%. Nhẹ không thu. Ghi vào sổ phạt để màn thu tiền thấy.
  Future<(int, String?)> _damageFee(LoanView loan) async {
    final fines = MockFineApi();
    final card = ApiClient.useRealApi ? null : await fines.cardOf(loan.readerId);
    if (!_damaged || _severity == 'LIGHT' || _severity == null) {
      return (0, card);
    }
    final percent = _severity == 'HEAVY' ? 100 : 30;
    final copy = await _api.findCopy(loan.copyCode);
    final amount = copy.priceVnd * percent ~/ 100;
    if (amount <= 0 || ApiClient.useRealApi) return (amount, card);
    await fines.assessDamage(
      loanId: loan.id,
      readerId: loan.readerId,
      amountVnd: amount,
      note: _severity == 'HEAVY' ? 'Hư hỏng mức nặng (100% giá bìa)' : 'Hư hỏng mức vừa (30% giá bìa)',
    );
    return (amount, card);
  }

  /// Trả sách xử lý từng cuốn một (mỗi cuốn phải chọn tình trạng) -> quét 1 lần.
  Future<void> _scanByCamera() async {
    final code = await scanQrOnce(context, title: 'Quét sách trả');
    if (code == null || !mounted) return;
    _codeCtrl.text = code;
    _lookup(code);
  }

  Future<void> _submit() async {
    if (_loan == null || _submitting) return;
    // validate() chạy tất cả validator; nếu có ô sai sẽ tự hiện lỗi đỏ
    if (_damaged && !_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);
    try {
      final result = await _api.returnLoan(
        _loan!.id,
        damaged: _damaged,
        severity: _damaged ? _severity : null,
        note: _damaged ? _noteCtrl.text.trim() : null,
      );
      final fee = await _damageFee(result);
      if (!mounted) return;
      // pushReplacement: không cho bấm ← quay lại form đã gửi
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.returnResult,
        arguments: ReturnOutcome(
          loan: result,
          damaged: _damaged,
          overdueDays: _overdueDays,
          damageFeeVnd: fee.$1,
          readerCard: fee.$2,
        ),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      // LOAN_CLOSED: quét lặp cuốn đã trả -> báo rõ, không phạt lần 2 (server lo)
      showAppSnackBar(context, describeError(e).$1, isError: true);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quét trả sách')),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            // ContentWidth (bài 0.6): trên web form không trải hết màn hình
            child: ContentWidth(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TextField(
                    controller: _codeCtrl,
                    focusNode: _codeFocus,
                    autofocus: !context.isCompact, // điện thoại dùng camera, không bật bàn phím
                    textCapitalization: TextCapitalization.characters,
                    onSubmitted: _lookup,
                    decoration: InputDecoration(
                      labelText: 'Mã bản sao *',
                      hintText: 'Quét tem QR trên sách',
                      prefixIcon: const Icon(Icons.qr_code_2),
                      errorText: _codeError,
                      errorMaxLines: 3,
                      suffixIcon: IconButton(
                        tooltip: 'Quét bằng camera',
                        icon: const Icon(Icons.qr_code_scanner),
                        onPressed: _scanByCamera,
                      ),
                    ),
                  ),
                  if (_loan == null) ...[
                    const SizedBox(height: 8),
                    FilledButton.tonalIcon(
                      style: AppButtonStyles.tonal(context),
                      onPressed: _scanByCamera,
                      icon: const Icon(Icons.photo_camera_outlined),
                      label: const Text('Quét sách bằng camera'),
                    ),
                  ],
                  if (_loan != null) ...[
                    const SizedBox(height: 16),
                    _loanCard(_loan!),
                    const SizedBox(height: 24),
                    Text('TÌNH TRẠNG KHI TRẢ *',
                        style: context.textTheme.labelLarge?.copyWith(color: context.colors.textSecondary)),
                    const SizedBox(height: 8),
                    SegmentedButton<bool>(
                      segments: const [
                        ButtonSegment(value: false, label: Text('Bình thường'), icon: Icon(Icons.check)),
                        ButtonSegment(value: true, label: Text('Hư hỏng'), icon: Icon(Icons.report_problem_outlined)),
                      ],
                      selected: {_damaged},
                      onSelectionChanged: (s) => setState(() => _damaged = s.first),
                      style: SegmentedButton.styleFrom(
                        selectedBackgroundColor: context.scheme.primaryContainer,
                        selectedForegroundColor: context.scheme.onPrimaryContainer,
                      ),
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOut,
                      alignment: Alignment.topCenter,
                      child: _damaged ? _damageSection() : const SizedBox(width: double.infinity),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text('Sách bị mất?', style: TextStyle(color: context.colors.textSecondary)),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(context, AppRoutes.lostRecord, arguments: _loan),
                          child: const Text('Ghi nhận mất'),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (_busy) const Positioned(top: 0, left: 0, right: 0, child: LinearProgressIndicator()),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: ContentWidth(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_loan == null) // nút tắt -> kèm lý do (spec 6.3)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text('Quét mã sách để tìm phiếu mượn',
                        style: TextStyle(fontSize: 13, color: context.colors.textSecondary)),
                  ),
                SizedBox(
                  width: double.infinity,
                  child: LoadingButton(
                    label: 'Ghi nhận trả',
                    loadingLabel: 'Đang ghi nhận…',
                    loading: _submitting,
                    onPressed: _loan == null ? null : _submit,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _loanCard(LoanView loan) {
    final late = _overdueDays;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.menu_book, color: context.scheme.primary),
                const SizedBox(width: 12),
                Expanded(child: Text(loan.titleName, style: context.textTheme.titleMedium)),
                loanStatusChip(context, loan.status),
              ],
            ),
            const SizedBox(height: 8),
            Text('${loan.copyCode} · Phiếu #${loan.id}', style: TextStyle(color: context.colors.textSecondary)),
            Text('Người đọc #${loan.readerId} · Hạn ${fmtDate(loan.dueAt)}',
                style: TextStyle(color: context.colors.textSecondary)),
            if (late > 0) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.schedule, size: 18, color: context.colors.warning),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text('Trễ $late ngày: hệ thống sẽ tính phạt quá hạn',
                        style: TextStyle(color: context.colors.warning, fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _damageSection() {
    // Material (không dùng Container có màu nền): RadioListTile vẽ hiệu ứng bấm lên Material gần nhất,
    // nền màu của Container sẽ che mất hiệu ứng đó.
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Material(
        color: context.scheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: context.colors.divider),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 12, 12),
          child: _damageFields(),
        ),
      ),
    );
  }

  Widget _damageFields() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text('Mức độ hư hỏng *', style: context.textTheme.titleSmall),
          ),
          // FormField bọc nhóm radio để cả nhóm tham gia validate() như ô chữ
          FormField<String>(
            validator: (_) => _severity == null ? 'Chọn mức độ hư hỏng' : null,
            builder: (field) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // RadioGroup: cách mới của Flutter thay groupValue/onChanged trên từng RadioListTile
                RadioGroup<String>(
                  groupValue: _severity,
                  onChanged: (v) {
                    setState(() => _severity = v);
                    field.didChange(v); // báo FormField để xóa lỗi
                  },
                  child: Column(
                    children: [
                      for (final (value, title, sub) in const [
                        ('LIGHT', 'Nhẹ', 'Không tính phí'),
                        ('MEDIUM', 'Vừa', 'Tính 30% giá bìa'),
                        ('HEAVY', 'Nặng', 'Tính 100% giá bìa'),
                      ])
                        RadioListTile<String>(value: value, title: Text(title), subtitle: Text(sub), dense: true),
                    ],
                  ),
                ),
                if (field.hasError)
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(field.errorText!, style: TextStyle(color: context.scheme.error, fontSize: 12)),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: TextFormField(
              controller: _noteCtrl,
              maxLines: 3,
              maxLength: 500,
              decoration: const InputDecoration(
                labelText: 'Mô tả hư hỏng *',
                hintText: 'VD: Rách bìa trước, cong gáy',
                alignLabelWithHint: true,
              ),
              validator: (v) =>
                  (v == null || v.trim().length < 5) ? 'Mô tả ít nhất 5 ký tự để người duyệt hiểu tình trạng' : null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 4),
            child: Text('Ảnh bằng chứng bổ sung ở màn chi tiết báo cáo hư hỏng.',
                style: TextStyle(fontSize: 12, color: context.colors.textSecondary)),
          ),
        ],
    );
  }
}
