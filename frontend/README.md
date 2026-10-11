# frontend – App Flutter Quản lý Thư viện

## Cài đặt lần đầu / sau khi kéo code mới

Trong thư mục `frontend/`:

```bash
flutter pub get
```

Lệnh này đọc `pubspec.yaml` và `pubspec.lock`, tải **đúng phiên bản** mọi thư viện dự án đang dùng. `flutter run` cũng tự chạy lệnh này khi `pubspec.yaml` thay đổi.

## Thêm thư viện mới

```bash
flutter pub add <tên_thư_viện>
```

- Lệnh tự ghi vào `pubspec.yaml` và cập nhật `pubspec.lock`. **Commit cả hai file.**
- `pubspec.yaml` là file dùng chung: báo nhóm trước khi thêm, tránh hai người thêm hai thư viện cùng việc.
- Ghi một dòng vào `CHANGELOG.md` (mục **Thêm**).

| Thư viện | Dùng cho | Thêm bởi |
|---|---|---|
| `qr_flutter` | Hiện mã QR thẻ người đọc (`reader_portal`) | TV3 |
| `flutter_localizations` (có sẵn trong Flutter SDK) | Tiếng Việt cho widget có sẵn: lịch chọn ngày dd/MM/yyyy, nút OK/Hủy | TV3 |

## Tiếng Việt

`MaterialApp` (trong `main.dart`) cần 3 dòng sau, nếu thiếu thì lịch chọn ngày sẽ đọc theo kiểu Mỹ (tháng/ngày/năm):

```dart
locale: const Locale('vi'),
supportedLocales: const [Locale('vi'), Locale('en')],
localizationsDelegates: GlobalMaterialLocalizations.delegates,
```

Kèm `import 'package:flutter_localizations/flutter_localizations.dart';`.

## Chạy và kiểm tra

```bash
flutter analyze
flutter run -d chrome
```

- `flutter analyze` phải không lỗi (yêu cầu của `plans/261009-0650-flutter-spring-thesis-stack/phase-04-flutter-shell.md`).
- App kiểm tra **bằng tay** theo checklist của từng feature: `docs/features/<feature>/test/checklist/checklist-feature.md` (Mobile 375, dữ liệu giả). Test tự động chỉ áp dụng cho backend (`apps/api`, `./mvnw verify`).

Chỉ format phần mình phụ trách, ví dụ `dart format lib/features/accounts`. Không chạy `dart format lib` vì sẽ đổi cả file của người khác (`core/theme`).

## Cấu trúc

- `lib/core/` – dùng chung (theme của TV1, `data/mock_db.dart`, `utils/format.dart`).
- `lib/features/<module>/{models,data,widgets,screens}` – mỗi thành viên làm trong module của mình.
- `assets/mock/mock-data.json` – bản copy của `docs/_shared/mock-data.json`, dùng khi chưa nối API.

Lịch sử thay đổi: `CHANGELOG.md`.
