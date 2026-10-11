// Model người đọc lấy khi quét thẻ. Bài: Hoang/01-nen-tang/03-goi-api-va-shared-preferences.md mục 4
// API: GET /readers/by-card/{code} -> MeResponse { id, email, displayName, role, status }
//
// Lỗ hổng G2: API chưa trả số cuốn đang mượn và nợ phạt. Lỗi OVERDUE_BLOCK / FINE_BLOCK /
// LOAN_LIMIT chỉ biết khi bấm xác nhận ở checkout-review.

class Reader {
  Reader({required this.id, required this.displayName, required this.email, required this.status});

  final int id;
  final String displayName;
  final String email;
  final String status; // ACTIVE / PENDING / LOCKED

  bool get isActive => status == 'ACTIVE';

  factory Reader.fromJson(Map<String, dynamic> j) => Reader(
        id: (j['id'] as num).toInt(),
        displayName: j['displayName'] as String,
        email: j['email'] as String,
        status: j['status'] as String,
      );
}
