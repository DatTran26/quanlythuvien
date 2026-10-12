---
type: design-system
status: approved
updated: 2026-10-12
links:
  - docs/he_thong_quan_ly_thu_vien.md
---

# Hệ thống màu và nút bấm — App Quản lý Thư viện

> Phạm vi: app Flutter (Android + Web) cho 3 vai trò Người đọc, Nhân viên, Nhân viên.
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

## 8. Code Flutter

Code thật nằm trong `frontend/lib/core/theme/`. Tài liệu không chép lại code để hai nơi không lệch nhau; đọc thẳng file.

### 8.1 File token — nơi duy nhất được chứa mã màu

`frontend/lib/core/theme/app_colors.dart`

| Thành phần | Nội dung |
|---|---|
| `lightScheme`, `darkScheme` | `ColorScheme` Material 3 theo Mục 5 |
| `AppColors.light`, `AppColors.dark` | `ThemeExtension` chứa màu ngoài `ColorScheme`: `background`, `textSecondary`, `divider`, `disabled*`, `primaryPressed`, `errorPressed`, `success`, `warning`, `info`, 7 cặp `status*` |
| `successContainer`, `warningContainer`, `errorContainer`, `infoContainer` | Cặp nền/chữ cho banner, ô thông báo (Mục 3.3; chế độ tối dùng lại cặp trạng thái theo Mục 4) |
| `ColorPair` | Cặp nền + chữ |
| `copyStatus()`, `loanStatus()`, `reservationStatus()`, `fineStatus()`, `damageStatus()` | Ánh xạ mã trạng thái → cặp màu chip theo bảng Mục 3.4. **Chỗ duy nhất** chọn màu chip, cả nhóm dùng chung |

Hàm ánh xạ nhận mã theo enum backend (`apps/api`) và cả tên trong tài liệu khi hai bên khác nhau: khoản phạt `OPEN` = `UNPAID`, báo cáo hư hỏng `DISPOSED` = `DISPOSE`. Mã chưa biết rơi về `statusNeutral`.

### 8.2 Gắn vào theme

`frontend/lib/core/theme/app_theme.dart` có `buildTheme(Brightness)` áp quy cách Mục 6 và Mục 7: AppBar, nút, ô nhập, thẻ, chip, snackbar, dialog, bottom sheet, thanh điều hướng dưới, NavigationRail, TabBar, scrim 40%.

Trong `MaterialApp`:

```dart
theme: buildTheme(Brightness.light),
darkTheme: buildTheme(Brightness.dark),
```

Ghi chú khi dùng:

1. **Kích thước nút** là cao 48px, rộng theo nội dung. Không dùng `Size.fromHeight(48)`: nó đặt chiều rộng tối thiểu vô hạn, nút trong `Row` sẽ lỗi layout. Nút chính full-width thì bọc `SizedBox(width: double.infinity)`.
2. **Filled** gắn thẳng vào theme (nền `primary`, nhấn `primaryPressed`). Theme Filled cũng áp lên `FilledButton.tonal`, nên **Tonal, Danger và nút nhỏ phải truyền `style`** từ `AppButtonStyles`.
3. **Viền focus** 2px `info` nằm sát mép nút; Flutter không hỗ trợ khoảng hở 2px như Mục 6.3.
4. **TabBar** trong theme tô cho trường hợp đặt trong thân màn. Đặt trong `AppBar.bottom` (nền `primary`) thì truyền `labelColor` và `indicatorColor` là `scheme.onPrimary`.
5. **Snackbar lỗi** truyền `backgroundColor: scheme.error`; mặc định theme là kiểu thành công/thông tin.

### 8.3 Cách dùng trong widget

```dart
// Lấy màu
final scheme = Theme.of(context).colorScheme;
final colors = Theme.of(context).extension<AppColors>()!;

// Nút
FilledButton(onPressed: _confirm, child: const Text('Xác nhận mượn'));     // Filled: theme lo
FilledButton.tonal(
  style: AppButtonStyles.tonal(context),
  onPressed: _scan,
  child: const Text('Quét thêm sách'),
);
OutlinedButton(onPressed: _renew, child: const Text('Gia hạn'));
TextButton(onPressed: _history, child: const Text('Xem lịch sử'));
FilledButton(                                                             // Danger
  style: AppButtonStyles.danger(context),
  onPressed: _confirmDispose,
  child: const Text('Thanh lý sách'),
);
OutlinedButton(                                                           // nút nhỏ trong danh sách
  style: AppButtonStyles.small(context),
  onPressed: _renewOne,
  child: const Text('Gia hạn'),
);

// Chip trạng thái — lấy cặp màu từ hàm ánh xạ chung
final pair = colors.copyStatus(copy.status);
Chip(
  backgroundColor: pair.background,
  label: Text('Sẵn sàng', style: TextStyle(color: pair.foreground)),
);

// Banner
final info = colors.warningContainer; // nền info.background, chữ + icon info.foreground
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

1. `frontend/lib/core/theme/app_colors.dart`: thêm field, giá trị `light` + `dark`, và dòng trong `lerp`.
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
   git diff origin/develop -- 'frontend/lib/**/*.dart' | grep -nE "Color\(0x|Colors\.[a-z]"
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
| 2026-10-10 | Code theme thật ở `frontend/lib/core/theme/`; Mục 8 trỏ sang code thay vì chép mẫu; sửa kích thước nút (bỏ `Size.fromHeight`), thêm `AppButtonStyles` (Tonal, Danger, nút nhỏ), container ngữ nghĩa và hàm ánh xạ trạng thái dùng chung | Hoàng |
