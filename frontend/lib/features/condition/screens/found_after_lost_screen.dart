// Màn 12 – Tìm lại sau khi mất (found-after-lost). Route: /lost/found · Release R1B
// Bài: 06-lost-handling/02-found-after-lost.md · Độ khó ⭐⭐ · CHƯA CÓ API (G6)
//
// Mục đích: sách đã Mất nay tìm thấy. Phải đối soát tài chính XONG trước khi cho lưu thông lại
// (BR-lost-handling-001).
//
// TODO:
// - Quét mã bản sao đang LOST.
// - Hiện tình trạng khoản bồi thường: chưa thu (hủy về 0) / đã thu (hoàn theo chính sách).
// - Chưa có phê duyệt tài chính -> chỉ ghi "Đã tìm thấy, chờ đối soát", bản sao vẫn LOST.
// - Sau đối soát: LOST -> AVAILABLE, hoặc ON_HOLD nếu có hàng chờ đặt trước.
// - Gọi markFound() (Fake API trong lost_api.dart).
