import 'package:frontend/core/data/mock_db.dart';
import 'package:frontend/core/utils/text_search.dart';

/// Dữ liệu danh mục, kho, nhập liệu, quy định và backup. Đọc mock một lần rồi sửa trong bộ nhớ.
class CatalogStore {
  CatalogStore._();
  static final instance = CatalogStore._();

  var _loaded = false;
  final titles = <TitleRecord>[];
  final copies = <CopyRecord>[];
  final categories = <CategoryRecord>[];
  final batches = <ImportBatch>[];
  final backups = <BackupRun>[];
  LendingPolicy policy = LendingPolicy.empty();
  DateTime? policyEffectiveAt;
  String? lastPolicyNote;

  Future<CatalogStore> load() async {
    if (_loaded) return this;
    final db = await MockDb.load();
    titles.addAll(db.table('shared', 'titles').map(TitleRecord.fromJson));
    copies.addAll(db.table('shared', 'copies').map(CopyRecord.fromJson));
    categories.addAll(db.table('shared', 'categories').map(CategoryRecord.fromJson));
    batches.addAll(db.table('tv1', 'importBatches').map(ImportBatch.fromJson));
    backups.addAll(db.table('tv1', 'backupRuns').map(BackupRun.fromJson));
    policy = LendingPolicy.fromJson(db.object('shared', 'lendingPolicy'));
    _loaded = true;
    return this;
  }

  String categoryName(int id) {
    for (final category in categories) {
      if (category.id == id) return category.name;
    }
    return 'Chưa rõ';
  }

  TitleRecord? titleOf(int id) {
    for (final title in titles) {
      if (title.id == id) return title;
    }
    return null;
  }

  List<CopyRecord> copiesOf(int titleId) => copies.where((c) => c.titleId == titleId).toList();

  int availableCount(TitleRecord title) => copiesOf(title.id).where((c) => c.status == 'AVAILABLE').length;

  List<TitleRecord> search(String query, {bool includeInactive = false}) {
    return titles.where((title) {
      if (!includeInactive && !title.active) return false;
      return matchesQuery('${title.name} ${title.author} ${title.isbn}', query);
    }).toList();
  }

  String? saveTitle(TitleRecord draft) {
    final name = draft.name.trim();
    final author = draft.author.trim();
    final isbn = draft.isbn.trim();
    if (name.isEmpty || author.isEmpty || isbn.isEmpty) return 'Điền tên, tác giả và ISBN.';
    if (draft.priceVnd <= 0) return 'Giá bìa phải lớn hơn 0.';
    if (!categories.any((c) => c.id == draft.categoryId)) return 'Chọn thể loại có trong danh mục.';
    final duplicated = titles.any((t) => t.id != draft.id && t.isbn == isbn);
    if (duplicated) return 'ISBN đã thuộc một đầu sách khác.';
    final existing = titleOf(draft.id);
    if (existing == null) {
      draft.id = _nextId(titles.map((t) => t.id));
      draft.name = name;
      draft.author = author;
      draft.isbn = isbn;
      titles.add(draft);
      return null;
    }
    existing
      ..name = name
      ..author = author
      ..isbn = isbn
      ..categoryId = draft.categoryId
      ..priceVnd = draft.priceVnd
      ..loanable = draft.loanable
      ..active = draft.active;
    return null;
  }

  void setActive(int titleId, bool active) {
    titleOf(titleId)?.active = active;
  }

  String? addCategory(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return 'Nhập tên thể loại.';
    if (categories.any((c) => c.name.toLowerCase() == trimmed.toLowerCase())) {
      return 'Thể loại này đã có.';
    }
    categories.add(CategoryRecord(id: _nextId(categories.map((c) => c.id)), name: trimmed));
    return null;
  }

  String? renameCategory(int id, String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return 'Nhập tên thể loại.';
    if (categories.any((c) => c.id != id && c.name.toLowerCase() == trimmed.toLowerCase())) {
      return 'Thể loại này đã có.';
    }
    for (final category in categories) {
      if (category.id == id) category.name = trimmed;
    }
    return null;
  }

  String? deleteCategory(int id) {
    if (titles.any((t) => t.categoryId == id)) {
      return 'Còn đầu sách dùng thể loại này.';
    }
    categories.removeWhere((c) => c.id == id);
    return null;
  }

  List<String> get authors {
    final names = titles.map((t) => t.author).toSet().toList()..sort();
    return names;
  }

  List<String> get shelves {
    final names = copies.map((c) => c.shelf).whereType<String>().where((s) => s.isNotEmpty).toSet().toList()..sort();
    return names;
  }

