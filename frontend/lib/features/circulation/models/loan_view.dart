// Phiếu mượn rút gọn (khớp record LoanView của backend).
// Bài: Hoang/01-nen-tang/03-goi-api-va-shared-preferences.md mục 4
// API mượn / trả / gia hạn / mất đều trả về:
//   { id, readerId, copyCode, titleName, status, dueAt, renewCount }

class LoanView {
  LoanView({
    required this.id,
    required this.readerId,
    required this.copyCode,
    required this.titleName,
    required this.status,
    required this.dueAt,
    required this.renewCount,
  });

  final int id;
  final int readerId;
  final String copyCode;
  final String titleName;
  final String status; // ACTIVE / OVERDUE / RETURNED / LOST
  final DateTime dueAt;
  final int renewCount;

  factory LoanView.fromJson(Map<String, dynamic> j) => LoanView(
        id: (j['id'] as num).toInt(),
        readerId: (j['readerId'] as num).toInt(),
        copyCode: j['copyCode'] as String,
        titleName: j['titleName'] as String,
        status: j['status'] as String,
        dueAt: DateTime.parse(j['dueAt'] as String),
        renewCount: (j['renewCount'] as num).toInt(),
      );
}
