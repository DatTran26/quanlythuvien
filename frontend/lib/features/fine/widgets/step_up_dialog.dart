// Xác thực lại trước thao tác tài chính nhạy cảm (miễn, điều chỉnh).
// Spec: CHK-fine-collection-adv-002 "miễn/điều chỉnh cần step-up";
// navigation-map: financial-events -> session-expired (access-control, TV1), E-access-control-001.
//
// TẠM THỜI: chưa có màn xác thực lại của TV1 và mock không lưu mật khẩu, nên đây chỉ là
// hộp thoại xác nhận. Khi TV1 có session-expired, thay hàm này bằng điều hướng sang màn đó.

import 'package:flutter/material.dart';

/// true nếu người dùng xác nhận lại danh tính.
Future<bool> confirmStepUp(
  BuildContext context, {
  required String action,
}) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Xác thực lại'),
      content: SizedBox(
        width: 360,
        child: Text(
          '$action là thao tác tài chính nhạy cảm và sẽ được ghi nhật ký. '
          'Xác nhận bạn là người đang đăng nhập để tiếp tục.',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Hủy'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Xác nhận'),
        ),
      ],
    ),
  );
  return ok ?? false;
}
