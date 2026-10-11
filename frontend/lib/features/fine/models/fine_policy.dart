// Phần quy định mượn liên quan tới phạt.
// API: GET /policy -> LendingPolicy (chỉ LIBRARIAN, ADMIN; người đọc chưa đọc được: T14)
// Mock: shared.lendingPolicy. Toàn bộ quy định thuộc policy-config (TV1).

class FinePolicy {
  final int perDayVnd; // phạt mỗi ngày trễ
  final int blockVnd; // nợ từ mức này trở lên thì chặn mượn

  const FinePolicy({required this.perDayVnd, required this.blockVnd});

  factory FinePolicy.fromJson(Map<String, dynamic> json) => FinePolicy(
    perDayVnd: json['finePerDayVnd'] as int,
    blockVnd: json['fineBlockVnd'] as int,
  );
}
