// Màn quét QR bằng camera (điện thoại) hoặc webcam (web).
// Bài: Hoang/01-nen-tang/05-quet-qr-bang-camera.md
//
// Phân công: widget quét QR là phần dùng chung của TV1 (Đạt). Bản này viết theo bài học
// để các màn TV2 chạy được; gửi Đạt duyệt để cả nhóm chỉ dùng một bản.
//
// Màn quét không biết gì về nghiệp vụ: chỉ đọc mã và trả về (quét 1 lần) hoặc gọi onCode
// (quét liên tục). Kiểm tra mã hợp lệ là việc của màn gọi.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../theme/theme_x.dart';

/// Màn gọi trả về cái này sau khi kiểm tra một mã vừa quét (chế độ liên tục).
class ScanFeedback {
  const ScanFeedback.ok(this.message) : ok = true;
  const ScanFeedback.error(this.message) : ok = false;

  final bool ok;
  final String message;
}

/// Quét 1 lần. Trả về mã, hoặc null nếu người dùng đóng.
Future<String?> scanQrOnce(BuildContext context, {String title = 'Quét mã QR'}) {
  return Navigator.push<String>(
    context,
    MaterialPageRoute(fullscreenDialog: true, builder: (_) => QrScanPage(title: title)),
  );
}

/// Quét liên tục. [onCode] được gọi mỗi khi đọc được mã mới.
Future<void> scanQrContinuous(
  BuildContext context, {
  required String title,
  required Future<ScanFeedback> Function(String code) onCode,
}) {
  return Navigator.push(
    context,
    MaterialPageRoute(fullscreenDialog: true, builder: (_) => QrScanPage(title: title, onCode: onCode)),
  );
}

class QrScanPage extends StatefulWidget {
  const QrScanPage({super.key, required this.title, this.onCode});

  final String title;
  final Future<ScanFeedback> Function(String code)? onCode; // null = quét 1 lần

  @override
  State<QrScanPage> createState() => _QrScanPageState();
}

class _QrScanPageState extends State<QrScanPage> {
  final _controller = MobileScannerController(
    formats: const [BarcodeFormat.qrCode], // chỉ đọc QR -> nhanh hơn, ít đọc nhầm
    detectionSpeed: DetectionSpeed.noDuplicates, // không báo lại liên tục cùng một mã
  );

  bool get _continuous => widget.onCode != null;
  bool _handling = false; // đang kiểm tra 1 mã -> bỏ qua mã khác
  String? _lastCode;
  DateTime _lastAt = DateTime(2000);
  ScanFeedback? _feedback;
  int _okCount = 0;
  bool _torchOn = false;

  @override
  void dispose() {
    _controller.dispose(); // tắt camera, giải phóng tài nguyên
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    final code = capture.barcodes.firstOrNull?.rawValue?.trim();
    if (code == null || code.isEmpty || _handling) return;

    // Chống đọc trùng: cùng một mã trong 2 giây thì bỏ qua
    final now = DateTime.now();
    if (code == _lastCode && now.difference(_lastAt) < const Duration(seconds: 2)) return;
    _lastCode = code;
    _lastAt = now;

    if (!_continuous) {
      HapticFeedback.mediumImpact();
      Navigator.pop(context, code); // quét 1 lần: trả mã và đóng
      return;
    }

    setState(() => _handling = true);
    final fb = await widget.onCode!(code); // màn gọi kiểm tra mã (gọi API...)
    if (!mounted) return;
    fb.ok ? HapticFeedback.lightImpact() : HapticFeedback.heavyImpact();
    setState(() {
      _feedback = fb;
      if (fb.ok) _okCount++;
      _handling = false;
    });
  }

