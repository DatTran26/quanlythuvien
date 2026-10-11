// Đầu sách rút gọn cho reader-search và reader-bib-detail.
// Mock: shared.titles + shared.categories + shared.copies.
//
// TODO:
// - class TitleSummary { id, name, author, isbn, categoryName, loanable, availableCount, shelves }.
// - availableCount: số bản sao AVAILABLE và loanableOverride != false.
// - Đầu sách active == false thì không hiện cho người đọc.
// Đầu sách cho reader-search và reader-bib-detail, kèm số bản và vị trí kệ.
// API: GET /titles?q= -> Title (chưa có số bản sẵn sàng, kệ: T7)
// Mock: ghép shared.titles + shared.categories + shared.copies.

/// Thể loại để lọc: (id, tên).
typedef CategoryItem = ({int id, String name});

class TitleSummary {
  final int id;
  final String name;
  final String author;
  final String? isbn;
  final int? categoryId;
  final String categoryName;
  final bool loanable; // false: chỉ đọc tại chỗ (từ điển...)
  final int totalCopies; // không tính bản đã mất, đã thanh lý
  final int availableCount; // bản đang trên kệ và được mượn về
  final List<String> shelves; // kệ có bản đang trên kệ

  const TitleSummary({
    required this.id,
    required this.name,
    required this.author,
    required this.isbn,
    required this.categoryId,
    required this.categoryName,
    required this.loanable,
    required this.totalCopies,
    required this.availableCount,
    required this.shelves,
  });

  /// Nhãn ngắn ở danh sách: "Còn 1/3", "Hết sách", "Đọc tại chỗ".
  String get availabilityLabel {
    if (!loanable) return 'Đọc tại chỗ';
    if (availableCount == 0) return 'Hết sách';
    return 'Còn $availableCount/$totalCopies';
  }
}
