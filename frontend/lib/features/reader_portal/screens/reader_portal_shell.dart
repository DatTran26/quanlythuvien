// Khung cổng người đọc có thanh điều hướng dưới. Route: /portal
// Mục đích: điểm vào của vai trò Người đọc sau đăng nhập (DEC-SF-02).
//
// Tab: Tra cứu, Thẻ, Đang mượn, Công nợ. Mỗi tab có chuông thông báo (notification-audit-ui).
// Web màn rộng dùng NavigationRail: chờ thống nhất với reservation_shell của TV2.

import 'package:flutter/material.dart';
import 'package:frontend/features/notification/widgets/notification_bell.dart';

import '../data/portal_api.dart';
import 'reader_current_loans_screen.dart';
import 'reader_my_fines_screen.dart';
import 'reader_qr_screen.dart';
import 'reader_search_screen.dart';

class ReaderPortalShell extends StatefulWidget {
  const ReaderPortalShell({super.key, required this.api, required this.userId});

  final PortalApi api;

  /// Người đọc đang đăng nhập, dùng cho chuông thông báo. Khi có đăng nhập (TV1) lấy từ phiên.
  final int userId;

  @override
  State<ReaderPortalShell> createState() => _ReaderPortalShellState();
}

class _ReaderPortalShellState extends State<ReaderPortalShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final bell = [NotificationBell(userId: widget.userId)];
    final pages = [
      ReaderSearchScreen(api: widget.api, actions: bell),
      ReaderQrScreen(api: widget.api, actions: bell),
      ReaderCurrentLoansScreen(api: widget.api, actions: bell),
      ReaderMyFinesScreen(api: widget.api, actions: bell),
    ];
    return Scaffold(
      // IndexedStack giữ trạng thái từng tab khi chuyển qua lại (không tải lại).
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.search), label: 'Tra cứu'),
          NavigationDestination(icon: Icon(Icons.qr_code_2), label: 'Thẻ'),
          NavigationDestination(
            icon: Icon(Icons.menu_book),
            label: 'Đang mượn',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long),
            label: 'Công nợ',
          ),
        ],
      ),
    );
  }
}
