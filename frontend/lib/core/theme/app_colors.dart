// Nguồn: docs/design/color-system.md (Mục 3, 4, 5, 8.1).
// Đây là file DUY NHẤT trong app được chứa mã màu Color(0xFF...).
// Thêm màu mới: theo quy trình Mục 9, sửa file này và color-system.md trong cùng một PR.

import 'package:flutter/material.dart';

/// Cặp màu nền + chữ cho chip trạng thái và banner.
@immutable
class ColorPair {
  const ColorPair(this.background, this.foreground);

  final Color background;
  final Color foreground;

  static ColorPair lerp(ColorPair a, ColorPair b, double t) => ColorPair(
        Color.lerp(a.background, b.background, t)!,
        Color.lerp(a.foreground, b.foreground, t)!,
      );
}

/// Màu bổ sung ngoài ColorScheme của Material 3.
///
/// Lấy trong widget: `Theme.of(context).extension<AppColors>()!`.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.background,
    required this.textSecondary,
    required this.divider,
    required this.disabledBackground,
    required this.disabledText,
    required this.primaryPressed,
    required this.errorPressed,
    required this.success,
    required this.warning,
    required this.info,
    required this.successContainer,
    required this.warningContainer,
    required this.errorContainer,
    required this.infoContainer,
    required this.statusAvailable,
    required this.statusOnLoan,
    required this.statusReserved,
    required this.statusPending,
    required this.statusRepair,
    required this.statusDanger,
    required this.statusNeutral,
  });

  /// Nền màn hình (Scaffold).
  final Color background;

  /// Chữ phụ, mô tả, nhãn. Cùng giá trị với `ColorScheme.onSurfaceVariant`.
  final Color textSecondary;

  /// Đường kẻ phân cách, viền thẻ.
  final Color divider;
  final Color disabledBackground;
  final Color disabledText;

  /// Nền nút Filled khi đang nhấn.
  final Color primaryPressed;

  /// Nền nút Danger khi đang nhấn.
  final Color errorPressed;

  /// Màu ngữ nghĩa dạng đậm: icon, chữ trên nền trắng. Lỗi dùng `ColorScheme.error`.
  final Color success;
  final Color warning;

  /// Cũng là màu viền focus bàn phím (web).
  final Color info;

  /// Màu ngữ nghĩa dạng container: banner, ô thông báo trong màn (Mục 3.3).
  final ColorPair successContainer;
  final ColorPair warningContainer;
  final ColorPair errorContainer;
  final ColorPair infoContainer;

  /// Màu chip trạng thái nghiệp vụ (Mục 3.4). Dùng qua các hàm `*Status` bên dưới.
  final ColorPair statusAvailable;
  final ColorPair statusOnLoan;
  final ColorPair statusReserved;
  final ColorPair statusPending;
  final ColorPair statusRepair;
  final ColorPair statusDanger;
  final ColorPair statusNeutral;

  static const light = AppColors(
    background: Color(0xFFF6F8F7),
    textSecondary: Color(0xFF56615C),
    divider: Color(0xFFE7EBE9),
    disabledBackground: Color(0xFFE7EBE9),
    disabledText: Color(0xFF8A948F),
    primaryPressed: Color(0xFF175747),
    errorPressed: Color(0xFFA61B1B),
    success: Color(0xFF1E7B45),
    warning: Color(0xFFA15C07),
    info: Color(0xFF1D5FA8),
    successContainer: ColorPair(Color(0xFFDDF3E5), Color(0xFF17663A)),
    warningContainer: ColorPair(Color(0xFFFDEBD0), Color(0xFF8A4B00)),
    errorContainer: ColorPair(Color(0xFFFBE1E1), Color(0xFFA61B1B)),
    infoContainer: ColorPair(Color(0xFFDDE9F8), Color(0xFF1B5296)),
    statusAvailable: ColorPair(Color(0xFFDDF3E5), Color(0xFF17663A)),
    statusOnLoan: ColorPair(Color(0xFFDDE9F8), Color(0xFF1B5296)),
    statusReserved: ColorPair(Color(0xFFEAE3FA), Color(0xFF5B3FA8)),
    statusPending: ColorPair(Color(0xFFFDEBD0), Color(0xFF8A4B00)),
    statusRepair: ColorPair(Color(0xFFF1E4D8), Color(0xFF7A4A21)),
    statusDanger: ColorPair(Color(0xFFFBE1E1), Color(0xFFA61B1B)),
    statusNeutral: ColorPair(Color(0xFFE7EBE9), Color(0xFF4B5551)),
  );

  // Chế độ tối: container ngữ nghĩa dùng lại cặp trạng thái tương ứng (Mục 4).
  static const dark = AppColors(
    background: Color(0xFF0F1412),
    textSecondary: Color(0xFFA9B3AE),
    divider: Color(0xFF222A27),
    disabledBackground: Color(0xFF222A27),
    disabledText: Color(0xFF66706B),
    primaryPressed: Color(0xFF9BE0C9),
    errorPressed: Color(0xFFFFA59D),
    success: Color(0xFF6FD39A),
    warning: Color(0xFFF0A548),
    info: Color(0xFF8AB8F0),
    successContainer: ColorPair(Color(0xFF12402A), Color(0xFF9FE0B8)),
    warningContainer: ColorPair(Color(0xFF4A2E05), Color(0xFFF7CD8E)),
    errorContainer: ColorPair(Color(0xFF4F1414), Color(0xFFF5AFAF)),
    infoContainer: ColorPair(Color(0xFF12305A), Color(0xFFA9C9F2)),
    statusAvailable: ColorPair(Color(0xFF12402A), Color(0xFF9FE0B8)),
    statusOnLoan: ColorPair(Color(0xFF12305A), Color(0xFFA9C9F2)),
    statusReserved: ColorPair(Color(0xFF33265E), Color(0xFFCDBEF5)),
    statusPending: ColorPair(Color(0xFF4A2E05), Color(0xFFF7CD8E)),
    statusRepair: ColorPair(Color(0xFF3F2A17), Color(0xFFE3C4A6)),
    statusDanger: ColorPair(Color(0xFF4F1414), Color(0xFFF5AFAF)),
    statusNeutral: ColorPair(Color(0xFF2A3230), Color(0xFFBAC3BF)),
  );

  // ---------------------------------------------------------------------------
  // Ánh xạ mã trạng thái -> màu chip (Mục 3.4). Viết MỘT chỗ để cả nhóm dùng chung.
  // Mã nhận theo enum backend (apps/api); mã chưa biết rơi về statusNeutral.
  // ---------------------------------------------------------------------------

  /// Bản sao: AVAILABLE, ON_LOAN, ON_HOLD, PENDING_REVIEW, IN_REPAIR, LOST, DISPOSED.
  ColorPair copyStatus(String status) => switch (status) {
        'AVAILABLE' => statusAvailable,
        'ON_LOAN' => statusOnLoan,
        'ON_HOLD' => statusReserved,
        'PENDING_REVIEW' => statusPending,
        'IN_REPAIR' => statusRepair,
        'LOST' => statusDanger,
        _ => statusNeutral,
      };

  /// Phiếu mượn: ACTIVE, OVERDUE, LOST, RETURNED.
  ColorPair loanStatus(String status) => switch (status) {
        'ACTIVE' => statusOnLoan,
        'OVERDUE' || 'LOST' => statusDanger,
        _ => statusNeutral,
      };

  /// Đặt trước: WAITING, READY, FULFILLED, EXPIRED, CANCELLED.
  ColorPair reservationStatus(String status) => switch (status) {
        'WAITING' => statusPending,
        'READY' => statusReserved,
        _ => statusNeutral,
      };

  /// Khoản phạt. Backend dùng OPEN, tài liệu dùng UNPAID: cùng nghĩa "chưa trả".
  ColorPair fineStatus(String status) => switch (status) {
        'OPEN' || 'UNPAID' => statusDanger,
        _ => statusNeutral,
      };

  /// Báo cáo hư hỏng. Backend dùng DISPOSED, tài liệu dùng DISPOSE.
  ColorPair damageStatus(String status) => switch (status) {
        'PENDING' => statusPending,
        'REPAIR' => statusRepair,
        _ => statusNeutral,
      };

  @override
  AppColors copyWith() => this;

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      background: Color.lerp(background, other.background, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      disabledBackground:
          Color.lerp(disabledBackground, other.disabledBackground, t)!,
      disabledText: Color.lerp(disabledText, other.disabledText, t)!,
      primaryPressed: Color.lerp(primaryPressed, other.primaryPressed, t)!,
      errorPressed: Color.lerp(errorPressed, other.errorPressed, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      successContainer:
          ColorPair.lerp(successContainer, other.successContainer, t),
      warningContainer:
          ColorPair.lerp(warningContainer, other.warningContainer, t),
      errorContainer: ColorPair.lerp(errorContainer, other.errorContainer, t),
      infoContainer: ColorPair.lerp(infoContainer, other.infoContainer, t),
      statusAvailable:
          ColorPair.lerp(statusAvailable, other.statusAvailable, t),
      statusOnLoan: ColorPair.lerp(statusOnLoan, other.statusOnLoan, t),
      statusReserved: ColorPair.lerp(statusReserved, other.statusReserved, t),
      statusPending: ColorPair.lerp(statusPending, other.statusPending, t),
      statusRepair: ColorPair.lerp(statusRepair, other.statusRepair, t),
      statusDanger: ColorPair.lerp(statusDanger, other.statusDanger, t),
      statusNeutral: ColorPair.lerp(statusNeutral, other.statusNeutral, t),
    );
  }
}

