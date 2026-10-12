import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/core/theme/app_theme.dart';
import 'package:frontend/core/widgets/qr_scan_page.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

const _scannerMethod = MethodChannel('dev.steenbakker.mobile_scanner/scanner/method');

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    final messenger = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(_scannerMethod, (call) async {
      switch (call.method) {
        case 'state':
          return 1; // authorized
        case 'start':
          throw PlatformException(code: 'genericError', message: 'no camera in test');
        default:
          return null;
      }
    });
    for (final name in const [
      'dev.steenbakker.mobile_scanner/scanner/event',
      'dev.steenbakker.mobile_scanner/scanner/deviceOrientation',
    ]) {
      messenger.setMockStreamHandler(
        EventChannel(name),
        MockStreamHandler.inline(onListen: (arguments, sink) {}, onCancel: (arguments) {}),
      );
    }
  });

  tearDown(() {
    final messenger = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(_scannerMethod, null);
    for (final name in const [
      'dev.steenbakker.mobile_scanner/scanner/event',
      'dev.steenbakker.mobile_scanner/scanner/deviceOrientation',
    ]) {
      messenger.setMockStreamHandler(EventChannel(name), null);
    }
    MobileScannerController.resetPlatformSessionOwner();
  });

  testWidgets('đóng hộp nhập mã tay không làm vỡ cây widget', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(theme: buildTheme(Brightness.light), home: const QrScanPage(title: 'Quét sách')),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    await tester.tap(find.text('Nhập tay'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.text('Nhập mã thủ công'), findsOneWidget);

    await tester.tap(find.text('Hủy'));
    await tester.pump();
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 20));
    }

    expect(tester.takeException(), isNull);
    expect(find.text('Nhập mã thủ công'), findsNothing);
    expect(find.text('Nhập tay'), findsOneWidget);
  });

  testWidgets('dùng mã tay trả mã và đóng màn quét một lần', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    String? scanned;
    await tester.pumpWidget(
      MaterialApp(
        theme: buildTheme(Brightness.light),
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              scanned = await scanQrOnce(context, title: 'Quét sách');
            },
            child: const Text('Mở quét'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Mở quét'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    await tester.tap(find.text('Nhập tay'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    await tester.enterText(find.byType(TextField), 'CP-001');
    await tester.tap(find.text('Dùng mã này'));
    await tester.pump();
    for (var i = 0; i < 30; i++) {
      await tester.pump(const Duration(milliseconds: 20));
    }

    expect(tester.takeException(), isNull);
    expect(scanned, 'CP-001');
    expect(find.text('Mở quét'), findsOneWidget);
  });
}
