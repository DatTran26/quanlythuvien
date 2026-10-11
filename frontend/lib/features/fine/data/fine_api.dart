// API khoản phạt cho thủ thư / quản trị viên và người đọc.
//
// API backend tương ứng:
// - policy()              -> GET  /policy (chỉ LIBRARIAN, ADMIN: T14)
// - finesOfReader(id)     -> chưa có (T9). Người đọc tự xem: GET /fines/mine
// - debtOf(id)            -> chưa có, tạm cộng từ finesOfReader
// - readerByCard(code)    -> GET  /readers/by-card/{code}
// - fineDetail(id)        -> chưa có (T9)
// - collect(...)          -> POST /fines/{id}/collect (backend thu toàn bộ, chưa thu một phần: T10;
//                            chưa nhận operationId: T15)
// - events(id)            -> chưa có (T8)
// - waive(...)            -> POST /fines/{id}/waive { reason } (chỉ ADMIN)
// - adjust(...)           -> chưa có (T10)
//
// Lỗ hổng:
// - T8: chưa có ledger fine_transaction, biên nhận không được lưu.
// - T9: chưa có GET /readers/{id}/fines, chi tiết khoản phạt cho thủ thư.
// - T10: /collect chỉ thu toàn bộ, chưa thu một phần; chưa có điều chỉnh, hoàn tiền.
// - T14: người đọc chưa đọc được mức phạt / ngưỡng chặn (GET /policy chỉ cho nhân viên).
// - T15: /collect chưa có idempotency key (BR-fine-collection-basic-001).
//
// Chưa làm (chờ quyết định): hoàn tiền / đảo bút toán (OQ-fine-collection-adv-001),
// đối soát cuối ca (FR-fine-collection-adv-003, OQ-fine-collection-adv-002),
// mẫu biên nhận chính thức (OQ-fine-collection-adv-003).
// BR-fine-collection-adv-001 (người tạo khoản phạt thủ công không tự miễn): app chưa có
// chức năng tạo khoản phạt thủ công nên chưa phát sinh.

import 'package:frontend/core/data/mock_db.dart';

import '../models/fine.dart';
import '../models/fine_policy.dart';
import '../models/fine_transaction.dart';

/// Lỗi nghiệp vụ, cùng dạng { code, message } mà backend trả về.
class FineException implements Exception {
  const FineException(this.code, this.message);

  final String code;
  final String message;

  @override
  String toString() => message;
}

/// Người đọc tìm được khi quét / nhập mã thẻ.
typedef FineReader = ({int id, String name, String cardCode, String status});

/// Khoản phạt kèm thông tin để hiển thị cho thủ thư.
typedef FineDetail = ({
  Fine fine,
  FineReader reader,
  String? titleName,
  String? copyCode,
});

/// Kết quả thu tiền: duplicate = true khi cùng operationId đã được ghi trước đó (E-core-005).
typedef PaymentResult = ({FineTransaction transaction, bool duplicate});

abstract class FineApi {
  Future<FinePolicy> policy();
  Future<List<Fine>> finesOfReader(int readerId);
  Future<int> debtOf(int readerId);
  Future<FineReader?> readerByCard(String cardCode);
  Future<FineDetail> fineDetail(int fineId);
  Future<List<FineTransaction>> events(int fineId);
  Future<bool> canAdjust(int actorId);
  Future<PaymentResult> collect({
    required int fineId,
    required int amountVnd,
    required int actorId,
    required String operationId,
  });
  Future<FineTransaction> waive({
    required int fineId,
    required String reason,
    required int actorId,
  });
  Future<FineTransaction> adjust({
    required int fineId,
    required int deltaVnd,
    required String reason,
    required int actorId,
  });
}

class MockFineApi implements FineApi {
  // ---- Bài 4A ----
  @override
  Future<FinePolicy> policy() async {
    final db = await MockDb.load();
    return FinePolicy.fromJson(db.object('shared', 'lendingPolicy'));
  }

  @override
  Future<List<Fine>> finesOfReader(int readerId) async {
    final db = await MockDb.load();
    final fines = db
        .table('shared', 'fines')
        .where((f) => f['readerId'] == readerId)
        .map(Fine.fromJson)
        .toList();
    // Khoản còn nợ lên trước, trong mỗi nhóm thì mới nhất trước.
    fines.sort((a, b) {
      if (a.isOpen != b.isOpen) return a.isOpen ? -1 : 1;
      return b.createdAt.compareTo(a.createdAt);
    });
    return fines;
  }

  @override
  Future<int> debtOf(int readerId) async {
    final fines = await finesOfReader(readerId);
    return fines
        .where((f) => f.isOpen)
        .fold<int>(0, (sum, f) => sum + f.balanceVnd);
  }

  // ---- Bài 5: fine-collection-basic ----
  @override
  Future<FineReader?> readerByCard(String cardCode) async {
    final db = await MockDb.load();
    final code = cardCode.trim().toUpperCase();
    final profile = db
        .table('shared', 'readerProfiles')
        .where((p) => p['cardCode'] == code)
        .firstOrNull;
    if (profile == null) return null;
    return _reader(db, profile['userId'] as int);
  }

