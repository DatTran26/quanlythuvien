// Màn 3 – Tài khoản Thủ thư (staff-accounts). Route: /staff
// Bài: TV3 1B · Độ khó ⭐⭐
// Spec: docs/features/account-admin/srs/account-admin-userflow.md
//
// Mục đích: chỉ Quản trị viên. Tạo, khóa, mở tài khoản Thủ thư.
// Đến từ: reader-list.
//

import 'package:flutter/material.dart';

import '../data/account_api.dart';
import '../models/app_user.dart';
import '../widgets/account_status.dart';
import '../widgets/create_staff_dialog.dart';
import '../widgets/status_change_dialog.dart';

class StaffAccountsScreen extends StatefulWidget {
  const StaffAccountsScreen({super.key});

  @override
  State<StaffAccountsScreen> createState() => _StaffAccountsScreenState();
}

class _StaffAccountsScreenState extends State<StaffAccountsScreen> {
  // Tạm coi người thao tác là Quản trị viên #1. Khi có đăng nhập (TV1) thì lấy từ phiên.
  static const _actorId = 1;

  final AccountApi _api = MockAccountApi();
  late Future<List<AppUser>> _future;

  @override
  void initState() {
    super.initState();
    _future = _api.staff();
  }

  void _reload() {
    setState(() {
      _future = _api.staff();
    });
  }

  Future<void> _create() async {
    final created = await showCreateStaffDialog(
      context,
      onSave: (name, email, password) => _api.createStaff(
        displayName: name,
        email: email,
        password: password,
        actorId: _actorId,
      ),
    );
    if (created != true || !mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Đã tạo tài khoản Thủ thư')));
    _reload();
  }

  Future<void> _toggle(AppUser user) async {
    final lock = user.status == 'ACTIVE';
    final reason = await showStatusChangeDialog(
      context,
      locking: lock,
      name: user.displayName,
    );
    if (reason == null || !mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    try {
      await _api.setStatus(
        user.id,
        lock ? 'LOCKED' : 'ACTIVE',
        reason: reason,
        actorId: _actorId,
      );
      messenger.showSnackBar(
        SnackBar(
          content: Text(lock ? 'Đã khóa tài khoản' : 'Đã mở khóa tài khoản'),
        ),
      );
      _reload();
    } on AccountException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tài khoản Thủ thư')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _create,
        icon: const Icon(Icons.person_add),
        label: const Text('Tạo tài khoản'),
      ),
      body: FutureBuilder<List<AppUser>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final staff = snapshot.data!;
          if (staff.isEmpty) {
            return const Center(child: Text('Chưa có tài khoản Thủ thư'));
          }
          return ListView.separated(
            itemCount: staff.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final user = staff[i];
              final lock = user.status == 'ACTIVE';
              return ListTile(
                title: Text(user.displayName),
                subtitle: Text(user.email),
                leading: AccountStatusChip(user.status),
                trailing: IconButton(
                  icon: Icon(lock ? Icons.lock_outline : Icons.lock_open),
                  tooltip: lock ? 'Khóa' : 'Mở khóa',
                  onPressed: () => _toggle(user),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
