import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/snackbar.dart';
import 'package:frontend/core/widgets/state_views.dart';
import 'package:frontend/features/catalog/widgets/store_loader.dart';

class CopyFormScreen extends StatefulWidget {
  const CopyFormScreen({super.key, required this.titleId});

  final int titleId;

  @override
  State<CopyFormScreen> createState() => _CopyFormScreenState();
}

class _CopyFormScreenState extends State<CopyFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _count = TextEditingController(text: '1');
  final _shelf = TextEditingController();
  var _inLibraryOnly = false;

  @override
  void dispose() {
    _count.dispose();
    _shelf.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thêm bản sao')),
      body: StoreLoader(
        builder: (context, store) {
          final title = store.titleOf(widget.titleId);
          if (title == null) {
            return const EmptyState(icon: Icons.inventory_2_outlined, message: 'Không thấy đầu sách.');
          }
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(title.name, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _count,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Số bản', border: OutlineInputBorder()),
                  validator: (v) {
                    final n = int.tryParse((v ?? '').trim());
                    if (n == null || n < 1 || n > 20) return 'Nhập từ 1 đến 20 bản';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _shelf,
                  decoration: const InputDecoration(labelText: 'Vị trí kệ', border: OutlineInputBorder()),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Nhập vị trí kệ' : null,
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Chỉ đọc tại chỗ'),
                  subtitle: const Text('Bản này không cho mượn về, kể cả khi đầu sách được mượn.'),
                  value: _inLibraryOnly,
                  onChanged: (v) => setState(() => _inLibraryOnly = v),
                ),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;
                    final created = store.addCopies(
                      titleId: widget.titleId,
                      count: int.parse(_count.text.trim()),
                      shelf: _shelf.text,
                      inLibraryOnly: _inLibraryOnly,
                    );
                    showAppSnackBar(context, 'Đã thêm ${created.length} bản, từ ${created.first.code}.');
                    Navigator.pop(context);
                  },
                  child: const Text('Lưu bản sao'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
