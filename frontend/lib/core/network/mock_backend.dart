// BACKEND GIẢ để dựng và bấm thử màn hình khi chưa có backend Spring / màn đăng nhập.
//
// - Dữ liệu ban đầu: assets/mock/mock-data.json (bản sao docs/_shared/mock-data.json).
// - Giữ trong bộ nhớ: mượn, trả, gia hạn… làm thay đổi dữ liệu cho tới khi tắt app.
// - Đường dẫn, JSON và mã lỗi bám theo LibraryController / *Service trong apps/api.
// - Có thêm GET /loans/open?copyCode= (lỗ hổng G3): backend thật CHƯA có endpoint này.
// - Người đang đăng nhập giả định: thủ thư #2 cho thao tác quầy, người đọc #3 cho các API "/mine".
//
// Tắt bản giả, gọi backend thật: flutter run --dart-define=REAL_API=true

import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

class MockBackend {
  MockBackend._();
  static final _instance = MockBackend._();

  /// http.Client trả lời mọi request bằng dữ liệu giả.
  static http.Client client() => MockClient(_instance._handle);

  /// Bỏ mọi thay đổi, nạp lại dữ liệu ban đầu ở request tới (dùng trong test).
  static void reset() {
    _instance._loaded = false;
    _instance._files.clear();
  }

  static const _staffId = 2; // thủ thư đang trực quầy
  static const _readerId = 3; // người đọc cho các API "/mine"
  static const _latency = Duration(milliseconds: 350);

  bool _loaded = false;
  late List<Map<String, dynamic>> _users, _profiles, _categories, _titles, _copies, _loans, _fines;
  late List<Map<String, dynamic>> _reservations, _damageReports;
  late Map<String, dynamic> _policy;
  final Map<String, List<int>> _files = {}; // ảnh hư hỏng đã tải lên

  // ---------------------------------------------------------------- nạp dữ liệu

  String? _raw; // nội dung file asset, chỉ đọc 1 lần; reset() giải mã lại từ chuỗi này

  Future<void> _load() async {
    if (_loaded) return;
    _raw ??= await rootBundle.loadString('assets/mock/mock-data.json');
    final data = jsonDecode(_raw!) as Map<String, dynamic>;
    final shared = data['shared'] as Map<String, dynamic>;
    final tv2 = data['tv2'] as Map<String, dynamic>;
    List<Map<String, dynamic>> list(Object? v) => (v as List).cast<Map<String, dynamic>>();
    _users = list(shared['users']);
    _profiles = list(shared['readerProfiles']);
    _categories = list(shared['categories']);
    _titles = list(shared['titles']);
    _copies = list(shared['copies']);
    _loans = list(shared['loans']);
    _fines = list(shared['fines']);
    _policy = shared['lendingPolicy'] as Map<String, dynamic>;
    _reservations = list(tv2['reservations']);
    _damageReports = list(tv2['damageReports']);
    _loaded = true;
  }

  // ---------------------------------------------------------------- điều phối request

