---
type: design-system
status: approved
updated: 2026-10-09
links:
  - docs/he_thong_quan_ly_thu_vien.md
---

# Hệ thống màu và nút bấm — App Quản lý Thư viện

> Phạm vi: app Flutter (Android + Web) cho 3 vai trò Người đọc, Nhân viên, Thủ thư.
> Bảng màu chế độ sáng được duyệt ngày 2026-10-09. Bảng màu chế độ tối đã đo đạt chuẩn tương phản nhưng chưa xem trực quan trên thiết bị thật — cần kiểm tra lại khi dựng màn hình đầu tiên.

## 1. Mục đích

Tài liệu này là **nguồn duy nhất** cho mọi màu dùng trong app. Mục tiêu:

- Cả nhóm code UI ra cùng một giao diện, không mỗi người một kiểu.
- Màu mang **ý nghĩa nhất quán**: cùng một trạng thái (vd "Quá hạn") luôn cùng một màu ở mọi màn hình.
- Chữ luôn đọc được: mọi cặp chữ/nền đạt chuẩn **WCAG 2.1 AA**.
- Đổi màu chỉ cần sửa **một file token**, không phải tìm khắp code.

## 2. Nguyên tắc

1. **Màu theo ý nghĩa, không theo sở thích.** Xanh rêu = thương hiệu và hành động chính; đỏ = lỗi/nguy hiểm/quá hạn; xám = trạng thái đã kết thúc.
2. **Không bao giờ chỉ dùng màu để truyền thông tin.** Chip trạng thái luôn có chữ; lỗi luôn có câu mô tả; icon đi kèm khi cần.
3. **Màu chữ trên nền màu** phải lấy tông đậm của cùng họ màu (vd chữ `#17663A` trên nền `#DDF3E5`), không dùng đen/xám chung.
4. **Tối đa 1 nút Filled (nút chính) trên mỗi màn hình.**
5. **Không viết mã màu trực tiếp trong widget.** Chỉ file token (Mục 7) được chứa `Color(0xFF...)`.
6. **Ngưỡng tương phản bắt buộc:** chữ thường ≥ 4.5:1; chữ lớn (≥ 18px, hoặc ≥ 14px đậm), icon, viền ô nhập ≥ 3:1. Nút ở trạng thái tắt (disabled) được miễn.

## 3. Bảng màu — chế độ sáng

### 3.1 Màu thương hiệu

| Token | Mã màu | Dùng cho | Tương phản |
|---|---|---|---|
| `primary` | `#1F6F5C` | Nút chính, AppBar, liên kết, ô nhập đang focus | 6.02:1 với chữ trắng |
| `onPrimary` | `#FFFFFF` | Chữ/icon trên `primary` | — |
| `primaryPressed` | `#175747` | Nút chính khi đang nhấn | 8.43:1 với chữ trắng |
| `primaryContainer` | `#D3EDE4` | Nền nút Tonal, thẻ được chọn, nền nhấn nhẹ | — |
| `onPrimaryContainer` | `#0B3B30` | Chữ trên `primaryContainer` | 10.11:1 |
| `secondary` | `#9A5B13` | Điểm nhấn nhỏ: huy hiệu, số đếm, ngôi sao | 5.41:1 với chữ trắng |
| `onSecondary` | `#FFFFFF` | Chữ trên `secondary` | — |
| `secondaryContainer` | `#FCE8CC` | Nền huy hiệu, nền "mới" | — |
| `onSecondaryContainer` | `#4A2A00` | Chữ trên `secondaryContainer` | 10.82:1 |

> `secondary` **không dùng cho nút**. Nút chỉ dùng `primary` hoặc màu ngữ nghĩa `error` (Mục 6).

### 3.2 Màu trung tính

