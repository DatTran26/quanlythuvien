// Một dòng ở reader-list: tài khoản + mã thẻ.

import 'app_user.dart';

class ReaderRow {
  final AppUser user;
  final String? cardCode;

  const ReaderRow({required this.user, required this.cardCode});
}
