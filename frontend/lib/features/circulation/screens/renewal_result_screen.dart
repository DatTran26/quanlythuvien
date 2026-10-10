// Màn 8 – Kết quả gia hạn (renewal-result). Route: /renewal/result · Release R1B
// Bài: 04-renewal/02-renewal-result.md · Độ khó ⭐⭐
//
// Mục đích: cho biết từng phiếu gia hạn thành công hay bị chặn.
//
// TODO:
// - Nhận danh sách kết quả (thành công: LoanView mới; thất bại: mã lỗi).
// - Thành công: hạn cũ gạch ngang -> hạn mới in đậm (+7 ngày), số lần gia hạn.
// - Bị chặn: lý do + gợi ý theo mã (dùng error_text.dart):
//   RENEW_STATUS, RENEW_LIMIT, RENEW_QUEUE, READER_INACTIVE, STALE_COPY.
// - Nút "Xong" quay lại màn trước.
