// Ô số liệu (KPI) dùng chung cho report-dashboard và trend-dashboard.
// Bài: Hoang/08-reports/01-report-dashboard.md (Bước 2)

import 'package:flutter/material.dart';

import '../../../core/theme/theme_x.dart';

class StatTile extends StatelessWidget {
  const StatTile({super.key, required this.label, required this.value, this.color, this.icon});

  final String label;
  final String value;
  final Color? color; // null = textPrimary
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: context.colors.textSecondary),
                const SizedBox(width: 6),
              ],
              Expanded(
                child: Text(label, style: TextStyle(color: context.colors.textSecondary), overflow: TextOverflow.ellipsis),
              ),
            ]),
            FittedBox(
              // số quá dài thì tự thu nhỏ, không tràn
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(value,
                  style: context.textTheme.headlineMedium?.copyWith(color: color, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}