  Future<http.Response> _handle(http.Request req) async {
    await Future<void>.delayed(_latency); // giả độ trễ mạng để thấy trạng thái đang tải
    await _load();
    _markOverdue();

    final path = req.url.path.replaceFirst(RegExp(r'^.*?/api'), '');
    final seg = path.split('/').where((s) => s.isNotEmpty).toList();
    final q = req.url.queryParameters;
    final get = req.method == 'GET';
    final post = req.method == 'POST';

    try {
      return switch (seg) {
        ['readers', 'by-card', final code] when get => _readerByCard(Uri.decodeComponent(code)),
        ['copies', 'by-code', final code] when get => _ok(_copyJson(_copyByCode(Uri.decodeComponent(code)))),
        ['copies', final id, 'repair-complete'] when post => _repairComplete(int.parse(id)),
        ['loans'] when post => _checkout(_body(req)),
        ['loans', 'open'] when get => _openLoan(q['copyCode'] ?? ''),
        ['loans', 'mine'] when get => _ok([for (final l in _loans.where((l) => l['readerId'] == _readerId)) _loanView(l)]),
        ['loans', final id, 'return'] when post => _return(int.parse(id), _body(req)),
        ['loans', final id, 'renew'] when post => _renew(int.parse(id)),
        ['loans', final id, 'lost'] when post => _lost(int.parse(id)),
        ['damage-reports'] when post => _createDamage(req),
        ['damage-reports', final id, 'disposition'] when post => _decide(int.parse(id), _body(req)),
        ['files', final name] when get => _file(Uri.decodeComponent(name)),
        ['titles'] when get => _ok(_searchTitles(q['q'] ?? '')),
        ['reservations'] when post => _reserve(_body(req)),
        ['reservations', 'mine'] when get =>
          _ok([for (final r in _reservations.where((r) => r['readerId'] == _readerId)) _reservationJson(r)]),
        ['reservations', final id, 'cancel'] when post => _cancelReservation(int.parse(id)),
        ['reports', 'overdue'] when get => _ok(_overdueReport()),
        ['reports', 'inventory'] when get => _ok(_inventory()),
        ['reports', 'trends'] when get => _ok(_trends(q['from'], q['to'])),
        ['reports', final file] when get && (file.endsWith('.xlsx') || file.endsWith('.pdf')) =>
          http.Response.bytes(utf8.encode('Báo cáo quá hạn (bản giả)'), 200),
        _ => _err(404, 'NOT_FOUND', 'Backend giả chưa hỗ trợ ${req.method} $path'),
      };
    } on _MockError catch (e) {
      return _err(e.status, e.code, e.message);
    }
  }

  // ---------------------------------------------------------------- người đọc, bản sao

  http.Response _readerByCard(String code) {
    final profile = _profiles.where((p) => p['cardCode'] == code.trim().toUpperCase()).firstOrNull;
    if (profile == null) throw _MockError.notFound('Không thấy người đọc');
    final u = _user(profile['userId'] as int);
    return _ok({'id': u['id'], 'email': u['email'], 'displayName': u['displayName'], 'role': u['role'], 'status': u['status']});
  }

  Map<String, dynamic> _copyByCode(String code) =>
      _copies.where((c) => c['code'] == code.trim().toUpperCase()).firstOrNull ??
      (throw _MockError.notFound('Không thấy bản sao'));

  Map<String, dynamic> _copyById(int id) =>
      _copies.where((c) => c['id'] == id).firstOrNull ?? (throw _MockError.notFound('Không thấy bản sao'));

  Map<String, dynamic> _title(int id) => _titles.firstWhere((t) => t['id'] == id);
  Map<String, dynamic> _user(int id) => _users.firstWhere((u) => u['id'] == id);

  Map<String, dynamic> _titleJson(int id) {
    final t = _title(id);
    final cat = _categories.where((c) => c['id'] == t['categoryId']).firstOrNull;
    return {...t, 'category': cat}..remove('categoryId');
  }

  Map<String, dynamic> _copyJson(Map<String, dynamic> c) => {...c, 'title': _titleJson(c['titleId'] as int)}..remove('titleId');

  bool _copyLoanable(Map<String, dynamic> c) {
    final t = _title(c['titleId'] as int);
    return (c['loanableOverride'] as bool?) ?? (t['loanable'] == true && t['active'] == true);
  }

  // ---------------------------------------------------------------- phiếu mượn

  Map<String, dynamic> _loanView(Map<String, dynamic> l) => {
        'id': l['id'],
        'readerId': l['readerId'],
        'copyCode': _copyById(l['copyId'] as int)['code'],
        'titleName': _title(l['titleId'] as int)['name'],
        'status': l['status'],
        'dueAt': l['dueAt'],
        'renewCount': l['renewCount'],
      };

  Map<String, dynamic> _loan(int id) =>
      _loans.where((l) => l['id'] == id).firstOrNull ?? (throw _MockError.notFound('Không thấy phiếu mượn'));

  bool _open(Map<String, dynamic> l) => l['status'] == 'ACTIVE' || l['status'] == 'OVERDUE';

  void _markOverdue() {
    final now = DateTime.now();
    for (final l in _loans) {
      if (l['status'] == 'ACTIVE' && DateTime.parse(l['dueAt'] as String).isBefore(now)) l['status'] = 'OVERDUE';
    }
  }

