// Màn 1 – Danh sách người đọc (reader-list). Route: /readers
// Bài: TV3 1A (Bước 5) · Độ khó ⭐⭐
// Spec: docs/features/account-admin/srs/account-admin-userflow.md
//
// Mục đích: Thủ thư / Quản trị viên tra cứu tài khoản người đọc.
// Đến từ: dashboard-home (TV1). Đi tới: reader-detail, reader-form (Cấp tài khoản mới),
// staff-accounts (chỉ Quản trị viên).
//

import 'package:flutter/material.dart';
import 'package:frontend/features/notification/widgets/notification_bell.dart';

import 'reader_form_screen.dart';
import '../data/account_api.dart';
import '../models/reader_row.dart';
import '../widgets/account_status.dart';
import 'reader_detail_screen.dart';
import 'staff_accounts_screen.dart';

class ReaderListScreen extends StatefulWidget {
  const ReaderListScreen({super.key});

  @override
  State<ReaderListScreen> createState() => _ReaderListScreenState();
}

class _ReaderListScreenState extends State<ReaderListScreen> {
  final AccountApi _api = MockAccountApi();
  final TextEditingController _search = TextEditingController();
  late Future<List<ReaderRow>> _future;

  @override
  void initState() {
    super.initState();
    _future = _api.readers();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _runSearch() {
    setState(() {
      _future = _api.readers(query: _search.text);
    });
  }

  Future<void> _openDetail(ReaderRow row) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ReaderDetailScreen(userId: row.user.id),
      ),
    );
    _runSearch();
  }

  Future<void> _openForm() async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const ReaderFormScreen()));
    // Có thể vừa cấp tài khoản mới: tải lại danh sách.
    _runSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách người đọc'),
        actions: [
          // Chỉ Quản trị viên. Khi có phân quyền (TV1) thì ẩn với Thủ thư.
          IconButton(
            icon: const Icon(Icons.badge_outlined),
            tooltip: 'Tài khoản Thủ thư',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const StaffAccountsScreen()),
            ),
          ),
          // Tạm coi người dùng màn là Quản trị viên #1 (giống _actorId ở các màn accounts).
          const NotificationBell(userId: 1),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openForm,
        icon: const Icon(Icons.person_add),
        label: const Text('Cấp tài khoản mới'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _search,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _runSearch(),
              decoration: InputDecoration(
                labelText: 'Tìm theo tên, email hoặc mã thẻ',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  tooltip: 'Tìm',
                  onPressed: _runSearch,
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<ReaderRow>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Lỗi: ${snapshot.error}'));
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final rows = snapshot.data!;
                if (rows.isEmpty) {
                  return const Center(
                    child: Text('Không tìm thấy người đọc phù hợp'),
                  );
                }
                return ListView.separated(
                  itemCount: rows.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final row = rows[i];
                    return ListTile(
                      title: Text(row.user.displayName),
                      subtitle: Text(row.cardCode ?? 'Chưa có thẻ'),
                      trailing: AccountStatusChip(row.user.status),
                      onTap: () => _openDetail(row),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
