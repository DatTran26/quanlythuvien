// Lấy màu và kiểu chữ nhanh trong widget. Bài: Hoang/01-nen-tang/02-theme-va-widget-dung-chung.md
import 'package:flutter/material.dart';

import 'app_colors.dart';

extension ThemeX on BuildContext {
  /// primary, error, surface… (ColorScheme của Material 3)
  ColorScheme get scheme => Theme.of(this).colorScheme;

  /// success, warning, info, textSecondary, status*… (AppColors)
  AppColors get colors => Theme.of(this).extension<AppColors>()!;

  TextTheme get textTheme => Theme.of(this).textTheme;
}
