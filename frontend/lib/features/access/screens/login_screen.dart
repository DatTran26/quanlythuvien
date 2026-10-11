import 'package:flutter/material.dart';
import 'package:frontend/core/layout/content_width.dart';
import 'package:frontend/core/routing/app_routes.dart';
import 'package:frontend/core/theme/theme_x.dart';
import 'package:frontend/core/widgets/info_banner.dart';
import 'package:frontend/core/widgets/loading_button.dart';
import 'package:frontend/features/access/data/auth_store.dart';

/// Màn đăng nhập. Nhận email hoặc mã thẻ, rồi vào dashboard theo vai trò.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _id = TextEditingController();
  final _password = TextEditingController();
  var _loading = false;
  var _obscure = true;
  String? _error;

  @override
  void dispose() {
    _id.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await AuthStore.login(_id.text, _password.text);
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
    } on AuthException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ContentWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(Icons.local_library_outlined, size: 48, color: context.scheme.primary),
                  const SizedBox(height: 12),
                  Text('Quản lý thư viện', style: context.textTheme.headlineSmall, textAlign: TextAlign.center),
                  const SizedBox(height: 4),
                  Text(
                    'Đăng nhập bằng email hoặc mã thẻ',
                    style: TextStyle(color: context.colors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _id,
                    autofillHints: const [AutofillHints.username],
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Email hoặc mã thẻ',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _password,
                    obscureText: _obscure,
                    autofillHints: const [AutofillHints.password],
                    onSubmitted: (_) => _loading ? null : _submit(),
                    decoration: InputDecoration(
                      labelText: 'Mật khẩu',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        tooltip: _obscure ? 'Hiện mật khẩu' : 'Ẩn mật khẩu',
                        onPressed: () => setState(() => _obscure = !_obscure),
                        icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                      ),
                    ),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    InfoBanner(kind: BannerKind.error, message: _error!),
                  ],
                  const SizedBox(height: 16),
                  LoadingButton(
                    label: 'Đăng nhập',
                    loadingLabel: 'Đang đăng nhập…',
                    loading: _loading,
                    onPressed: _submit,
                    icon: Icons.login,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _loading ? null : () => Navigator.pushNamed(context, AppRoutes.forgotPassword),
                      child: const Text('Quên mật khẩu'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const InfoBanner(
                    kind: BannerKind.info,
                    title: 'Tài khoản thử',
                    message:
                        'admin@library.local, librarian@library.local, reader@library.local. Mật khẩu Dev123456. Mã thẻ ví dụ R10000001.',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
