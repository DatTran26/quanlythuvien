// Một sự kiện tài chính trên khoản phạt (sổ chỉ thêm, BR-core-002).
// Mock: tv3.fineTransactions { id, fineId, type, method, amountVnd, receiptNo, actorId, reason,
//   createdAt, operationId }
//   type: ASSESSMENT (ghi nhận phạt, dựng từ chính khoản phạt), PAYMENT, WAIVER, ADJUSTMENT
//   (docs/_shared/domain/library-states.md). Reversal/refund: chờ OQ-fine-collection-adv-001.
// Lỗ hổng: T8 – backend chưa có bảng fine_transaction, chưa lưu biên nhận.

class FineTransaction {
  final int id;
  final int fineId;
  final String type;
  final String? method; // CASH
  final int amountVnd; // ADJUSTMENT có thể âm (giảm) hoặc dương (tăng)
  final String? receiptNo; // chỉ PAYMENT
  final int? actorId;
  final String actorName;
  final String? reason; // bắt buộc với WAIVER, ADJUSTMENT
  final DateTime createdAt;

  const FineTransaction({
    required this.id,
    required this.fineId,
    required this.type,
    required this.method,
    required this.amountVnd,
    required this.receiptNo,
    required this.actorId,
    required this.actorName,
    required this.reason,
    required this.createdAt,
  });

  factory FineTransaction.fromJson(
    Map<String, dynamic> json, {
    required String actorName,
  }) => FineTransaction(
    id: json['id'] as int,
    fineId: json['fineId'] as int,
    type: json['type'] as String,
    method: json['method'] as String?,
    amountVnd: json['amountVnd'] as int,
    receiptNo: json['receiptNo'] as String?,
    actorId: json['actorId'] as int?,
    actorName: actorName,
    reason: json['reason'] as String?,
    createdAt: DateTime.parse(json['createdAt'] as String),
  );

  /// Ảnh hưởng tới số dư: ghi nhận và tăng làm số dư tăng; thu, miễn, giảm làm số dư giảm.
  int get balanceEffect => switch (type) {
    'ASSESSMENT' => amountVnd,
    'ADJUSTMENT' => amountVnd,
    _ => -amountVnd,
  };
}
