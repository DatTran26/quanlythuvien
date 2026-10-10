// Màn 15 – Hàng đợi đặt trước (reservation-queue). Route: /reservation/queue · R2
// Bài: 07-reservation/03-reservation-queue.md · Độ khó ⭐⭐⭐
//
// Mục đích: người đọc xem đặt trước của mình theo trạng thái.
//
// TODO:
// - TabBar 3 tab, "Sẵn sàng" đứng đầu vì gấp:
//   · Sẵn sàng (READY): đếm ngược tới readyUntil (giữ 48h, Timer.periodic), nút Hủy.
//   · Đang chờ (WAITING): ngày đặt (vị trí hàng chờ ẩn vì G9), nút Hủy.
//   · Lịch sử (FULFILLED / EXPIRED / CANCELLED): chỉ xem.
// - Hủy -> dialog xác nhận -> cancel(), tải lại danh sách.
// - RefreshIndicator kéo để tải lại.
// - Thủ thư: lối sang reservation-pickup.
