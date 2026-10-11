// Model khoản phạt.
// API: GET /fines/mine -> Fine (entity, readerId nằm trong object reader lồng bên trong)
// Mock: shared.fines { id, loanId, readerId, amountVnd, balanceVnd, reason, status, note, createdAt }
//   reason: OVERDUE, LOST, DAMAGE · status: OPEN, PAID, WAIVED

class Fine {
  final int id;
  final int? loanId;
  final int readerId;
  final int amountVnd; // số tiền gốc
  final int balanceVnd; // số còn nợ
  final String reason; // OVERDUE | LOST | DAMAGE
  final String status; // OPEN | PAID | WAIVED
  final String? note;
  final DateTime createdAt;

  const Fine({
    required this.id,
    required this.loanId,
    required this.readerId,
    required this.amountVnd,
    required this.balanceVnd,
    required this.reason,
    required this.status,
    required this.note,
    required this.createdAt,
  });

  factory Fine.fromJson(Map<String, dynamic> json) => Fine(
    id: json['id'] as int,
    loanId: json['loanId'] as int?,
    // Mock có readerId; API trả object reader lồng nhau.
    readerId:
        (json['readerId'] ?? (json['reader'] as Map<String, dynamic>)['id'])
            as int,
    amountVnd: json['amountVnd'] as int,
    balanceVnd: json['balanceVnd'] as int,
    reason: json['reason'] as String,
    status: json['status'] as String,
    note: json['note'] as String?,
    createdAt: DateTime.parse(json['createdAt'] as String),
  );

  /// Còn phải thu.
  bool get isOpen => status == 'OPEN' && balanceVnd > 0;

  /// Đã nộp một phần hoặc toàn bộ.
  int get paidVnd => amountVnd - balanceVnd;
}
