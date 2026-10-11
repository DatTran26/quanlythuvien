// Ánh xạ trạng thái tài khoản -> nhãn tiếng Việt + màu chip.
// Bài: TV3 1A (Bước 4). Nguồn màu: docs/design/color-system.md, core/theme/app_colors.dart
//
// TODO:
// - String accountStatusLabel(String status): ACTIVE "Hoạt động", PENDING "Chờ kích hoạt",
//   LOCKED "Đã khóa".
// - ColorPair accountStatusColors(BuildContext context, String status): lấy từ
//   Theme.of(context).extension<AppColors>()!: ACTIVE statusAvailable, PENDING statusPending,
//   LOCKED statusDanger, còn lại statusNeutral.
// - Widget AccountStatusChip(status): Chip có chữ + màu từ hai hàm trên.
//   Quy tắc vàng: không viết Color(0xFF...), chip luôn có chữ.
//
// Ghi chú: AppColors chưa có hàm accountStatus(). Khi TV1 thêm (hoặc có
// core/widgets/status_chip.dart), đổi sang dùng hàm chung.
import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';

String accountStatusLabel(String status) => switch (status) {
  'ACTIVE' => 'Đang hoạt động',
  'PENDING' => 'Chờ kích hoạt',
  'LOCKED' => 'Đã khóa',
  _ => status,
};

ColorPair accountStatusColors(BuildContext context, String status) {
  final colors = Theme.of(context).extension<AppColors>()!;
  return switch (status) {
    'ACTIVE' => colors.statusAvailable,
    'PENDING' => colors.statusPending,
    'LOCKED' => colors.statusDanger,
    _ => colors.statusNeutral,
  };
}

/// Chip trạng thái tài khoản. Luôn có chữ, không chỉ dùng màu.
class AccountStatusChip extends StatelessWidget {
  const AccountStatusChip(this.status, {super.key});

  final String status;

  @override
  Widget build(BuildContext context) {
    final pair = accountStatusColors(context, status);
    return Chip(
      label: Text(
        accountStatusLabel(status),
        style: TextStyle(color: pair.foreground),
      ),
      backgroundColor: pair.background,
      side: BorderSide.none,
      visualDensity: VisualDensity.compact,
    );
  }
}
