// Snackbar đúng màu. Bài: Hoang/01-nen-tang/02-theme-va-widget-dung-chung.md mục 6
import 'package:flutter/material.dart';

import '../theme/theme_x.dart';

/// Thành công / thông tin: nền textPrimary, chữ surface. Lỗi: nền error, chữ onError.
void showAppSnackBar(BuildContext context, String message, {bool isError = false, SnackBarAction? action}) {
  final s = context.scheme;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar() // tránh xếp hàng nhiều snackbar
    ..showSnackBar(SnackBar(
      content: Text(message, style: TextStyle(color: isError ? s.onError : s.surface)),
      backgroundColor: isError ? s.error : s.onSurface,
      behavior: SnackBarBehavior.floating, // nổi lên, không che thanh nút dưới
      action: action,
    ));
}
