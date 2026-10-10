// Phiên mượn: người đọc + giỏ sách. Truyền từ checkout-scan sang checkout-review.
// Bài: 02-checkout/02-checkout-scan.md (Bước 1)
//
// TODO:
// - class CheckoutSession { Reader reader; List<BookCopy> items; }
// - Hàm kiểm tra khi thêm sách: trùng mã bản sao, trùng đầu sách (DUPLICATE_TITLE).
// - Giới hạn tối đa 5 cuốn đang mượn (lendingPolicy.maxActiveLoans), hạn mượn 14 ngày.
// - toDraftJson(): chỉ lưu MÃ bản sao để lưu nháp bằng SharedPreferences (Bước 7),
//   khôi phục thì tra lại API vì trạng thái sách có thể đã đổi.
