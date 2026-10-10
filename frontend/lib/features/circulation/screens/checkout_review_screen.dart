// Màn 3 – Rà soát mượn (checkout-review). Route: /checkout/review
// Bài: 02-checkout/03-checkout-review.md · Độ khó ⭐⭐⭐
//
// Mục đích: xem lại giỏ, bấm "Xác nhận mượn", thành công thì hiện biên nhận ngay trên màn
// (FR-checkout-003: tên thư viện, mã phiếu, ngày giờ, người đọc, danh sách cuốn + hạn trả, thủ thư).
// Đến từ: checkout-scan, reservation-pickup (1 cuốn).
//
// TODO:
// - Nhận CheckoutSession qua arguments.
// - Danh sách cuốn + hạn trả dự kiến (hôm nay + 14 ngày).
// - _submit(): LoadingButton, chặn bấm lặp. Gọi checkout() lần lượt từng cuốn,
//   dừng ở lỗi đầu tiên, báo rõ cuốn nào đã mượn / chưa (G1).
// - Kết quả:
//   · Thành công -> hiện biên nhận; "Giao dịch mới" về circulation-desk (xóa stack).
//   · STALE_COPY / CONFLICT -> push checkout-conflict.
//   · OVERDUE_BLOCK / FINE_BLOCK / LOAN_LIMIT / READER_INACTIVE -> ở lại, banner đỏ + cách khắc phục.
//   · Mất mạng -> banner + nút Thử lại.
// - Nút "In biên nhận" tắt, Tooltip "Chưa cấu hình máy in" (OQ-checkout-001).
