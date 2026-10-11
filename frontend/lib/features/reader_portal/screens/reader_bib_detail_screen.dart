// Màn 2 – Chi tiết đầu sách (reader-bib-detail). Route: /portal/titles/:id
// Bài: TV3 3 · Độ khó ⭐
//
// Mục đích: chỉ xem: thông tin đầu sách, số bản khả dụng, vị trí kệ.
// Đến từ: reader-search. Đi tới: reservation-form (TV2) khi hết sách.
//
// TODO:
// - Hiện tên, tác giả, ISBN, thể loại, số bản sẵn sàng, danh sách kệ.
// - Hết sách -> nút "Đặt trước" push route của TV2 (thống nhất tên route với TV2).
// Màn 2 – Chi tiết đầu sách (reader-bib-detail). Route: /portal/titles/:id
// Spec: docs/features/reader-self-service/srs/ (FR-001)
//
// Mục đích: chỉ xem: thông tin đầu sách, số bản khả dụng, vị trí kệ.
// Đến từ: reader-search. Đi tới: reservation-form (TV2) khi hết sách – chờ TV2 có route.

import 'package:flutter/material.dart';

import '../data/portal_api.dart';
import '../models/title_summary.dart';

class ReaderBibDetailScreen extends StatefulWidget {
  const ReaderBibDetailScreen({
    super.key,
    required this.api,
    required this.titleId,
  });

  final PortalApi api;
  final int titleId;

  @override
  State<ReaderBibDetailScreen> createState() => _ReaderBibDetailScreenState();
}

class _ReaderBibDetailScreenState extends State<ReaderBibDetailScreen> {
  late final Future<TitleSummary> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.api.titleDetail(widget.titleId);
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết sách')),
      body: FutureBuilder<TitleSummary>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final t = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(t.name, style: text.headlineSmall),
              const SizedBox(height: 4),
              Text(t.author, style: text.titleMedium),
              const SizedBox(height: 16),
              _row('Thể loại', t.categoryName),
              _row('ISBN', t.isbn ?? '—'),
              _row('Tình trạng', _status(t)),
              _row('Vị trí kệ', t.shelves.isEmpty ? '—' : t.shelves.join(', ')),
              const SizedBox(height: 24),
              if (t.loanable && t.availableCount == 0) ...[
                const Text(
                  'Hiện không còn bản để mượn. Bạn có thể đặt trước để được giữ sách.',
                ),
                const SizedBox(height: 8),
                // TODO(TV2): nối route reservation-form khi TV2 làm xong.
                const FilledButton(
                  onPressed: null,
                  child: Text('Đặt trước (sắp có)'),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  String _status(TitleSummary t) {
    if (!t.loanable) return 'Chỉ đọc tại chỗ, không cho mượn về';
    if (t.availableCount == 0) {
      return 'Hết sách (${t.totalCopies} bản đang được mượn hoặc giữ)';
    }
    return 'Còn ${t.availableCount} / ${t.totalCopies} bản có thể mượn';
  }

  Widget _row(String label, String value) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      subtitle: Text(value, style: Theme.of(context).textTheme.bodyLarge),
    );
  }
}
