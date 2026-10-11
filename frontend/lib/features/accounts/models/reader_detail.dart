// Dữ liệu màn reader-detail: hồ sơ + nghĩa vụ đang mở tính từ bảng khác.

import 'app_user.dart';

class ReaderDetail {
  final AppUser user;
  final String? cardCode;
  final int openLoans;
  final int openReservations;
  final int debtVnd;

  const ReaderDetail({
    required this.user,
    required this.cardCode,
    required this.openLoans,
    required this.openReservations,
    required this.debtVnd,
  });
}
