// Màn 8 – Kết quả gia hạn (renewal-result). Route: /renewal/result · R1B
// Bài: Hoang/04-renewal/02-renewal-result.md
//
// Từng phiếu gia hạn thành công hay bị chặn, kèm lý do và việc nên làm.

import 'package:flutter/material.dart';

import '../../../core/theme/theme_x.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/info_banner.dart';
import 'renewal_request_screen.dart' show RenewalItemResult;

class RenewalResultScreen extends StatelessWidget {
  const RenewalResultScreen({super.key, required this.results});

  final List<RenewalItemResult> results;

  (String, String) _explain(String? code, String? fallback) => switch (code) {
        'RENEW_STATUS' => ('Phiếu đã quá hạn hoặc đã đóng.', 'Trả sách và thanh toán phạt nếu có.'),
        'RENEW_LIMIT' => ('Đã hết lượt gia hạn.', 'Vui lòng trả sách đúng hạn.'),
        'RENEW_QUEUE' => ('Có người đang đặt trước đầu sách này.', 'Vui lòng trả đúng hạn. Có thể đặt trước lại sau khi trả.'),
        'READER_INACTIVE' => ('Tài khoản đang bị khóa hoặc chưa kích hoạt.', 'Liên hệ thủ thư để được hỗ trợ.'),
        'STALE_COPY' || 'CONFLICT' => ('Phiếu vừa thay đổi (đã trả hoặc ghi nhận mất).', 'Tải lại danh sách.'),
        _ => (fallback ?? 'Không gia hạn được.', 'Thử lại sau.'),
      };

  @override
  Widget build(BuildContext context) {
    final ok = results.where((r) => r.ok).toList();
    final failed = results.where((r) => !r.ok).toList();
    final allOk = failed.isEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Kết quả gia hạn')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          InfoBanner(
            kind: allOk ? BannerKind.success : BannerKind.warning,
            message: allOk
                ? 'Gia hạn thành công ${ok.length} cuốn.'
                : 'Gia hạn thành công ${ok.length}/${results.length} cuốn.',
          ),
          if (ok.isNotEmpty) ...[
            _title(context, 'Thành công'),
            Card(
              margin: EdgeInsets.zero,
              child: Column(children: [
                for (var i = 0; i < ok.length; i++) ...[
                  if (i > 0) const Divider(height: 1),
                  _okTile(context, ok[i]),
                ],
              ]),
            ),
          ],
          if (failed.isNotEmpty) ...[
            _title(context, 'Không gia hạn được'),
            Card(
              margin: EdgeInsets.zero,
              clipBehavior: Clip.antiAlias,
              child: Column(children: [
                for (var i = 0; i < failed.length; i++) ...[
                  if (i > 0) const Divider(height: 1),
                  _failTile(context, failed[i]),
                ],
              ]),
            ),
          ],
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Xong')),
        ),
      ),
    );
  }

  Widget _title(BuildContext context, String t) => Padding(
        padding: const EdgeInsets.fromLTRB(4, 20, 0, 8),
        child: Text(t.toUpperCase(), style: context.textTheme.labelLarge?.copyWith(color: context.colors.textSecondary)),
      );

  Widget _okTile(BuildContext context, RenewalItemResult r) {
    final sub = context.colors.textSecondary;
    return ListTile(
      leading: Icon(Icons.check_circle_outline, color: context.colors.success),
      title: Text(r.before.titleName),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(TextSpan(children: [
            TextSpan(text: 'Hạn: ', style: TextStyle(color: sub)),
            TextSpan(
              text: fmtDate(r.before.dueAt),
              style: TextStyle(color: sub, decoration: TextDecoration.lineThrough), // hạn cũ gạch ngang
            ),
            TextSpan(text: '  →  ', style: TextStyle(color: sub)),
            TextSpan(
              text: fmtDate(r.after!.dueAt),
              style: TextStyle(color: context.scheme.onSurface, fontWeight: FontWeight.w700),
            ),
          ])),
          Text('Đã gia hạn ${r.after!.renewCount} lần', style: TextStyle(color: sub)),
        ],
      ),
    );
  }

  Widget _failTile(BuildContext context, RenewalItemResult r) {
    final (reason, hint) = _explain(r.errorCode, r.errorMessage);
    return ExpansionTile(
      leading: Icon(Icons.cancel_outlined, color: context.scheme.error),
      title: Text(r.before.titleName),
      subtitle: Text(reason),
      shape: const Border(), // bỏ viền mặc định khi mở
      childrenPadding: const EdgeInsets.fromLTRB(72, 0, 16, 12),
      expandedAlignment: Alignment.centerLeft,
      children: [
        Text('Hạn trả hiện tại: ${fmtDate(r.before.dueAt)}'),
        const SizedBox(height: 4),
        Text('Gợi ý: $hint', style: TextStyle(color: context.colors.textSecondary)),
      ],
    );
  }
}
