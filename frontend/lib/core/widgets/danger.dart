// Nút Danger và dialog xác nhận. Bài: Hoang/01-nen-tang/02-theme-va-widget-dung-chung.md mục 4
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../theme/theme_x.dart';

/// Style nút đỏ: nền error, chữ onError, nhấn -> errorPressed. Dùng lại AppButtonStyles.danger.
ButtonStyle dangerButtonStyle(BuildContext context) => AppButtonStyles.danger(context);

/// Mở dialog xác nhận cho thao tác không hoàn tác.
/// Trả về true nếu người dùng bấm nút hành động.
Future<bool> confirmDanger(
  BuildContext context, {
  required String title, // "Thanh lý bản sao?"
  required String message, // giải thích hậu quả
  required String actionLabel, // "Thanh lý 1 bản sao", KHÔNG ghi "OK"
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      icon: Icon(Icons.warning_amber_rounded, color: ctx.scheme.error),
      title: Text(title),
      content: Text(message),
      actions: [
        // Thứ tự: hành động phụ bên TRÁI, hành động chính bên PHẢI (spec 6.4.5)
        OutlinedButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Hủy'),
        ),
        FilledButton(
          style: dangerButtonStyle(ctx),
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(actionLabel),
        ),
      ],
    ),
  );
  return result ?? false; // bấm ra ngoài dialog = hủy
}
