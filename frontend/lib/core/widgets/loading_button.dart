// Nút chính có trạng thái đang xử lý. Bài: Hoang/01-nen-tang/02-theme-va-widget-dung-chung.md mục 3
import 'package:flutter/material.dart';

class LoadingButton extends StatelessWidget {
  const LoadingButton({
    super.key,
    required this.label,
    required this.loadingLabel,
    required this.loading,
    required this.onPressed,
    this.icon,
    this.style,
  });

  final String label; // "Xác nhận mượn"
  final String loadingLabel; // "Đang ghi phiếu…"
  final bool loading;
  final VoidCallback? onPressed;
  final IconData? icon;
  final ButtonStyle? style; // truyền dangerButtonStyle(context) nếu là nút đỏ

  @override
  Widget build(BuildContext context) {
    final fg = style?.foregroundColor?.resolve({}) ?? Theme.of(context).colorScheme.onPrimary;
    return FilledButton.icon(
      style: style,
      // Đang loading: vẫn truyền hàm rỗng để nút GIỮ MÀU (null sẽ chuyển sang màu disabled)
      // nhưng hàm rỗng không làm gì -> chặn bấm lặp.
      onPressed: loading ? () {} : onPressed,
      icon: loading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2.5, color: fg),
            )
          : Icon(icon ?? Icons.check, size: 20),
      label: Text(loading ? loadingLabel : label),
    );
  }
}
