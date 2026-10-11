import 'package:flutter/material.dart';
import 'package:frontend/core/routing/app_routes.dart';
import 'package:frontend/core/theme/theme_x.dart';
import 'package:frontend/core/utils/format.dart';
import 'package:frontend/core/widgets/info_banner.dart';
import 'package:frontend/core/widgets/status_chip.dart';
import 'package:frontend/features/catalog/widgets/store_loader.dart';

class ImportUploadScreen extends StatefulWidget {
  const ImportUploadScreen({super.key});

  @override
  State<ImportUploadScreen> createState() => _ImportUploadScreenState();
}

class _ImportUploadScreenState extends State<ImportUploadScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nhập dữ liệu')),
      body: StoreLoader(
        builder: (context, store) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const InfoBanner(
                kind: BannerKind.info,
                message: 'Bản thử dùng hai lô có sẵn. Lô chạy thử có dòng lỗi để đối soát. Ghi lô chỉ bật khi không còn lỗi.',
              ),
              const SizedBox(height: 12),
              for (final batch in store.batches)
                Card(
                  child: ListTile(
                    title: Text(batch.fileName),
                    subtitle: Text(
                      '${_statusLabel(batch.status)} · ${batch.validRows}/${batch.totalRows} dòng đúng\n'
                      'Tải lúc ${formatDate(DateTime.parse(batch.uploadedAt))}',
                    ),
                    isThreeLine: true,
                    trailing: _chip(context, batch.status),
                    onTap: () async {
                      await Navigator.pushNamed(context, AppRoutes.importReport, arguments: batch.id);
                      if (mounted) setState(() {});
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

String _statusLabel(String status) => switch (status) {
      'COMMITTED' => 'Đã ghi',
      'DRY_RUN' => 'Chạy thử',
      'OVERRIDE_REQUESTED' => 'Đã xin override',
      _ => status,
    };

StatusChip _chip(BuildContext context, String status) {
  final colors = context.colors;
  final pair = switch (status) {
    'COMMITTED' => colors.successContainer,
    'DRY_RUN' => colors.warningContainer,
    'OVERRIDE_REQUESTED' => colors.infoContainer,
    _ => colors.statusNeutral,
  };
  return StatusChip(label: _statusLabel(status), pair: pair);
}
