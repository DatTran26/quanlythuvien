// Màn 9 – Báo hư hỏng (damage-report-form). Route: /damage/new
// Bài: Hoang/05-damage-lifecycle/01-damage-report-form.md
//
// Lập báo cáo hư hỏng: bản sao, mức độ, mô tả, ảnh bằng chứng.
// Gửi xong: báo cáo PENDING, bản sao PENDING_REVIEW (ngừng cho mượn ngay).
// G4: backend nhận 1 ảnh nên _maxPhotos = 1; lưới ảnh đã sẵn cho 5.
// G5: chưa có API xem chi tiết -> truyền thẳng báo cáo vừa tạo sang màn chi tiết.

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/layout/breakpoints.dart';
import '../../../core/layout/content_width.dart';
import '../../../core/network/api_client.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/theme_x.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/loading_button.dart';
import '../../../core/widgets/qr_scan_page.dart';
import '../../../core/widgets/snackbar.dart';
import '../../circulation/data/circulation_api.dart';
import '../../circulation/data/error_text.dart';
import '../../circulation/models/book_copy.dart';
import '../../circulation/widgets/status_mapping.dart';
import '../data/condition_api.dart';

class DamageReportFormScreen extends StatefulWidget {
  const DamageReportFormScreen({super.key, this.initialCopyCode});

  final String? initialCopyCode; // mở từ màn khác có sẵn mã thì điền luôn

  @override
  State<DamageReportFormScreen> createState() => _DamageReportFormScreenState();
}

