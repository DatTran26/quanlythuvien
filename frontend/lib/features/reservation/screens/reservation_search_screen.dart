// Màn 13 – Tìm sách để đặt trước (reservation-search). Route: /reservation/search · R2
// Bài: Hoang/07-reservation/01-reservation-search.md
//
// BR-08: chỉ đặt trước khi số bản khả dụng = 0; còn bản thì mượn trực tiếp tại quầy.
// G7: /titles chưa trả availableCount -> hiện nút "Đặt trước" cho mọi đầu sách; nếu còn bản,
// backend trả STILL_AVAILABLE và màn form báo + gợi ý mượn trực tiếp.

import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/layout/breakpoints.dart';
import '../../../core/network/api_client.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/theme_x.dart';
import '../../../core/widgets/state_views.dart';
import '../data/reservation_api.dart';
import '../models/title_item.dart';

class ReservationSearchScreen extends StatefulWidget {
  const ReservationSearchScreen({super.key});

  @override
  State<ReservationSearchScreen> createState() => _ReservationSearchScreenState();
}

class _ReservationSearchScreenState extends State<ReservationSearchScreen> {
  final _api = ReservationApi();
  final _ctrl = TextEditingController();
  Timer? _debounce;
  String _query = '';
  List<TitleItem> _items = [];
  bool _loading = false;
  String? _error;
  int _requestId = 0; // chống "kết quả cũ về sau ghi đè kết quả mới"

  @override
  void dispose() {
    _debounce?.cancel(); // hủy timer, nếu không nó vẫn chạy sau khi đóng màn
    _ctrl.dispose();
    super.dispose();
  }

  /// Debounce: chỉ tìm khi người dùng ngừng gõ 400ms, không gọi API theo từng ký tự.
  void _onChanged(String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () => _search(text.trim()));
    setState(() {}); // cập nhật nút xóa
  }

  Future<void> _search(String q) async {
    setState(() {
      _query = q;
      _error = null;
    });
    if (q.length < 2) {
      // ít hơn 2 ký tự: chưa tìm
      setState(() => _items = []);
      return;
    }
    final myId = ++_requestId;
    setState(() => _loading = true);
    try {
      final list = await _api.searchTitles(q);
      if (!mounted || myId != _requestId) return; // đã có lần tìm mới hơn -> bỏ kết quả này
      setState(() {
        _items = list;
        _loading = false;
      });
    } on ApiException catch (e) {
      if (!mounted || myId != _requestId) return;
      setState(() {
        _error = e.message;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đặt trước sách')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: SearchBar(
              controller: _ctrl,
              autoFocus: !context.isCompact, // điện thoại: không bật bàn phím ngay
              hintText: 'Tên sách, tác giả hoặc ISBN',
              leading: const Icon(Icons.search),
              onChanged: _onChanged,
              onSubmitted: (t) {
                _debounce?.cancel();
                _search(t.trim());
              },
              trailing: [
                if (_ctrl.text.isNotEmpty)
                  IconButton(
                    tooltip: 'Xóa',
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _ctrl.clear();
                      _search('');
                    },
                  ),
              ],
              elevation: const WidgetStatePropertyAll(0),
              backgroundColor: WidgetStatePropertyAll(context.scheme.surface),
              side: WidgetStatePropertyAll(BorderSide(color: context.scheme.outline)),
            ),
          ),
          if (_items.isNotEmpty && !_loading)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('${_items.length} kết quả cho "$_query"',
                    style: TextStyle(color: context.colors.textSecondary)),
              ),
            ),
          Expanded(child: _results()),
        ],
      ),
    );
  }

  Widget _results() {
    if (_query.length < 2) {
      return const EmptyState(icon: Icons.manage_search, message: 'Nhập ít nhất 2 ký tự để tìm sách.');
    }
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) return ErrorState(message: _error!, onRetry: () => _search(_query));
    if (_items.isEmpty) {
      return EmptyState(icon: Icons.search_off, message: 'Không tìm thấy sách nào cho "$_query".');
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      itemCount: _items.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (_, i) => _titleTile(_items[i]),
    );
  }

  Widget _titleTile(TitleItem t) {
    final available = t.availableCount; // null = chưa biết (G7)
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _highlight(t.name, _query),
                const SizedBox(height: 2),
                Text(t.author, style: TextStyle(color: context.colors.textSecondary)),
                if (available != null)
                  Text(
                    available == 0 ? 'Khả dụng: 0 bản' : 'Khả dụng: $available bản · mượn tại quầy',
                    style: TextStyle(
                      color: available == 0 ? context.colors.warning : context.colors.success,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          if (available == null || available == 0) // BR-08
            FilledButton.tonal(
              style: AppButtonStyles.tonal(context).merge(AppButtonStyles.small(context)),
              onPressed: () => Navigator.pushNamed(context, AppRoutes.reservationForm, arguments: t),
              child: const Text('Đặt trước'),
            ),
        ],
      ),
    );
  }

  /// Tô đậm phần trùng từ khóa (không phân biệt hoa thường)
  Widget _highlight(String text, String q) {
    final i = text.toLowerCase().indexOf(q.toLowerCase());
    final base = context.textTheme.bodyLarge;
    if (q.isEmpty || i < 0) return Text(text, style: base);
    return Text.rich(TextSpan(style: base, children: [
      TextSpan(text: text.substring(0, i)),
      TextSpan(
        text: text.substring(i, i + q.length),
        style: TextStyle(fontWeight: FontWeight.w700, color: context.scheme.primary),
      ),
      TextSpan(text: text.substring(i + q.length)),
    ]));
  }
}
