import 'package:flutter/material.dart';
import 'package:frontend/core/auth/session.dart';
import 'package:frontend/core/routing/app_routes.dart';
import 'package:frontend/core/theme/theme_x.dart';
import 'package:frontend/features/access/data/auth_store.dart';
import 'package:frontend/features/notification/widgets/notification_bell.dart';

/// Điểm vào sau đăng nhập. Chỉ hiện lối vào đúng vai trò.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const _entries = <_Entry>[
    _Entry(Icons.countertops_outlined, 'Quầy lưu thông', 'Mượn, trả, gia hạn tại quầy', AppRoutes.circulationDesk, staff: true),
    _Entry(Icons.menu_book_outlined, 'Danh mục đầu sách', 'Tìm, sửa và ngưng đầu sách', AppRoutes.catalogSearch, staff: true),
    _Entry(Icons.upload_file_outlined, 'Nhập dữ liệu', 'Chạy thử file và đối soát dòng lỗi', AppRoutes.importUpload, admin: true),
    _Entry(Icons.tune, 'Quy định mượn', 'Hạn mượn, phạt, giữ chỗ', AppRoutes.adminConfig, admin: true),
    _Entry(Icons.backup_outlined, 'Sao lưu', 'Lịch sử backup hằng ngày', AppRoutes.backupRuns, admin: true),
    _Entry(Icons.fact_check_outlined, 'Nhật ký', 'Ai đã làm thao tác nhạy cảm', AppRoutes.auditLog, admin: true),
    _Entry(Icons.mark_email_unread_outlined, 'Trạng thái gửi', 'Thư đã gửi, đang thử lại, lỗi hẳn', AppRoutes.notificationStatus, admin: true),
    _Entry(Icons.people_outline, 'Người đọc', 'Hồ sơ, khóa và kích hoạt thẻ', AppRoutes.readerList, staff: true),
    _Entry(Icons.payments_outlined, 'Thu phạt', 'Xem công nợ và thu tiền mặt', AppRoutes.finePayment, staff: true),
    _Entry(Icons.assessment_outlined, 'Báo cáo', 'Kho, quá hạn và xu hướng', AppRoutes.reportDashboard, staff: true),
    _Entry(Icons.bookmark_added_outlined, 'Đặt trước', 'Hàng đợi và nhận sách giữ chỗ', AppRoutes.reservationSearch, staff: true),
    _Entry(Icons.auto_stories_outlined, 'Cổng của tôi', 'Tra cứu, thẻ QR, sách đang mượn', AppRoutes.readerPortal, reader: true),
  ];

  @override
  Widget build(BuildContext context) {
    final visible = _entries.where((e) {
      if (AppSession.isAdmin) return e.admin || e.staff;
      if (AppSession.isStaff) return e.staff;
      return e.reader;
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang chủ'),
        actions: [
          if (AppSession.userId != null) NotificationBell(userId: AppSession.userId!),
          IconButton(
            tooltip: 'Đăng xuất',
            onPressed: () => _signOut(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Chào ${AppSession.displayName}', style: context.textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(AppSession.roleLabel, style: TextStyle(color: context.colors.textSecondary)),
          const SizedBox(height: 16),
          for (final entry in visible) ...[
            Card(
              child: ListTile(
                leading: Icon(entry.icon),
                title: Text(entry.title),
                subtitle: Text(entry.subtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.pushNamed(context, entry.route),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    await AuthStore.signOut();
    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.dashboard, (_) => false);
  }
}

class _Entry {
  const _Entry(this.icon, this.title, this.subtitle, this.route, {this.admin = false, this.staff = false, this.reader = false});

  final IconData icon;
  final String title;
  final String subtitle;
  final String route;
  final bool admin;
  final bool staff;
  final bool reader;
}