| Token | Mã màu | Dùng cho | Tương phản |
|---|---|---|---|
| `background` | `#F6F8F7` | Nền màn hình | — |
| `surface` | `#FFFFFF` | Thẻ, ô nhập, bottom sheet, dialog | — |
| `textPrimary` | `#1A1F1D` | Chữ chính, tiêu đề | 15.65:1 trên `background` |
| `textSecondary` | `#56615C` | Chữ phụ, mô tả, nhãn | 6.44:1 trên `surface`, 6.04:1 trên `background` |
| `outline` | `#8A948F` | Viền ô nhập, viền nút Outlined | 3.13:1 trên `surface` |
| `divider` | `#E7EBE9` | Đường kẻ phân cách | — (trang trí) |
| `disabledBackground` | `#E7EBE9` | Nền nút/ô nhập bị tắt | — (được miễn) |
| `disabledText` | `#8A948F` | Chữ trên nền bị tắt | — (được miễn) |
| `scrim` | `#000000` @ 40% | Lớp phủ sau dialog/bottom sheet | — |

### 3.3 Màu ngữ nghĩa

Mỗi màu có 2 dạng: **đậm** (nút, icon, chữ trên nền trắng) và **container** (banner, snackbar, ô thông báo).

| Ý nghĩa | Đậm | Container (nền / chữ) | Dùng khi | Tương phản |
|---|---|---|---|---|
| `success` | `#1E7B45` | `#DDF3E5` / `#17663A` | Mượn/trả/thu phạt thành công | 5.28:1 · 6.01:1 |
| `warning` | `#A15C07` | `#FDEBD0` / `#8A4B00` | Sắp đến hạn, cảnh báo cần chú ý | 5.19:1 · 5.82:1 |
| `error` | `#C62828` | `#FBE1E1` / `#A61B1B` | Lỗi, chặn mượn, thao tác nguy hiểm | 5.62:1 · 6.07:1 |
| `info` | `#1D5FA8` | `#DDE9F8` / `#1B5296` | Thông tin chung, hướng dẫn | 6.45:1 · 6.34:1 |

Bổ sung: `errorPressed` = `#A61B1B` (nút Danger khi nhấn, 7.52:1 với chữ trắng). Viền focus bàn phím (web) dùng `info` `#1D5FA8` (6.05:1 trên `background`).

### 3.4 Màu trạng thái nghiệp vụ

Dùng cho **chip trạng thái** trong danh sách và màn chi tiết. Tên trạng thái lấy theo các file `*-states.md` trong `docs/features/`.

| Token | Nền | Chữ | Tương phản | Ý nghĩa nhóm |
|---|---|---|---|---|
| `statusAvailable` | `#DDF3E5` | `#17663A` | 6.01:1 | Có thể dùng ngay |
| `statusOnLoan` | `#DDE9F8` | `#1B5296` | 6.34:1 | Đang được sử dụng |
| `statusReserved` | `#EAE3FA` | `#5B3FA8` | 6.20:1 | Đang giữ cho một người |
| `statusPending` | `#FDEBD0` | `#8A4B00` | 5.82:1 | Đang chờ xử lý / chờ duyệt |
| `statusRepair` | `#F1E4D8` | `#7A4A21` | 5.95:1 | Đang sửa chữa |
| `statusDanger` | `#FBE1E1` | `#A61B1B` | 6.07:1 | Có vấn đề cần xử lý |
| `statusNeutral` | `#E7EBE9` | `#4B5551` | 6.42:1 | Đã kết thúc, không còn hành động |

**Ánh xạ trạng thái → token:**