  @override
  Future<FineDetail> fineDetail(int fineId) async {
    final db = await MockDb.load();
    final fine = Fine.fromJson(_fineRow(db, fineId));
    final loan = db
        .table('shared', 'loans')
        .where((l) => l['id'] == fine.loanId)
        .firstOrNull;
    final title = loan == null
        ? null
        : db
              .table('shared', 'titles')
              .where((t) => t['id'] == loan['titleId'])
              .firstOrNull;
    final copy = loan == null
        ? null
        : db
              .table('shared', 'copies')
              .where((c) => c['id'] == loan['copyId'])
              .firstOrNull;
    return (
      fine: fine,
      reader: _reader(db, fine.readerId),
      titleName: title?['name'] as String?,
      copyCode: copy?['code'] as String?,
    );
  }

  @override
  Future<bool> canAdjust(int actorId) async {
    final db = await MockDb.load();
    return _role(db, actorId) == 'ADMIN';
  }

  @override
  Future<PaymentResult> collect({
    required int fineId,
    required int amountVnd,
    required int actorId,
    required String operationId,
  }) async {
    final db = await MockDb.load();
    final txs = db.table('tv3', 'fineTransactions');

    // BR-fine-collection-basic-001: cùng operationId thì trả lại khoản thu đã ghi, không ghi lần hai.
    final earlier = txs
        .where((t) => t['operationId'] == operationId)
        .firstOrNull;
    if (earlier != null) {
      return (transaction: _tx(db, earlier), duplicate: true);
    }

    // CHK-fine-collection-basic-007: thủ thư chỉ được ghi PAYMENT; người đọc không được ghi gì.
    final role = _role(db, actorId);
    if (role != 'LIBRARIAN' && role != 'ADMIN') {
      throw const FineException(
        'FORBIDDEN',
        'Chỉ thủ thư hoặc quản trị viên được thu tiền',
      );
    }
    final row = _openFineRow(db, fineId);
    final balance = row['balanceVnd'] as int;
    if (amountVnd <= 0) {
      throw const FineException('VALIDATION', 'Số tiền thu phải lớn hơn 0');
    }
    if (amountVnd > balance) {
      throw const FineException('OVER_BALANCE', 'Số tiền thu vượt số còn nợ');
    }

    // Kiểm tra xong mới ghi: số dư, trạng thái, sự kiện, audit.
    row['balanceVnd'] = balance - amountVnd;
    if (row['balanceVnd'] == 0) row['status'] = 'PAID';
    final tx = {
      'id': _nextId(txs),
      'fineId': fineId,
      'type': 'PAYMENT',
      'method': 'CASH',
      'amountVnd': amountVnd,
      'receiptNo': _nextReceiptNo(db),
      'actorId': actorId,
      'reason': null,
      'createdAt': db.now.toIso8601String(),
      'operationId': operationId,
    };
    txs.add(tx);
    _audit(
      db,
      actorId,
      'FINE_COLLECT',
      fineId,
      '${tx['receiptNo']} · $amountVndđ',
    );
    return (transaction: _tx(db, tx), duplicate: false);
  }

  @override
  Future<List<FineTransaction>> events(int fineId) async {
    final db = await MockDb.load();
    final row = _fineRow(db, fineId);
    // Sự kiện ghi nhận phạt (ASSESSMENT) dựng từ chính khoản phạt: mock chưa lưu riêng.
    final assessment = FineTransaction(
      id: 0,
      fineId: fineId,
      type: 'ASSESSMENT',
      method: null,
      amountVnd: row['amountVnd'] as int,
      receiptNo: null,
      actorId: null,
      actorName: 'Hệ thống',
      reason: row['note'] as String?,
      createdAt: DateTime.parse(row['createdAt'] as String),
    );
    final others =
        db
            .table('tv3', 'fineTransactions')
            .where((t) => t['fineId'] == fineId)
            .map((t) => _tx(db, t))
            .toList()
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return [assessment, ...others];
  }

  // ---- Bài 6: fine-collection-adv ----
  @override
  Future<FineTransaction> waive({
    required int fineId,
    required String reason,
    required int actorId,
  }) async {
    final db = await MockDb.load();
    _requireAdmin(db, actorId);
    final why = _requireReason(reason);
    final row = _openFineRow(db, fineId);
    final balance = row['balanceVnd'] as int;
    row['balanceVnd'] = 0;
    row['status'] = 'WAIVED';
    final tx = _addTx(db, fineId, 'WAIVER', balance, actorId, why);
    _audit(db, actorId, 'FINE_WAIVE', fineId, '$balanceđ · $why');
    return _tx(db, tx);
  }

