// Màn 6 – Kết quả trả (return-result). Route: /return/result
// Bài: Hoang/03-return-handling/02-return-result.md
//
// Xác nhận đã nhận trả và cho biết bước tiếp theo: phạt quá hạn (nút sang màn thu phạt của TV3),
// bản sao chờ duyệt nếu hư hỏng.

import 'package:flutter/material.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/theme_x.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/info_banner.dart';
import '../models/return_outcome.dart';
import '../widgets/status_mapping.dart';

class ReturnResultScreen extends StatelessWidget {
  const ReturnResultScreen({super.key, required this.result});

  final ReturnOutcome result;

  /// Trạng thái bản sao sau khi trả (suy ra, vì API chỉ trả LoanView).
  /// Nếu có hàng chờ đặt trước, bản sao thực tế là ON_HOLD (R2). Muốn chính xác: gọi
  /// GET /copies/by-code/{code} sau khi trả.
  String get _copyStatusAfter => result.damaged ? 'PENDING_REVIEW' : 'AVAILABLE';

  @override
  Widget build(BuildContext context) {
    final loan = result.loan;
    return PopScope(
      canPop: false, // không quay lại form đã gửi
      child: Scaffold(
        appBar: AppBar(title: const Text('Kết quả trả'), automaticallyImplyLeading: false),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _successHeader(context),
            const SizedBox(height: 20),
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(loan.titleName, style: context.textTheme.titleMedium),
                    Text('${loan.copyCode} · Phiếu #${loan.id}', style: TextStyle(color: context.colors.textSecondary)),
                    const Divider(height: 24),
                    _statusRow(context, 'Phiếu mượn', loanStatusChip(context, loan.status)),
                    const SizedBox(height: 8),
                    _statusRow(context, 'Bản sao', copyStatusChip(context, _copyStatusAfter)),
                  ],
                ),
              ),
            ),
            if (result.overdueDays > 0) ...[
              const SizedBox(height: 12),
              InfoBanner(
                kind: BannerKind.warning,
                title: 'Phát sinh phạt quá hạn',
                message: 'Trả trễ ${result.overdueDays} ngày. Khoản phạt đã được ghi vào tài khoản người đọc.',
                action: TextButton(
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.finePayment,
                      arguments: loan.readerId), // màn của TV3 (Bảo)
                  child: const Text('Thu phạt'),
                ),
              ),
            ],
            if (result.damaged) ...[
              const SizedBox(height: 12),
              const InfoBanner(
                kind: BannerKind.info,
                title: 'Bản sao chờ duyệt hư hỏng',
                message: 'Đã lập báo cáo hư hỏng. Bản sao tạm ngừng cho mượn đến khi Quản trị viên duyệt.',
              ),
            ],
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                // Cuốn vừa trả không gia hạn được nữa -> gia hạn các cuốn KHÁC người đọc đang mượn
                onPressed: () => Navigator.pushNamed(context, AppRoutes.renewalRequest, arguments: loan.readerId),
                icon: const Icon(Icons.update),
                label: const Text('Gia hạn sách khác của người đọc'),
              ),
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.popUntil(context, ModalRoute.withName(AppRoutes.circulationDesk)),
                    child: const Text('Về quầy'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    // arguments: true = mở màn quét và bật camera ngay (điện thoại)
                    onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.returnScan, arguments: true),
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text('Quét cuốn tiếp'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _successHeader(BuildContext context) {
    return Column(
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.6, end: 1), // phóng từ 60% lên 100%
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutBack, // nảy nhẹ ở cuối
          builder: (_, scale, child) => Transform.scale(scale: scale, child: child),
          // Truyền Icon qua child để Flutter không tạo lại Icon mỗi khung hình
          child: Icon(Icons.check_circle, size: 72, color: context.colors.success),
        ),
        const SizedBox(height: 8),
        Text('Đã nhận trả sách', style: context.textTheme.titleLarge),
        Text(fmtDateTime(DateTime.now()), style: TextStyle(color: context.colors.textSecondary)),
      ],
    );
  }

  Widget _statusRow(BuildContext context, String label, Widget chip) => Row(
        children: [
          Expanded(child: Text(label, style: TextStyle(color: context.colors.textSecondary))),
          chip,
        ],
      );
}
