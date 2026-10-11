// Chip trạng thái theo mã backend: nhãn tiếng Việt + màu.
// Bài: Hoang/01-nen-tang/02-theme-va-widget-dung-chung.md mục 2.2
// Màu lấy từ hàm ánh xạ chung trong AppColors (copyStatus, loanStatus…), không tự chọn màu.

import 'package:flutter/material.dart';

import '../../../core/theme/theme_x.dart';
import '../../../core/widgets/status_chip.dart';

/// Bản sao (Copy)
StatusChip copyStatusChip(BuildContext context, String status) {
  final label = switch (status) {
    'AVAILABLE' => 'Sẵn sàng',
    'ON_LOAN' => 'Đang mượn',
    'ON_HOLD' => 'Đang giữ',
    'PENDING_REVIEW' => 'Chờ duyệt',
    'IN_REPAIR' => 'Đang sửa',
    'LOST' => 'Mất',
    'DISPOSED' => 'Đã thanh lý',
    _ => status,
  };
  return StatusChip(label: label, pair: context.colors.copyStatus(status));
}

/// Phiếu mượn (Loan)
StatusChip loanStatusChip(BuildContext context, String status) {
  final (label, icon) = switch (status) {
    'ACTIVE' => ('Đang mở', null),
    'OVERDUE' => ('Quá hạn', Icons.schedule),
    'LOST' => ('Mất', null),
    'RETURNED' => ('Đã trả', Icons.check),
    _ => (status, null),
  };
  return StatusChip(label: label, pair: context.colors.loanStatus(status), icon: icon);
}

/// Đặt trước (Reservation)
StatusChip reservationStatusChip(BuildContext context, String status) {
  final label = switch (status) {
    'WAITING' => 'Đang chờ',
    'READY' => 'Sẵn sàng lấy',
    'FULFILLED' => 'Đã nhận',
    'EXPIRED' => 'Hết hạn',
    'CANCELLED' => 'Đã hủy',
    _ => status,
  };
  return StatusChip(label: label, pair: context.colors.reservationStatus(status));
}

/// Báo cáo hư hỏng (DamageReport). Backend dùng DISPOSED, tài liệu ghi DISPOSE.
StatusChip damageStatusChip(BuildContext context, String status) {
  final label = switch (status) {
    'PENDING' => 'Chờ duyệt',
    'REPAIR' => 'Sửa chữa',
    'DISPOSE' || 'DISPOSED' => 'Thanh lý',
    'REJECTED' => 'Bác bỏ',
    _ => status,
  };
  return StatusChip(label: label, pair: context.colors.damageStatus(status));
}
