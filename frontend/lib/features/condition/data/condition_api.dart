// API hư hỏng (damage-lifecycle). Bài: Hoang/05-damage-lifecycle/01 và 02
//
// Lỗ hổng:
// - G4: backend nhận 1 ảnh (field "photo"), tài liệu muốn 1–5.
// - G5: chưa có GET /damage-reports và /{id}: màn chi tiết nhận báo cáo truyền từ màn trước.
// - disposition chưa nhận "reason" dù UI bắt nhập lý do -> cần thêm vào DecisionRequest.

import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../../../core/network/api_client.dart';
import '../models/damage_report.dart';

class ConditionApi {
  final _api = ApiClient.instance;

  Future<DamageReport> report({
    required int copyId,
    required String severity,
    required String note,
    required List<Uint8List> photos,
  }) async {
    final files = [
      for (var i = 0; i < photos.length; i++)
        http.MultipartFile.fromBytes(
          'photo', // tên field backend đọc: @RequestPart photo
          photos[i],
          filename: 'damage_$i.jpg',
          contentType: MediaType('image', 'jpeg'),
        ),
    ];
    final j = await _api.postMultipart('/damage-reports',
        fields: {'copyId': '$copyId', 'severity': severity, 'note': note}, files: files);
    return DamageReport.fromJson(j as Map<String, dynamic>);
  }

  Future<DamageReport> decide(int reportId, String decision) async =>
      DamageReport.fromJson(await _api.post('/damage-reports/$reportId/disposition', {'decision': decision}));

  Future<void> repairComplete(int copyId) => _api.post('/copies/$copyId/repair-complete');

  /// Tải ảnh bằng chứng về dạng bytes (gắn token). Dùng Image.memory thay Image.network
  /// để không bị CORS trên web và chạy được với backend giả.
  Future<Uint8List> photoBytes(String path) async =>
      Uint8List.fromList(await _api.getBytes('/files/${Uri.encodeComponent(path.split('/').last)}'));
}
