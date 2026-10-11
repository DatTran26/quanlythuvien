import 'package:flutter/material.dart';
import 'package:frontend/core/theme/theme_x.dart';
import 'package:frontend/core/utils/format.dart';
import 'package:frontend/core/widgets/info_banner.dart';
import 'package:frontend/core/widgets/snackbar.dart';
import 'package:frontend/core/widgets/status_chip.dart';
import 'package:frontend/features/catalog/widgets/store_loader.dart';

class BackupRunsScreen extends StatefulWidget {
  const BackupRunsScreen({super.key});

  @override
  State<BackupRunsScreen> createState() => _BackupRunsScreenState();
}

class _BackupRunsScreenState extends State<BackupRunsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sao lưu')),
      body: StoreLoader(
        builder: (context, store) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const InfoBanner(
                kind: BannerKind.info,
                message: 'Backup chạy hằng ngày. Bản lỗi được giữ lại để vận hành xử lý. Hệ thống chỉ giữ 30 bản mới nhất.',
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () {
                  store.runBackup();
                  setState(() {});
                  showAppSnackBar(context, 'Đã chạy backup.');
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('Chạy backup ngay'),
              ),
              const SizedBox(height: 12),
              for (final run in store.backups)
                Card(
                  child: ListTile(
                    title: Text(run.fileName ?? 'Không tạo được file'),
                    subtitle: Text(
                      '${formatDate(DateTime.parse(run.startedAt))}'
                      '${run.sizeKb == null ? '' : ' · ${run.sizeKb} KB'}'
                      '${run.error == null ? '' : '\n${run.error}'}',
                    ),
                    isThreeLine: run.error != null,
                    trailing: StatusChip(
                      label: run.status == 'SUCCESS' ? 'Thành công' : 'Lỗi',
                      pair: run.status == 'SUCCESS' ? context.colors.successContainer : context.colors.errorContainer,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
