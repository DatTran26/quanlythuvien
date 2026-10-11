// Banner trong màn. Bài: Hoang/01-nen-tang/02-theme-va-widget-dung-chung.md mục 5
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/theme_x.dart';

enum BannerKind { success, warning, error, info }

class InfoBanner extends StatelessWidget {
  const InfoBanner({super.key, required this.kind, required this.message, this.title, this.action});

  final BannerKind kind;
  final String? title;
  final String message;
  final Widget? action; // ví dụ TextButton "Thu phạt"

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    // Nền container + chữ đậm của màu ngữ nghĩa (color-system.md Mục 3.3, Mục 7)
    final (ColorPair pair, IconData icon) = switch (kind) {
      BannerKind.success => (c.successContainer, Icons.check_circle_outline),
      BannerKind.warning => (c.warningContainer, Icons.warning_amber_rounded),
      BannerKind.error => (c.errorContainer, Icons.error_outline),
      BannerKind.info => (c.infoContainer, Icons.info_outline),
    };

    return Semantics(
      liveRegion: true, // trình đọc màn hình đọc ngay khi banner xuất hiện
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: pair.background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: pair.foreground),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null)
                    Text(title!, style: TextStyle(fontWeight: FontWeight.w600, color: pair.foreground)),
                  Text(message, style: TextStyle(color: pair.foreground)),
                  if (action != null) ...[const SizedBox(height: 4), action!],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