| Đối tượng | Trạng thái (mã → tên hiển thị) | Token |
|---|---|---|
| Bản sao (Copy) | `AVAILABLE` Sẵn sàng | `statusAvailable` |
| | `ON_LOAN` Đang mượn | `statusOnLoan` |
| | `ON_HOLD` Đang giữ | `statusReserved` |
| | `PENDING_REVIEW` Chờ duyệt | `statusPending` |
| | `IN_REPAIR` Đang sửa | `statusRepair` |
| | `LOST` Mất | `statusDanger` |
| | `DISPOSED` Đã thanh lý | `statusNeutral` |
| Phiếu mượn (Loan) | `ACTIVE` Đang mở | `statusOnLoan` |
| | `OVERDUE` Quá hạn | `statusDanger` |
| | `LOST` Mất | `statusDanger` |
| | `RETURNED` Đã trả | `statusNeutral` |
| Đặt trước (Reservation) | `WAITING` Đang chờ | `statusPending` |
| | `READY` Sẵn sàng lấy | `statusReserved` |
| | `FULFILLED` Đã nhận | `statusNeutral` |
| | `EXPIRED` Hết hạn | `statusNeutral` |
| | `CANCELLED` Đã hủy | `statusNeutral` |
| Khoản phạt (Fine) | `UNPAID` Chưa trả | `statusDanger` |
| | `PAID` Đã trả | `statusNeutral` |
| | `WAIVED` Đã miễn | `statusNeutral` |
| Báo cáo hư hỏng (DamageReport) | `PENDING` Chờ duyệt | `statusPending` |
| | `REPAIR` Sửa chữa | `statusRepair` |
| | `DISPOSE` Thanh lý | `statusNeutral` |
| | `REJECTED` Bác bỏ | `statusNeutral` |

> Khi tài liệu nghiệp vụ thêm trạng thái mới: chọn một trong 7 token trên theo "ý nghĩa nhóm". Chỉ tạo token mới khi không nhóm nào phù hợp — theo quy trình Mục 9.

## 4. Bảng màu — chế độ tối

Cùng tên token, chỉ đổi giá trị. Code không cần biết đang ở chế độ nào.

| Token | Mã màu | Tương phản |
|---|---|---|
| `background` | `#0F1412` | — |
| `surface` | `#171D1B` | — |
| `textPrimary` | `#E3E8E5` | 15.00:1 trên `background`, 13.79:1 trên `surface` |
| `textSecondary` | `#A9B3AE` | 7.94:1 trên `surface` |
| `outline` | `#76817C` | 4.24:1 trên `surface` |
| `divider` / `disabledBackground` | `#222A27` | — |
| `disabledText` | `#66706B` | — (được miễn) |
| `primary` | `#7DD3B8` | 9.68:1 trên `surface` |
| `onPrimary` | `#003829` | 7.44:1 trên `primary` |
| `primaryPressed` | `#9BE0C9` | 8.70:1 với `onPrimary` |
| `primaryContainer` / `onPrimaryContainer` | `#0F4F40` / `#C2EBDC` | 7.33:1 |
| `secondary` / `onSecondary` | `#F2B66B` / `#3A2100` | 8.36:1 |
| `secondaryContainer` / `onSecondaryContainer` | `#5A3A0C` / `#FCE8CC` | 8.58:1 |
| `success` | `#6FD39A` | 9.33:1 trên `surface` |
| `warning` | `#F0A548` | 8.29:1 trên `surface` |
| `error` / `onError` | `#FF8A80` / `#5C0A0A` | 7.49:1 trên `surface` · 6.12:1 |
| `info` | `#8AB8F0` | 8.30:1 trên `surface` |

Màu trạng thái (nền / chữ):

| Token | Nền | Chữ | Tương phản |
|---|---|---|---|
| `statusAvailable` | `#12402A` | `#9FE0B8` | 7.71:1 |
| `statusOnLoan` | `#12305A` | `#A9C9F2` | 7.72:1 |
| `statusReserved` | `#33265E` | `#CDBEF5` | 7.77:1 |
| `statusPending` | `#4A2E05` | `#F7CD8E` | 8.36:1 |
| `statusRepair` | `#3F2A17` | `#E3C4A6` | 8.18:1 |
| `statusDanger` | `#4F1414` | `#F5AFAF` | 8.06:1 |
| `statusNeutral` | `#2A3230` | `#BAC3BF` | 7.29:1 |

Container của màu ngữ nghĩa ở chế độ tối dùng lại cặp nền/chữ của trạng thái tương ứng: `success` ↔ `statusAvailable`, `warning` ↔ `statusPending`, `error` ↔ `statusDanger`, `info` ↔ `statusOnLoan`.

## 5. Ánh xạ sang Material 3 (Flutter `ColorScheme`)

