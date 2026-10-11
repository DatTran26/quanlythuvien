// Đổi mã lỗi backend thành câu dễ hiểu kèm cách khắc phục.
// Bài: Hoang/01-nen-tang/03-goi-api-va-shared-preferences.md mục 6

import '../../../core/network/api_client.dart';

/// Trả về (câu lỗi, gợi ý khắc phục).
(String, String?) describeError(ApiException e) => switch (e.code) {
      'READER_INACTIVE' => (
          'Người đọc chưa được kích hoạt hoặc đang bị khóa.',
          'Mở hồ sơ người đọc để kích hoạt hoặc mở khóa.'
        ),
      'OVERDUE_BLOCK' => ('Người đọc còn sách quá hạn.', 'Nhận trả sách quá hạn trước khi mượn tiếp.'),
      'FINE_BLOCK' => ('Người đọc còn khoản phạt chưa thanh toán.', 'Thu phạt rồi quay lại mượn.'),
      'LOAN_LIMIT' => ('Người đọc đã đạt giới hạn số cuốn đang mượn.', 'Trả bớt sách hoặc bỏ bớt cuốn khỏi giỏ.'),
      'NOT_LOANABLE' => ('Bản sao này không cho mượn về.', 'Chọn bản sao khác của cùng đầu sách.'),
      'DUPLICATE_TITLE' => ('Người đọc đang mượn một cuốn cùng đầu sách.', 'Bỏ cuốn này khỏi giỏ.'),
      'HOLD_OWNER' => ('Bản sao đang được giữ cho người đọc khác.', 'Xem hàng đợi đặt trước hoặc chọn bản khác.'),
      'HOLD_MISSING' => ('Bản sao đang giữ nhưng không còn lượt đặt trước hợp lệ.', 'Tải lại trạng thái sách.'),
      'STALE_COPY' || 'CONFLICT' => ('Sách vừa được cập nhật ở quầy khác.', 'Tải trạng thái mới rồi thử lại.'),
      'RENEW_STATUS' => ('Phiếu đã quá hạn hoặc đã đóng nên không gia hạn được.', 'Nhận trả sách và thu phạt nếu có.'),
      'RENEW_LIMIT' => ('Phiếu đã hết lượt gia hạn.', 'Nhắc người đọc trả đúng hạn.'),
      'RENEW_QUEUE' => ('Có người đang đặt trước đầu sách này.', 'Nhắc người đọc trả đúng hạn, có thể đặt trước lại sau.'),
      'LOAN_CLOSED' => ('Phiếu mượn đã đóng trước đó.', 'Kiểm tra lại mã sách vừa quét.'),
      'NOT_FOUND' => (e.message, 'Kiểm tra lại mã, quét lại hoặc nhập tay.'),
      'NETWORK' => (e.message, null),
      _ => (e.message, null),
    };