  http.Response _checkout(Map<String, dynamic> body) {
    final readerId = (body['readerId'] as num).toInt();
    final reader = _user(readerId);
    if (reader['status'] != 'ACTIVE') {
      throw _MockError.conflict('READER_INACTIVE', 'Người đọc chưa được kích hoạt hoặc đang bị khóa');
    }
    final mine = _loans.where((l) => l['readerId'] == readerId && _open(l)).toList();
    if (mine.any((l) => l['status'] == 'OVERDUE')) throw _MockError.conflict('OVERDUE_BLOCK', 'Người đọc còn sách quá hạn');
    final debt = _fines
        .where((f) => f['readerId'] == readerId && f['status'] == 'OPEN')
        .fold<int>(0, (s, f) => s + (f['balanceVnd'] as int));
    if (debt >= (_policy['fineBlockVnd'] as int)) throw _MockError.conflict('FINE_BLOCK', 'Còn phạt chưa thu');
    if (mine.length >= (_policy['maxActiveLoans'] as int)) throw _MockError.conflict('LOAN_LIMIT', 'Đã mượn đủ số cuốn');

    final copy = _copyByCode(body['copyCode'] as String);
    if (!_copyLoanable(copy)) throw _MockError.conflict('NOT_LOANABLE', 'Bản sao không cho mượn');
    if (mine.any((l) => l['titleId'] == copy['titleId'])) throw _MockError.conflict('DUPLICATE_TITLE', 'Đang mượn đầu sách này');

    Map<String, dynamic>? hold;
    if (copy['status'] == 'ON_HOLD') {
      hold = _reservations.where((r) => r['heldCopyId'] == copy['id'] && r['status'] == 'READY').firstOrNull;
      if (hold == null) throw _MockError.conflict('HOLD_MISSING', 'Bản sao đang giữ nhưng không có phiếu đặt trước');
      if (hold['readerId'] != readerId) throw _MockError.conflict('HOLD_OWNER', 'Bản sao đang giữ cho người đọc khác');
    } else if (copy['status'] != 'AVAILABLE') {
      throw _MockError.conflict('STALE_COPY', 'Sách vừa được cập nhật');
    }

    final now = DateTime.now();
    final loan = {
      'id': _nextId(_loans),
      'copyId': copy['id'],
      'titleId': copy['titleId'],
      'readerId': readerId,
      'status': 'ACTIVE',
      'borrowedAt': _iso(now),
      'dueAt': _iso(now.add(Duration(days: _policy['loanDays'] as int))),
      'returnedAt': null,
      'renewCount': 0,
    };
    _loans.add(loan);
    copy['status'] = 'ON_LOAN';
    copy['version'] = (copy['version'] as int) + 1;
    if (hold != null) hold['status'] = 'FULFILLED';
    return _ok(_loanView(loan));
  }

  /// G3: endpoint giả định, backend thật chưa có.
  http.Response _openLoan(String copyCode) {
    final copy = _copyByCode(copyCode);
    final loan = _loans.where((l) => l['copyId'] == copy['id'] && _open(l)).firstOrNull;
    if (loan == null) throw _MockError.notFound('Không có phiếu mượn đang mở cho bản sao này');
    return _ok(_loanView(loan));
  }

  http.Response _return(int id, Map<String, dynamic> body) {
    final loan = _loan(id);
    if (!_open(loan)) throw _MockError.conflict('LOAN_CLOSED', 'Phiếu mượn đã đóng');
    final now = DateTime.now();
    final copy = _copyById(loan['copyId'] as int);
    final lateDays = now.difference(DateTime.parse(loan['dueAt'] as String)).inDays;

    loan['status'] = 'RETURNED';
    loan['returnedAt'] = _iso(now);
    if (lateDays > 0) {
      final amount = lateDays * (_policy['finePerDayVnd'] as int);
      _fines.add({
        'id': _nextId(_fines), 'loanId': id, 'readerId': loan['readerId'], 'amountVnd': amount,
        'balanceVnd': amount, 'reason': 'OVERDUE', 'status': 'OPEN', 'note': 'Trả trễ $lateDays ngày',
        'createdAt': _iso(now),
      });
    }
    if (body['damaged'] == true) {
      copy['status'] = 'PENDING_REVIEW';
      _damageReports.add({
        'id': _nextId(_damageReports), 'copyId': copy['id'], 'reporterId': _staffId, 'status': 'PENDING',
        'severity': body['severity'] ?? 'LIGHT', 'note': body['note'], 'photoPath': null, 'createdAt': _iso(now),
      });
    } else {
      _releaseCopy(copy);
    }
    return _ok(_loanView(loan));
  }

