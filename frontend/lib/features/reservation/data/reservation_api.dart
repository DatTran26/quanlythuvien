// API đặt trước. Bài: Hoang/07-reservation/01..04
// (Bài học gọi ApiClient thẳng trong màn; gom về đây để màn chỉ lo vẽ, giống circulation_api.)
//
// Nhận sách đặt trước dùng lại CirculationApi.checkout (POST /loans tự xử lý bản sao ON_HOLD).
// Lỗ hổng: G8 chỉ đặt được cho người đang đăng nhập; G9 chưa có vị trí trong hàng chờ.

import '../../../core/network/api_client.dart';
import '../models/reservation.dart';
import '../models/title_item.dart';

class ReservationApi {
  final _api = ApiClient.instance;

  Future<List<TitleItem>> searchTitles(String q) async {
    final list = await _api.get('/titles', query: {'q': q}) as List;
    return list.map((e) => TitleItem.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> create(int titleId) => _api.post('/reservations', {'titleId': titleId});

  Future<List<Reservation>> mine() async {
    final list = await _api.get('/reservations/mine') as List;
    return list.map((e) => Reservation.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> cancel(int id) => _api.post('/reservations/$id/cancel');
}
