import 'package:flutter/material.dart';
import 'package:frontend/core/auth/session.dart';
import 'package:frontend/core/routing/app_routes.dart';
import 'package:frontend/core/theme/theme_x.dart';
import 'package:frontend/core/widgets/snackbar.dart';
import 'package:frontend/core/widgets/state_views.dart';
import 'package:frontend/features/catalog/widgets/store_loader.dart';
import 'package:frontend/features/circulation/widgets/status_mapping.dart';

class CopyInventoryScreen extends StatefulWidget {
  const CopyInventoryScreen({super.key, required this.titleId});

  final int titleId;

  @override
  State<CopyInventoryScreen> createState() => _CopyInventoryScreenState();
}

class _CopyInventoryScreenState extends State<CopyInventoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kho bản sao')),
      floatingActionButton: AppSession.isAdmin
          ? FloatingActionButton.extended(
              onPressed: () async {
                await Navigator.pushNamed(context, AppRoutes.copyForm, arguments: widget.titleId);
                if (mounted) setState(() {});
              },
              icon: const Icon(Icons.add),
              label: const Text('Thêm bản'),
            )
          : null,
      body: StoreLoader(
        builder: (context, store) {
          final title = store.titleOf(widget.titleId);
          if (title == null) {
            return const EmptyState(icon: Icons.inventory_2_outlined, message: 'Không thấy đầu sách.');
          }
          final copies = store.copiesOf(widget.titleId);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(title.name, style: context.textTheme.titleMedium),
              ),
              Expanded(
                child: copies.isEmpty
                    ? const EmptyState(icon: Icons.inventory_2_outlined, message: 'Chưa có bản sao.')
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 88),
                        itemCount: copies.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final copy = copies[index];
                          final localOnly = copy.loanableOverride == false;
                          return Card(
                            child: ListTile(
                              title: Text(copy.code),
                              subtitle: Text('${copy.shelf ?? 'Chưa xếp kệ'}${localOnly ? ' · Chỉ đọc tại chỗ' : ''}'),
                              trailing: copyStatusChip(context, copy.status),
                              onTap: () => showAppSnackBar(context, 'Đã gửi lệnh in nhãn ${copy.code}.'),
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
