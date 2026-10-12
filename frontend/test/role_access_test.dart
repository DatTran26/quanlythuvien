import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/core/auth/session.dart';
import 'package:frontend/core/routing/app_router.dart';
import 'package:frontend/core/routing/app_routes.dart';
import 'package:frontend/core/theme/app_theme.dart';
import 'package:frontend/features/access/data/auth_store.dart';
import 'package:frontend/features/accounts/screens/reader_list_screen.dart';
import 'package:frontend/features/notification/widgets/notification_bell.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));
  tearDown(AuthStore.signOut);

  test('tài khoản seed giữ đúng vai trò theo nghiệp vụ gốc', () async {
    for (final account in [
      ('admin@library.local', 'LIBRARIAN', 'Thủ thư', true, true),
      ('librarian@library.local', 'STAFF', 'Nhân viên', false, true),
      ('reader@library.local', 'READER', 'Người đọc', false, false),
    ]) {
      await AuthStore.login(account.$1, AuthStore.demoPassword);
      expect(AppSession.role, account.$2);
      expect(AppSession.roleLabel, account.$3);
      expect(AppSession.isLibrarian, account.$4);
      expect(AppSession.isStaff, account.$5);
      await AuthStore.signOut();
    }
  });

  for (final role in ['STAFF', 'READER']) {
    testWidgets('$role không mở được cấu hình của Thủ thư', (tester) async {
      AppSession.signIn(id: 2, nextRole: role, name: 'Người dùng', nextEmail: 'member@library.test');
      await tester.pumpWidget(MaterialApp(
        theme: buildTheme(Brightness.light),
        initialRoute: AppRoutes.adminConfig,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ));
      await tester.pumpAndSettle();
      expect(find.text('Tài khoản của bạn không có quyền mở màn này.'), findsOneWidget);
    });
  }

  testWidgets('Nhân viên thấy khu vực quầy và không thấy mục cấu hình', (tester) async {
    AppSession.signIn(id: 2, nextRole: 'STAFF', name: 'Nhân viên', nextEmail: 'librarian@library.local');
    await tester.pumpWidget(MaterialApp(
      theme: buildTheme(Brightness.light),
      onGenerateRoute: AppRouter.onGenerateRoute,
    ));
    await tester.pumpAndSettle();
    expect(find.text('Nhân viên'), findsOneWidget);
    expect(find.text('Quầy lưu thông'), findsOneWidget);
    expect(find.text('Nhập dữ liệu'), findsNothing);
    expect(find.text('Quy định mượn'), findsNothing);
  });

  testWidgets('Nhân viên không mở quản trị tài khoản và chỉ thấy thông báo của mình', (tester) async {
    AppSession.signIn(id: 2, nextRole: 'STAFF', name: 'Nhân viên', nextEmail: 'librarian@library.local');
    await tester.pumpWidget(MaterialApp(
      theme: buildTheme(Brightness.light),
      home: const ReaderListScreen(),
    ));
    await tester.pumpAndSettle();

    expect(find.byTooltip('Tài khoản Nhân viên'), findsNothing);
    expect(tester.widget<NotificationBell>(find.byType(NotificationBell)).userId, 2);
  });
}