| `ColorScheme` | Token (sáng) | Token (tối) |
|---|---|---|
| `primary` / `onPrimary` | `#1F6F5C` / `#FFFFFF` | `#7DD3B8` / `#003829` |
| `primaryContainer` / `onPrimaryContainer` | `#D3EDE4` / `#0B3B30` | `#0F4F40` / `#C2EBDC` |
| `secondary` / `onSecondary` | `#9A5B13` / `#FFFFFF` | `#F2B66B` / `#3A2100` |
| `secondaryContainer` / `onSecondaryContainer` | `#FCE8CC` / `#4A2A00` | `#5A3A0C` / `#FCE8CC` |
| `error` / `onError` | `#C62828` / `#FFFFFF` | `#FF8A80` / `#5C0A0A` |
| `errorContainer` / `onErrorContainer` | `#FBE1E1` / `#A61B1B` | `#4F1414` / `#F5AFAF` |
| `surface` / `onSurface` | `#FFFFFF` / `#1A1F1D` | `#171D1B` / `#E3E8E5` |
| `onSurfaceVariant` | `#56615C` | `#A9B3AE` |
| `outline` / `outlineVariant` | `#8A948F` / `#E7EBE9` | `#76817C` / `#222A27` |
| `scrim` | `#000000` | `#000000` |

`background`, `success`, `warning`, `info`, các màu `status*`, `primaryPressed`, `errorPressed`, `disabled*` **không có sẵn** trong `ColorScheme` → khai báo trong `AppColors` (ThemeExtension, Mục 7).

## 6. Nút bấm

### 6.1 Quy cách chung

| Thuộc tính | Giá trị |
|---|---|
| Chiều cao | **48px** (vùng chạm tối thiểu cho ngón tay) · nút nhỏ trong danh sách: 40px, vùng chạm vẫn 48px |
| Bo góc | **12px** |
| Đệm ngang | 20px · có icon: icon 20px, cách chữ 8px |
| Chữ | 15px, đậm vừa (`FontWeight.w500`), viết hoa chữ đầu câu ("Xác nhận mượn", không "XÁC NHẬN MƯỢN") |
| Độ rộng | Nút chính ở cuối form/màn mobile: full-width. Nút trong hàng: theo nội dung |
| Khoảng cách giữa 2 nút | 12px |

### 6.2 Các kiểu nút

| Kiểu | Nền | Chữ | Viền | Khi nhấn | Dùng khi | Ví dụ |
|---|---|---|---|---|---|---|
| **Filled** | `primary` | `onPrimary` | — | nền `primaryPressed` | Hành động chính của màn hình. **Tối đa 1 nút/màn** | "Xác nhận mượn", "Đăng nhập" |
| **Tonal** | `primaryContainer` | `onPrimaryContainer` | — | lớp phủ `primary` 12% | Hành động phụ cần nổi bật | "Quét thêm sách" |
| **Outlined** | `surface` | `primary` | 1px `outline` | lớp phủ `primary` 12% | Hành động phụ, đi cạnh nút chính | "Gia hạn", "Hủy" |
| **Text** | trong suốt | `primary` | — | lớp phủ `primary` 12% | Hành động nhẹ, liên kết | "Xem lịch sử", "Quên mật khẩu?" |
| **Danger** | `error` | `onError` | — | nền `errorPressed` | Thao tác không hoàn tác được | "Thanh lý sách", "Ghi nhận mất" |
| **Disabled** | `disabledBackground` | `disabledText` | — | — | Chưa đủ điều kiện thực hiện | — |

### 6.3 Trạng thái của nút

| Trạng thái | Cách thể hiện |
|---|---|
| Mặc định | Như bảng 6.2 |
| Nhấn (pressed) | Như cột "Khi nhấn" + hiệu ứng ripple mặc định của Material |
| Focus (bàn phím, web) | Viền 2px `info` `#1D5FA8`, cách nút 2px |
| Đang xử lý (loading) | Giữ nguyên màu, thay icon bằng vòng xoay 20px cùng màu chữ, chữ đổi thành dạng đang làm ("Đang lưu…"); **chặn bấm lặp** để tránh tạo phiếu trùng |
| Tắt (disabled) | Màu disabled; **luôn kèm 1 dòng lý do** bên dưới bằng `textSecondary` (vd "Người đọc đang có sách quá hạn") |

