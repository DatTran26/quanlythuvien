// Các hàm gọi API cho mượn / trả / gia hạn / mất.
// Bài: 01-nen-tang/03-goi-api-va-shared-preferences.md, các bài 02–04
// Dùng ApiClient của TV1 (core/network/api_client.dart): tự gắn Bearer token, ném lỗi {code, message}.
//
// TODO (mỗi hàm một API):
// - Future<Reader> findReaderByCard(String code)   -> GET  /readers/by-card/{code}
// - Future<BookCopy> findCopyByCode(String code)   -> GET  /copies/by-code/{code}
// - Future<LoanView> checkout(int readerId, String copyCode) -> POST /loans
// - Future<LoanView> returnLoan(int loanId, {bool damaged, String? severity, String? note})
//                                                  -> POST /loans/{id}/return
// - Future<LoanView> renew(int loanId)             -> POST /loans/{id}/renew
// - Future<List<LoanView>> myLoans()               -> GET  /loans/mine
// - Future<LoanView?> findOpenLoanByCopy(String copyCode)
//
// Lỗ hổng:
// - G1: chưa có POST /loans/batch -> checkout-review gọi checkout() lần lượt từng cuốn.
// - G3: chưa có GET /loans/open?copyCode= -> findOpenLoanByCopy() tạm đọc từ mock-data
//   (docs/_shared/mock-data.json, shared.loans) cho tới khi backend thêm endpoint.
