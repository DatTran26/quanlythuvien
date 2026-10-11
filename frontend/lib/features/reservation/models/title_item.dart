// Đầu sách trong kết quả tìm kiếm. Bài: Hoang/07-reservation/01-reservation-search.md
// API: GET /titles?q= -> [{ id, name, author, isbn, ... }]
// G7: API chưa trả availableCount (số bản khả dụng) -> hiện null.

class TitleItem {
  TitleItem({required this.id, required this.name, required this.author, this.isbn, this.availableCount});

  final int id;
  final String name;
  final String author;
  final String? isbn;
  final int? availableCount; // G7: hiện null

  factory TitleItem.fromJson(Map<String, dynamic> j) => TitleItem(
        id: (j['id'] as num).toInt(),
        name: j['name'] as String,
        author: j['author'] as String,
        isbn: j['isbn'] as String?,
        availableCount: (j['availableCount'] as num?)?.toInt(),
      );
}
