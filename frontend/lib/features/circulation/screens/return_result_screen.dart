// Màn 6 – Kết quả trả (return-result). Route: /return/result
// Bài: 03-return-handling/02-return-result.md · Độ khó ⭐⭐
//
// Mục đích: xác nhận đã nhận trả và cho biết bước tiếp theo.
//
// TODO:
// - Nhận ReturnOutcome qua arguments.
// - Banner thành công + thông tin phiếu (luôn có).
// - Trả trễ: banner cảnh báo "Phát sinh phạt quá hạn N ngày" + nút "Thu phạt" -> /fines/payment (TV3).
// - Hư hỏng: banner thông tin "Bản sao chuyển sang Chờ duyệt, đã lập báo cáo hư hỏng".
// - Nút: "Quét cuốn tiếp" (Filled, về return-scan), "Gia hạn sách khác" (R1B -> renewal-request),
//   "Về quầy".
// - Cần xác nhận với nhóm: nút gia hạn ở đây là gia hạn các cuốn KHÁC người đọc đang mượn.
