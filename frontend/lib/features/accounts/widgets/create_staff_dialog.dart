// Hộp thoại tạo tài khoản Nhân viên: họ tên, email, mật khẩu tạm.
// Spec: account-admin staff-accounts (E-core-001 thiếu trường, E-core-003 email trùng).
// Lỗi từ API (email trùng) hiện ngay dưới ô email, hộp thoại không đóng.

import 'package:flutter/material.dart';

import '../data/account_api.dart';

/// Hàm lưu do màn hình truyền vào. Ném AccountException nếu lỗi.
typedef SaveStaff = Future<void> Function(
  String name,
  String email,
  String password,
);

/// Trả về true nếu đã tạo thành công, null nếu bấm Hủy.
Future<bool?> showCreateStaffDialog(
  BuildContext context, {
  required SaveStaff onSave,
}) {
  return showDialog<bool>(
    context: context,
    builder: (_) => _CreateStaffDialog(onSave: onSave),
  );
}

class _CreateStaffDialog extends StatefulWidget {
  const _CreateStaffDialog({required this.onSave});

  final SaveStaff onSave;

  @override
  State<_CreateStaffDialog> createState() => _CreateStaffDialogState();
}

class _CreateStaffDialogState extends State<_CreateStaffDialog> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  String? _emailError;
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _emailError = null);
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    try {
      await widget.onSave(_name.text, _email.text, _password.text);
      if (mounted) Navigator.of(context).pop(true);
    } on AccountException catch (e) {
      if (mounted) setState(() => _emailError = e.message);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tạo tài khoản Nhân viên'),
      content: SizedBox(
        width: 360,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _name,
                autofocus: true,
                decoration: const InputDecoration(labelText: 'Họ tên *'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Cần nhập họ tên' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email *',
                  errorText: _emailError,
                ),
                validator: (v) => (v == null || !v.contains('@'))
                    ? 'Email không hợp lệ'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _password,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Mật khẩu tạm *'),
                validator: (v) =>
                    (v == null || v.length < 8) ? 'Tối thiểu 8 ký tự' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: const Text('Hủy'),
        ),
        FilledButton(
          onPressed: _saving ? null : _submit,
          child: const Text('Tạo tài khoản'),
        ),
      ],
    );
  }
}
