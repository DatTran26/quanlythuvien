// Thẻ hành động trên màn Quầy lưu thông (dùng lại 5 lần).
// Bài: Hoang/02-checkout/01-circulation-desk.md (Bước 1)

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class DeskActionCard extends StatelessWidget {
  const DeskActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.highlight = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  /// true = thẻ thao tác chính (Bắt đầu mượn): nền primaryContainer.
  /// Làm nổi bằng màu nền thay vì thêm nút Filled.
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    final iconColor = highlight ? scheme.onPrimaryContainer : scheme.primary;
    final titleColor = highlight ? scheme.onPrimaryContainer : scheme.onSurface;
    final subtitleColor =
        highlight ? scheme.onPrimaryContainer : colors.textSecondary;

    return Card(
      // null = dùng màu theme (surface, viền divider, bo 12px, không bóng).
      color: highlight ? scheme.primaryContainer : null,
      // Thẻ nổi bật bỏ viền: nền màu đã đủ tách khối.
      shape: highlight
          ? const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            )
          : null,
      margin: EdgeInsets.zero, // khoảng cách giữa các thẻ do lưới lo
      clipBehavior: Clip.antiAlias, // gợn sóng khi bấm không tràn ra góc bo
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: highlight ? 32 : 28, color: iconColor),
              const SizedBox(height: 8),
              Text(
                title,
                style: textTheme.titleMedium?.copyWith(color: titleColor),
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: textTheme.bodySmall?.copyWith(color: subtitleColor),
                maxLines: 2,
                overflow: TextOverflow.ellipsis, // chữ dài thì "…" chứ không tràn
              ),
            ],
          ),
        ),
      ),
    );
  }
}
