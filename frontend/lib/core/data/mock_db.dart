// Đọc docs/_shared/mock-data.json (bản copy trong assets/mock/) khi app chưa nối API.
// Dùng chung cho cả 3 thành viên. TV3 tạo, cần nhóm duyệt qua PR nhỏ.
// Khai báo asset trong pubspec.yaml: assets/mock/mock-data.json

import 'dart:convert';

import 'package:flutter/services.dart';

/// Đọc mock-data.json một lần, giữ trong bộ nhớ để các màn dùng chung.
class MockDb {
  MockDb._(this._data);

  final Map<String, dynamic> _data;
  static MockDb? _instance;

  static Future<MockDb> load() async {
    if (_instance != null) return _instance!;
    final text = await rootBundle.loadString('assets/mock/mock-data.json');
    _instance = MockDb._(jsonDecode(text) as Map<String, dynamic>);
    return _instance!;
  }

  /// Lấy một "bảng", ví dụ table('shared', 'users').
  List<Map<String, dynamic>> table(String section, String key) =>
      (_data[section][key] as List).cast<Map<String, dynamic>>();

  /// Lấy một bản ghi đơn (không phải danh sách), ví dụ object('shared', 'lendingPolicy').
  Map<String, dynamic> object(String section, String key) =>
      _data[section][key] as Map<String, dynamic>;

  /// Mốc "hiện tại" của bộ dữ liệu. Tính quá hạn theo mốc này, không theo đồng hồ máy.
  DateTime get now => DateTime.parse(_data['_meta']['referenceNow'] as String);
}
