// Kết quả trả sách, truyền từ return-scan sang return-result.
// Bài: Hoang/03-return-handling/01-return-scan.md (Bước 2)

import 'loan_view.dart';

class ReturnOutcome {
  ReturnOutcome({required this.loan, required this.damaged, required this.overdueDays});

  final LoanView loan; // phiếu sau khi trả (status RETURNED)
  final bool damaged;
  final int overdueDays; // > 0 nghĩa là có phạt quá hạn
}
