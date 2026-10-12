// Phiên mượn: người đọc + giỏ sách. Truyền từ checkout-scan sang checkout-review.
// Bài: Hoang/02-checkout/02-checkout-scan.md (Bước 1)

import 'book_copy.dart';
import 'reader.dart';

class CheckoutSession {
  CheckoutSession({required this.reader, required this.copies});

  final Reader reader;
  final List<BookCopy> copies;
}