  List<CopyRecord> addCopies({
    required int titleId,
    required int count,
    required String shelf,
    required bool inLibraryOnly,
  }) {
    final created = <CopyRecord>[];
    for (var i = 0; i < count; i++) {
      final copy = CopyRecord(
        id: _nextId(copies.map((c) => c.id)),
        titleId: titleId,
        code: _nextCopyCode(),
        status: 'AVAILABLE',
        shelf: shelf.trim(),
        loanableOverride: inLibraryOnly ? false : null,
        version: 1,
      );
      copies.add(copy);
      created.add(copy);
    }
    return created;
  }

  ImportBatch? batchOf(int id) {
    for (final batch in batches) {
      if (batch.id == id) return batch;
    }
    return null;
  }

  void commitBatch(int id) {
    final batch = batchOf(id);
    if (batch == null || batch.errorRows > 0) return;
    batch.status = 'COMMITTED';
    batch.committedAt = DateTime.now().toIso8601String();
  }

  void requestOverride(int id) {
    final batch = batchOf(id);
    if (batch == null) return;
    batch.status = 'OVERRIDE_REQUESTED';
  }

  String? savePolicy(LendingPolicy next, DateTime effectiveAt) {
    if (next.loanDays < 1 || next.renewDays < 1 || next.holdHours < 1) {
      return 'Số ngày mượn, ngày gia hạn và giờ giữ chỗ phải từ 1 trở lên.';
    }
    if (next.maxActiveLoans < 1 || next.maxRenewals < 0 || next.maxOpenReservations < 0) {
      return 'Số cuốn và số lần không hợp lệ.';
    }
    if (next.finePerDayVnd < 0 || next.fineBlockVnd < 0 || next.lostProcessingFeeVnd < 0) {
      return 'Số tiền không được âm.';
    }
    final today = DateTime.now();
    final startOfToday = DateTime(today.year, today.month, today.day);
    if (effectiveAt.isBefore(startOfToday)) return 'Thời điểm hiệu lực không được ở quá khứ.';
    policy = next;
    policyEffectiveAt = effectiveAt;
    lastPolicyNote = 'Đã ghi audit POLICY_UPDATE, áp dụng từ ${effectiveAt.toIso8601String()}.';
    return null;
  }

  void runBackup() {
    final now = DateTime.now();
    final stamp = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    backups.insert(
      0,
      BackupRun(
        id: _nextId(backups.map((b) => b.id)),
        startedAt: now.toIso8601String(),
        finishedAt: now.toIso8601String(),
        status: 'SUCCESS',
        fileName: 'pgdump-$stamp.sql.gz',
        sizeKb: 830,
        error: null,
      ),
    );
    if (backups.length > 30) backups.removeRange(30, backups.length);
  }

  String _nextCopyCode() {
    var max = 0;
    for (final copy in copies) {
      final n = int.tryParse(copy.code.replaceFirst(RegExp(r'^BC'), '')) ?? 0;
      if (n > max) max = n;
    }
    return 'BC${(max + 1).toString().padLeft(6, '0')}';
  }
}

int _nextId(Iterable<int> ids) => ids.fold(0, (a, b) => a > b ? a : b) + 1;

class TitleRecord {
  TitleRecord({
    required this.id,
    required this.name,
    required this.author,
    required this.isbn,
    required this.categoryId,
    required this.priceVnd,
    required this.loanable,
    required this.active,
  });

  int id;
  String name;
  String author;
  String isbn;
  int categoryId;
  int priceVnd;
  bool loanable;
  bool active;

  TitleRecord copy() => TitleRecord(
        id: id,
        name: name,
        author: author,
        isbn: isbn,
        categoryId: categoryId,
        priceVnd: priceVnd,
        loanable: loanable,
        active: active,
      );

  factory TitleRecord.fromJson(Map<String, dynamic> json) => TitleRecord(
        id: json['id'] as int,
        name: json['name'] as String,
        author: json['author'] as String,
        isbn: json['isbn'] as String,
        categoryId: json['categoryId'] as int,
        priceVnd: json['priceVnd'] as int,
        loanable: json['loanable'] as bool,
        active: json['active'] as bool,
      );
}

class CopyRecord {
  CopyRecord({
    required this.id,
    required this.titleId,
    required this.code,
    required this.status,
    required this.shelf,
    required this.loanableOverride,
    required this.version,
  });

  final int id;
  final int titleId;
  final String code;
  final String status;
  final String? shelf;
  final bool? loanableOverride;
  final int version;

  factory CopyRecord.fromJson(Map<String, dynamic> json) => CopyRecord(
        id: json['id'] as int,
        titleId: json['titleId'] as int,
        code: json['code'] as String,
        status: json['status'] as String,
        shelf: json['shelf'] as String?,
        loanableOverride: json['loanableOverride'] as bool?,
        version: json['version'] as int,
      );
}

