// Màn 3 – Thanh toán tiền mặt (fine-payment, fine-collection-basic). Route: /fines/:id/pay
// Spec: docs/features/fine-collection-basic/srs/ (FR-001, BR-001, E-001, E-002)
// Checklist: CHK-fine-collection-basic-001..004.
//
// Mục đích: ghi nhận thu tiền mặt. Số tiền > 0 và ≤ số dư. Mỗi lần mở màn có một mã thao tác
// (operationId): bấm lặp hoặc gửi lại không ghi khoản thu thứ hai (E-core-005).
// Đến từ: fine-detail. Đi tới: fine-receipt.

import 'package:flutter/material.dart';
import 'package:frontend/core/utils/format.dart';

import '../data/fine_api.dart';
import '../widgets/money_field.dart';
import 'fine_receipt_screen.dart';

class FinePaymentScreen extends StatefulWidget {
  const FinePaymentScreen({
    super.key,
    required this.api,
    required this.actorId,
    required this.fineId,
  });

  final FineApi api;
  final int actorId;
  final int fineId;

  @override
  State<FinePaymentScreen> createState() => _FinePaymentScreenState();
}

class _FinePaymentScreenState extends State<FinePaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amount = TextEditingController();
  // Một mã cho cả lần mở màn này: gửi lại sau lỗi mạng vẫn dùng mã cũ (BR-fine-collection-basic-001).
  final _operationId = 'pay-${DateTime.now().microsecondsSinceEpoch}';
  late final Future<FineDetail> _future;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _future = widget.api.fineDetail(widget.fineId).then((d) {
      _amount.text = '${d.fine.balanceVnd}'; // mặc định thu hết
      return d;
    });
  }

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  Future<void> _submit(FineDetail detail) async {
    if (!_formKey.currentState!.validate()) return;
    final amount = parseVnd(_amount.text)!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận thu tiền'),
        content: Text(
          'Thu ${formatVnd(amount)} tiền mặt của ${detail.reader.name}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Thu'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;

    setState(() => _saving = true);
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final result = await widget.api.collect(
        fineId: widget.fineId,
        amountVnd: amount,
        actorId: widget.actorId,
        operationId: _operationId,
      );
      if (result.duplicate) {
        // E-fine-collection-basic-002: báo trùng và hiện khoản thu đã ghi.
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Khoản thu này đã được ghi trước đó, không ghi lại.'),
          ),
        );
      }
      navigator.pushReplacement(
        MaterialPageRoute(
          builder: (_) => FineReceiptScreen(
            api: widget.api,
            transaction: result.transaction,
            reader: detail.reader,
          ),
        ),
      );
    } on FineException catch (e) {
      // E-fine-collection-basic-001: khoản phạt giữ nguyên, cho thử lại với cùng mã thao tác.
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thu tiền mặt')),
      body: FutureBuilder<FineDetail>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final detail = snapshot.data!;
          final balance = detail.fine.balanceVnd;
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  detail.reader.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text('Còn nợ ${formatVnd(balance)}'),
                const SizedBox(height: 16),
                MoneyField(
                  controller: _amount,
                  label: 'Số tiền thu *',
                  helperText: 'Tối đa ${formatVnd(balance)}',
                  validator: (v) {
                    if (v == null || v <= 0) {
                      return 'Số tiền thu phải lớn hơn 0';
                    }
                    if (v > balance) {
                      return 'Không được vượt số còn nợ ${formatVnd(balance)}';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    // Khóa nút trong lúc ghi để không bấm hai lần.
                    onPressed: _saving ? null : () => _submit(detail),
                    child: const Text('Xác nhận thu'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
