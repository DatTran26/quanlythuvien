import 'package:flutter/material.dart';
import 'package:frontend/core/auth/session.dart';
import 'package:frontend/core/routing/app_routes.dart';
import 'package:frontend/core/theme/theme_x.dart';
import 'package:frontend/core/utils/format.dart';
import 'package:frontend/core/widgets/danger.dart';
import 'package:frontend/core/widgets/snackbar.dart';
import 'package:frontend/core/widgets/state_views.dart';
import 'package:frontend/features/catalog/data/catalog_store.dart';
import 'package:frontend/features/catalog/widgets/store_loader.dart';
import 'package:frontend/features/circulation/widgets/status_mapping.dart';

class BibliographicDetailScreen extends StatefulWidget {
  const BibliographicDetailScreen({super.key, required this.titleId});

  final int titleId;

  @override
  State<BibliographicDetailScreen> createState() => _BibliographicDetailScreenState();
}

class _BibliographicDetailScreenState extends State<BibliographicDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết đầu sách')),
      body: StoreLoader(
        builder: (context, store) {
          final title = store.titleOf(widget.titleId);
          if (title == null) {
            return const EmptyState(icon: Icons.menu_book_outlined, message: 'Không thấy đầu sách.');
          }
          final copies = store.copiesOf(title.id);
          final shelves = copies.map((c) => c.shelf).whereType<String>().toSet().join(', ');
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(title.name, style: context.textTheme.headlineSmall),
              const SizedBox(height: 4),
              Text(title.author, style: TextStyle(color: context.colors.textSecondary)),
              const SizedBox(height: 16),
              _row(context, 'ISBN', title.isbn),
              _row(context, 'Thể loại', store.categoryName(title.categoryId)),
              _row(context, 'Giá bìa', formatVnd(title.priceVnd)),
              _row(context, 'Cho mượn', title.loanable ? 'Có' : 'Chỉ đọc tại chỗ'),
              _row(context, 'Trạng thái', title.active ? 'Đang dùng' : 'Ngưng'),
              _row(context, 'Sẵn sàng', '${store.availableCount(title)} / ${copies.length}'),
              _row(context, 'Kệ', shelves.isEmpty ? 'Chưa có' : shelves),
              const SizedBox(height: 12),
              Text('Bản sao', style: context.textTheme.titleMedium),
              const SizedBox(height: 8),
              for (final copy in copies)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(copy.code),
                  subtitle: Text(copy.shelf ?? 'Chưa xếp kệ'),
                  trailing: copyStatusChip(context, copy.status),
                ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.copyInventory, arguments: title.id),
                icon: const Icon(Icons.inventory_2_outlined),
                label: const Text('Xem bản sao'),
              ),
              if (AppSession.isAdmin) ...[
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.bibliographicForm, arguments: title.id),
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('Sửa đầu sách'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () => _toggle(context, store, title),
                  icon: Icon(title.active ? Icons.pause_circle_outline : Icons.play_circle_outline),
                  label: Text(title.active ? 'Ngưng đầu sách' : 'Mở lại đầu sách'),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Future<void> _toggle(BuildContext context, CatalogStore store, TitleRecord title) async {
    if (title.active) {
      final ok = await confirmDanger(
        context,
        title: 'Ngưng đầu sách?',
        message: 'Đầu sách không bị xóa. Bản sao đã có lịch sử vẫn giữ nguyên.',
        actionLabel: 'Ngưng đầu sách',
      );
      if (!ok) return;
    }
    final opening = !title.active;
    store.setActive(title.id, opening);
    if (!context.mounted) return;
    setState(() {});
    showAppSnackBar(context, opening ? 'Đã mở lại đầu sách.' : 'Đã ngưng đầu sách.');
  }
}

Widget _row(BuildContext context, String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 110, child: Text(label, style: TextStyle(color: context.colors.textSecondary))),
        Expanded(child: Text(value)),
      ],
    ),
  );
}
