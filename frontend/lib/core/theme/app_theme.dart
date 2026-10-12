// Nguồn: docs/design/color-system.md (Mục 6, 7, 8.2).
// Gắn trong MaterialApp:
//   theme: buildTheme(Brightness.light),
//   darkTheme: buildTheme(Brightness.dark),
//
// Không chứa mã màu: mọi màu lấy từ app_colors.dart.

import 'package:flutter/material.dart';

import 'app_colors.dart';

const _radius = BorderRadius.all(Radius.circular(12));
const _shape = RoundedRectangleBorder(borderRadius: _radius);
const _buttonText = TextStyle(fontSize: 15, fontWeight: FontWeight.w500);
const _buttonPadding = EdgeInsets.symmetric(horizontal: 20);

// Cao 48px, rộng theo nội dung. Không dùng Size.fromHeight(48): nó đặt chiều rộng
// tối thiểu vô hạn, nút đặt trong Row sẽ lỗi layout. Nút full-width thì bọc
// SizedBox(width: double.infinity).
const _buttonSize = Size(64, 48);

/// Lớp phủ khi nhấn / rê chuột lên nút Tonal, Outlined, Text (Mục 6.2: primary 12%).
WidgetStateProperty<Color?> _overlay(Color color) =>
    WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.pressed)) return color.withValues(alpha: 0.12);
      if (states.contains(WidgetState.hovered)) return color.withValues(alpha: 0.08);
      if (states.contains(WidgetState.focused)) return color.withValues(alpha: 0.12);
      return null;
    });

/// Viền focus bàn phím trên web: 2px `info` (Mục 6.3).
/// Flutter không hỗ trợ khoảng cách 2px giữa viền và nút nên viền nằm sát mép nút.
WidgetStateProperty<BorderSide?> _focusSide(AppColors colors, {BorderSide? normal}) =>
    WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.focused)) {
        return BorderSide(color: colors.info, width: 2);
      }
      if (states.contains(WidgetState.disabled)) return BorderSide.none;
      return normal;
    });

/// Nền / chữ cho một kiểu nút đặc (Filled, Tonal, Danger) theo bảng Mục 6.2.
ButtonStyle _solidStyle({
  required Color background,
  required Color foreground,
  required AppColors colors,
  Color? pressed,
  Color? overlay,
}) {
  return ButtonStyle(
    minimumSize: const WidgetStatePropertyAll(_buttonSize),
    padding: const WidgetStatePropertyAll(_buttonPadding),
    shape: const WidgetStatePropertyAll(_shape),
    textStyle: const WidgetStatePropertyAll(_buttonText),
    iconSize: const WidgetStatePropertyAll(20),
    elevation: const WidgetStatePropertyAll(0),
    backgroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) return colors.disabledBackground;
      if (pressed != null && states.contains(WidgetState.pressed)) return pressed;
      return background;
    }),
    foregroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) return colors.disabledText;
      return foreground;
    }),
    iconColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) return colors.disabledText;
      return foreground;
    }),
    overlayColor: overlay != null ? _overlay(overlay) : null,
    side: _focusSide(colors),
  );
}

/// Các kiểu nút không gắn sẵn được vào theme. Truyền vào tham số `style` của nút.
///
/// ```dart
/// FilledButton(onPressed: _confirm, child: const Text('Xác nhận mượn'));        // Filled: theme lo
/// FilledButton.tonal(style: AppButtonStyles.tonal(context), ...);              // Tonal
/// FilledButton(style: AppButtonStyles.danger(context), ...);                   // Danger
/// OutlinedButton(style: AppButtonStyles.small(context), ...);                  // nút nhỏ trong danh sách
/// ```
abstract final class AppButtonStyles {
  /// Tonal: nền `primaryContainer`, chữ `onPrimaryContainer`.
  /// Bắt buộc truyền style này cho `FilledButton.tonal`, vì theme Filled đã tô nền `primary`.
  static ButtonStyle tonal(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return _solidStyle(
      background: scheme.primaryContainer,
      foreground: scheme.onPrimaryContainer,
      overlay: scheme.primary,
      colors: _colorsOf(context),
    );
  }

