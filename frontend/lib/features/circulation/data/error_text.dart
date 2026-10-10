// Đổi mã lỗi backend thành câu tiếng Việt + gợi ý cách khắc phục.
// Bài: 02-checkout/03-checkout-review.md (mục 8), 04-renewal/02-renewal-result.md
//
// TODO:
// - String errorText(String code) và String? errorHint(String code).
// - Các mã cần có: READER_INACTIVE, OVERDUE_BLOCK, FINE_BLOCK, LOAN_LIMIT, NOT_LOANABLE,
//   DUPLICATE_TITLE, HOLD_MISSING, HOLD_OWNER, STALE_COPY, CONFLICT, RENEW_STATUS,
//   RENEW_LIMIT, RENEW_QUEUE, LOAN_CLOSED, NOT_FOUND, VALIDATION.
// - Mã lạ -> trả message gốc từ backend. Lỗi luôn có chữ, không chỉ đổi màu.
