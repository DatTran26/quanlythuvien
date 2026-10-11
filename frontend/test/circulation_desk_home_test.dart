import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/core/auth/session.dart';
import 'package:frontend/core/routing/app_router.dart';
import 'package:frontend/core/routing/app_routes.dart';
import 'package:frontend/core/theme/app_theme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(AppSession.clear);

  testWidgets('quầy lưu thông quay về trang chủ bằng nút trái và mục trong menu', (tester) async {
    AppSession.signIn(
      id: 1,
      nextRole: 'ADMIN',
      name: 'Quản trị viên',
      nextEmail: 'admin@library.local',
    );
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: buildTheme(Brightness.light),
        initialRoute: AppRoutes.dashboard,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Quầy lưu thông'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Menu quầy'), findsOneWidget);

    await tester.tap(find.byTooltip('Trang chủ'));
    await tester.pumpAndSettle();
    expect(find.text('Nhập dữ liệu'), findsOneWidget);
    expect(find.byTooltip('Menu quầy'), findsNothing);

    await tester.tap(find.text('Quầy lưu thông'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Menu quầy'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Trang chủ'));
    await tester.pumpAndSettle();

    expect(find.text('Nhập dữ liệu'), findsOneWidget);
    expect(find.byTooltip('Menu quầy'), findsNothing);
  });
}
