// Chip hạn trả: "Còn 5 ngày" / "Hạn hôm nay" / "Quá hạn 6 ngày".
// Màu lấy từ AppColors.loanStatus của TV1.

import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';

String dueLabel(int daysLeft) {
  if (daysLeft > 0) return 'Còn $daysLeft ngày';
  if (daysLeft == 0) return 'Hạn hôm nay';
  return 'Quá hạn ${-daysLeft} ngày';
}

class DueChip extends StatelessWidget {
  const DueChip(this.daysLeft, {super.key});

  final int daysLeft;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    // Tính từ hạn trả, không dựa vào status: job đánh dấu OVERDUE chỉ chạy ban đêm.
    final pair = colors.loanStatus(daysLeft < 0 ? 'OVERDUE' : 'ACTIVE');
    return Chip(
      label: Text(dueLabel(daysLeft), style: TextStyle(color: pair.foreground)),
      backgroundColor: pair.background,
      side: BorderSide.none,
      visualDensity: VisualDensity.compact,
    );
  }
}
