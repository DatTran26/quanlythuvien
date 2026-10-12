// Màn – Biểu mẫu người đọc (reader-form, feature reader-onboarding). Route: /readers/new
// Bài: TV3 2 · Độ khó ⭐⭐
// Spec: docs/features/reader-onboarding/srs/
//
// Mục đích: Nhân viên cấp tài khoản người đọc tại quầy: nhập hồ sơ, kiểm trùng,
// kích hoạt ngay và cấp mã thẻ QR (DEC-SF-03: không tự đăng ký online).
// Đến từ: reader-list. Đi tới: reader-detail (lưu thành công).
//
// Lỗ hổng:
// - T4: backend chưa có POST /readers cho nhân viên (chỉ có /auth/register tạo PENDING).
// - Spec cần số điện thoại, hạn thẻ: mock và DB đều chưa có (OQ-05, OQ-reader-onboarding-001).

import 'package:flutter/material.dart';
import 'package:frontend/core/auth/session.dart';

import '../data/account_api.dart';
import '../models/app_user.dart';
import 'reader_detail_screen.dart';

class ReaderFormScreen extends StatefulWidget {
  const ReaderFormScreen({super.key});

  @override
  State<ReaderFormScreen> createState() => _ReaderFormScreenState();
}

class _ReaderFormScreenState extends State<ReaderFormScreen> {
  final AccountApi _api = MockAccountApi();
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  String? _emailError;
  AppUser? _existing; // hồ sơ đã dùng email này (E-core-003)
  bool _saving = false;

  int get _actorId => AppSession.userId!;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() {
      _emailError = null;
      _existing = null;
    });
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final created = await _api.createReader(
        displayName: _name.text,
        email: _email.text,
        password: _password.text,
        actorId: _actorId,
      );
      messenger.showSnackBar(
        SnackBar(content: Text('Đã cấp tài khoản, mã thẻ ${created.cardCode}')),
      );
      // Thay biểu mẫu bằng màn chi tiết: bấm "←" ở chi tiết sẽ về thẳng danh sách.
      navigator.pushReplacement(
        MaterialPageRoute(
          builder: (_) => ReaderDetailScreen(userId: created.user.id),
        ),
      );
    } on AccountException catch (e) {
      if (e.code == 'EMAIL_TAKEN') {
        final existing = await _api.userByEmail(_email.text);
        if (mounted) {
          setState(() {
            _emailError = e.message;
            _existing = existing;
          });
        }
      } else {
        messenger.showSnackBar(SnackBar(content: Text(e.message)));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _openExisting() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ReaderDetailScreen(userId: _existing!.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cấp tài khoản người đọc')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _name,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'Họ tên *'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Cần nhập họ tên' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'Email *',
                errorText: _emailError,
              ),
              validator: (v) =>
                  (v == null || !v.contains('@')) ? 'Email không hợp lệ' : null,
            ),
            // Chỉ mở hồ sơ hiện có khi đó là người đọc (spec E-core-003).
            if (_existing != null && _existing!.role == 'READER')
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: _openExisting,
                  icon: const Icon(Icons.open_in_new),
                  label: Text('Mở hồ sơ hiện có: ${_existing!.displayName}'),
                ),
              ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _password,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Mật khẩu tạm *',
                helperText: 'Người đọc đổi lại sau khi đăng nhập lần đầu',
              ),
              validator: (v) =>
                  (v == null || v.length < 8) ? 'Tối thiểu 8 ký tự' : null,
              onFieldSubmitted: (_) => _save(),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _saving ? null : _save,
                child: const Text('Lưu và cấp thẻ'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
