// Lưu token đăng nhập (JWT). Bài: Hoang/01-nen-tang/03-goi-api-va-shared-preferences.md mục 2
// shared_preferences không mã hóa: chấp nhận cho đồ án, app thật nên dùng flutter_secure_storage.
import 'package:shared_preferences/shared_preferences.dart';

class TokenStore {
  static const _key = 'access_token';

  static Future<void> save(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, token);
  }

  static Future<String?> read() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