  http.Response _renew(int id) {
    final loan = _loan(id);
    if (loan['status'] != 'ACTIVE') {
      throw _MockError.conflict('RENEW_STATUS', 'Chỉ gia hạn phiếu đang mượn, chưa quá hạn');
    }
    if ((loan['renewCount'] as int) >= (_policy['maxRenewals'] as int)) {
      throw _MockError.conflict('RENEW_LIMIT', 'Đã hết lượt gia hạn');
    }
    if (_reservations.any((r) => r['titleId'] == loan['titleId'] && r['status'] == 'WAITING')) {
      throw _MockError.conflict('RENEW_QUEUE', 'Có người đang đặt trước đầu sách này');
    }
    final due = DateTime.parse(loan['dueAt'] as String).add(Duration(days: _policy['renewDays'] as int));
    loan['dueAt'] = _iso(due);
    loan['renewCount'] = (loan['renewCount'] as int) + 1;
    return _ok(_loanView(loan));
  }

  http.Response _lost(int id) {
    final loan = _loan(id);
    if (!_open(loan)) throw _MockError.conflict('LOAN_CLOSED', 'Phiếu mượn đã đóng');
    final copy = _copyById(loan['copyId'] as int);
    loan['status'] = 'LOST';
    copy['status'] = 'LOST';
    final price = _title(loan['titleId'] as int)['priceVnd'] as int;
    final amount = price + (_policy['lostProcessingFeeVnd'] as int);
    _fines.add({
      'id': _nextId(_fines), 'loanId': id, 'readerId': loan['readerId'], 'amountVnd': amount, 'balanceVnd': amount,
      'reason': 'LOST', 'status': 'OPEN', 'note': 'Bồi thường mất sách', 'createdAt': _iso(DateTime.now()),
    });
    return _ok(_loanView(loan));
  }

  /// Bản sao về kệ: nếu có người đang chờ đầu sách này thì giữ cho người đầu hàng.
  void _releaseCopy(Map<String, dynamic> copy) {
    final waiting = _reservations.where((r) => r['titleId'] == copy['titleId'] && r['status'] == 'WAITING').toList()
      ..sort((a, b) => (a['createdAt'] as String).compareTo(b['createdAt'] as String));
    if (waiting.isEmpty) {
      copy['status'] = 'AVAILABLE';
      return;
    }
    final next = waiting.first;
    next['status'] = 'READY';
    next['heldCopyId'] = copy['id'];
    next['readyUntil'] = _iso(DateTime.now().add(Duration(hours: _policy['holdHours'] as int)));
    copy['status'] = 'ON_HOLD';
  }

  // ---------------------------------------------------------------- hư hỏng

  http.Response _createDamage(http.Request req) {
    final parts = _multipart(req);
    final copy = _copyById(int.parse(utf8.decode(parts['copyId'] ?? [])));
    if (copy['status'] == 'DISPOSED') throw _MockError.conflict('CONFLICT', 'Bản sao đã thanh lý');
    final id = _nextId(_damageReports);
    String? photoPath;
    if (parts['photo'] != null) {
      photoPath = 'damage-$id.jpg';
      _files[photoPath] = parts['photo']!;
    }
    final report = {
      'id': id, 'copyId': copy['id'], 'reporterId': _staffId, 'status': 'PENDING',
      'severity': utf8.decode(parts['severity'] ?? utf8.encode('LIGHT')),
      'note': utf8.decode(parts['note'] ?? []), 'photoPath': photoPath, 'createdAt': _iso(DateTime.now()),
    };
    _damageReports.add(report);
    copy['status'] = 'PENDING_REVIEW';
    return _ok(report);
  }

