// Model bản sao sách (BookCopy) nhận từ API.
// Bài: Hoang/01-nen-tang/03-goi-api-va-shared-preferences.md, 02-checkout/02-checkout-scan.md
//
// API trả về (GET /copies/by-code/{code}), khớp entity BookCopy trong apps/api:
//   {
//     "id": 2, "code": "BC000002", "status": "AVAILABLE", "shelf": "A1-01",
//     "loanableOverride": null, "version": 4,
//     "title": { "id": 1, "name": "Lập trình Flutter cơ bản", "author": "Nguyễn Hữu Phúc",
//                "isbn": "9786040000011", "priceVnd": 120000, "loanable": true, "active": true,
//                "category": { "id": 1, "name": "Công nghệ thông tin" } }
//   }

/// Đầu sách rút gọn, nằm lồng trong BookCopy.
class TitleRef {
  const TitleRef({
    required this.id,
    required this.name,
    required this.author,
    this.isbn,
    this.categoryName,
    required this.priceVnd,
    required this.loanable,
    required this.active,
  });

  final int id;
  final String name;
  final String author;
  final String? isbn;
  final String? categoryName;
  final int priceVnd;
  final bool loanable;
  final bool active;

  factory TitleRef.fromJson(Map<String, dynamic> json) {
    // category có thể null, hoặc chưa được backend gửi kèm.
    final category = json['category'];
    return TitleRef(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      author: json['author'] as String,
      isbn: json['isbn'] as String?,
      categoryName: category is Map<String, dynamic> ? category['name'] as String? : null,
      priceVnd: (json['priceVnd'] as num?)?.toInt() ?? 0,
      loanable: json['loanable'] as bool? ?? true,
      active: json['active'] as bool? ?? true,
    );
  }
}

/// Một bản sao vật lý có nhãn QR riêng.
class BookCopy {
  const BookCopy({
    required this.id,
    required this.code,
    required this.status,
    this.shelf,
    this.loanableOverride,
    required this.version,
    required this.title,
  });

  final int id;

  /// Mã in trên nhãn QR, ví dụ "BC000002".
  final String code;

  /// Mã trạng thái backend: AVAILABLE, ON_LOAN, ON_HOLD, PENDING_REVIEW,
  /// IN_REPAIR, LOST, DISPOSED. Giữ nguyên chuỗi, không tự đặt tên khác.
  /// Nhãn tiếng Việt: widgets/status_mapping.dart. Màu chip: AppColors.copyStatus().
  final String status;

  final String? shelf;

  /// null = theo đầu sách; true/false = ghi đè riêng cho bản sao này
  /// (ví dụ sách tham khảo chỉ đọc tại chỗ).
  final bool? loanableOverride;

  /// Số phiên bản để backend phát hiện hai quầy cùng sửa (lỗi STALE_COPY).
  final int version;

  final TitleRef title;

  factory BookCopy.fromJson(Map<String, dynamic> json) {
    return BookCopy(
      id: (json['id'] as num).toInt(),
      code: json['code'] as String,
      status: json['status'] as String,
      shelf: json['shelf'] as String?,
      loanableOverride: json['loanableOverride'] as bool?,
      version: (json['version'] as num?)?.toInt() ?? 0,
      title: TitleRef.fromJson(json['title'] as Map<String, dynamic>),
    );
  }

  // Lối tắt tới thông tin đầu sách, đúng tên bài học dùng (copy.titleName, copy.priceVnd…).
  int get titleId => title.id;
  String get titleName => title.name;
  String get author => title.author;
  int get priceVnd => title.priceVnd;

  /// Bản sao có được phép mượn không (cùng quy tắc với BookCopy.loanable() ở backend).
  bool get isLoanable => loanableOverride ?? (title.loanable && title.active);

  /// Có thể cho vào giỏ mượn ngay không.
  /// ON_HOLD (đang giữ cho người đặt trước) phải kiểm đúng người ở màn nhận sách, không xét ở đây.
  bool get canBorrow => isLoanable && status == 'AVAILABLE';

  /// Lý do không mượn được, để hiện dưới ô quét. null = mượn được.
  String? get borrowBlockReason {
    if (!title.active) return 'Đầu sách đã ngưng lưu thông';
    if (!isLoanable) return 'Sách chỉ đọc tại chỗ, không cho mượn';
    return switch (status) {
      'AVAILABLE' => null,
      'ON_LOAN' => 'Sách đang được người khác mượn',
      'ON_HOLD' => 'Sách đang giữ cho người đặt trước',
      'PENDING_REVIEW' => 'Sách đang chờ duyệt hư hỏng',
      'IN_REPAIR' => 'Sách đang sửa chữa',
      'LOST' => 'Sách đã ghi nhận mất',
      'DISPOSED' => 'Sách đã thanh lý',
      _ => 'Trạng thái sách không cho mượn ($status)',
    };
  }
}
