// Dữ liệu cổng người đọc (reader-self-service): sách, thẻ, phiếu mượn, công nợ của chính mình.
// Bài: TV3 3
//
// Dữ liệu cổng người đọc (reader-self-service). Chỉ dữ liệu của chính người đọc (BR-core-004).
//
// API backend tương ứng:
// - myCard()   -> GET /me (T5: chưa có cardCode, hạn thẻ)
// - myLoans()  -> GET /loans/mine (T6: chưa có borrowedAt, returnedAt)
// - now()      -> API thật dùng DateTime.now(); mock dùng mốc referenceNow
// - (3B) searchTitles(q) -> GET /titles?q= (T7: chưa có số bản sẵn sàng, kệ, lọc thể loại)
// - (4B) myFines()       -> GET /fines/mine
// - (4B) finePolicy()    -> GET /policy (chỉ nhân viên: T14)
//
// Lỗ hổng:
// - T5: /me chưa trả cardCode, chưa có hạn thẻ.
// - T6: LoanView chưa có borrowedAt, returnedAt -> lịch sử chưa hiện được ngày trả từ API.
// - T7: GET /titles chưa trả số bản sẵn sàng, vị trí kệ; chưa lọc thể loại.

import 'package:frontend/core/data/mock_db.dart';
import 'package:frontend/core/utils/text_search.dart';
import 'package:frontend/features/fine/data/fine_api.dart';
import 'package:frontend/features/fine/models/fine.dart';
import 'package:frontend/features/fine/models/fine_policy.dart';

import '../models/my_card.dart';
import '../models/my_loan.dart';
import '../models/title_summary.dart';

abstract class PortalApi {
  Future<DateTime> now();
  Future<MyCard> myCard();
  Future<List<MyLoan>> myLoans();
  Future<List<CategoryItem>> categories();
  Future<List<TitleSummary>> searchTitles({
    String query = '',
    int? categoryId,
    bool availableOnly = false,
  });
  Future<TitleSummary> titleDetail(int titleId);
  Future<List<Fine>> myFines();
  Future<FinePolicy> finePolicy();
}

class MockPortalApi implements PortalApi {
  /// Người đọc đang đăng nhập. Tạm mặc định #3; khi có đăng nhập (TV1) thì lấy từ phiên.
  MockPortalApi({this.readerId = 3});

  final int readerId;

  /// Phần phạt dùng lại MockFineApi của feature fine, không viết lại.
  final FineApi _fines = MockFineApi();
  @override
  Future<DateTime> now() async => (await MockDb.load()).now;

  @override
  Future<MyCard> myCard() async {
    final db = await MockDb.load();
    final user = db
        .table('shared', 'users')
        .firstWhere((u) => u['id'] == readerId);
    final profile = db
        .table('shared', 'readerProfiles')
        .where((p) => p['userId'] == readerId)
        .firstOrNull;
    return MyCard(
      displayName: user['displayName'] as String,
      status: user['status'] as String,
      cardCode: profile?['cardCode'] as String?,
    );
  }

  @override
  Future<List<MyLoan>> myLoans() async {
    final db = await MockDb.load();
    final titles = {
      for (final t in db.table('shared', 'titles'))
        t['id'] as int: t['name'] as String,
    };
    final copies = {
      for (final c in db.table('shared', 'copies'))
        c['id'] as int: c['code'] as String,
    };
    final prices = {
      for (final t in db.table('shared', 'titles'))
        t['id'] as int: t['priceVnd'] as int,
    };
    return db
        .table('shared', 'loans')
        .where((l) => l['readerId'] == readerId)
        // Ghép thành đúng dạng JSON mà API trả về, rồi dùng chung fromJson.
        .map(
          (l) => MyLoan.fromJson({
            ...l,
            'titleName': titles[l['titleId']],
            'copyCode': copies[l['copyId']],
            'priceVnd': prices[l['titleId']],
          }),
        )
        .toList();
  }

  // ---- Bài 3B ----
  @override
  Future<List<CategoryItem>> categories() async {
    final db = await MockDb.load();
    return [
      for (final c in db.table('shared', 'categories'))
        (id: c['id'] as int, name: c['name'] as String),
    ];
  }

  @override
  Future<List<TitleSummary>> searchTitles({
    String query = '',
    int? categoryId,
    bool availableOnly = false,
  }) async {
    final all = await _summaries();
    return all
        .where(
          (t) =>
              matchesQuery(t.name, query) ||
              matchesQuery(t.author, query) ||
              (t.isbn ?? '').contains(query.trim()),
        )
        .where((t) => categoryId == null || t.categoryId == categoryId)
        .where((t) => !availableOnly || t.availableCount > 0)
        .toList();
  }

  @override
  Future<TitleSummary> titleDetail(int titleId) async {
    final all = await _summaries();
    return all.firstWhere((t) => t.id == titleId);
  }

  // ---- Bài 4B ----
  @override
  Future<List<Fine>> myFines() => _fines.finesOfReader(readerId);

  @override
  Future<FinePolicy> finePolicy() => _fines.policy();

  /// Ghép đầu sách + thể loại + bản sao thành TitleSummary. Bỏ đầu sách ngưng (active=false).
  Future<List<TitleSummary>> _summaries() async {
    final db = await MockDb.load();
    final categoryNames = {
      for (final c in db.table('shared', 'categories'))
        c['id'] as int: c['name'] as String,
    };
    final copies = db.table('shared', 'copies');
    return [
      for (final t in db.table('shared', 'titles'))
        if (t['active'] == true) _summary(t, categoryNames, copies),
    ];
  }

  TitleSummary _summary(
    Map<String, dynamic> title,
    Map<int, String> categoryNames,
    List<Map<String, dynamic>> copies,
  ) {
    final loanable = title['loanable'] as bool;
    final own = copies.where((c) => c['titleId'] == title['id']);
    // Bản đã mất, đã thanh lý không còn là tài sản của thư viện.
    final kept = own.where(
      (c) => c['status'] != 'LOST' && c['status'] != 'DISPOSED',
    );
    final onShelf = own.where((c) => c['status'] == 'AVAILABLE');
    // Mượn về được: đang trên kệ, đầu sách cho mượn, bản sao không bị ghi đè "không cho mượn".
    final borrowable = loanable
        ? onShelf.where((c) => c['loanableOverride'] != false).length
        : 0;
    final categoryId = title['categoryId'] as int?;
    return TitleSummary(
      id: title['id'] as int,
      name: title['name'] as String,
      author: title['author'] as String,
      isbn: title['isbn'] as String?,
      categoryId: categoryId,
      categoryName: categoryNames[categoryId] ?? 'Chưa phân loại',
      loanable: loanable,
      totalCopies: kept.length,
      availableCount: borrowable,
      shelves: {for (final c in onShelf) c['shelf'] as String}.toList()..sort(),
    );
  }
}
