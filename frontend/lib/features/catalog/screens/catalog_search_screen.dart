import 'package:flutter/material.dart';
import 'package:frontend/core/auth/session.dart';
import 'package:frontend/core/routing/app_routes.dart';
import 'package:frontend/core/utils/format.dart';
import 'package:frontend/core/widgets/state_views.dart';
import 'package:frontend/features/catalog/widgets/store_loader.dart';

class CatalogSearchScreen extends StatefulWidget {
  const CatalogSearchScreen({super.key});

  @override
  State<CatalogSearchScreen> createState() => _CatalogSearchScreenState();
}

class _CatalogSearchScreenState extends State<CatalogSearchScreen> {
  final _query = TextEditingController();
  var _includeInactive = false;

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh mục'),
        actions: [
          if (AppSession.isLibrarian)
            IconButton(
              tooltip: 'Thể loại',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.categoryAdmin),
              icon: const Icon(Icons.category_outlined),
            ),
        ],
      ),
      floatingActionButton: AppSession.isLibrarian
          ? FloatingActionButton.extended(
              onPressed: () async {
                await Navigator.pushNamed(context, AppRoutes.bibliographicForm);
                if (mounted) setState(() {});
              },
              icon: const Icon(Icons.add),
              label: const Text('Đầu sách'),
            )
          : null,
      body: StoreLoader(
        builder: (context, store) {
          final found = store.search(_query.text, includeInactive: _includeInactive);
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: TextField(
                  controller: _query,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    labelText: 'Tên, tác giả hoặc ISBN',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              SwitchListTile(
                title: const Text('Hiện đầu sách đã ngưng'),
                value: _includeInactive,
                onChanged: (v) => setState(() => _includeInactive = v),
              ),
              Expanded(
                child: found.isEmpty
                    ? const EmptyState(icon: Icons.search_off, message: 'Không có đầu sách khớp.')
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 88),
                        itemCount: found.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final title = found[index];
                          return Card(
                            child: ListTile(
                              title: Text(title.name),
                              subtitle: Text(
                                '${title.author} · ${store.categoryName(title.categoryId)}\n'
                                'Sẵn sàng ${store.availableCount(title)} · ${formatVnd(title.priceVnd)}'
                                '${title.active ? '' : ' · Ngưng'}',
                              ),
                              isThreeLine: true,
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () async {
                                await Navigator.pushNamed(context, AppRoutes.bibliographicDetail, arguments: title.id);
                                if (mounted) setState(() {});
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