class _DamageReportFormScreenState extends State<DamageReportFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  final _picker = ImagePicker();
  final _circulation = CirculationApi();
  final _condition = ConditionApi();

  static const _maxPhotos = 1; // G4: backend nhận 1 ảnh. Sau đổi thành 5
  static const _maxBytes = 500 * 1024; // 500KB (NFR-05)

  BookCopy? _copy;
  String? _severity;
  final List<Uint8List> _photos = [];
  bool _busy = false, _submitting = false, _triedSubmit = false;
  String? _codeError;

  bool get _dirty => _copy != null || _noteCtrl.text.isNotEmpty || _photos.isNotEmpty;

  static const _severities = [
    ('LIGHT', 'Nhẹ', 0.0),
    ('MEDIUM', 'Vừa', 0.3),
    ('HEAVY', 'Nặng', 1.0),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialCopyCode != null) {
      _codeCtrl.text = widget.initialCopyCode!;
      _lookup(widget.initialCopyCode!);
    }
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _lookup(String raw) async {
    final code = raw.trim().toUpperCase();
    if (code.isEmpty) return;
    setState(() {
      _busy = true;
      _codeError = null;
      _copy = null;
    });
    try {
      final copy = await _circulation.findCopy(code);
      if (!mounted) return;
      setState(() {
        if (copy.status == 'DISPOSED') {
          _codeError = 'Bản sao đã thanh lý, không thể báo hư hỏng.';
        } else if (copy.status == 'PENDING_REVIEW') {
          _codeError = 'Bản sao này đã có báo cáo đang chờ duyệt.';
        } else {
          _copy = copy;
        }
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _codeError = e.code == 'NOT_FOUND' ? 'Không tìm thấy bản sao với mã này.' : e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _addPhoto() async {
    // Hỏi nguồn ảnh bằng bottom sheet
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Chụp ảnh'),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Chọn từ thư viện'),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;

    final XFile? file = await _picker.pickImage(
      source: source,
      maxWidth: 1600, // thu nhỏ ngay khi chọn -> file nhẹ
      maxHeight: 1600,
      imageQuality: 70, // nén JPEG 70%
    );
    if (file == null || !mounted) return;

    final bytes = await file.readAsBytes();
    if (!mounted) return;
    if (bytes.lengthInBytes > _maxBytes) {
      showAppSnackBar(
          context,
          'Ảnh vẫn lớn hơn 500KB sau khi nén (${(bytes.lengthInBytes / 1024).round()}KB). '
          'Chọn ảnh khác hoặc chụp gần hơn.',
          isError: true);
      return;
    }
    setState(() => _photos.add(bytes));
  }

  void _previewPhoto(Uint8List bytes) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        insetPadding: const EdgeInsets.all(12),
        child: Stack(
          children: [
            InteractiveViewer(
              // chụm 2 ngón để phóng to
              minScale: 1,
              maxScale: 4,
              child: Image.memory(bytes, fit: BoxFit.contain),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: IconButton.filledTonal(
                tooltip: 'Đóng',
                onPressed: () => Navigator.pop(ctx),
                icon: const Icon(Icons.close),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    setState(() => _triedSubmit = true); // bật hiển thị lỗi cho chip/ảnh
    // Gõ mã rồi bấm Gửi không kích hoạt onSubmitted, nên tra mã tại đây.
    final typed = _codeCtrl.text.trim().toUpperCase();
    if (typed.isNotEmpty && _copy?.code != typed) {
      await _lookup(typed);
      if (!mounted) return;
    }
    final formOk = _formKey.currentState!.validate();
    if (!formOk || _copy == null || _severity == null || _photos.isEmpty || _submitting) return;

    setState(() => _submitting = true);
    try {
      final report = await _condition.report(
        copyId: _copy!.id,
        severity: _severity!,
        note: _noteCtrl.text.trim(),
        photos: _photos,
      );
      // Bản sao vừa chuyển PENDING_REVIEW: tải lại để màn chi tiết hiện đúng trạng thái
      final fresh = await _circulation.findCopy(_copy!.code);
      if (!mounted) return;
      showAppSnackBar(context, 'Đã gửi báo cáo. Bản sao tạm ngừng cho mượn.');
      Navigator.pushReplacementNamed(context, AppRoutes.damageDetail, arguments: (report: report, copy: fresh));
    } on ApiException catch (e) {
      if (!mounted) return;
      final msg = switch (e.code) {
        'IMAGE' => 'File không phải ảnh hợp lệ. Chọn ảnh JPG/PNG khác.',
        'IMAGE_SIZE' => 'Ảnh sau nén vẫn lớn hơn 500KB. Chọn ảnh khác.',
        _ => describeError(e).$1,
      };
      showAppSnackBar(context, msg, isError: true);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_dirty,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final ok = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Bỏ báo cáo đang nhập?'),
            content: const Text('Ảnh và mô tả đã nhập sẽ mất.'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Tiếp tục nhập')),
              OutlinedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Bỏ báo cáo')),
            ],
          ),
        );
        if (ok == true && context.mounted) Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Báo cáo hư hỏng')),
        body: Form(
          key: _formKey,
          child: ContentWidth(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextField(
                  controller: _codeCtrl,
                  autofocus: widget.initialCopyCode == null && !context.isCompact,
                  textCapitalization: TextCapitalization.characters,
                  onSubmitted: _lookup,
                  decoration: InputDecoration(
                    labelText: 'Mã bản sao *',
                    prefixIcon: const Icon(Icons.qr_code_2),
                    errorText: _codeError ?? (_triedSubmit && _copy == null ? 'Quét hoặc nhập mã bản sao' : null),
                    errorMaxLines: 2,
                    suffixIcon: _busy
                        ? const Padding(
                            padding: EdgeInsets.all(14),
                            child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                          )
                        : IconButton(
                            icon: const Icon(Icons.qr_code_scanner),
                            tooltip: 'Quét bằng camera',
                            onPressed: () async {
                              final code = await scanQrOnce(context, title: 'Quét sách hư hỏng');
                              if (code == null) return;
                              _codeCtrl.text = code;
                              _lookup(code);
                            },
                          ),
                  ),
                ),
                if (_copy != null) ...[
                  const SizedBox(height: 12),
                  Card(
                    margin: EdgeInsets.zero,
                    child: ListTile(
                      leading: Icon(Icons.menu_book, color: context.scheme.primary),
                      title: Text(_copy!.titleName),
                      subtitle: Text('${_copy!.code}${_copy!.shelf != null ? ' · Kệ ${_copy!.shelf}' : ''}'),
                      trailing: copyStatusChip(context, _copy!.status),
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                Text('Mức độ hư hỏng *', style: context.textTheme.titleSmall),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final (value, label, _) in _severities)
                      ChoiceChip(
                        label: Text(label),
                        selected: _severity == value,
                        onSelected: (_) => setState(() => _severity = value),
                        selectedColor: context.scheme.primaryContainer,
                        labelStyle: TextStyle(color: _severity == value ? context.scheme.onPrimaryContainer : null),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                _severityHint(),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _noteCtrl,
                  maxLines: 4,
                  maxLength: 500,
                  onChanged: (_) => setState(() {}), // để _dirty cập nhật
                  decoration: const InputDecoration(
                    labelText: 'Mô tả hư hỏng *',
                    hintText: 'Vị trí và tình trạng: rách bìa, ố nước trang 20–35…',
                    alignLabelWithHint: true,
                  ),
                  validator: (v) => (v == null || v.trim().length < 5) ? 'Mô tả ít nhất 5 ký tự' : null,
                ),
                const SizedBox(height: 8),
                Text('Ảnh bằng chứng * (${_photos.length}/$_maxPhotos)', style: context.textTheme.titleSmall),
                const SizedBox(height: 8),
                GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    for (var i = 0; i < _photos.length; i++) _photoThumb(i),
                    if (_photos.length < _maxPhotos) _addPhotoTile(),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  _triedSubmit && _photos.isEmpty
                      ? 'Cần ít nhất 1 ảnh bằng chứng'
                      : 'Ảnh được nén tự động, tối đa 500KB mỗi ảnh.',
                  style: TextStyle(
                    fontSize: 12,
                    color: _triedSubmit && _photos.isEmpty ? context.scheme.error : context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: ContentWidth(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: SizedBox(
                width: double.infinity,
                child: LoadingButton(
                  icon: Icons.send_outlined,
                  label: 'Gửi báo cáo',
                  loadingLabel: 'Đang gửi…',
                  loading: _submitting,
                  onPressed: _submit,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _severityHint() {
    if (_severity == null) {
      return Text(
        _triedSubmit ? 'Chọn mức độ hư hỏng' : 'Mức độ quyết định phí bồi thường.',
        style: TextStyle(fontSize: 12, color: _triedSubmit ? context.scheme.error : context.colors.textSecondary),
      );
    }
    final rate = _severities.firstWhere((s) => s.$1 == _severity).$3;
    final fee = _copy == null ? '' : ' (≈ ${fmtMoney((_copy!.priceVnd * rate).round())})';
    return Text(
      rate == 0 ? 'Không tính phí.' : 'Tính ${(rate * 100).round()}% giá bìa$fee.',
      style: TextStyle(fontSize: 12, color: rate == 1 ? context.colors.warning : context.colors.textSecondary),
    );
  }

  Widget _photoThumb(int i) {
    return MouseRegion(
      cursor: SystemMouseCursors.click, // web: con trỏ bàn tay (bài 0.6)
      child: GestureDetector(
        onTap: () => _previewPhoto(_photos[i]),
        child: Stack(
          fit: StackFit.expand, // ảnh lấp đầy ô vuông
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.memory(_photos[i], fit: BoxFit.cover),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: Material(
                // Material để nút xóa có ripple trên ảnh
                color: context.scheme.surface,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => setState(() => _photos.removeAt(i)),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(Icons.close, size: 18, color: context.scheme.onSurface, semanticLabel: 'Xóa ảnh ${i + 1}'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _addPhotoTile() {
    return Material(
      color: context.scheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: context.scheme.outline),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: _addPhoto,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo_outlined, color: context.scheme.primary),
            const SizedBox(height: 4),
            Text('Thêm ảnh', style: TextStyle(color: context.scheme.primary, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
