// Màn 5 – Quét trả sách (return-scan). Route: /return/scan
// Bài: 03-return-handling/01-return-scan.md · Độ khó ⭐⭐⭐
//
// Mục đích: quét mã sách -> tìm phiếu đang mở -> chọn tình trạng -> "Ghi nhận trả".
// Người đọc bị khóa VẪN trả được: không kiểm tra điều kiện người đọc ở đây.
//
// TODO:
// - Ô nhập mã sách + camera (quét 1 lần).
// - Gọi findOpenLoanByCopy() (G3: tạm dùng mock). Không có phiếu -> lỗi dưới ô (E-core-008).
// - Thẻ phiếu mượn: người đọc, đầu sách, hạn trả, số ngày trễ.
// - RadioListTile: Bình thường / Hư hỏng. Chọn Hư hỏng thì AnimatedSize hiện thêm:
//   mức độ (LIGHT/MEDIUM/HEAVY, bắt buộc) + mô tả (bắt buộc).
// - Nút Filled "Ghi nhận trả" -> returnLoan() -> pushReplacement return-result với ReturnOutcome.
// - Lối tắt "Ghi nhận mất" -> lost-record (mất sách không đi qua màn này).
