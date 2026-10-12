// Các hàm gọi API cho mượn / trả / gia hạn / mất.
// Bài: Hoang/01-nen-tang/03-goi-api-va-shared-preferences.md mục 5, Hoang/03-return-handling/01-return-scan.md
//
// Lỗ hổng:
// - G1: chưa có POST /loans/batch -> checkout-review gọi checkout() lần lượt từng cuốn.
// - G3: chưa có GET /loans/open?copyCode= -> backend giả (mock_backend.dart) đã có,
//   backend Spring thật cần thêm endpoint này.

import '../../../core/network/api_client.dart';
import '../models/book_copy.dart';
import '../models/loan_view.dart';
import '../models/reader.dart';

/// Phiếu đang mở tìm theo mã bản sao. Khi backend trả thêm field thì tách class riêng.
typedef OpenLoan = LoanView;

class CirculationApi {
  final _api = ApiClient.instance;

  Future<Reader> findReaderByCard(String code) async =>
      Reader.fromJson(await _api.get('/readers/by-card/${Uri.encodeComponent(code.trim())}'));

  Future<BookCopy> findCopy(String code) async =>
      BookCopy.fromJson(await _api.get('/copies/by-code/${Uri.encodeComponent(code.trim())}'));

  Future<LoanView> checkout({required int readerId, required String copyCode}) async =>
      LoanView.fromJson(await _api.post('/loans', {'readerId': readerId, 'copyCode': copyCode}));

  Future<LoanView> returnLoan(int loanId, {bool damaged = false, String? severity, String? note}) async =>
      LoanView.fromJson(
          await _api.post('/loans/$loanId/return', {'damaged': damaged, 'severity': severity, 'note': note}));

  Future<LoanView> renew(int loanId) async => LoanView.fromJson(await _api.post('/loans/$loanId/renew'));

  Future<LoanView> markLost(int loanId) async => LoanView.fromJson(await _api.post('/loans/$loanId/lost'));

  Future<List<LoanView>> myLoans() async {
    final list = await _api.get('/loans/mine') as List;
    return list.map((e) => LoanView.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// G3: endpoint GIẢ ĐỊNH, cần backend thêm. Trả null nếu không có phiếu đang mở.
  Future<OpenLoan?> findOpenLoanByCopy(String copyCode) async {
    try {
      final j = await _api.get('/loans/open', query: {'copyCode': copyCode.trim()});
      return OpenLoan.fromJson(j as Map<String, dynamic>);
    } on ApiException catch (e) {
      if (e.code == 'NOT_FOUND') return null;
      rethrow;
    }
  }
}
