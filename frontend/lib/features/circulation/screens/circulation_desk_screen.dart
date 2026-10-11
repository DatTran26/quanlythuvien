// Màn 1 – Quầy lưu thông (circulation-desk). Route: /circulation
// Bài: Hoang/02-checkout/01-circulation-desk.md
//
// Điểm vào mọi thao tác tại quầy của Thủ thư / Quản trị viên.
// Màn này không gọi API, chỉ là menu. Tên người dùng lấy từ AppSession (sau là /me của TV1).

import 'package:flutter/material.dart';

import '../../../core/auth/session.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/theme_x.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/info_banner.dart';
import '../widgets/desk_action_card.dart';

class CirculationDeskScreen extends StatelessWidget {
  const CirculationDeskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quầy lưu thông'),
        actions: [
          IconButton(
            tooltip: 'Thông báo', // nhãn cho trình đọc màn hình
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {}, // màn thông báo của TV3
          ),
        ],
      ),
      drawer: const _DeskDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Greeting(name: AppSession.displayName, role: AppSession.isAdmin ? 'Quản trị viên' : 'Thủ thư'),
              const SizedBox(height: 16),
              DeskActionCard(
                highlight: true,
                icon: Icons.menu_book_rounded,
                title: 'Mượn Sách',
                subtitle: 'Quét thẻ hoặc nhập mã người đọc để mượn sách',
                onTap: () => Navigator.pushNamed(context, AppRoutes.checkoutScan),
              ),
              const SizedBox(height: 12),
              _actionGrid(context),
              const SizedBox(height: 16),
              const InfoBanner(
                kind: BannerKind.info,
                message: 'Trả sách luôn nhận được, kể cả khi người đọc đang bị khóa.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionGrid(BuildContext context) {
    final actions = [
      DeskActionCard(
        icon: Icons.assignment_return_outlined,
        title: 'Xem Trả Sách / Gia Hạn',
        subtitle: 'Quét mã sách để nhận trả',
        onTap: () => Navigator.pushNamed(context, AppRoutes.returnScan),
      ),
      DeskActionCard(
        icon: Icons.report_problem_outlined,
        title: 'Xem Báo Hư Hỏng',
        subtitle: 'Lập báo cáo kèm ảnh',
        onTap: () => Navigator.pushNamed(context, AppRoutes.damageForm),
      ),
      DeskActionCard(
        icon: Icons.bookmark_add_outlined,
        title: 'Xem Đặt Trước',
        subtitle: 'Giữ chỗ sách đang hết',
        onTap: () => Navigator.pushNamed(context, AppRoutes.reservationSearch),
      ),
      DeskActionCard(
        icon: Icons.bar_chart_rounded,
        title: 'Xem Báo Cáo',
        subtitle: 'Kho, quá hạn, xu hướng',
        onTap: () => Navigator.pushNamed(context, AppRoutes.reportDashboard),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        // Điện thoại < 600px: 2 cột. Tablet / web: 4 cột.
        final columns = constraints.maxWidth < 600 ? 2 : 4;
        return GridView.count(
          crossAxisCount: columns,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          // rộng / cao. 2 cột để 0.95: tiêu đề 2 dòng + mô tả 2 dòng vẫn vừa ở màn 375px
          childAspectRatio: columns == 2 ? 0.95 : 1.4,
          // GridView mặc định muốn cao vô hạn và tự cuộn; đặt trong
          // SingleChildScrollView thì phải co vừa nội dung và tắt cuộn riêng.
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: actions,
        );
      },
    );
  }
}

class _Greeting extends StatelessWidget {
  const _Greeting({required this.name, required this.role});

  final String name;
  final String role;

  static const _weekdays = ['Thứ Hai', 'Thứ Ba', 'Thứ Tư', 'Thứ Năm', 'Thứ Sáu', 'Thứ Bảy', 'Chủ nhật'];

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Chào $name · $role', style: context.textTheme.titleLarge),
        const SizedBox(height: 2),
        Text('${_weekdays[now.weekday - 1]}, ${fmtDate(now)}', style: TextStyle(color: context.colors.textSecondary)),
      ],
    );
  }
}

class _DeskDrawer extends StatelessWidget {
  const _DeskDrawer();

  @override
  Widget build(BuildContext context) {
    final scheme = context.scheme;

    // Đóng drawer TRƯỚC khi chuyển màn, không thì quay lại vẫn thấy drawer mở.
    void go(String route) {
      Navigator.pop(context);
      Navigator.pushNamed(context, route);
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: scheme.primary),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text('Thư viện', style: context.textTheme.titleLarge?.copyWith(color: scheme.onPrimary)),
            ),
          ),
          // Các màn TV2 không có thẻ riêng trên quầy
          ListTile(
            leading: const Icon(Icons.update),
            title: const Text('Gia hạn sách'),
            onTap: () => go(AppRoutes.renewalRequest),
          ),
          ListTile(
            leading: const Icon(Icons.search_off),
            title: const Text('Ghi nhận mất sách'),
            onTap: () => go(AppRoutes.lostRecord),
          ),
          ListTile(
            leading: const Icon(Icons.find_in_page_outlined),
            title: const Text('Tìm lại sách đã mất'),
            onTap: () => go(AppRoutes.foundAfterLost),
          ),
          ListTile(
            leading: const Icon(Icons.how_to_reg_outlined),
            title: const Text('Nhận sách đặt trước'),
            onTap: () => go(AppRoutes.reservationPickup),
          ),
          ListTile(
            leading: const Icon(Icons.schedule),
            title: const Text('Phiếu quá hạn'),
            onTap: () => go(AppRoutes.overdueList),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person_search_outlined),
            title: const Text('Tra cứu người đọc'),
            onTap: () => Navigator.pop(context), // màn của TV3
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text('Tra cứu danh mục'),
            onTap: () => Navigator.pop(context), // màn của TV1
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Đăng xuất'),
            onTap: () => Navigator.pop(context), // TV1 cung cấp hàm đăng xuất
          ),
        ],
      ),
    );
  }
}