/// ColorScheme Material 3, chế độ sáng (Mục 5).
const lightScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF1F6F5C),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFD3EDE4),
  onPrimaryContainer: Color(0xFF0B3B30),
  secondary: Color(0xFF9A5B13),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFFCE8CC),
  onSecondaryContainer: Color(0xFF4A2A00),
  error: Color(0xFFC62828),
  onError: Color(0xFFFFFFFF),
  errorContainer: Color(0xFFFBE1E1),
  onErrorContainer: Color(0xFFA61B1B),
  surface: Color(0xFFFFFFFF),
  onSurface: Color(0xFF1A1F1D),
  onSurfaceVariant: Color(0xFF56615C),
  outline: Color(0xFF8A948F),
  outlineVariant: Color(0xFFE7EBE9),
  scrim: Color(0xFF000000),
);

/// ColorScheme Material 3, chế độ tối (Mục 5).
const darkScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF7DD3B8),
  onPrimary: Color(0xFF003829),
  primaryContainer: Color(0xFF0F4F40),
  onPrimaryContainer: Color(0xFFC2EBDC),
  secondary: Color(0xFFF2B66B),
  onSecondary: Color(0xFF3A2100),
  secondaryContainer: Color(0xFF5A3A0C),
  onSecondaryContainer: Color(0xFFFCE8CC),
  error: Color(0xFFFF8A80),
  onError: Color(0xFF5C0A0A),
  errorContainer: Color(0xFF4F1414),
  onErrorContainer: Color(0xFFF5AFAF),
  surface: Color(0xFF171D1B),
  onSurface: Color(0xFFE3E8E5),
  onSurfaceVariant: Color(0xFFA9B3AE),
  outline: Color(0xFF76817C),
  outlineVariant: Color(0xFF222A27),
  scrim: Color(0xFF000000),
);