  http.Response _decide(int id, Map<String, dynamic> body) {
    final report = _damageReports.where((r) => r['id'] == id).firstOrNull ??
        (throw _MockError.notFound('Không thấy báo cáo'));
    if (report['status'] != 'PENDING') throw _MockError.conflict('REPORT_CLOSED', 'Báo cáo đã được xử lý');
    final copy = _copyById(report['copyId'] as int);
    switch (body['decision']) {
      case 'REJECT':
        report['status'] = 'REJECTED';
        _releaseCopy(copy);
      case 'REPAIR':
        report['status'] = 'REPAIR';
        copy['status'] = 'IN_REPAIR';
      case 'DISPOSE':
        report['status'] = 'DISPOSED';
        copy['status'] = 'DISPOSED';
      default:
        throw _MockError(400, 'DECISION', 'Quyết định không hợp lệ');
    }
    return _ok(report);
  }

  http.Response _repairComplete(int copyId) {
    final copy = _copyById(copyId);
    if (copy['status'] != 'IN_REPAIR') throw _MockError.conflict('NOT_IN_REPAIR', 'Bản sao không đang sửa');
    _releaseCopy(copy);
    return _ok(_copyJson(copy));
  }

  http.Response _file(String name) {
    final bytes = _files[name];
    if (bytes == null) throw _MockError.notFound('Không thấy ảnh');
    return http.Response.bytes(bytes, 200, headers: {'content-type': 'image/jpeg'});
  }

  // ---------------------------------------------------------------- đặt trước

  List<Map<String, dynamic>> _searchTitles(String q) {
    final k = q.trim().toLowerCase();
    return [
      for (final t in _titles)
        if (t['active'] == true &&
            (k.isEmpty || '${t['name']} ${t['author']} ${t['isbn']}'.toLowerCase().contains(k)))
          _titleJson(t['id'] as int),
    ];
  }

  Map<String, dynamic> _reservationJson(Map<String, dynamic> r) {
    final u = _user(r['readerId'] as int);
    return {
      ...r,
      'title': {'id': r['titleId'], 'name': _title(r['titleId'] as int)['name']},
      'reader': {'id': u['id'], 'displayName': u['displayName']},
    }..remove('titleId')..remove('readerId');
  }

  http.Response _reserve(Map<String, dynamic> body) {
    final titleId = (body['titleId'] as num).toInt();
    if (_user(_readerId)['status'] != 'ACTIVE') {
      throw _MockError.conflict('READER_INACTIVE', 'Người đọc chưa được kích hoạt');
    }
    if (!_titles.any((t) => t['id'] == titleId)) throw _MockError.notFound('Không thấy đầu sách');
    if (_copies.any((c) => c['titleId'] == titleId && c['status'] == 'AVAILABLE' && _copyLoanable(c))) {
      throw _MockError.conflict('STILL_AVAILABLE', 'Đầu sách còn bản sẵn sàng, hãy mượn trực tiếp');
    }
    final open = _reservations.where((r) => r['readerId'] == _readerId && ['WAITING', 'READY'].contains(r['status']));
    if (open.length >= (_policy['maxOpenReservations'] as int)) {
      throw _MockError.conflict('RESERVE_LIMIT', 'Đã đủ số đặt trước đang mở');
    }
    if (open.any((r) => r['titleId'] == titleId)) {
      throw _MockError.conflict('CONFLICT', 'Dữ liệu bị trùng hoặc không còn hợp lệ');
    }
    final r = {
      'id': _nextId(_reservations), 'titleId': titleId, 'readerId': _readerId, 'status': 'WAITING',
      'heldCopyId': null, 'createdAt': _iso(DateTime.now()), 'readyUntil': null,
    };
    _reservations.add(r);
    return _ok(_reservationJson(r));
  }

