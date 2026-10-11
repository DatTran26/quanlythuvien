// API báo cáo. Bài: Hoang/08-reports/01-report-dashboard.md (Bước 1), 03-trend-dashboard.md
//
// Lỗ hổng: G10 chưa có API RP-05 phạt, RP-06 top sách, RP-07 hư hỏng; G11 chưa có RP-01 tài khoản.
// JSON của entity Loan (lồng reader, title, copy) tùy cách Jackson serialize: chạy backend thật thì
// mở Swagger gọi thử rồi chỉnh OverdueLoan.fromJson cho khớp.

import '../../../core/network/api_client.dart';

class InventoryCount {
  InventoryCount(this.status, this.count);

  final String status;
  final int count;
}

class OverdueLoan {
  OverdueLoan({
    required this.id,
    required this.readerName,
    required this.titleName,
    required this.copyCode,
    required this.dueAt,
  });

  final int id;
  final String readerName, titleName, copyCode;
  final DateTime dueAt;

  int get daysLate => DateTime.now().difference(dueAt).inDays;

  factory OverdueLoan.fromJson(Map<String, dynamic> j) => OverdueLoan(
        id: (j['id'] as num).toInt(),
        readerName: ((j['reader'] as Map?)?['displayName'] ?? '—') as String,
        titleName: ((j['title'] as Map?)?['name'] ?? '—') as String,
        copyCode: ((j['copy'] as Map?)?['code'] ?? '—') as String,
        dueAt: DateTime.parse(j['dueAt'] as String),
      );
}

class ReportApi {
  final _api = ApiClient.instance;

  Future<List<InventoryCount>> inventory() async {
    final rows = await _api.get('/reports/inventory') as List; // [["AVAILABLE", 812], ...]
    return rows.map((r) => InventoryCount(r[0] as String, (r[1] as num).toInt())).toList();
  }

  Future<List<OverdueLoan>> overdue() async {
    final list = await _api.get('/reports/overdue') as List;
    return list.map((e) => OverdueLoan.fromJson(e as Map<String, dynamic>)).toList()
      ..sort((a, b) => b.daysLate.compareTo(a.daysLate)); // lâu nhất lên đầu
  }

  Future<Map<String, int>> trends(DateTime from, DateTime to) async {
    String d(DateTime x) => x.toIso8601String().substring(0, 10); // YYYY-MM-DD
    final j = await _api.get('/reports/trends', query: {'from': d(from), 'to': d(to)}) as Map;
    return {'loans': (j['loans'] as num).toInt(), 'returns': (j['returns'] as num).toInt()};
  }

  Future<List<int>> overdueFile(String ext) => _api.getBytes('/reports/overdue.$ext');
}
