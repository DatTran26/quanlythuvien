// Chuông thông báo có huy hiệu số chưa đọc, gắn vào AppBar của mọi khu vực.
// Bấm -> notification-center. Quay về thì tự đếm lại.
// Báo TV1 / TV2 tên widget này để gắn vào AppBar của họ.

import 'package:flutter/material.dart';

import '../data/notification_api.dart';
import '../screens/notification_center_screen.dart';

class NotificationBell extends StatefulWidget {
  const NotificationBell({super.key, required this.userId, this.api});

  final int userId;
  final NotificationApi? api;

  @override
  State<NotificationBell> createState() => _NotificationBellState();
}

class _NotificationBellState extends State<NotificationBell> {
  late final NotificationApi _api = widget.api ?? MockNotificationApi();
  int _unread = 0;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final count = await _api.unreadCount(widget.userId);
    if (mounted) setState(() => _unread = count);
  }

  Future<void> _open() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            NotificationCenterScreen(userId: widget.userId, api: _api),
      ),
    );
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return IconButton(
      tooltip: _unread == 0 ? 'Thông báo' : 'Thông báo, $_unread chưa đọc',
      onPressed: _open,
      icon: Badge(
        isLabelVisible: _unread > 0,
        // docs/design/color-system.md: secondary dùng cho huy hiệu, số đếm.
        backgroundColor: colors.secondary,
        textColor: colors.onSecondary,
        label: Text(_unread > 9 ? '9+' : '$_unread'),
        child: const Icon(Icons.notifications_outlined),
      ),
    );
  }
}
