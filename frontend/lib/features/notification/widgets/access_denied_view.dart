// Màn báo không có quyền (E-core-002: "Access denied screen/banner", quay về an toàn).

import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';

class AccessDeniedView extends StatelessWidget {
  const AccessDeniedView({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final pair = Theme.of(context).extension<AppColors>()!.errorContainer;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Card(
          color: pair.background,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock_outline, color: pair.foreground),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: pair.foreground),
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  child: const Text('Quay lại'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
