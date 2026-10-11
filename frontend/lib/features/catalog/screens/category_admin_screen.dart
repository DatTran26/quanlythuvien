import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/snackbar.dart';
import 'package:frontend/features/catalog/widgets/store_loader.dart';

class CategoryAdminScreen extends StatefulWidget {
  const CategoryAdminScreen({super.key});

  @override
  State<CategoryAdminScreen> createState() => _CategoryAdminScreenState();
}

class _CategoryAdminScreenState extends State<CategoryAdminScreen> {
  final _name = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<String?> _ask(String title, String initial) async {
    final controller = TextEditingController(text: initial);
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: TextField(controller: controller, autofocus: true, decoration: const InputDecoration(labelText: 'Tên')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
          FilledButton(onPressed: () => Navigator.pop(ctx, controller.text), child: const Text('Lưu')),
        ],
      ),
    );
    controller.dispose();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thể loại và vị trí')),
      body: StoreLoader(
        builder: (context, store) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Thể loại', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _name,
                      decoration: const InputDecoration(labelText: 'Thể loại mới', border: OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () {
                      final error = store.addCategory(_name.text);
                      if (error != null) {
                        showAppSnackBar(context, error, isError: true);
                        return;
                      }
                      _name.clear();
                      setState(() {});
                    },
                    child: const Text('Thêm'),
                  ),
                ],
              ),
              for (final category in store.categories)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(category.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: 'Đổi tên',
                        onPressed: () async {
                          final next = await _ask('Đổi tên thể loại', category.name);
                          if (next == null || !context.mounted) return;
                          final error = store.renameCategory(category.id, next);
                          if (!context.mounted) return;
                          if (error != null) {
                            showAppSnackBar(context, error, isError: true);
                            return;
                          }
                          setState(() {});
                        },
                        icon: const Icon(Icons.edit_outlined),
                      ),
                      IconButton(
                        tooltip: 'Xóa',
                        onPressed: () {
                          final error = store.deleteCategory(category.id);
                          if (error != null) {
                            showAppSnackBar(context, error, isError: true);
                            return;
                          }
                          setState(() {});
                        },
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
                ),
              const Divider(height: 32),
              Text('Tác giả trên đầu sách', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(store.authors.join(', ')),
              const SizedBox(height: 16),
              Text('Vị trí kệ trên bản sao', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(store.shelves.isEmpty ? 'Chưa có kệ.' : store.shelves.join(', ')),
              const SizedBox(height: 12),
              const Text('Tác giả sửa trên đầu sách. Kệ sửa khi nhập bản sao. Chưa có nhà xuất bản riêng trong dữ liệu.'),
            ],
          );
        },
      ),
    );
  }
}
