// Màn 12 – Tìm lại sau khi mất (found-after-lost). Route: /lost/found · R1B
// Bài: Hoang/06-lost-handling/02-found-after-lost.md
//
// Sách đã "Mất" nay tìm thấy. Phải đối soát tài chính XONG trước khi cho lưu thông lại
// (BR-lost-handling-001). Chưa có API (G6) -> dùng FakeLostApi, màn hình chỉ biết LostApi.

import 'package:flutter/material.dart';

import '../../../core/layout/breakpoints.dart';
import '../../../core/layout/content_width.dart';
import '../../../core/network/api_client.dart';
import '../../../core/theme/theme_x.dart';
import '../../../core/widgets/info_banner.dart';
import '../../../core/widgets/loading_button.dart';
import '../../../core/widgets/qr_scan_page.dart';
import '../../circulation/data/circulation_api.dart';
import '../../circulation/models/book_copy.dart';
import '../../circulation/widgets/status_mapping.dart';
import '../data/lost_api.dart';

class FoundAfterLostScreen extends StatefulWidget {
  const FoundAfterLostScreen({super.key});

  @override
  State<FoundAfterLostScreen> createState() => _FoundAfterLostScreenState();
}

class _FoundAfterLostScreenState extends State<FoundAfterLostScreen> {
  // Kiểu khai báo là LostApi (abstract), giá trị là Fake. Có backend thì chỉ đổi vế phải.
  final LostApi _lostApi = FakeLostApi();
  final _circulation = CirculationApi();
  final _codeCtrl = TextEditingController();

  BookCopy? _copy;
  String? _error;
  bool _checked = false, _submitting = false;
  FoundOutcome? _outcome;

  int get _step => _outcome == null ? 0 : (_outcome == FoundOutcome.pendingReconciliation ? 1 : 2);

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  Future<void> _lookup(String raw) async {
    setState(() {
      _error = null;
      _copy = null;
      _checked = false;
      _outcome = null;
    });
    try {
      final c = await _circulation.findCopy(raw.trim().toUpperCase());
      if (!mounted) return;
      setState(() {
        if (c.status != 'LOST') {
          _error = 'Bản sao không ở trạng thái "Mất" nên không cần ghi nhận tìm lại.';
        } else {
          _copy = c;
        }
      });
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    }
  }

  Future<void> _submit() async {
    if (_copy == null || !_checked || _submitting) return;
    setState(() => _submitting = true);
    try {
      final r = await _lostApi.markFound(_copy!.id);
      if (mounted) setState(() => _outcome = r);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tìm lại sách đã mất')),
      body: ContentWidth(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextField(
              controller: _codeCtrl,
              autofocus: !context.isCompact,
              textCapitalization: TextCapitalization.characters,
              onSubmitted: _lookup,
              decoration: InputDecoration(
                labelText: 'Mã bản sao',
                hintText: 'VD: BC000012',
                prefixIcon: const Icon(Icons.qr_code_2),
                suffixIcon: IconButton(
                  tooltip: 'Quét bằng camera',
                  icon: const Icon(Icons.qr_code_scanner),
                  onPressed: () async {
                    final code = await scanQrOnce(context, title: 'Quét sách tìm lại');
                    if (code != null) {
                      _codeCtrl.text = code;
                      _lookup(code);
                    }
                  },
                ),
                errorText: _error,
                errorMaxLines: 2,
              ),
            ),
            if (_copy != null) ...[
              const SizedBox(height: 12),
              Card(
                margin: EdgeInsets.zero,
                child: ListTile(
                  leading: Icon(Icons.menu_book, color: context.scheme.primary),
                  title: Text(_copy!.titleName),
                  subtitle: Text(_copy!.code),
                  trailing: copyStatusChip(context, _copy!.status),
                ),
              ),
              const SizedBox(height: 16),
              Text('QUY TRÌNH', style: context.textTheme.labelLarge?.copyWith(color: context.colors.textSecondary)),
              Stepper(
                physics: const NeverScrollableScrollPhysics(), // nằm trong ListView
                currentStep: _step,
                controlsBuilder: (_, _) => const SizedBox.shrink(), // ẩn nút Continue/Cancel mặc định
                steps: [
                  Step(
                    title: const Text('Kiểm tra vật lý bản sao'),
                    state: _step > 0 ? StepState.complete : StepState.indexed,
                    isActive: _step >= 0,
                    content: CheckboxListTile(
                      value: _checked,
                      onChanged: _outcome == null ? (v) => setState(() => _checked = v ?? false) : null,
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Đã kiểm tra, sách còn dùng được'),
                    ),
                  ),
                  Step(
                    title: const Text('Đối soát bồi thường'),
                    subtitle: const Text('Thực hiện ở mục Tài chính (TV3)'),
                    state: _step > 1 ? StepState.complete : StepState.indexed,
                    isActive: _step >= 1,
                    content: const InfoBanner(
                      kind: BannerKind.info,
                      title: 'Đã tìm thấy, chờ đối soát',
                      message: 'Bản sao vẫn ở trạng thái "Mất" cho tới khi khoản bồi thường được điều chỉnh '
                          'hoặc hoàn tiền.',
                    ),
                  ),
                  Step(
                    title: const Text('Đưa bản sao về lưu thông'),
                    isActive: _step >= 2,
                    content: const Text('Tự động sau khi đối soát xong.'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: _copy == null || _outcome != null
          ? null
          : SafeArea(
              child: ContentWidth(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!_checked)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text('Kiểm tra vật lý bản sao trước',
                              style: TextStyle(fontSize: 13, color: context.colors.textSecondary)),
                        ),
                      SizedBox(
                        width: double.infinity,
                        child: LoadingButton(
                          label: 'Xác nhận đã tìm lại',
                          loadingLabel: 'Đang ghi nhận…',
                          loading: _submitting,
                          onPressed: _checked ? _submit : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
