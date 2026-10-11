// Luật tính phạt quá hạn và nhắc hạn (overdue-fines). Hàm thuần Dart: không đọc dữ liệu,
// không gọi API, cùng đầu vào luôn ra cùng kết quả -> test bằng bảng ví dụ.
// Spec: docs/features/overdue-fines/srs/ (BR-overdue-fines-001, OQ-overdue-fines-001)
// Backend: CirculationService.chargeOverdue (tính khi trả sách).
//
// Dùng ở: reader-current-loans, reader-my-fines (tạm tính), fine-list, màn trả sách của TV2.

/// Số ngày quá hạn theo ngày lịch (bỏ giờ), 0 nếu chưa quá hạn. Giống backend (LocalDate).
int overdueDays(DateTime dueAt, DateTime now) {
  // Dùng UTC để phép trừ không lệch 1 ngày ở múi giờ có giờ mùa hè.
  final due = DateTime.utc(dueAt.year, dueAt.month, dueAt.day);
  final today = DateTime.utc(now.year, now.month, now.day);
  final days = today.difference(due).inDays;
  return days > 0 ? days : 0;
}

/// Tiền phạt quá hạn = số ngày × mức/ngày, không vượt giá bìa của sách.
/// Trần = giá sách theo mặc định của nguồn (OQ-overdue-fines-001 chưa chốt chính thức).
int overdueFine({
  required int days,
  required int perDayVnd,
  required int priceVnd,
}) {
  if (days <= 0) return 0;
  final amount = days * perDayVnd;
  return amount > priceVnd ? priceVnd : amount;
}

/// Nhắc sắp đến hạn: đúng 2 ngày trước hạn (job 08:00).
bool shouldRemindDueSoon(int daysLeft) => daysLeft == 2;

/// Nhắc quá hạn: ngày quá hạn đầu tiên, rồi mỗi 3 ngày (ngày 1, 4, 7, 10...).
bool shouldRemindOverdue(int daysOverdue) =>
    daysOverdue >= 1 && (daysOverdue - 1) % 3 == 0;

/// Người đọc bị chặn mượn vì nợ phạt.
/// Theo docs/_shared/mock-data.md: nợ >= ngưỡng fineBlockVnd.
/// Lưu ý: backend hiện chặn khi nợ > 0 (FINE_BLOCK). Nhóm cần chốt một luật.
bool isBlockedByDebt(int debtVnd, int blockVnd) =>
    debtVnd > 0 && debtVnd >= blockVnd;
