// Màn 4 – Xung đột khi mượn (checkout-conflict). Route: /checkout/conflict
// Bài: Hoang/02-checkout/04-checkout-conflict.md
//
// Hai quầy cùng mượn một bản sao: backend trả 409 STALE_COPY cho quầy sau.
// Màn này tải trạng thái MỚI của từng cuốn chưa ghi và cho chọn: rà soát lại hoặc hủy phiên.

import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/theme_x.dart';
import '../../../core/widgets/info_banner.dart';
import '../../../core/widgets/state_views.dart';
import '../data/circulation_api.dart';
import '../models/book_copy.dart';
import '../widgets/status_mapping.dart';

class CheckoutConflictScreen extends StatefulWidget {
  const CheckoutConflictScreen({super.key, required this.copies});

  final List<BookCopy> copies; // trạng thái CŨ (lúc quét)

  @override
  State<CheckoutConflictScreen> createState() => _CheckoutConflictScreenState();
}

class _CheckoutConflictScreenState extends State<CheckoutConflictScreen> {
  final _api = CirculationApi();
  Map<String, BookCopy> _fresh = {}; // code -> trạng thái MỚI
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadFresh();
  }

  Future<void> _loadFresh() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      // Gọi song song cho nhanh: Future.wait chờ tất cả cùng xong
      final list = await Future.wait(widget.copies.map((c) => _api.findCopy(c.code)));
      if (!mounted) return;
      setState(() {
        _fresh = {for (final c in list) c.code: c};
        _loading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message;
        _loading = false;
      });
    }
  }

  bool _stillOk(BookCopy c) => c.status == 'AVAILABLE' || c.status == 'ON_HOLD';

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // buộc chọn 1 trong 2 nút, không lỡ tay quay lại
      child: Scaffold(
        appBar: AppBar(title: const Text('Xung đột khi mượn'), automaticallyImplyLeading: false),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? ErrorState(message: _error!, onRetry: _loadFresh)
                : _content(),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Row(
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.popUntil(context, ModalRoute.withName(AppRoutes.circulationDesk)),
                  child: const Text('Hủy phiên'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _loading ? null : () => Navigator.pop(context, true), // true -> review tải lại
                    icon: const Icon(Icons.refresh),
                    label: const Text('Tải lại và rà soát'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _content() {
    final removed = widget.copies.where((c) => !_stillOk(_fresh[c.code] ?? c)).length;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        InfoBanner(
          kind: BannerKind.warning,
          title: 'Sách vừa được cập nhật',
          message: 'Một số cuốn vừa được xử lý ở quầy khác. Chưa có phiếu nào được ghi cho các cuốn này, '
              'thử lại là an toàn.${removed > 0 ? '\n$removed cuốn sẽ bị bỏ khỏi giỏ.' : ''}',
        ),
        const SizedBox(height: 20),
        Text('TRẠNG THÁI MỚI', style: context.textTheme.labelLarge?.copyWith(color: context.colors.textSecondary)),
        const SizedBox(height: 8),
        Card(
          margin: EdgeInsets.zero,
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.copies.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final old = widget.copies[i];
              final now = _fresh[old.code] ?? old;
              return _conflictRow(old, now);
            },
          ),
        ),
      ],
    );
  }

  Widget _conflictRow(BookCopy old, BookCopy now) {
    final ok = _stillOk(now);
    final color = ok ? context.colors.success : context.scheme.error;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(ok ? Icons.check_circle_outline : Icons.cancel_outlined, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(old.titleName, style: context.textTheme.bodyLarge),
                Text(old.code, style: TextStyle(color: context.colors.textSecondary)),
                const SizedBox(height: 8),
                Wrap(
                  // Wrap: hết chỗ thì tự xuống dòng, Row thì tràn
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    copyStatusChip(context, old.status),
                    Icon(Icons.arrow_forward, size: 16, color: context.colors.textSecondary),
                    copyStatusChip(context, now.status),
                  ],
                ),
                const SizedBox(height: 6),
                Text(ok ? 'Vẫn mượn được' : 'Sẽ bỏ khỏi giỏ',
                    style: TextStyle(color: color, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
