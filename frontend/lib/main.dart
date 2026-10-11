// TẠM THỜI để chạy thử các màn TV2. main.dart là phần của TV1 (Đạt): khi Đạt làm khung app,
// giữ 3 điểm sau: initializeDateFormatting('vi'), theme/darkTheme, onGenerateRoute.

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/routing/app_router.dart';
import 'core/routing/app_routes.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('vi'); // DateFormat(..., 'vi') cần dữ liệu ngôn ngữ (bài 02-checkout/01)
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quản lý thư viện',
      debugShowCheckedModeBanner: false,
      // Bắt buộc: các màn lấy màu bằng Theme.of(context).extension<AppColors>()!,
      // thiếu theme thì extension là null và màn báo lỗi đỏ.
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      // Mở thẳng màn quầy; nút ← ở quầy quay về trang chủ (TV1, đang là màn tạm).
      initialRoute: AppRoutes.circulationDesk,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
