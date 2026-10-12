// Màn 6 – Miễn / điều chỉnh (fine-adjust, fine-collection-adv). Route: /fines/:id/adjust
// Spec: docs/features/fine-collection-adv/srs/ (FR-002), CHK-fine-collection-adv-002 (cần step-up),
// CHK-fine-collection-basic-007 (nhân viên không ghi sự kiện ngoài PAYMENT).
//
// Mục đích: Thủ thư miễn toàn bộ hoặc điều chỉnh tăng / giảm, lý do bắt buộc.
// Hoàn tiền / đảo bút toán chờ OQ-fine-collection-adv-001.

import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_theme.dart';
import 'package:frontend/core/utils/format.dart';

import '../data/fine_api.dart';
import '../widgets/money_field.dart';
import '../widgets/step_up_dialog.dart';

enum _Mode { waive, decrease, increase }

class FineAdjustScreen extends StatefulWidget {
  const FineAdjustScreen({
    super.key,
    required this.api,
    required this.actorId,
    required this.fineId,
  });

  final FineApi api;
  final int actorId;
  final int fineId;

  @override
  State<FineAdjustScreen> createState() => _FineAdjustScreenState();
}

class _FineAdjustScreenState extends State<FineAdjustScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amount = TextEditingController();
  final _reason = TextEditingController();
  late final Future<FineDetail> _future = widget.api.fineDetail(widget.fineId);
  _Mode _mode = _Mode.waive;
  bool _saving = false;

  @override
  void dispose() {
    _amount.dispose();
    _reason.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final action = _mode == _Mode.waive ? 'Miễn phạt' : 'Điều chỉnh phạt';
    if (!await confirmStepUp(context, action: action) || !mounted) return;

    setState(() => _saving = true);
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      if (_mode == _Mode.waive) {
        await widget.api.waive(
          fineId: widget.fineId,
          reason: _reason.text,
          actorId: widget.actorId,
        );
      } else {
        final amount = parseVnd(_amount.text)!;
        await widget.api.adjust(
          fineId: widget.fineId,
          deltaVnd: _mode == _Mode.increase ? amount : -amount,
          reason: _reason.text,
          actorId: widget.actorId,
        );
      }
      messenger.showSnackBar(SnackBar(content: Text('Đã ghi: $action')));
      navigator.pop();
    } on FineException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Miễn / điều chỉnh')),
      body: FutureBuilder<FineDetail>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final balance = snapshot.data!.fine.balanceVnd;
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Còn nợ ${formatVnd(balance)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                SegmentedButton<_Mode>(
                  segments: const [
                    ButtonSegment(value: _Mode.waive, label: Text('Miễn')),
                    ButtonSegment(value: _Mode.decrease, label: Text('Giảm')),
                    ButtonSegment(value: _Mode.increase, label: Text('Tăng')),
                  ],
                  selected: {_mode},
                  onSelectionChanged: (s) => setState(() => _mode = s.first),
                ),
                const SizedBox(height: 16),
                if (_mode == _Mode.waive)
                  Text('Miễn toàn bộ ${formatVnd(balance)} còn nợ.')
                else
                  MoneyField(
                    controller: _amount,
                    label: _mode == _Mode.increase
                        ? 'Số tiền tăng *'
                        : 'Số tiền giảm *',
                    validator: (v) {
                      if (v == null || v <= 0) return 'Số tiền phải lớn hơn 0';
                      if (_mode == _Mode.decrease && v >= balance) {
                        return 'Giảm hết số nợ thì chọn "Miễn"';
                      }
                      return null;
                    },
                  ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _reason,
                  maxLines: 2,
                  decoration: const InputDecoration(labelText: 'Lý do *'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Cần nhập lý do' : null,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: AppButtonStyles.danger(context),
                    onPressed: _saving ? null : _submit,
                    child: Text(
                      _mode == _Mode.waive ? 'Miễn phạt' : 'Ghi điều chỉnh',
                    ),
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
