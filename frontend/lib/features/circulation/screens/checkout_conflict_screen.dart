// Màn 4 – Xung đột checkout (checkout-conflict). Route: /checkout/conflict
// Bài: 02-checkout/04-checkout-conflict.md · Độ khó ⭐⭐
//
// Mục đích: hai quầy cùng mượn một bản sao, quầy sau nhận 409 STALE_COPY.
// Giải thích ngắn (không đổ lỗi thủ thư), hiện trạng thái mới của từng cuốn chưa ghi.
// Đến từ: checkout-review (truyền danh sách cuốn chưa ghi).
//
// TODO:
// - Tải lại trạng thái từng cuốn bằng findCopyByCode().
// - Hiện chip trạng thái mới (status_mapping).
// - 2 lựa chọn:
//   · "Tải trạng thái mới và rà soát lại" -> pop(true), review bỏ cuốn không còn mượn được.
//   · "Hủy phiên" -> về circulation-desk.
// - Ghi chú cho người dùng: chưa có gì được ghi cho cuốn xung đột, thử lại an toàn.
