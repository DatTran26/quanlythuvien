// Màn 11 – Ghi nhận mất (lost-record). Route: /lost/record
// Bài: 06-lost-handling/01-lost-record.md · Độ khó ⭐⭐
//
// Mục đích: người đọc báo mất sách, thủ thư ghi nhận. Một giao dịch:
// phiếu -> LOST, bản sao -> LOST, phát sinh bồi thường (BR-06: 100% giá sách + phí xử lý).
// Đến từ: return-scan (truyền LoanView) hoặc damage-report-detail (truyền mã bản sao).
//
// TODO:
// - Thẻ thông tin phiếu + giá sách + số tiền bồi thường dự kiến.
// - CheckboxListTile "Tôi đã đối chiếu với người đọc" -> mới bật nút.
//   Nút Danger tắt kèm 1 dòng lý do khi chưa tích.
// - Nút Danger "Ghi nhận mất" -> dialog xác nhận (thao tác không hoàn tác) -> markLost().
// - Sách đang nằm trên kệ (không có phiếu mở): báo "Chỉ ghi nhận mất cho sách đang được mượn".
// - Sau khi ghi: nút "Thu bồi thường" -> /fines/payment (TV3), hoặc về quầy.