### 6.4 Quy tắc sử dụng

1. Mỗi màn hình **tối đa 1 nút Filled**. Các nút còn lại dùng Tonal, Outlined hoặc Text.
2. Nút **Danger** luôn mở **dialog xác nhận** trước khi thực hiện; nút xác nhận trong dialog cũng là Danger và ghi rõ hành động ("Thanh lý 1 bản sao"), không ghi "OK".
3. Hạn chế nút Disabled. Ưu tiên cho bấm rồi báo lỗi cụ thể; chỉ tắt nút khi lý do hiển thị ngay bên cạnh.
4. Nhãn nút là **động từ + đối tượng**, 1–3 từ: "Tạo phiếu mượn", không "Submit", "OK", "Đồng ý".
5. Thứ tự trong dialog/hàng nút: hành động phụ bên trái, hành động chính bên phải.

## 7. Các thành phần khác

| Thành phần | Quy cách màu |
|---|---|
| AppBar | Nền `primary`, chữ/icon `onPrimary` |
| Ô nhập (TextField) | Nền `surface`, viền 1px `outline`; focus: viền 2px `primary`; lỗi: viền 2px `error` + dòng lỗi màu `error` bên dưới; nhãn và gợi ý `textSecondary`; bo góc 12px |
| Thẻ (Card) | Nền `surface`, viền 1px `divider`, bo góc 12px, không đổ bóng |
| Chip trạng thái | Nền/chữ theo token `status*` Mục 3.4, bo tròn hoàn toàn, chữ 13px đậm vừa |
| Banner/thông báo trong màn | Nền container + chữ đậm của màu ngữ nghĩa (Mục 3.3), icon cùng màu chữ |
| Snackbar | Thành công/thông tin: nền `textPrimary`, chữ `surface`. Lỗi: nền `error`, chữ `onError` |
| Thanh điều hướng dưới | Nền `surface`; mục đang chọn: icon/chữ `primary` trên viên `primaryContainer`; mục khác: `textSecondary` |
| Tiền phạt / số tiền nợ | `error` khi chưa trả; `textPrimary` khi đã trả |

## 8. Code mẫu Flutter

### 8.1 File token — nơi duy nhất được chứa mã màu

`lib/core/theme/app_colors.dart`

```dart
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
    required this.statusAvailable,
    required this.statusOnLoan,
    required this.statusReserved,
    required this.statusPending,
    required this.statusRepair,
    required this.statusDanger,
    required this.statusNeutral,
  });

  final Color background;
  final Color textSecondary;
  final Color divider;
  final Color disabledBackground;
  final Color disabledText;
  final Color primaryPressed;
  final Color errorPressed;
  final Color success;
  final Color warning;
  final Color info;
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
    statusAvailable: ColorPair(Color(0xFFDDF3E5), Color(0xFF17663A)),
    statusOnLoan: ColorPair(Color(0xFFDDE9F8), Color(0xFF1B5296)),
    statusReserved: ColorPair(Color(0xFFEAE3FA), Color(0xFF5B3FA8)),
    statusPending: ColorPair(Color(0xFFFDEBD0), Color(0xFF8A4B00)),
    statusRepair: ColorPair(Color(0xFFF1E4D8), Color(0xFF7A4A21)),
    statusDanger: ColorPair(Color(0xFFFBE1E1), Color(0xFFA61B1B)),
    statusNeutral: ColorPair(Color(0xFFE7EBE9), Color(0xFF4B5551)),
  );

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
    statusAvailable: ColorPair(Color(0xFF12402A), Color(0xFF9FE0B8)),
    statusOnLoan: ColorPair(Color(0xFF12305A), Color(0xFFA9C9F2)),
    statusReserved: ColorPair(Color(0xFF33265E), Color(0xFFCDBEF5)),
    statusPending: ColorPair(Color(0xFF4A2E05), Color(0xFFF7CD8E)),
    statusRepair: ColorPair(Color(0xFF3F2A17), Color(0xFFE3C4A6)),
    statusDanger: ColorPair(Color(0xFF4F1414), Color(0xFFF5AFAF)),
    statusNeutral: ColorPair(Color(0xFF2A3230), Color(0xFFBAC3BF)),
  );

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

/// ColorScheme Material 3 theo Mục 5.
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
```

