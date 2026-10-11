// Màn tạm cho route của người khác chưa làm. Bài: Hoang/01-nen-tang/04-dieu-huong-routing.md mục 5

import 'package:flutter/material.dart';

import '../theme/theme_x.dart';
import '../widgets/info_banner.dart';
import '../widgets/state_views.dart';

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key, this.title = 'Đang xây dựng', this.owner});

  final String title;
  final String? owner; // ai làm màn này, ví dụ "TV3 (Bảo)"

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(title)),
        body: EmptyState(
          icon: Icons.construction,
          message: owner == null ? 'Màn hình này đang được làm.' : 'Màn hình này do $owner làm, đang được xây dựng.',
        ),
      );
}

/// TẠM THỜI thay màn session-expired của TV1 (xác thực lại trước thao tác nhạy cảm).
/// Trả về true khi bấm "Xác nhận", false khi hủy. TV1 sẽ thay bằng màn nhập mật khẩu thật.
class StepUpPlaceholderScreen extends StatelessWidget {
  const StepUpPlaceholderScreen({super.key, this.reason});

  final String? reason;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Xác thực lại')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(reason ?? 'Xác nhận để tiếp tục thao tác nhạy cảm.', style: context.textTheme.titleMedium),
          const SizedBox(height: 12),
          const InfoBanner(
            kind: BannerKind.warning,
            message: 'Màn tạm: chưa kiểm tra mật khẩu. TV1 (Đạt) sẽ thay bằng màn xác thực thật.',
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(children: [
            Expanded(
              child: OutlinedButton(onPressed: () => Navigator.pop(context, false), child: const Text('Hủy')),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Xác nhận')),
            ),
          ]),
        ),
      ),
    );
  }
}
