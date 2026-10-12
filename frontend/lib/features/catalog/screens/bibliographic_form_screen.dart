import 'package:flutter/material.dart';
import 'package:frontend/core/utils/format.dart';
import 'package:frontend/core/widgets/snackbar.dart';
import 'package:frontend/core/widgets/state_views.dart';
import 'package:frontend/features/catalog/data/catalog_store.dart';
import 'package:frontend/features/catalog/widgets/store_loader.dart';

class BibliographicFormScreen extends StatefulWidget {
  const BibliographicFormScreen({super.key, this.titleId});

  final int? titleId;

  @override
  State<BibliographicFormScreen> createState() => _BibliographicFormScreenState();
}

class _BibliographicFormScreenState extends State<BibliographicFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _author = TextEditingController();
  final _isbn = TextEditingController();
  final _price = TextEditingController();
  int? _categoryId;
  var _loanable = true;
  var _active = true;
  var _filled = false;

  @override
  void dispose() {
    _name.dispose();
    _author.dispose();
    _isbn.dispose();
    _price.dispose();
    super.dispose();
  }

  void _fill(TitleRecord title) {
    if (_filled) return;
    _filled = true;
    _name.text = title.name;
    _author.text = title.author;
    _isbn.text = title.isbn;
    _price.text = '${title.priceVnd}';
    _categoryId = title.categoryId;
    _loanable = title.loanable;
    _active = title.active;
  }

  void _save(CatalogStore store) {
    if (!_formKey.currentState!.validate()) return;
    final draft = TitleRecord(
      id: widget.titleId ?? 0,
      name: _name.text,
      author: _author.text,
      isbn: _isbn.text,
      categoryId: _categoryId!,
      priceVnd: int.parse(_price.text.trim()),
      loanable: _loanable,
      active: _active,
    );
    final error = store.saveTitle(draft);
    if (error != null) {
      showAppSnackBar(context, error, isError: true);
      return;
    }
    showAppSnackBar(context, widget.titleId == null ? 'Đã thêm đầu sách.' : 'Đã lưu đầu sách.');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.titleId != null;
    return Scaffold(
      appBar: AppBar(title: Text(editing ? 'Sửa đầu sách' : 'Thêm đầu sách')),
      body: StoreLoader(
        builder: (context, store) {
          final current = widget.titleId == null ? null : store.titleOf(widget.titleId!);
          if (editing && current == null) {
            return const EmptyState(icon: Icons.menu_book_outlined, message: 'Không thấy đầu sách.');
          }
          if (current != null) _fill(current);
          _categoryId ??= store.categories.isEmpty ? null : store.categories.first.id;
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextFormField(
                  controller: _name,
                  decoration: const InputDecoration(labelText: 'Tên sách', border: OutlineInputBorder()),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Nhập tên sách' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _author,
                  decoration: const InputDecoration(labelText: 'Tác giả', border: OutlineInputBorder()),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Nhập tác giả' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _isbn,
                  decoration: const InputDecoration(labelText: 'ISBN', border: OutlineInputBorder()),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Nhập ISBN' : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  initialValue: _categoryId,
                  decoration: const InputDecoration(labelText: 'Thể loại', border: OutlineInputBorder()),
                  items: [
                    for (final category in store.categories)
                      DropdownMenuItem(value: category.id, child: Text(category.name)),
                  ],
                  onChanged: (v) => setState(() => _categoryId = v),
                  validator: (v) => v == null ? 'Chọn thể loại' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _price,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Giá bìa (đồng)', border: OutlineInputBorder()),
                  validator: (v) {
                    final n = int.tryParse((v ?? '').trim());
                    if (n == null || n <= 0) return 'Giá bìa phải lớn hơn 0';
                    return null;
                  },
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Cho mượn về'),
                  value: _loanable,
                  onChanged: (v) => setState(() => _loanable = v),
                ),
                if (editing)
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Đang sử dụng'),
                    value: _active,
                    onChanged: (v) => setState(() => _active = v),
                  ),
                const SizedBox(height: 8),
                FilledButton(onPressed: () => _save(store), child: const Text('Lưu')),
                if (current != null) ...[
                  const SizedBox(height: 8),
                  Text('Giá hiện tại ${formatVnd(current.priceVnd)}', textAlign: TextAlign.center),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
