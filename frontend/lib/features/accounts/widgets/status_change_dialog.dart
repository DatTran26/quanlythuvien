// Hộp thoại xác nhận khóa / mở tài khoản, bắt buộc nhập lý do.
// Spec: account-admin FR-002 (lý do bắt buộc), wireframe reader-detail (cảnh báo nghĩa vụ đang mở).
// Dùng ở reader-detail (1B) và staff-accounts (1C).

import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_theme.dart';

/// Trả về lý do đã nhập, hoặc null nếu người dùng bấm Hủy.
Future<String?> showStatusChangeDialog(
  BuildContext context, {
  required bool locking,
  required String name,
  String? warning,
}) {
  return showDialog<String>(
    context: context,
    builder: (_) =>
        _StatusChangeDialog(locking: locking, name: name, warning: warning),
  );
}

class _StatusChangeDialog extends StatefulWidget {
  const _StatusChangeDialog({
    required this.locking,
    required this.name,
    this.warning,
  });

  final bool locking;
  final String name;
  final String? warning;

  @override
  State<_StatusChangeDialog> createState() => _StatusChangeDialogState();
}

class _StatusChangeDialogState extends State<_StatusChangeDialog> {
  final _formKey = GlobalKey<FormState>();
  final _reason = TextEditingController();

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  void _confirm() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop(_reason.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final action = widget.locking ? 'Khóa' : 'Mở khóa';
    return AlertDialog(
      title: Text('$action tài khoản?'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.name),
            if (widget.warning != null) ...[
              const SizedBox(height: 12),
              Text(
                widget.warning!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: 16),
            TextFormField(
              controller: _reason,
              autofocus: true,
              maxLines: 2,
              decoration: const InputDecoration(labelText: 'Lý do *'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Cần nhập lý do' : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Hủy'),
        ),
        FilledButton(
          style: widget.locking ? AppButtonStyles.danger(context) : null,
          onPressed: _confirm,
          child: Text(action),
        ),
      ],
    );
  }
}
