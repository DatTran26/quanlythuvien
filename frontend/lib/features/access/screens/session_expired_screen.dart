import 'package:flutter/material.dart';
import 'package:frontend/core/auth/session.dart';
import 'package:frontend/core/routing/app_routes.dart';
import 'package:frontend/core/theme/theme_x.dart';
import 'package:frontend/core/widgets/loading_button.dart';
import 'package:frontend/features/access/data/auth_store.dart';

/// Xác thực lại trước thao tác nhạy cảm. Trả true khi mật khẩu đúng, false khi hủy.
class SessionExpiredScreen extends StatefulWidget {
  const SessionExpiredScreen({super.key, this.reason});

  final String? reason;

  @override
  State<SessionExpiredScreen> createState() => _SessionExpiredScreenState();
}

class _SessionExpiredScreenState extends State<SessionExpiredScreen> {
  final _password = TextEditingController();
  var _loading = false;
  String? _error;

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final ok = await AuthStore.checkPassword(_password.text);
    if (!mounted) return;
    if (ok) {
      Navigator.pop(context, true);
      return;
    }
    setState(() {
      _loading = false;
      _error = AppSession.isSignedIn ? 'Mật khẩu không đúng.' : 'Phiên đã kết thúc. Hãy đăng nhập lại.';
    });
  }

  Future<void> _relogin() async {
    await AuthStore.signOut();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.dashboard, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Xác thực lại')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            widget.reason ?? 'Phiên làm việc cần xác nhận lại trước khi tiếp tục.',
            style: context.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            AppSession.isSignedIn ? 'Nhập mật khẩu của ${AppSession.email}.' : 'Bạn chưa đăng nhập.',
            style: TextStyle(color: context.colors.textSecondary),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _password,
            obscureText: true,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Mật khẩu', border: OutlineInputBorder()),
            onSubmitted: (_) => _loading ? null : _submit(),
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: TextStyle(color: context.scheme.error)),
          ],
          const SizedBox(height: 16),
          LoadingButton(
            label: 'Xác nhận',
            loadingLabel: 'Đang kiểm tra…',
            loading: _loading,
            onPressed: AppSession.isSignedIn ? _submit : null,
          ),
          const SizedBox(height: 8),
          OutlinedButton(onPressed: _loading ? null : () => Navigator.pop(context, false), child: const Text('Hủy')),
          TextButton(onPressed: _loading ? null : _relogin, child: const Text('Đăng nhập tài khoản khác')),
        ],
      ),
    );
  }
}
