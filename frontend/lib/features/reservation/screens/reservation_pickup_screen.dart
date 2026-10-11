// Màn 16 – Nhận sách đặt trước (reservation-pickup). Route: /reservation/pickup · R2
// Bài: 07-reservation/04-reservation-pickup.md · Độ khó ⭐⭐
//
// Mục đích: người đọc đến quầy nhận sách đang giữ.
//
// TODO:
// - Quét thẻ người đọc, rồi quét bản sao đang giữ (ON_HOLD).
// - Kiểm tra: bản sao đang giữ, đúng người đặt, còn hạn nhận.
// - Lỗi: HOLD_OWNER "Sách đang giữ cho người đọc khác"; hết hạn nhận "Lượt giữ đã hết hạn"
//   + gợi ý đặt lại hoặc mượn trực tiếp; bản sao không ở trạng thái giữ -> hiện trạng thái hiện tại.
// - Nút "Xác nhận nhận sách" -> push checkout-review với CheckoutSession 1 cuốn
//   (dùng lại màn rà soát, backend tự chuyển Reservation sang FULFILLED).