> `errorPressed` chế độ tối `#FFA59D` là màu sáng hơn `error` một bậc (cùng logic `primaryPressed`); chữ `onError` `#5C0A0A` trên nền này vẫn đạt trên 6:1.

### 8.2 Gắn vào theme

`lib/core/theme/app_theme.dart`

```dart
import 'package:flutter/material.dart';

import 'app_colors.dart';

ThemeData buildTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  final scheme = isDark ? darkScheme : lightScheme;
  final colors = isDark ? AppColors.dark : AppColors.light;

  const shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
  );
  const size = Size.fromHeight(48);
  const padding = EdgeInsets.symmetric(horizontal: 20);
  const text = TextStyle(fontSize: 15, fontWeight: FontWeight.w500);

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: colors.background,
    extensions: [colors],
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.primary,
      foregroundColor: scheme.onPrimary,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: size,
        padding: padding,
        shape: shape,
        textStyle: text,
        disabledBackgroundColor: colors.disabledBackground,
        disabledForegroundColor: colors.disabledText,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: size,
        padding: padding,
        shape: shape,
        textStyle: text,
        side: BorderSide(color: scheme.outline),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: size,
        padding: padding,
        shape: shape,
        textStyle: text,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: scheme.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: scheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: scheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: scheme.error, width: 2),
      ),
    ),
    cardTheme: CardThemeData(
      color: scheme.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colors.divider),
      ),
    ),
  );
}
```

Trong `MaterialApp`: `theme: buildTheme(Brightness.light), darkTheme: buildTheme(Brightness.dark)`.

### 8.3 Cách dùng trong widget

```dart
// Lấy màu
final scheme = Theme.of(context).colorScheme;
final colors = Theme.of(context).extension<AppColors>()!;

// Nút — KHÔNG truyền màu, theme đã lo
FilledButton(onPressed: _confirm, child: const Text('Xác nhận mượn'));
FilledButton.tonal(onPressed: _scan, child: const Text('Quét thêm sách'));
OutlinedButton(onPressed: _renew, child: const Text('Gia hạn'));
TextButton(onPressed: _history, child: const Text('Xem lịch sử'));

// Nút Danger
FilledButton(
  style: FilledButton.styleFrom(
    backgroundColor: scheme.error,
    foregroundColor: scheme.onError,
  ),
  onPressed: _confirmDispose,
  child: const Text('Thanh lý sách'),
);

// Chip trạng thái — ánh xạ mã trạng thái sang token tại MỘT chỗ duy nhất
ColorPair copyStatusColor(AppColors c, String status) => switch (status) {
      'AVAILABLE' => c.statusAvailable,
      'ON_LOAN' => c.statusOnLoan,
      'ON_HOLD' => c.statusReserved,
      'PENDING_REVIEW' => c.statusPending,
      'IN_REPAIR' => c.statusRepair,
      'LOST' => c.statusDanger,
      _ => c.statusNeutral, // DISPOSED và mã chưa biết
    };
```

❌ **Không viết:** `color: Color(0xFF1F6F5C)`, `color: Colors.green`, `color: Colors.red.shade700` trong widget.

## 9. Quy trình thêm màu hệ thống

Áp dụng khi code UI mà thấy **thiếu màu**.

### Bước 1 — Tìm trong bảng có sẵn trước

Đối chiếu Mục 3–7. Phần lớn nhu cầu đã có token:

