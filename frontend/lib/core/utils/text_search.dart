// So khớp chữ khi tìm kiếm: không phân biệt hoa thường, không phân biệt dấu tiếng Việt.
// TV3 tạo, cần nhóm duyệt qua PR nhỏ. Dùng được cho mọi ô tìm kiếm trong app.

/// Bảng đổi chữ có dấu -> chữ gốc, ví dụ 'ễ' -> 'e', 'đ' -> 'd'.
final Map<String, String> _base = {
  for (final (accented, plain) in const [
    ('àáạảãâầấậẩẫăằắặẳẵ', 'a'),
    ('èéẹẻẽêềếệểễ', 'e'),
    ('ìíịỉĩ', 'i'),
    ('òóọỏõôồốộổỗơờớợởỡ', 'o'),
    ('ùúụủũưừứựửữ', 'u'),
    ('ỳýỵỷỹ', 'y'),
    ('đ', 'd'),
  ])
    for (final char in accented.split('')) char: plain,
};

/// "Tô Hoài" -> "to hoai".
String foldVietnamese(String text) =>
    text.toLowerCase().split('').map((c) => _base[c] ?? c).join();

/// true nếu [text] chứa [query], bỏ qua hoa thường và dấu. Query rỗng luôn khớp.
bool matchesQuery(String text, String query) {
  final q = foldVietnamese(query.trim());
  return q.isEmpty || foldVietnamese(text).contains(q);
}
