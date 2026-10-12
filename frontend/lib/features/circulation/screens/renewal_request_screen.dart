// Màn 7 – Yêu cầu gia hạn (renewal-request). Route: /renewal/request · R1B
// Bài: Hoang/04-renewal/01-renewal-request.md
//
// Chọn các phiếu đang mượn để gia hạn. Dòng không gia hạn được thì tắt và ghi lý do (BR-renewal-001).
// Hiện lấy phiếu của người đang đăng nhập (GET /loans/mine). Nhân viên gia hạn hộ người đọc
// cần API lấy phiếu theo người đọc (chưa có), xem 00-cau-hoi-va-lo-hong-api.md.

import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/theme_x.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/info_banner.dart';
import '../../../core/widgets/loading_button.dart';
import '../../../core/widgets/state_views.dart';
import '../data/circulation_api.dart';
import '../models/loan_view.dart';
import '../widgets/status_mapping.dart';

/// Kết quả gia hạn từng phiếu, truyền sang renewal-result.
class RenewalItemResult {
  RenewalItemResult({required this.before, this.after, this.errorCode, this.errorMessage});

  final LoanView before;
  final LoanView? after; // != null là thành công
  final String? errorCode;
  final String? errorMessage;

  bool get ok => after != null;
}

class RenewalRequestScreen extends StatefulWidget {
  const RenewalRequestScreen({super.key});

  @override
  State<RenewalRequestScreen> createState() => _RenewalRequestScreenState();
}

class _RenewalRequestScreenState extends State<RenewalRequestScreen> {
  final _api = CirculationApi();
  static const _renewLimit = 1; // OQ-policy-config-001 (đề xuất 1)

  List<LoanView> _loans = [];
  final Set<int> _selected = {};
  bool _loading = true;
  bool _submitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final loans = await _api.myLoans();
      if (!mounted) return;
      setState(() {
        _loans = loans.where((l) => l.status == 'ACTIVE' || l.status == 'OVERDUE').toList();
        _selected.removeWhere((id) => !_loans.any((l) => l.id == id && _blockReason(l) == null));
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

  /// null = được gia hạn; ngược lại là câu lý do
  String? _blockReason(LoanView l) {
    if (l.status == 'OVERDUE' || l.dueAt.isBefore(DateTime.now())) {
      return 'Đã quá hạn, cần trả sách và thanh toán phạt';
    }
    if (l.renewCount >= _renewLimit) return 'Đã hết lượt gia hạn ($_renewLimit/$_renewLimit)';
    return null;
  }

  Future<void> _submit() async {
    if (_selected.isEmpty || _submitting) return;
    setState(() => _submitting = true);
    final results = <RenewalItemResult>[];
    for (final loan in _loans.where((l) => _selected.contains(l.id))) {
      try {
        final after = await _api.renew(loan.id);
        results.add(RenewalItemResult(before: loan, after: after));
      } on ApiException catch (e) {
        // Lỗi 1 phiếu KHÔNG dừng các phiếu khác: mỗi phiếu gia hạn độc lập
        results.add(RenewalItemResult(before: loan, errorCode: e.code, errorMessage: e.message));
      }
    }
    if (!mounted) return;
    setState(() => _submitting = false);
    await Navigator.pushNamed(context, AppRoutes.renewalResult, arguments: results);
    if (mounted) {
      _selected.clear();
      _load(); // quay lại thì tải hạn trả mới
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gia hạn sách')),
      body: RefreshIndicator(onRefresh: _load, child: _body()),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_selected.isEmpty && !_loading)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text('Chọn ít nhất 1 cuốn để gia hạn',
                      style: TextStyle(fontSize: 13, color: context.colors.textSecondary)),
                ),
              SizedBox(
                width: double.infinity,
                child: LoadingButton(
                  icon: Icons.update,
                  label: 'Gửi yêu cầu gia hạn${_selected.isEmpty ? '' : ' (${_selected.length})'}',
                  loadingLabel: 'Đang gia hạn…',
                  loading: _submitting,
                  onPressed: _selected.isEmpty ? null : _submit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _body() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) return ErrorState(message: _error!, onRetry: _load);
    if (_loans.isEmpty) {
      // ListView để RefreshIndicator vẫn kéo được khi trống
      return ListView(children: const [
        SizedBox(height: 120),
        EmptyState(icon: Icons.library_books_outlined, message: 'Không có sách đang mượn để gia hạn.'),
      ]);
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _loans.length + 2, // + mô tả đầu + banner cuối
      itemBuilder: (context, i) {
        if (i == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text('Chọn sách muốn gia hạn. Mỗi lần gia hạn cộng thêm 7 ngày.',
                style: TextStyle(color: context.colors.textSecondary)),
          );
        }
        if (i == _loans.length + 1) {
          return const Padding(
            padding: EdgeInsets.only(top: 8),
            child: InfoBanner(kind: BannerKind.info, message: 'Sách đang có người đặt trước sẽ không gia hạn được.'),
          );
        }
        final loan = _loans[i - 1];
        final reason = _blockReason(loan);
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: CheckboxListTile(
            value: _selected.contains(loan.id),
            onChanged: reason != null
                ? null // null = dòng bị tắt
                : (v) => setState(() => v == true ? _selected.add(loan.id) : _selected.remove(loan.id)),
            controlAffinity: ListTileControlAffinity.leading, // ô tích bên trái
            title: Text(loan.titleName),
            subtitle: Text(
              reason ?? 'Hạn ${fmtDate(loan.dueAt)} · đã gia hạn ${loan.renewCount}/$_renewLimit',
              style: TextStyle(color: context.colors.textSecondary),
            ),
            secondary: loan.status == 'OVERDUE' ? loanStatusChip(context, loan.status) : null,
          ),
        );
      },
    );
  }
}
