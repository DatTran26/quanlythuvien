// API mất sách (lost-handling).
// Bài: 06-lost-handling/01-lost-record.md, 02-found-after-lost.md
//
// TODO:
// - Future<LoanView> markLost(int loanId) -> POST /loans/{id}/lost
//   Lặp lại -> backend trả LOAN_CLOSED, không tạo khoản bồi thường thứ hai.
// - Future<void> markFound(String copyCode) -> FAKE (G6: chưa có endpoint, R1B).
//   Giữ đúng tên hàm để sau thay bằng API thật.
