// Màn 2 – Quét phiên mượn (checkout-scan). Route: /checkout/scan
// Bài: 02-checkout/02-checkout-scan.md · Độ khó ⭐⭐⭐ (bài quan trọng nhất)
//
// Mục đích: quét thẻ người đọc (D1) rồi quét từng cuốn sách vào giỏ (D2), kiểm tra ngay khi quét.
// Đến từ: circulation-desk. Đi tới: checkout-review (khi giỏ có ≥ 1 cuốn).
//
// TODO:
// - StatefulWidget, state: Reader? _reader, List<BookCopy> _cart, lỗi từng ô.
// - D1: ô nhập mã thẻ + nút camera (QrScanPage của TV1, quét 1 lần).
//   Không tìm thấy -> lỗi dưới ô. Bị khóa/chưa kích hoạt -> banner đỏ, KHÔNG cho quét sách.
// - D2: ô nhập mã sách + camera quét liên tục. Một hàm _addCopy(code) dùng chung cho cả hai.
//   Loại cuốn lỗi (không AVAILABLE, trùng mã, trùng đầu sách), giữ nguyên cuốn hợp lệ.
// - Giỏ: ListView + Dismissible để vuốt xóa; Badge đếm số cuốn.
// - PopScope: hỏi xác nhận khi thoát mà giỏ còn sách.
// - Lưu nháp mã sách bằng SharedPreferences, khôi phục khi mở lại.
// - Điện thoại: không autofocus (tránh bật bàn phím). Web: 2 cột + phím tắt (bài 0.6).
// - Nút Filled duy nhất: "Rà soát mượn" -> push checkout-review với CheckoutSession.
//
// Lỗ hổng G2: chưa biết số cuốn đang mượn / nợ phạt ở bước này.
