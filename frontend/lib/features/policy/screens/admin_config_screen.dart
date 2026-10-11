import 'package:flutter/material.dart';
import 'package:frontend/core/routing/app_routes.dart';
import 'package:frontend/core/utils/format.dart';
import 'package:frontend/core/widgets/info_banner.dart';
import 'package:frontend/core/widgets/snackbar.dart';
import 'package:frontend/features/catalog/data/catalog_store.dart';
import 'package:frontend/features/catalog/widgets/store_loader.dart';

class AdminConfigScreen extends StatefulWidget {
  const AdminConfigScreen({super.key});

  @override
  State<AdminConfigScreen> createState() => _AdminConfigScreenState();
}

class _AdminConfigScreenState extends State<AdminConfigScreen> {
  final _fields = <String, TextEditingController>{};
  DateTime? _effectiveAt;
  var _ready = false;

  @override
  void dispose() {
    for (final controller in _fields.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _ensure(LendingPolicy policy) {
    if (_ready) return;
    _ready = true;
    _effectiveAt = DateTime.now();
    _fields.addAll({
      'maxActiveLoans': TextEditingController(text: '${policy.maxActiveLoans}'),
      'loanDays': TextEditingController(text: '${policy.loanDays}'),
      'maxRenewals': TextEditingController(text: '${policy.maxRenewals}'),
      'renewDays': TextEditingController(text: '${policy.renewDays}'),
      'finePerDayVnd': TextEditingController(text: '${policy.finePerDayVnd}'),
      'fineBlockVnd': TextEditingController(text: '${policy.fineBlockVnd}'),
      'holdHours': TextEditingController(text: '${policy.holdHours}'),
      'maxOpenReservations': TextEditingController(text: '${policy.maxOpenReservations}'),
      'lostProcessingFeeVnd': TextEditingController(text: '${policy.lostProcessingFeeVnd}'),
    });
  }

  int _read(String key) => int.tryParse(_fields[key]!.text.trim()) ?? -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quy định mượn')),
      body: StoreLoader(
        builder: (context, store) {
          _ensure(store.policy);
          final effective = _effectiveAt ?? DateTime.now();
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const InfoBanner(
                kind: BannerKind.info,
                message: 'Phiếu đã tạo giữ quy định lúc mượn. Thay đổi chỉ áp dụng cho giao dịch sau thời điểm hiệu lực.',
              ),
              const SizedBox(height: 12),
              _number('Số sách đang mượn tối đa', 'maxActiveLoans'),
              _number('Số ngày mượn', 'loanDays'),
              _number('Số lần gia hạn', 'maxRenewals'),
              _number('Số ngày mỗi lần gia hạn', 'renewDays'),
              _number('Phạt mỗi ngày (đồng)', 'finePerDayVnd'),
              _number('Ngưỡng chặn mượn (đồng)', 'fineBlockVnd'),
              _number('Giờ giữ chỗ', 'holdHours'),
              _number('Số đặt trước đang mở', 'maxOpenReservations'),
              _number('Phí xử lý mất sách (đồng)', 'lostProcessingFeeVnd'),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Hiệu lực từ'),
                subtitle: Text(formatDate(effective)),
                trailing: const Icon(Icons.calendar_today_outlined),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: effective,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) setState(() => _effectiveAt = picked);
                },
              ),
              if (store.lastPolicyNote != null) ...[
                const SizedBox(height: 8),
                InfoBanner(kind: BannerKind.success, message: store.lastPolicyNote!),
              ],
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () {
                  final next = LendingPolicy(
                    maxActiveLoans: _read('maxActiveLoans'),
                    loanDays: _read('loanDays'),
                    maxRenewals: _read('maxRenewals'),
                    renewDays: _read('renewDays'),
                    finePerDayVnd: _read('finePerDayVnd'),
                    fineBlockVnd: _read('fineBlockVnd'),
                    holdHours: _read('holdHours'),
                    maxOpenReservations: _read('maxOpenReservations'),
                    lostProcessingFeeVnd: _read('lostProcessingFeeVnd'),
                  );
                  final error = store.savePolicy(next, effective);
                  if (error != null) {
                    showAppSnackBar(context, error, isError: true);
                    return;
                  }
                  setState(() {});
                  showAppSnackBar(context, 'Đã lưu quy định.');
                },
                child: const Text('Lưu quy định'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.importUpload),
                child: const Text('Mở nhập dữ liệu'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _number(String label, String key) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: _fields[key],
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      ),
    );
  }
}
