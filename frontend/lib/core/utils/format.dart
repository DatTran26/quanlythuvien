import 'package:intl/intl.dart';

/// 55000 -> "55.000đ" chuyển đơn vị sang tiền việt nam để dễ đọc.
String formatVnd(int amount) {
  final digits = amount.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
    buffer.write(digits[i]);
  }
  return '$bufferđ';
}

/// 2026-10-05 -> "05/10/2026" chuyển sang định dang ngày/tháng/năm để dễ đọc.
String formatDate(DateTime date) {
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(date.day)}/${two(date.month)}/${date.year}';
}

// DateFormat cần initializeDateFormatting('vi') trong main() trước khi dùng.
final _date = DateFormat('dd/MM/yyyy');
final _dateTime = DateFormat('dd/MM/yyyy HH:mm');
final _money = NumberFormat.decimalPattern('vi_VN');

String fmtDate(DateTime d) => _date.format(d.toLocal());
String fmtDateTime(DateTime d) => _dateTime.format(d.toLocal());
String fmtMoney(int vnd) => '${_money.format(vnd)} đ'; // 24000 -> "24.000 đ"
