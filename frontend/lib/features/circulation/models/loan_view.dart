// Model phiếu mượn rút gọn (LoanView) mà API mượn/trả/gia hạn/mất trả về.
// Bài: 02-checkout/03-checkout-review.md, 03-return-handling/01-return-scan.md
//
// API: { id, readerId, copyCode, titleName, status, dueAt, renewCount }
//   status: ACTIVE, OVERDUE, RETURNED, LOST
//
// TODO:
// - class LoanView + fromJson. dueAt parse bằng DateTime.parse.
// - getter isOverdue, daysOverdue (so với ngày hiện tại).
// - getter canRenew dùng ở renewal-request: status == ACTIVE && renewCount < maxRenewals.
