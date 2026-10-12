// API client dùng chung. Bài: Hoang/01-nen-tang/03-goi-api-va-shared-preferences.md mục 3
//
// Phân công: phần này thuộc TV1 (Đạt). Bản này viết theo bài học để các màn TV2 chạy được.
//
// Khác bài học: gửi request qua một http.Client. Mặc định là BACKEND GIẢ (mock_backend.dart)
// vì chưa có màn đăng nhập và backend chưa chạy cố định. Muốn gọi backend Spring thật:
//   flutter run --dart-define=REAL_API=true

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

import 'mock_backend.dart';
import 'token_store.dart';

/// Lỗi từ API, khớp body {"code","message"} của ApiExceptionHandler bên Spring.
class ApiException implements Exception {
  ApiException(this.status, this.code, this.message);

  final int status; // 0 = lỗi mạng
  final String code; // VD: LOAN_LIMIT, STALE_COPY
  final String message; // câu tiếng Việt backend gửi

  bool get isConflict => status == 409;
  bool get isNetwork => status == 0;
  bool get isUnauthorized => status == 401 || status == 403;

  @override
  String toString() => '$code: $message';
}

class ApiClient {
  ApiClient._();
  static final instance = ApiClient._(); // dùng chung 1 đối tượng cho cả app

  /// false = dùng backend giả. Bật backend thật bằng --dart-define=REAL_API=true
  static const useRealApi = bool.fromEnvironment('REAL_API');

  // Web gọi localhost; máy ảo Android gọi 10.0.2.2 (= localhost của máy tính).
  static String get baseUrl => kIsWeb ? 'http://localhost:8080/api' : 'http://10.0.2.2:8080/api';
  static const _timeout = Duration(seconds: 15);

  final http.Client _client = useRealApi ? http.Client() : MockBackend.client();

  /// Gọi khi gặp 401 -> TV1 gắn hàm điều hướng sang màn session-expired.
  void Function()? onUnauthorized;

  Future<Map<String, String>> _headers({bool json = true}) async {
    final token = await TokenStore.read();
    return {
      if (json) 'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Uri _uri(String path, [Map<String, String>? query]) =>
      Uri.parse('$baseUrl$path').replace(queryParameters: query);

  Future<dynamic> get(String path, {Map<String, String>? query}) =>
      _send(() async => _client.get(_uri(path, query), headers: await _headers()));

  Future<dynamic> post(String path, [Object? body]) => _send(() async => _client.post(
        _uri(path),
        headers: await _headers(),
        body: body == null ? null : jsonEncode(body),
      ));

  /// Tải file (Excel/PDF, ảnh) về dạng bytes.
  Future<List<int>> getBytes(String path) async {
    final res = await _raw(() async => _client.get(_uri(path), headers: await _headers(json: false)));
    if (res.statusCode >= 200 && res.statusCode < 300) return res.bodyBytes;
    throw _toError(res);
  }

  /// Gửi form có file (báo hư kèm ảnh).
  Future<dynamic> postMultipart(
    String path, {
    required Map<String, String> fields,
    List<http.MultipartFile> files = const [],
  }) {
    return _send(() async {
      final req = http.MultipartRequest('POST', _uri(path))
        ..headers.addAll(await _headers(json: false))
        ..fields.addAll(fields)
        ..files.addAll(files);
      return http.Response.fromStream(await _client.send(req));
    });
  }

  // ---------- phần xử lý chung ----------

  Future<http.Response> _raw(Future<http.Response> Function() call) async {
    try {
      return await call().timeout(_timeout);
    } on TimeoutException {
      throw ApiException(0, 'NETWORK', 'Máy chủ phản hồi quá lâu. Kiểm tra mạng rồi thử lại.');
    } on http.ClientException {
      throw ApiException(0, 'NETWORK', 'Không kết nối được máy chủ. Kiểm tra mạng rồi thử lại.');
    }
  }

  Future<dynamic> _send(Future<http.Response> Function() call) async {
    final res = await _raw(call);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      if (res.bodyBytes.isEmpty) return null;
      return jsonDecode(utf8.decode(res.bodyBytes)); // utf8.decode để không lỗi tiếng Việt
    }
    final error = _toError(res);
    if (error.status == 401) onUnauthorized?.call();
    throw error;
  }

  ApiException _toError(http.Response res) {
    try {
      final body = jsonDecode(utf8.decode(res.bodyBytes));
      if (body is Map) {
        return ApiException(res.statusCode, '${body['code'] ?? 'UNKNOWN'}', '${body['message'] ?? 'Có lỗi xảy ra'}');
      }
    } catch (_) {}
    return switch (res.statusCode) {
      401 => ApiException(401, 'UNAUTHORIZED', 'Phiên đăng nhập đã hết. Vui lòng đăng nhập lại.'),
      403 => ApiException(403, 'FORBIDDEN', 'Tài khoản của bạn không có quyền thực hiện thao tác này.'),
      _ => ApiException(res.statusCode, 'UNKNOWN', 'Có lỗi xảy ra (mã ${res.statusCode}).'),
    };
  }
}
