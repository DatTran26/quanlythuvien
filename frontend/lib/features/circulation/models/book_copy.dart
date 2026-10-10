// Model bản sao sách (BookCopy) nhận từ API.
// Bài: Hoang/01-nen-tang/03-goi-api-va-shared-preferences.md, 02-checkout/02-checkout-scan.md
//
// API trả về (GET /copies/by-code/{code}):
//   { id, code, status, shelf, version,
//     title: { id, name, author, isbn, priceVnd, loanable, active } }
//
// TODO:
// - class BookCopy với các field trên (title lồng: tạo class TitleRef nhỏ hoặc gom field).
// - factory BookCopy.fromJson(Map<String, dynamic> json).
// - getter canBorrow: status == 'AVAILABLE' (hoặc 'ON_HOLD' đúng chủ, kiểm ở màn).
// - status là chuỗi enum backend: AVAILABLE, ON_LOAN, ON_HOLD, PENDING_REVIEW,
//   IN_REPAIR, LOST, DISPOSED. Không tự đặt tên khác.
