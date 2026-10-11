import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/core/auth/session.dart';
import 'package:frontend/features/access/data/auth_store.dart';
import 'package:frontend/features/catalog/data/catalog_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() async {
    await AuthStore.signOut();
  });

  test('admin đăng nhập bằng email và mật khẩu seed', () async {
    await AuthStore.login('admin@library.local', AuthStore.demoPassword);
    expect(AppSession.isAdmin, isTrue);
    expect(AppSession.displayName, 'Quản trị viên');
  });

  test('người đọc đăng nhập bằng mã thẻ', () async {
    await AuthStore.login('R10000001', AuthStore.demoPassword);
    expect(AppSession.isReader, isTrue);
    expect(AppSession.email, 'reader@library.local');
  });

  test('sai mật khẩu không lộ tài khoản có tồn tại hay không', () async {
    await expectLater(
      AuthStore.login('khong-co@library.local', 'sai'),
      throwsA(isA<AuthException>().having((e) => e.code, 'code', 'BAD_CREDENTIALS')),
    );
  });

  test('tài khoản khóa và tài khoản chờ không vào được', () async {
    await expectLater(
      AuthStore.login('giang.vo@student.local', AuthStore.demoPassword),
      throwsA(isA<AuthException>().having((e) => e.code, 'code', 'LOCKED')),
    );
    await expectLater(
      AuthStore.login('em.hoang@student.local', AuthStore.demoPassword),
      throwsA(isA<AuthException>().having((e) => e.code, 'code', 'PENDING')),
    );
  });

  test('danh mục đọc được đầu sách và lô import', () async {
    final store = await CatalogStore.instance.load();
    expect(store.titles, isNotEmpty);
    expect(store.batches, isNotEmpty);
    expect(store.policy.loanDays, 14);
  });
}
