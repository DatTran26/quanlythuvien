// Phiếu mượn của chính người đọc (đang mượn + lịch sử).
// API: GET /loans/mine -> { id, readerId, copyCode, titleName, status, dueAt, renewCount }
// Mock: shared.loans ghép thêm tên sách, mã bản sao cho giống API; có thêm borrowedAt, returnedAt (T6).
//
// Ghi chú: features/circulation/models/loan_view.dart (TV2) là cùng response. Khi TV2 viết xong,
// cân nhắc dùng chung thay vì giữ hai model.

class MyLoan {
  final int id;
  final String copyCode;
  final String titleName;
  final String status; // ACTIVE | OVERDUE | RETURNED | LOST
  final DateTime dueAt;
  final int renewCount;
  final DateTime? borrowedAt; // API chưa trả (T6)
  final DateTime? returnedAt; // API chưa trả (T6)
  final int? priceVnd; // giá bìa, làm trần phạt. API chưa trả (T6)

  const MyLoan({
    required this.id,
    required this.copyCode,
    required this.titleName,
    required this.status,
    required this.dueAt,
    required this.renewCount,
    this.borrowedAt,
    this.returnedAt,
    this.priceVnd,
  });

  factory MyLoan.fromJson(Map<String, dynamic> json) => MyLoan(
    id: json['id'] as int,
    copyCode: json['copyCode'] as String,
    titleName: json['titleName'] as String,
    status: json['status'] as String,
    dueAt: DateTime.parse(json['dueAt'] as String),
    renewCount: json['renewCount'] as int,
    borrowedAt: _parse(json['borrowedAt']),
    returnedAt: _parse(json['returnedAt']),
    priceVnd: json['priceVnd'] as int?,
  );

  static DateTime? _parse(Object? value) =>
      value == null ? null : DateTime.parse(value as String);

  /// Phiếu còn mở: chưa trả, chưa báo mất.
  bool get isOpen => status == 'ACTIVE' || status == 'OVERDUE';

  /// Số ngày còn lại tới hạn trả. Âm nghĩa là đã quá hạn.
  /// Tính theo ngày lịch (bỏ giờ), giống backend.
  int daysLeft(DateTime now) {
    final due = DateTime(dueAt.year, dueAt.month, dueAt.day);
    final today = DateTime(now.year, now.month, now.day);
    return due.difference(today).inDays;
  }
}