  /// Danger: nền `error`, khi nhấn `errorPressed`. Luôn mở dialog xác nhận trước (Mục 6.4).
  static ButtonStyle danger(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final colors = _colorsOf(context);
    return _solidStyle(
      background: scheme.error,
      foreground: scheme.onError,
      pressed: colors.errorPressed,
      colors: colors,
    );
  }

  /// Nút nhỏ trong danh sách: cao 40px, vùng chạm vẫn 48px (Mục 6.1).
  /// Ghép với kiểu khác: `AppButtonStyles.small(context).merge(AppButtonStyles.danger(context))`.
  static ButtonStyle small(BuildContext context) => const ButtonStyle(
        minimumSize: WidgetStatePropertyAll(Size(48, 40)),
        padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 16)),
        tapTargetSize: MaterialTapTargetSize.padded,
      );

  static AppColors _colorsOf(BuildContext context) =>
      Theme.of(context).extension<AppColors>()!;
}

ThemeData buildTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  final scheme = isDark ? darkScheme : lightScheme;
  final colors = isDark ? AppColors.dark : AppColors.light;
  final scrim = scheme.scrim.withValues(alpha: 0.4);

  OutlineInputBorder inputBorder(Color color, [double width = 1]) =>
      OutlineInputBorder(
        borderRadius: _radius,
        borderSide: BorderSide(color: color, width: width),
      );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: colors.background,
    canvasColor: colors.background,
    dividerColor: colors.divider,
    extensions: [colors],

    // AppBar: nền primary, chữ/icon onPrimary (Mục 7).
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.primary,
      foregroundColor: scheme.onPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
    ),

    // Nút (Mục 6). Filled gắn thẳng vào theme; Tonal, Danger, nút nhỏ dùng AppButtonStyles.
    filledButtonTheme: FilledButtonThemeData(
      style: _solidStyle(
        background: scheme.primary,
        foreground: scheme.onPrimary,
        pressed: colors.primaryPressed,
        colors: colors,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        minimumSize: const WidgetStatePropertyAll(_buttonSize),
        padding: const WidgetStatePropertyAll(_buttonPadding),
        shape: const WidgetStatePropertyAll(_shape),
        textStyle: const WidgetStatePropertyAll(_buttonText),
        iconSize: const WidgetStatePropertyAll(20),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) return colors.disabledBackground;
          return scheme.surface;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) return colors.disabledText;
          return scheme.primary;
        }),
        overlayColor: _overlay(scheme.primary),
        side: _focusSide(colors, normal: BorderSide(color: scheme.outline)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        minimumSize: const WidgetStatePropertyAll(_buttonSize),
        padding: const WidgetStatePropertyAll(_buttonPadding),
        shape: const WidgetStatePropertyAll(_shape),
        textStyle: const WidgetStatePropertyAll(_buttonText),
        iconSize: const WidgetStatePropertyAll(20),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) return colors.disabledText;
          return scheme.primary;
        }),
        overlayColor: _overlay(scheme.primary),
        side: _focusSide(colors),
      ),
    ),

    // Ô nhập: nền surface, viền outline; focus viền 2px primary; lỗi viền 2px error
    // và luôn có dòng lỗi bên dưới (truyền errorText), nhãn và gợi ý textSecondary.
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surface,
      border: inputBorder(scheme.outline),
      enabledBorder: inputBorder(scheme.outline),
      focusedBorder: inputBorder(scheme.primary, 2),
      errorBorder: inputBorder(scheme.error, 2),
      focusedErrorBorder: inputBorder(scheme.error, 2),
      disabledBorder: inputBorder(colors.disabledBackground),
      labelStyle: TextStyle(color: colors.textSecondary),
      hintStyle: TextStyle(color: colors.textSecondary),
      helperStyle: TextStyle(color: colors.textSecondary),
      errorStyle: TextStyle(color: scheme.error),
      floatingLabelStyle: WidgetStateTextStyle.resolveWith((states) {
        if (states.contains(WidgetState.error)) return TextStyle(color: scheme.error);
        if (states.contains(WidgetState.focused)) return TextStyle(color: scheme.primary);
        return TextStyle(color: colors.textSecondary);
      }),
      prefixIconColor: colors.textSecondary,
      suffixIconColor: colors.textSecondary,
    ),

    // Thẻ: nền surface, viền 1px divider, bo 12px, không đổ bóng.
    cardTheme: CardThemeData(
      color: scheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: _radius,
        side: BorderSide(color: colors.divider),
      ),
    ),

    // Chip trạng thái: bo tròn hoàn toàn, chữ 13px w500.
    // Màu nền/chữ truyền theo từng chip: colors.copyStatus(...), colors.loanStatus(...)…
    // Chip lọc (FilterChip, ChoiceChip) không truyền màu: dùng màu mặc định dưới đây,
    // chữ đổi theo sáng/tối. Thiếu màu chữ thì chip rơi về chữ đen, không đọc được ở chế độ tối.
    chipTheme: ChipThemeData(
      shape: const StadiumBorder(),
      side: BorderSide.none,
      backgroundColor: colors.divider,
      selectedColor: scheme.primaryContainer,
      checkmarkColor: scheme.onPrimaryContainer,
      labelStyle: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: WidgetStateColor.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? scheme.onPrimaryContainer
              : scheme.onSurface,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
    ),

    // Snackbar thành công/thông tin: nền textPrimary, chữ surface.
    // Snackbar lỗi: truyền backgroundColor: scheme.error, chữ scheme.onError.
    snackBarTheme: SnackBarThemeData(
      backgroundColor: scheme.onSurface,
      contentTextStyle: TextStyle(color: scheme.surface, fontSize: 14),
      actionTextColor: scheme.surface,
      behavior: SnackBarBehavior.floating,
      shape: _shape,
    ),

    dividerTheme: DividerThemeData(color: colors.divider, thickness: 1, space: 1),

    dialogTheme: DialogThemeData(
      backgroundColor: scheme.surface,
      surfaceTintColor: Colors.transparent,
      shape: _shape,
      barrierColor: scrim,
    ),

    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: scheme.surface,
      surfaceTintColor: Colors.transparent,
      modalBarrierColor: scrim,
    ),

    // Thanh điều hướng dưới: nền surface; mục chọn primary trên viên primaryContainer;
    // mục khác textSecondary.
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: scheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      indicatorColor: scheme.primaryContainer,
      iconTheme: WidgetStateProperty.resolveWith((states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? scheme.primary
                : colors.textSecondary,
          )),
      labelTextStyle: WidgetStateProperty.resolveWith((states) => TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: states.contains(WidgetState.selected)
                ? scheme.primary
                : colors.textSecondary,
          )),
    ),
    // Bản web màn rộng thay thanh dưới bằng NavigationRail, cùng quy cách màu.
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: scheme.surface,
      indicatorColor: scheme.primaryContainer,
      selectedIconTheme: IconThemeData(color: scheme.primary),
      unselectedIconTheme: IconThemeData(color: colors.textSecondary),
      selectedLabelTextStyle: TextStyle(
        color: scheme.primary,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelTextStyle: TextStyle(color: colors.textSecondary),
    ),

    // TabBar đặt trong thân màn (nền surface/background).
    // Đặt trong AppBar.bottom (nền primary) thì truyền labelColor: scheme.onPrimary,
    // indicatorColor: scheme.onPrimary.
    tabBarTheme: TabBarThemeData(
      labelColor: scheme.primary,
      unselectedLabelColor: colors.textSecondary,
      indicatorColor: scheme.primary,
      dividerColor: colors.divider,
      labelStyle: const TextStyle(fontWeight: FontWeight.w500),
    ),

    listTileTheme: ListTileThemeData(iconColor: colors.textSecondary),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: scheme.primary),
  );
}
