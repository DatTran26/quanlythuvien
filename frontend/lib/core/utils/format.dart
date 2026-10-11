// Định dạng ngày và tiền. Bài: Hoang/01-nen-tang/03-goi-api-va-shared-preferences.md
// DateFormat cần initializeDateFormatting('vi') trong main() trước khi dùng.
import 'package:intl/intl.dart';

final _date = DateFormat('dd/MM/yyyy');
final _dateTime = DateFormat('dd/MM/yyyy HH:mm');
final _money = NumberFormat.decimalPattern('vi_VN');

String fmtDate(DateTime d) => _date.format(d.toLocal());
String fmtDateTime(DateTime d) => _dateTime.format(d.toLocal());
String fmtMoney(int vnd) => '${_money.format(vnd)} đ'; // 24000 -> "24.000 đ"
