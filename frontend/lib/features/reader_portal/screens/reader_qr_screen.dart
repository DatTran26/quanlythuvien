// Màn 3 – Thẻ QR (reader-qr). Route: /portal/card
// Bài: TV3 3 · Độ khó ⭐⭐
//
// Mục đích: hiện mã QR thẻ để thủ thư quét khi mượn / trả.
//
// TODO:
// - Hiện QR từ cardCode (package QR: thống nhất với widget quét QR của TV1), kèm mã dạng chữ.
// - Chỉ hiện QR khi tài khoản ACTIVE. PENDING: "Chờ thủ thư kích hoạt". LOCKED: "Thẻ đang bị khóa".
// - Tăng độ sáng / chữ to để dễ quét.
//
// Lỗ hổng: T5 (/me chưa có cardCode, chưa có hạn thẻ).
// Màn 3 – Thẻ QR (reader-qr). Route: /portal/card
// Spec: docs/features/reader-self-service/srs/ (FR-004)
//
// Mục đích: hiện mã QR thẻ để thủ thư quét khi mượn / trả.
// Lỗ hổng: T5 (/me chưa có cardCode, chưa có hạn thẻ).

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../data/portal_api.dart';
import '../models/my_card.dart';

class ReaderQrScreen extends StatefulWidget {
  const ReaderQrScreen({super.key, required this.api, this.actions = const []});

  final PortalApi api;

  /// Nút trên AppBar do khung cổng truyền vào (chuông thông báo).
  final List<Widget> actions;

  @override
  State<ReaderQrScreen> createState() => _ReaderQrScreenState();
}

class _ReaderQrScreenState extends State<ReaderQrScreen> {
  late final Future<MyCard> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.api.myCard();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thẻ thư viện'),
        actions: widget.actions,
      ),
      body: FutureBuilder<MyCard>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final card = snapshot.data!;
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(card.displayName, style: text.headlineSmall),
                  const SizedBox(height: 24),
                  if (card.canShowQr) ...[
                    // QR luôn nền trắng, mã đen để máy quét đọc được, kể cả ở chế độ tối.
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(16),
                      child: QrImageView(data: card.cardCode!, size: 220),
                    ),
                    const SizedBox(height: 16),
                    SelectableText(card.cardCode!, style: text.headlineMedium),
                    const SizedBox(height: 8),
                    const Text(
                      'Đưa mã này cho thủ thư quét khi mượn, trả sách',
                    ),
                  ] else
                    Text(
                      card.status == 'LOCKED'
                          ? 'Thẻ đang bị khóa. Vui lòng liên hệ quầy thư viện.'
                          : 'Tài khoản chờ thủ thư kích hoạt.',
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
