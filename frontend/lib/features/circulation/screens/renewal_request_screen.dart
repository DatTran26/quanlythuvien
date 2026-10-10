// Màn 7 – Yêu cầu gia hạn (renewal-request). Route: /renewal/request · Release R1B
// Bài: 04-renewal/01-renewal-request.md · Độ khó ⭐⭐
//
// Mục đích: chọn các phiếu đang mượn để gia hạn.
// - Người đọc: thấy phiếu của mình (GET /loans/mine).
// - Thủ thư: quét mã sách để thêm phiếu (cần G3 như màn trả).
//
// TODO:
// - CheckboxListTile cho từng phiếu. Dòng không gia hạn được thì tắt checkbox + lý do bên dưới:
//   · đã quá hạn -> "Đã quá hạn, cần trả sách"
//   · renewCount >= maxRenewals (1) -> "Đã hết lượt gia hạn"
// - Có người đặt trước / người đọc bị chặn: chỉ biết khi gửi, hiện ở renewal-result.
// - Nút Filled "Gia hạn N cuốn": gọi renew() từng phiếu, gom kết quả -> renewal-result.
