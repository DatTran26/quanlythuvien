// Model người đọc lấy khi quét thẻ.
// Bài: 02-checkout/02-checkout-scan.md (Bước 3)
//
// API: GET /readers/by-card/{code} -> { id, email, displayName, role, status }
//
// TODO:
// - class Reader { id, email, displayName, role, status, cardCode }.
// - factory Reader.fromJson(...).
// - getter isActive: status == 'ACTIVE'. PENDING / LOCKED thì không cho quét sách.
//
// Lỗ hổng G2: API chưa trả số cuốn đang mượn và nợ phạt. Chưa thêm field đó,
// lỗi OVERDUE_BLOCK / FINE_BLOCK / LOAN_LIMIT chỉ biết khi bấm xác nhận ở checkout-review.
