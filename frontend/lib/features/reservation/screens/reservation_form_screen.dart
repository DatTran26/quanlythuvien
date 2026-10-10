// Màn 14 – Biểu mẫu đặt trước (reservation-form). Route: /reservation/form · R2
// Bài: 07-reservation/02-reservation-form.md · Độ khó ⭐⭐
//
// Mục đích: xác nhận đặt trước một đầu sách. Thành công -> Reservation WAITING, xếp cuối hàng FIFO
// -> chuyển sang reservation-queue.
//
// TODO:
// - Nhận TitleItem qua arguments, hiện thông tin đầu sách.
// - Checklist điều kiện cho người dùng biết trước: tài khoản hoạt động, không quá hạn, nợ trong
//   ngưỡng; đặt trước đang mở < 3; chưa đặt đầu sách này; đầu sách đã hết bản.
// - LoadingButton "Xác nhận đặt trước" -> create().
// - Lỗi:
//   STILL_AVAILABLE -> nút "Mượn trực tiếp tại quầy"
//   RESERVE_LIMIT   -> nút "Xem hàng đợi của tôi"
//   READER_INACTIVE -> chỉ báo lỗi
//   CONFLICT        -> "Bạn đã đặt trước đầu sách này" + xem hàng đợi
