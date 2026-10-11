// API tìm lại sách đã mất. Bài: Hoang/06-lost-handling/02-found-after-lost.md (Bước 1)
// Ghi nhận mất dùng CirculationApi.markLost (POST /loans/{id}/lost).
//
// G6: backend CHƯA có endpoint "tìm lại sau khi mất" (R1B) -> dùng FakeLostApi.
// Màn hình chỉ biết LostApi (abstract): có backend thì viết HttpLostApi implements LostApi,
// đổi vế phải ở màn hình, không sửa gì khác.

enum FoundOutcome { pendingReconciliation, backToShelf, heldForReservation }

abstract class LostApi {
  Future<FoundOutcome> markFound(int copyId);
}

/// Dùng tạm cho tới khi backend có endpoint (G6).
class FakeLostApi implements LostApi {
  @override
  Future<FoundOutcome> markFound(int copyId) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return FoundOutcome.pendingReconciliation; // mặc định: chờ đối soát
  }
}
