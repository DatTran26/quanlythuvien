import 'package:flutter/material.dart';
import 'package:frontend/core/layout/content_width.dart';
import 'package:frontend/core/routing/app_routes.dart';
import 'package:frontend/core/widgets/info_banner.dart';
import 'package:frontend/core/widgets/loading_button.dart';
import 'package:frontend/core/widgets/snackbar.dart';
import 'package:frontend/features/access/data/auth_store.dart';

/// Đặt mật khẩu mới bằng mã còn hiệu lực, rồi quay về đăng nhập.
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _email = TextEditingController();
  final _code = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  var _loading = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _code.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_password.text != _confirm.text) {
      setState(() => _error = 'Mật khẩu nhập lại không khớp.');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await AuthStore.resetPassword(
        email: _email.text,
        code: _code.text,
        password: _password.text,
      );
      if (!mounted) return;
      showAppSnackBar(context, 'Đã đặt lại mật khẩu. Hãy đăng nhập lại.');
      Navigator.popUntil(context, ModalRoute.withName(AppRoutes.dashboard));
    } on AuthException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đặt lại mật khẩu')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ContentWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const InfoBanner(
                    kind: BannerKind.info,
                    message: 'Môi trường thử nghiệm: mã đặt lại là DEV-RESET.',
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _email,
                    decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _code,
                    decoration: const InputDecoration(labelText: 'Mã trong email', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Mật khẩu mới', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _confirm,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Nhập lại mật khẩu', border: OutlineInputBorder()),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    InfoBanner(kind: BannerKind.error, message: _error!),
                  ],
                  const SizedBox(height: 16),
                  LoadingButton(
                    label: 'Đặt lại mật khẩu',
                    loadingLabel: 'Đang lưu…',
                    loading: _loading,
                    onPressed: _submit,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