  Future<void> _typeManually() async {
    final ctrl = TextEditingController();
    final code = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nhập mã thủ công'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          textCapitalization: TextCapitalization.characters,
          decoration: const InputDecoration(labelText: 'Mã trên tem/thẻ'),
          onSubmitted: (v) => Navigator.pop(ctx, v),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
          FilledButton(onPressed: () => Navigator.pop(ctx, ctrl.text), child: const Text('Dùng mã này')),
        ],
      ),
    );
    ctrl.dispose();
    if (code == null || code.trim().isEmpty || !mounted) return;
    if (_continuous) {
      final fb = await widget.onCode!(code.trim());
      if (mounted) {
        setState(() {
          _feedback = fb;
          if (fb.ok) _okCount++;
        });
      }
    } else {
      Navigator.pop(context, code.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = context.scheme;
    return Scaffold(
      backgroundColor: s.scrim,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Colors.transparent là ngoại lệ được phép
        foregroundColor: s.surface,
        title: Text(widget.title),
        actions: [
          IconButton(
            tooltip: _torchOn ? 'Tắt đèn' : 'Bật đèn',
            icon: Icon(_torchOn ? Icons.flash_on : Icons.flash_off),
            onPressed: () async {
              await _controller.toggleTorch();
              setState(() => _torchOn = !_torchOn);
            },
          ),
          IconButton(
            tooltip: 'Đổi camera',
            icon: const Icon(Icons.cameraswitch_outlined),
            onPressed: () => _controller.switchCamera(),
          ),
        ],
      ),
      body: LayoutBuilder(builder: (context, c) {
        // Khung ngắm vuông, 70% cạnh ngắn của màn, tối đa 320px (đẹp cả trên web)
        final side = (c.biggest.shortestSide * 0.7).clamp(180.0, 320.0);
        final window = Rect.fromCenter(
          center: Offset(c.maxWidth / 2, c.maxHeight * 0.42),
          width: side,
          height: side,
        );
        return Stack(
          fit: StackFit.expand,
          children: [
            MobileScanner(
              controller: _controller,
              onDetect: _onDetect,
              scanWindow: window, // chỉ đọc mã nằm trong khung -> tránh đọc nhầm mã bên cạnh
            ),
            CustomPaint(
              painter: _ScanWindowPainter(
                window: window,
                shade: s.scrim.withValues(alpha: 0.55),
                border: s.primaryContainer,
              ),
            ),
            Positioned(
              top: window.bottom + 16,
              left: 24,
              right: 24,
              child: Text(
                _handling ? 'Đang kiểm tra…' : 'Đưa mã QR vào giữa khung',
                textAlign: TextAlign.center,
                style: TextStyle(color: s.surface, fontSize: 16),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: SafeArea(child: _bottomPanel()),
            ),
          ],
        );
      }),
    );
  }

  Widget _bottomPanel() {
    final fb = _feedback;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_continuous && fb != null)
              Row(children: [
                Icon(fb.ok ? Icons.check_circle : Icons.error,
                    color: fb.ok ? context.colors.success : context.scheme.error),
                const SizedBox(width: 8),
                Expanded(child: Text(fb.message, maxLines: 3)),
              ]),
            if (_continuous) ...[
              const SizedBox(height: 4),
              Text('Đã quét: $_okCount', style: TextStyle(color: context.colors.textSecondary)),
              const SizedBox(height: 8),
            ],
            Row(children: [
              TextButton.icon(
                onPressed: _typeManually,
                icon: const Icon(Icons.keyboard_outlined),
                label: const Text('Nhập tay'),
              ),
              const Spacer(),
              if (_continuous) FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Xong')),
            ]),
          ],
        ),
      ),
    );
  }
}

/// Vẽ lớp tối phủ cả màn, khoét một ô vuông trong suốt ở giữa, viền góc bo 16.
class _ScanWindowPainter extends CustomPainter {
  _ScanWindowPainter({required this.window, required this.shade, required this.border});

  final Rect window;
  final Color shade;
  final Color border;

  @override
  void paint(Canvas canvas, Size size) {
    final hole = RRect.fromRectAndRadius(window, const Radius.circular(16));
    final overlay = Path()
      ..addRect(Offset.zero & size) // hình chữ nhật cả màn
      ..addRRect(hole) // ô vuông giữa
      ..fillType = PathFillType.evenOdd; // evenOdd: vùng chồng nhau bị "khoét" ra
    canvas.drawPath(overlay, Paint()..color = shade);
    canvas.drawRRect(
      hole,
      Paint()
        ..color = border
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }

  @override
  bool shouldRepaint(_ScanWindowPainter old) => old.window != window;
}
