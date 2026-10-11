// Màn 1 – Danh sách công nợ (fine-list, fine-collection-basic). Route: /fines
// Spec: docs/features/fine-collection-basic/srs/
//
// Mục đích: thủ thư nhập / quét mã thẻ người đọc để xem khoản phạt và tổng còn nợ.
// Đến từ: circulation-desk (TV2), menu. Đi tới: fine-detail.
// Mã thẻ không tồn tại: E-core-003, cho nhập lại.

import 'package:flutter/material.dart';
import 'package:frontend/core/utils/format.dart';

import '../data/fine_api.dart';
import '../models/fine.dart';
import '../widgets/fine_labels.dart';
import 'fine_detail_screen.dart';

class FineListScreen extends StatefulWidget {
  const FineListScreen({super.key, required this.api, required this.actorId});

  final FineApi api;
  final int actorId;

  @override
  State<FineListScreen> createState() => _FineListScreenState();
}

class _FineListScreenState extends State<FineListScreen> {
  final _card = TextEditingController();
  FineReader? _reader;
  List<Fine> _fines = const [];
  bool _showClosed = false;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _card.dispose();
    super.dispose();
  }

  Future<void> _lookup() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final reader = await widget.api.readerByCard(_card.text);
    final fines = reader == null
        ? const <Fine>[]
        : await widget.api.finesOfReader(reader.id);
    if (!mounted) return;
    setState(() {
      _loading = false;
      _reader = reader;
      _fines = fines;
      _error = reader == null
          ? 'Không thấy thẻ người đọc "${_card.text.trim()}"'
          : null;
    });
  }

  Future<void> _openDetail(Fine fine) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FineDetailScreen(
          api: widget.api,
          actorId: widget.actorId,
          fineId: fine.id,
        ),
      ),
    );
    // Có thể vừa thu / miễn: tải lại.
    if (_reader != null) await _lookup();
  }

  @override
  Widget build(BuildContext context) {
    final reader = _reader;
    final visible = _fines.where((f) => _showClosed || f.isOpen).toList();
    final debt = _fines
        .where((f) => f.isOpen)
        .fold<int>(0, (sum, f) => sum + f.balanceVnd);
    return Scaffold(
      appBar: AppBar(title: const Text('Công nợ người đọc')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _card,
            textCapitalization: TextCapitalization.characters,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => _lookup(),
            decoration: InputDecoration(
              labelText: 'Mã thẻ người đọc',
              hintText: 'VD: R10000004',
              errorText: _error,
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                tooltip: 'Tra cứu',
                onPressed: _loading ? null : _lookup,
              ),
            ),
          ),
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            ),
          if (reader != null && !_loading) ...[
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                reader.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              subtitle: Text(reader.cardCode),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Còn nợ'),
                  Text(
                    formatVnd(debt),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Hiện cả khoản đã đóng'),
              value: _showClosed,
              onChanged: (v) => setState(() => _showClosed = v),
            ),
            const Divider(),
            if (visible.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: Text('Không có khoản phạt cần thu')),
              )
            else
              for (final fine in visible)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    '${fineReasonLabel(fine.reason)} · ${formatVnd(fine.amountVnd)}',
                  ),
                  subtitle: Text(
                    '${formatDate(fine.createdAt)}'
                    '${fine.isOpen ? ' · còn ${formatVnd(fine.balanceVnd)}' : ''}',
                  ),
                  trailing: FineStatusChip(fine.status),
                  onTap: () => _openDetail(fine),
                ),
          ],
        ],
      ),
    );
  }
}
