// Khung cụm đặt trước: "Tìm sách" | "Của tôi".
// Bài: Hoang/07-reservation/03-reservation-queue.md (Bước 2), Hoang/01-nen-tang/06 mục 4
// Điện thoại: NavigationBar ở dưới. Màn rộng: NavigationRail bên trái.

import 'package:flutter/material.dart';

import '../../../core/layout/breakpoints.dart';
import '../../../core/theme/theme_x.dart';
import 'reservation_queue_screen.dart';
import 'reservation_search_screen.dart';

class ReservationShell extends StatefulWidget {
  const ReservationShell({super.key, this.initialTab = 0});

  final int initialTab; // 0 = Tìm sách, 1 = Của tôi

  @override
  State<ReservationShell> createState() => _ReservationShellState();
}

class _ReservationShellState extends State<ReservationShell> {
  late int _tab = widget.initialTab;

  @override
  Widget build(BuildContext context) {
    // IndexedStack giữ nguyên trạng thái từng tab khi chuyển qua lại
    final content = IndexedStack(
      index: _tab,
      children: const [ReservationSearchScreen(), ReservationQueueScreen()],
    );

    if (context.isCompact) {
      return Scaffold(
        body: content,
        bottomNavigationBar: NavigationBar(
          selectedIndex: _tab,
          onDestinationSelected: (i) => setState(() => _tab = i),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.search), label: 'Tìm sách'),
            NavigationDestination(
              icon: Icon(Icons.bookmarks_outlined),
              selectedIcon: Icon(Icons.bookmarks), // icon đậm khi đang chọn
              label: 'Của tôi',
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Row(children: [
        SafeArea(
          child: NavigationRail(
            selectedIndex: _tab,
            onDestinationSelected: (i) => setState(() => _tab = i),
            labelType: NavigationRailLabelType.all,
            leading: BackButton(onPressed: () => Navigator.maybePop(context)),
            destinations: const [
              NavigationRailDestination(icon: Icon(Icons.search), label: Text('Tìm sách')),
              NavigationRailDestination(
                icon: Icon(Icons.bookmarks_outlined),
                selectedIcon: Icon(Icons.bookmarks),
                label: Text('Của tôi'),
              ),
            ],
          ),
        ),
        VerticalDivider(width: 1, color: context.colors.divider),
        Expanded(child: content),
      ]),
    );
  }
}
