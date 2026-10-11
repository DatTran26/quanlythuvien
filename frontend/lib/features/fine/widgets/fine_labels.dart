// Nhãn tiếng Việt và chip trạng thái cho khoản phạt.
// Màu: AppColors.fineStatus của TV1 (docs/design/color-system.md).

import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';

String fineReasonLabel(String reason) => switch (reason) {
  'OVERDUE' => 'Trả trễ',
  'LOST' => 'Mất sách',
  'DAMAGE' => 'Hư hỏng',
  _ => reason,
};

String fineStatusLabel(String status) => switch (status) {
  'OPEN' => 'Chưa thanh toán',
  'PAID' => 'Đã thanh toán',
  'WAIVED' => 'Đã miễn',
  _ => status,
};

class FineStatusChip extends StatelessWidget {
  const FineStatusChip(this.status, {super.key});

  final String status;

  @override
  Widget build(BuildContext context) {
    final pair = Theme.of(context).extension<AppColors>()!.fineStatus(status);
    return Chip(
      label: Text(
        fineStatusLabel(status),
        style: TextStyle(color: pair.foreground),
      ),
      backgroundColor: pair.background,
      side: BorderSide.none,
      visualDensity: VisualDensity.compact,
    );
  }
}
