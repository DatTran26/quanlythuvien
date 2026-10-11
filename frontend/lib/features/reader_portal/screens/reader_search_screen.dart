// Màn 1 – Tra cứu sách (reader-search). Route: /portal/search
// Bài: TV3 3 · Độ khó ⭐⭐
// Spec: docs/features/reader-self-service/srs/
//
// Mục đích: người đọc tìm sách theo tên, tác giả, ISBN, thể loại; lọc còn / hết.
// Đi tới: reader-bib-detail.
//
// TODO:
// - Ô tìm + chip lọc "Còn sách". Danh sách: tên, tác giả, "Còn 2 / 3".
// - Đầu sách không cho mượn (loanable=false): ghi "Chỉ đọc tại chỗ".
// - Rỗng / lỗi / đang tải như reader-list.
// Màn 1 – Tra cứu sách (reader-search). Route: /portal/search
// Spec: docs/features/reader-self-service/srs/ (FR-001)
//
// Mục đích: người đọc tìm sách theo tên, tác giả, ISBN, thể loại; lọc còn / hết.
// Đi tới: reader-bib-detail.
// Lỗ hổng: T7 (GET /titles chưa trả số bản sẵn sàng, kệ; chưa lọc thể loại).

import 'package:flutter/material.dart';

import '../data/portal_api.dart';
import '../models/title_summary.dart';
import 'reader_bib_detail_screen.dart';

class ReaderSearchScreen extends StatefulWidget {
  const ReaderSearchScreen({
    super.key,
    required this.api,
    this.actions = const [],
  });

  final PortalApi api;

  /// Nút trên AppBar do khung cổng truyền vào (chuông thông báo).
  final List<Widget> actions;

  @override
  State<ReaderSearchScreen> createState() => _ReaderSearchScreenState();
}

class _ReaderSearchScreenState extends State<ReaderSearchScreen> {
  final _search = TextEditingController();
  late final Future<List<CategoryItem>> _categories;
  late Future<List<TitleSummary>> _results;
  int? _categoryId; // null = mọi thể loại
  bool _availableOnly = false;

  @override
  void initState() {
    super.initState();
    _categories = widget.api.categories();
    _results = widget.api.searchTitles();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  /// Gom mọi điều kiện lọc hiện tại thành một lần tìm.
  void _runSearch() {
    setState(() {
      _results = widget.api.searchTitles(
        query: _search.text,
        categoryId: _categoryId,
        availableOnly: _availableOnly,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tra cứu sách'),
        actions: widget.actions,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _search,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _runSearch(),
              decoration: InputDecoration(
                labelText: 'Tên sách, tác giả hoặc ISBN',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  tooltip: 'Tìm',
                  onPressed: _runSearch,
                ),
              ),
            ),
          ),
          _filters(),
          Expanded(child: _resultList()),
        ],
      ),
    );
  }

  /// Hàng chip lọc, cuộn ngang: "Còn sách" + từng thể loại.
  Widget _filters() {
    return FutureBuilder<List<CategoryItem>>(
      future: _categories,
      builder: (context, snapshot) {
        final categories = snapshot.data ?? const <CategoryItem>[];
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              FilterChip(
                label: const Text('Còn sách'),
                selected: _availableOnly,
                onSelected: (value) {
                  _availableOnly = value;
                  _runSearch();
                },
              ),
              const SizedBox(width: 16),
              ChoiceChip(
                label: const Text('Tất cả'),
                selected: _categoryId == null,
                onSelected: (_) {
                  _categoryId = null;
                  _runSearch();
                },
              ),
              for (final c in categories) ...[
                const SizedBox(width: 8),
                ChoiceChip(
                  label: Text(c.name),
                  selected: _categoryId == c.id,
                  onSelected: (_) {
                    _categoryId = c.id;
                    _runSearch();
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _resultList() {
    return FutureBuilder<List<TitleSummary>>(
      future: _results,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Lỗi: ${snapshot.error}'));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final titles = snapshot.data!;
        if (titles.isEmpty) {
          return const Center(child: Text('Không tìm thấy sách phù hợp'));
        }
        return ListView.separated(
          itemCount: titles.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, i) {
            final t = titles[i];
            return ListTile(
              title: Text(t.name),
              subtitle: Text('${t.author} · ${t.categoryName}'),
              trailing: Text(t.availabilityLabel),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      ReaderBibDetailScreen(api: widget.api, titleId: t.id),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