class CategoryRecord {
  CategoryRecord({required this.id, required this.name});

  final int id;
  String name;

  factory CategoryRecord.fromJson(Map<String, dynamic> json) =>
      CategoryRecord(id: json['id'] as int, name: json['name'] as String);
}

class LendingPolicy {
  LendingPolicy({
    required this.maxActiveLoans,
    required this.loanDays,
    required this.maxRenewals,
    required this.renewDays,
    required this.finePerDayVnd,
    required this.fineBlockVnd,
    required this.holdHours,
    required this.maxOpenReservations,
    required this.lostProcessingFeeVnd,
  });

  int maxActiveLoans;
  int loanDays;
  int maxRenewals;
  int renewDays;
  int finePerDayVnd;
  int fineBlockVnd;
  int holdHours;
  int maxOpenReservations;
  int lostProcessingFeeVnd;

  factory LendingPolicy.empty() => LendingPolicy(
        maxActiveLoans: 5,
        loanDays: 14,
        maxRenewals: 1,
        renewDays: 7,
        finePerDayVnd: 2000,
        fineBlockVnd: 50000,
        holdHours: 48,
        maxOpenReservations: 3,
        lostProcessingFeeVnd: 0,
      );

  LendingPolicy copy() => LendingPolicy(
        maxActiveLoans: maxActiveLoans,
        loanDays: loanDays,
        maxRenewals: maxRenewals,
        renewDays: renewDays,
        finePerDayVnd: finePerDayVnd,
        fineBlockVnd: fineBlockVnd,
        holdHours: holdHours,
        maxOpenReservations: maxOpenReservations,
        lostProcessingFeeVnd: lostProcessingFeeVnd,
      );

  factory LendingPolicy.fromJson(Map<String, dynamic> json) => LendingPolicy(
        maxActiveLoans: json['maxActiveLoans'] as int,
        loanDays: json['loanDays'] as int,
        maxRenewals: json['maxRenewals'] as int,
        renewDays: json['renewDays'] as int,
        finePerDayVnd: json['finePerDayVnd'] as int,
        fineBlockVnd: json['fineBlockVnd'] as int,
        holdHours: json['holdHours'] as int,
        maxOpenReservations: json['maxOpenReservations'] as int,
        lostProcessingFeeVnd: json['lostProcessingFeeVnd'] as int,
      );
}

class ImportBatch {
  ImportBatch({
    required this.id,
    required this.fileName,
    required this.status,
    required this.uploadedAt,
    required this.committedAt,
    required this.totalRows,
    required this.validRows,
    required this.errorRows,
    required this.rows,
  });

  final int id;
  final String fileName;
  String status;
  final String uploadedAt;
  String? committedAt;
  final int totalRows;
  final int validRows;
  final int errorRows;
  final List<ImportRow> rows;

  factory ImportBatch.fromJson(Map<String, dynamic> json) => ImportBatch(
        id: json['id'] as int,
        fileName: json['fileName'] as String,
        status: json['status'] as String,
        uploadedAt: json['uploadedAt'] as String,
        committedAt: json['committedAt'] as String?,
        totalRows: json['totalRows'] as int,
        validRows: json['validRows'] as int,
        errorRows: json['errorRows'] as int,
        rows: (json['rows'] as List).map((row) => ImportRow.fromJson(row as Map<String, dynamic>)).toList(),
      );
}

class ImportRow {
  ImportRow({required this.rowNo, required this.name, required this.isbn, required this.result, required this.error});

  final int rowNo;
  final String name;
  final String isbn;
  final String result;
  final String? error;

  factory ImportRow.fromJson(Map<String, dynamic> json) => ImportRow(
        rowNo: json['rowNo'] as int,
        name: (json['name'] as String?) ?? '',
        isbn: (json['isbn'] as String?) ?? '',
        result: json['result'] as String,
        error: json['error'] as String?,
      );
}

class BackupRun {
  BackupRun({
    required this.id,
    required this.startedAt,
    required this.finishedAt,
    required this.status,
    required this.fileName,
    required this.sizeKb,
    required this.error,
  });

  final int id;
  final String startedAt;
  final String? finishedAt;
  final String status;
  final String? fileName;
  final int? sizeKb;
  final String? error;

  factory BackupRun.fromJson(Map<String, dynamic> json) => BackupRun(
        id: json['id'] as int,
        startedAt: json['startedAt'] as String,
        finishedAt: json['finishedAt'] as String?,
        status: json['status'] as String,
        fileName: json['fileName'] as String?,
        sizeKb: json['sizeKb'] as int?,
        error: json['error'] as String?,
      );
}