  http.Response _cancelReservation(int id) {
    final r = _reservations.where((r) => r['id'] == id).firstOrNull ??
        (throw _MockError.notFound('Không thấy đặt trước'));
    if (!['WAITING', 'READY'].contains(r['status'])) throw _MockError.conflict('RESERVE_CLOSED', 'Phiếu đặt trước đã đóng');
    final wasReady = r['status'] == 'READY';
    r['status'] = 'CANCELLED';
    if (wasReady && r['heldCopyId'] != null) _releaseCopy(_copyById(r['heldCopyId'] as int));
    return _ok(_reservationJson(r));
  }

  // ---------------------------------------------------------------- báo cáo

  List<Map<String, dynamic>> _overdueReport() => [
        for (final l in _loans.where((l) => l['status'] == 'OVERDUE'))
          {
            'id': l['id'],
            'status': l['status'],
            'dueAt': l['dueAt'],
            'borrowedAt': l['borrowedAt'],
            'reader': {'id': l['readerId'], 'displayName': _user(l['readerId'] as int)['displayName']},
            'title': {'id': l['titleId'], 'name': _title(l['titleId'] as int)['name']},
            'copy': {'id': l['copyId'], 'code': _copyById(l['copyId'] as int)['code']},
          },
      ];

  List<List<Object>> _inventory() {
    final counts = <String, int>{};
    for (final c in _copies) {
      counts.update(c['status'] as String, (n) => n + 1, ifAbsent: () => 1);
    }
    return [for (final e in counts.entries) [e.key, e.value]];
  }

  Map<String, int> _trends(String? from, String? to) {
    final f = DateTime.parse(from ?? '2000-01-01');
    final t = DateTime.parse(to ?? '2100-01-01').add(const Duration(days: 1)); // tính hết ngày "to"
    bool inRange(Object? v) {
      if (v == null) return false;
      final d = DateTime.parse(v as String);
      return !d.isBefore(f) && d.isBefore(t);
    }

    return {
      'loans': _loans.where((l) => inRange(l['borrowedAt'])).length,
      'returns': _loans.where((l) => inRange(l['returnedAt'])).length,
    };
  }

  // ---------------------------------------------------------------- tiện ích

  static Map<String, dynamic> _body(http.Request req) =>
      req.body.isEmpty ? {} : jsonDecode(req.body) as Map<String, dynamic>;

  /// Tách form multipart thành {tên field: bytes}.
  static Map<String, List<int>> _multipart(http.Request req) {
    final type = req.headers['content-type'] ?? '';
    final boundary = RegExp(r'boundary=(.+)$').firstMatch(type)?.group(1);
    if (boundary == null) return {};
    final text = latin1.decode(req.bodyBytes); // latin1: mỗi byte một ký tự, không mất dữ liệu ảnh
    final result = <String, List<int>>{};
    for (final part in text.split('--$boundary')) {
      final split = part.indexOf('\r\n\r\n');
      if (split < 0) continue;
      final name = RegExp(r'name="([^"]+)"').firstMatch(part.substring(0, split))?.group(1);
      if (name == null) continue;
      var content = part.substring(split + 4);
      if (content.endsWith('\r\n')) content = content.substring(0, content.length - 2);
      result[name] = latin1.encode(content);
    }
    return result;
  }

  static int _nextId(List<Map<String, dynamic>> list) =>
      list.fold<int>(0, (m, e) => (e['id'] as int) > m ? e['id'] as int : m) + 1;

  static String _iso(DateTime d) => d.toIso8601String().split('.').first;

  static http.Response _ok(Object? body) => http.Response.bytes(
        utf8.encode(jsonEncode(body)),
        200,
        headers: {'content-type': 'application/json; charset=utf-8'},
      );

  static http.Response _err(int status, String code, String message) => http.Response.bytes(
        utf8.encode(jsonEncode({'code': code, 'message': message})),
        status,
        headers: {'content-type': 'application/json; charset=utf-8'},
      );
}

class _MockError implements Exception {
  _MockError(this.status, this.code, this.message);
  _MockError.notFound(this.message)
      : status = 404,
        code = 'NOT_FOUND';
  _MockError.conflict(this.code, this.message) : status = 409;

  final int status;
  final String code;
  final String message;
}
