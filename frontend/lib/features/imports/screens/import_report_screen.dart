import 'package:flutter/material.dart';
import 'package:frontend/core/routing/app_routes.dart';
import 'package:frontend/core/theme/theme_x.dart';
import 'package:frontend/core/widgets/snackbar.dart';
import 'package:frontend/core/widgets/state_views.dart';
import 'package:frontend/features/catalog/widgets/store_loader.dart';

class ImportReportScreen extends StatelessWidget {
  const ImportReportScreen({super.key, required this.batchId});

  final int batchId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đối soát import')),
      body: StoreLoader(
        builder: (context, store) {
          final batch = store.batchOf(batchId);
          if (batch == null) {
            return const EmptyState(icon: Icons.description_outlined, message: 'Không thấy lô import.');
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(batch.fileName, style: context.textTheme.titleLarge),
              const SizedBox(height: 4),
              Text(
                '${batch.validRows} dòng đúng · ${batch.errorRows} dòng lỗi',
                style: TextStyle(color: context.colors.textSecondary),
              ),
              const SizedBox(height: 12),
              if (batch.rows.isEmpty)
                const Text('Lô này không còn dòng cần đối soát.')
              else
                for (final row in batch.rows)
                  Card(
                    child: ListTile(
                      title: Text(row.name.isEmpty ? 'Dòng ${row.rowNo}' : row.name),
                      subtitle: Text(row.error ?? row.isbn),
                      trailing: Text(
                        row.result == 'OK' ? 'Đúng' : 'Lỗi',
                        style: TextStyle(color: row.result == 'OK' ? context.colors.success : context.scheme.error),
                      ),
                    ),
                  ),
              const SizedBox(height: 16),
              if (batch.status == 'DRY_RUN' && batch.errorRows == 0)
                FilledButton(
                  onPressed: () {
                    store.commitBatch(batch.id);
                    showAppSnackBar(context, 'Đã ghi lô vào danh mục.');
                    Navigator.pop(context);
                  },
                  child: const Text('Ghi lô'),
                ),
              if (batch.status == 'DRY_RUN' && batch.errorRows > 0)
                FilledButton(
                  onPressed: () async {
                    final ok = await Navigator.pushNamed<bool>(
                      context,
                      AppRoutes.sessionExpired,
                      arguments: 'Xin override các dòng lỗi của lô ${batch.fileName}.',
                    );
                    if (ok != true || !context.mounted) return;
                    store.requestOverride(batch.id);
                    showAppSnackBar(context, 'Đã gửi yêu cầu override. Lô chưa được ghi.');
                    Navigator.pop(context);
                  },
                  child: const Text('Xin override'),
                ),
              if (batch.status == 'OVERRIDE_REQUESTED')
                const Text('Yêu cầu override đã gửi. Lô vẫn chưa ghi cho đến khi được duyệt.'),
            ],
          );
        },
      ),
    );
  }
}