| Muốn | Dùng |
|---|---|
| Nhấn mạnh một con số, huy hiệu "mới" | `secondary` / `secondaryContainer` |
| Nền nhẹ cho vùng được chọn | `primaryContainer` |
| Trạng thái nghiệp vụ mới | Chọn 1 trong 7 `status*` theo ý nghĩa nhóm |
| Cảnh báo / lỗi / thành công / thông tin | `warning` / `error` / `success` / `info` |

Có token phù hợp → dùng luôn, **dừng ở đây**.

### Bước 2 — Thiết kế màu mới (khi thật sự cần)

1. **Đặt tên theo ý nghĩa**, không theo sắc màu: `statusSuspended`, `chartLoans` — không `purple2`, `lightBlue`.
2. **Khai báo đủ bộ:** màu đậm (nếu dùng cho chữ/icon trên nền trắng) và/hoặc cặp nền + chữ; **cả chế độ sáng lẫn tối**.
3. **Đo tương phản** bằng WebAIM Contrast Checker (https://webaim.org/resources/contrastchecker/) hoặc công cụ tương đương:
   - Chữ thường ≥ **4.5:1**; chữ lớn, icon, viền ≥ **3:1**.
   - Không đạt → chỉnh độ đậm/nhạt đến khi đạt, **không** hạ chuẩn.
4. **Không trùng nghĩa** với màu đã có: không dùng đỏ cho thứ không phải lỗi/nguy hiểm, không dùng xanh lá cho thứ không phải thành công/khả dụng.

### Bước 3 — Thêm vào code và tài liệu trong CÙNG một PR

1. `lib/core/theme/app_colors.dart`: thêm field, giá trị `light` + `dark`, và dòng trong `lerp`.
2. File này (`docs/design/color-system.md`): thêm dòng vào bảng tương ứng (Mục 3, 4, và Mục 3.4 nếu là trạng thái), ghi mã hex + mục đích + tỉ lệ tương phản; thêm dòng vào Mục 11.
3. Dùng token mới trong widget qua `Theme.of(context).extension<AppColors>()`.

### Bước 4 — Mở PR

Mô tả PR phải có:

- [ ] Tên token, mã màu sáng/tối, mục đích sử dụng.
- [ ] Lý do không dùng được token có sẵn.
- [ ] Tỉ lệ tương phản đã đo (sáng và tối).
- [ ] Ảnh chụp màn hình dùng màu mới ở **chế độ sáng và tối**.
- [ ] Đã cập nhật `color-system.md`.

Cần **ít nhất 1 thành viên khác duyệt** trước khi merge vào `develop`.

### Bước 5 — Người review kiểm tra

1. Tìm màu viết cứng trong phần code thay đổi:
   ```bash
   git diff origin/develop -- 'app/lib/**/*.dart' | grep -nE "Color\(0x|Colors\.[a-z]"
   ```
   Có kết quả nằm ngoài `app_colors.dart` → yêu cầu sửa sang token. (Ngoại lệ: `Colors.transparent`.)
2. Đối chiếu tỉ lệ tương phản trong PR với công cụ đo.
3. Kiểm tra `color-system.md` đã cập nhật khớp với code.

## 10. Checklist khi code một màn hình UI

- [ ] Không có `Color(0x...)` hoặc `Colors.xxx` (trừ `transparent`) trong file widget.
- [ ] Màn hình có **tối đa 1 nút Filled**.
- [ ] Nút Danger có dialog xác nhận.
- [ ] Nút bị tắt có dòng lý do.
- [ ] Nút gửi dữ liệu có trạng thái loading và chặn bấm lặp.
- [ ] Chip trạng thái dùng hàm ánh xạ chung, không tự chọn màu.
- [ ] Lỗi ô nhập có chữ mô tả, không chỉ đổi màu viền.
- [ ] Đã xem thử ở chế độ sáng **và** tối.

## 11. Lịch sử thay đổi

| Ngày | Nội dung | Người |
|---|---|---|
| 2026-10-09 | Tạo bảng màu sáng/tối, màu trạng thái, quy cách nút và quy trình thêm màu | Hoàng |
