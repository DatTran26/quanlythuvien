// Màn 19 – Dashboard xu hướng (trend-dashboard). Route: /reports/trends · R2
// Bài: 08-reports/03-trend-dashboard.md · Độ khó ⭐⭐⭐
//
// Mục đích: xem xu hướng lượt mượn/trả theo thời gian.
//
// TODO:
// - CupertinoSlidingSegmentedControl chọn Ngày / Tuần / Tháng.
// - RP-03: gọi trends(from, to) cho từng khoảng, vẽ biểu đồ cột bằng Container
//   (2 cột mượn/trả mỗi khoảng) + chú thích chữ + Tooltip số.
// - StatTile tổng mượn, tổng trả phía trên.
// - RP-05 phạt, RP-06 top sách, RP-07 hư hỏng: G10 chưa có API -> thẻ "Chưa có dữ liệu".
// - Nút xuất Excel/PDF tắt kèm lý do (chưa có API cho xu hướng).