  @override
  Future<FineTransaction> adjust({
    required int fineId,
    required int deltaVnd,
    required String reason,
    required int actorId,
  }) async {
    final db = await MockDb.load();
    _requireAdmin(db, actorId);
    final why = _requireReason(reason);
    if (deltaVnd == 0) {
      throw const FineException('VALIDATION', 'Số tiền điều chỉnh phải khác 0');
    }
    final row = _openFineRow(db, fineId);
    final next = (row['balanceVnd'] as int) + deltaVnd;
    if (next <= 0) {
      // Đưa nợ về 0 là miễn, phải dùng chức năng Miễn để ghi đúng loại sự kiện.
      throw const FineException(
        'USE_WAIVER',
        'Điều chỉnh làm số dư về 0 hoặc âm. Hãy dùng chức năng Miễn.',
      );
    }
    row['balanceVnd'] = next;
    final tx = _addTx(db, fineId, 'ADJUSTMENT', deltaVnd, actorId, why);
    _audit(
      db,
      actorId,
      'FINE_ADJUST',
      fineId,
      '${deltaVnd > 0 ? '+' : ''}$deltaVndđ · $why',
    );
    return _tx(db, tx);
  }

  // ---- Hàm dùng chung trong file ----

  Map<String, dynamic> _fineRow(MockDb db, int fineId) => db
      .table('shared', 'fines')
      .firstWhere(
        (f) => f['id'] == fineId,
        orElse: () =>
            throw const FineException('NOT_FOUND', 'Không thấy khoản phạt'),
      );

  /// Giống FineService.open() ở backend: khoản đã đóng thì không thu / miễn nữa (E-core-008).
  Map<String, dynamic> _openFineRow(MockDb db, int fineId) {
    final row = _fineRow(db, fineId);
    if (row['status'] != 'OPEN' || (row['balanceVnd'] as int) <= 0) {
      throw const FineException('FINE_CLOSED', 'Khoản phạt đã đóng');
    }
    return row;
  }

  FineReader _reader(MockDb db, int userId) {
    final user = db
        .table('shared', 'users')
        .firstWhere((u) => u['id'] == userId);
    final profile = db
        .table('shared', 'readerProfiles')
        .where((p) => p['userId'] == userId)
        .firstOrNull;
    return (
      id: userId,
      name: user['displayName'] as String,
      cardCode: profile?['cardCode'] as String? ?? '—',
      status: user['status'] as String,
    );
  }

  String? _role(MockDb db, int userId) =>
      db
              .table('shared', 'users')
              .where((u) => u['id'] == userId)
              .firstOrNull?['role']
          as String?;

  void _requireAdmin(MockDb db, int actorId) {
    if (_role(db, actorId) != 'ADMIN') {
      throw const FineException(
        'FORBIDDEN',
        'Chỉ quản trị viên được miễn hoặc điều chỉnh phạt',
      );
    }
  }

  String _requireReason(String reason) {
    final why = reason.trim();
    if (why.isEmpty) {
      throw const FineException('REASON_REQUIRED', 'Cần nhập lý do');
    }
    return why;
  }

  int _nextId(List<Map<String, dynamic>> rows) => rows.isEmpty
      ? 1
      : rows.map((r) => r['id'] as int).reduce((a, b) => a > b ? a : b) + 1;

  /// Mã biên nhận duy nhất `BL-năm-số thứ tự 4 chữ số`, tăng từ số lớn nhất đang có.
  String _nextReceiptNo(MockDb db) {
    final year = db.now.year;
    final numbers = db
        .table('tv3', 'fineTransactions')
        .map((t) => t['receiptNo'] as String?)
        .whereType<String>()
        .where((no) => no.startsWith('BL-$year-'))
        .map((no) => int.parse(no.split('-').last));
    final next = numbers.isEmpty
        ? 1
        : numbers.reduce((a, b) => a > b ? a : b) + 1;
    return 'BL-$year-${next.toString().padLeft(4, '0')}';
  }

  Map<String, dynamic> _addTx(
    MockDb db,
    int fineId,
    String type,
    int amountVnd,
    int actorId,
    String reason,
  ) {
    final txs = db.table('tv3', 'fineTransactions');
    final tx = <String, dynamic>{
      'id': _nextId(txs),
      'fineId': fineId,
      'type': type,
      'method': null,
      'amountVnd': amountVnd,
      'receiptNo': null,
      'actorId': actorId,
      'reason': reason,
      'createdAt': db.now.toIso8601String(),
    };
    txs.add(tx);
    return tx;
  }

  FineTransaction _tx(MockDb db, Map<String, dynamic> row) {
    final actor = db
        .table('shared', 'users')
        .where((u) => u['id'] == row['actorId'])
        .firstOrNull;
    return FineTransaction.fromJson(
      row,
      actorName: actor?['displayName'] as String? ?? 'Hệ thống',
    );
  }

  void _audit(
    MockDb db,
    int actorId,
    String action,
    int fineId,
    String detail,
  ) {
    final logs = db.table('tv3', 'auditLogs');
    logs.add({
      'id': _nextId(logs),
      'actorId': actorId,
      'action': action,
      'entityType': 'fine',
      'entityId': '$fineId',
      'detail': detail,
      'createdAt': db.now.toIso8601String(),
    });
  }
}
