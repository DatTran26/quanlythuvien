// Chip trạng thái. Bài: Hoang/01-nen-tang/02-theme-va-widget-dung-chung.md mục 2
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Chip trạng thái: nền + chữ lấy từ cặp ColorPair, bo tròn hoàn toàn, chữ 13px w500.
class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.label, required this.pair, this.icon});

  final String label;
  final ColorPair pair;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: pair.background,
        borderRadius: BorderRadius.circular(999), // bo tròn hoàn toàn
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // chỉ rộng vừa nội dung
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: pair.foreground),
            const SizedBox(width: 4),
          ],
          // Flexible + ellipsis: chip đặt trong ô hẹp thì cắt chữ bằng "…" thay vì tràn
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: pair.foreground),
            ),
          ),
        ],
      ),
    );
  }
}
