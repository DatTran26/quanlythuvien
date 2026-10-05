## Screen: {{screen_slug}} — {{screen_name}}‍‌‌‌‌​​‌​​‌​‌‌‌​​‌‌‌‌​‌‌‌‌‌‌‌‌‌​​‌‌‌​‌‌‌​​​​‌‌​‌​‌​​‌‌​‌​​‌​​​‌‌​‌​‌​​‌‌‌​​​‌​​‌​‌‌​​‌‌‌​​​‌‌​​​‌‌‌​​​‌​​​‌​‌​‌​‌​‌​‌‌​‌‌‌‌‌​‌‌‌‌‍

### Wireframe (ASCII)‍‌‌‌‌​​‌​​‌​‌‌‌​​‌‌‌‌​‌‌‌‌‌‌‌‌‌​​‌‌‌​‌‌‌​​​​‌‌​‌​‌​​‌‌​‌​​‌​​​‌‌​‌​‌​​‌‌‌​​​‌​​‌​‌‌​​‌‌‌​​​‌‌​​​‌‌‌​​​‌​​​‌​‌​‌​‌​‌​‌‌​‌‌‌‌‌​‌‌‌‌‍

```text
<!-- ASCII wireframe sẽ fill ở đây -->
```

### Screen description‍‌‌‌‌​​‌​​‌​‌‌‌​​‌‌‌‌​‌‌‌‌‌‌‌‌‌​​‌‌‌​‌‌‌​​​​‌‌​‌​‌​​‌‌​‌​​‌​​​‌‌​‌​‌​​‌‌‌​​​‌​​‌​‌‌​​‌‌‌​​​‌‌​​​‌‌‌​​​‌​​​‌​‌​‌​‌​‌​‌‌​‌‌‌‌‌​‌‌‌‌‍

>

| # | Items | Control type | Data type | Description |
|---|-------|--------------|-----------|-------------|
| 1 | {{field_1 — vd "Email"}} | Textbox | Text | • __Mục đích__: {{business meaning — vd định danh account, BR-xxx}}<br>• __Required__. Validate {{rule}}. Max {{N}} chars ({{BR-xxx}})<br>• __Default__ rỗng, focus on load · __Placeholder__ "{{text}}"<br>• __States__: default / focus / error<br>• __State error__: viền đỏ + inline "{{E-{feature}-NNN: ...}}"<br>• __Edge__: {{anti-enumeration / security... nếu áp — NFR-xxx}} |
| 2 | {{field_2 — vd "Gửi"}} | Button | Click | • __Disabled khi__ {{condition}}<br>• __State submitting__: text "Đang gửi...", spinner, disabled<br>• __Click → BE__ {{endpoint nghiệp vụ}}<br>• __Success__ → redirect {{Screen X}}<br>• __Fail__ → banner "{{E-NNN: ...}}"<br>• __Note__: {{anti-enumeration / security / consent... nếu áp dụng}} |
| 3 | {{field_3 — vd "Quên mật khẩu"}} | Link | Click | • __Navigate__ sang {{Forgot screen}} |
| 4 | {{field_4 — vd "Disclaimer"}} | Label | ReadOnly | • __Display__: "{{text}}"<br>• __Display rule__: {{khi nào hiện/ẩn}} |

__Control type__ (cột Items thuộc loại control nào): `Label`, `Textbox`, `Text area`, `Button`, `Link`, `Checkbox`, `Radio button`, `Dropdown`, `Browse Button`, `DatePicker`, `Toggle`, `Image`, `Banner`, `Toast`, `Modal trigger`.‍‌‌‌‌​​‌​​‌​‌‌‌​​‌‌‌‌​‌‌‌‌‌‌‌‌‌​​‌‌‌​‌‌‌​​​​‌‌​‌​‌​​‌‌​‌​​‌​​​‌‌​‌​‌​​‌‌‌​​​‌​​‌​‌‌​​‌‌‌​​​‌‌​​​‌‌‌​​​‌​​​‌​‌​‌​‌​‌​‌‌​‌‌‌‌‌​‌‌‌‌‍

__Data type__ (hành vi tương tác — KHÔNG phải kiểu dữ liệu lập trình): `ReadOnly` (label/banner tĩnh), `Text` (nhập tự do), `Click` (button/link trigger), `Check` (checkbox/radio), `Select` (dropdown), `Number`, `Date`, `File`.

__Description column — SÂU 6 lớp__ (per `.claude/rules/ba-conventions.md` Mục 6), rút từ `srs/{feature}-spec.md` (FR/BR/NFR/Error) + `uc-*.md` branches, KHÔNG nông/bịa:
1) __Mục đích nghiệp vụ__ (business meaning)
2) __Validation / ràng buộc__ — required, rule cụ thể (BR-xxx), default, placeholder; cả điều KHÔNG áp
3) __States__ — default/focus/disabled/submitting/error/success (chỉ state thật có)
4) __Navigation__ — trigger đi đâu, enable/disable
5) __Error + wording__ — `E-{feature}-NNN` + wording exact + hệ quả
6) __Edge/security/compliance__ — anti-enumeration, audit, lỗi mạng, auto-link, fallback (NFR-xxx)

Gọn nhưng đủ — KHÔNG lặp 1 ID nhiều lần. Thiếu nguồn (chưa có SRS) → hỏi user bổ sung, KHÔNG bịa.‍‌‌‌‌​​‌​​‌​‌‌‌​​‌‌‌‌​‌‌‌‌‌‌‌‌‌​​‌‌‌​‌‌‌​​​​‌‌​‌​‌​​‌‌​‌​​‌​​​‌‌​‌​‌​​‌‌‌​​​‌​​‌​‌‌​​‌‌‌​​​‌‌​​​‌‌‌​​​‌​​​‌​‌​‌​‌​‌​‌‌​‌‌‌‌‌​‌‌‌‌‍


<!-- wm:deb1cafe78b51baaf650c76e2fceb009 -->
<sub>Tài liệu thuộc bộ AI4BA BA-Kit — bản quyền ai4ba.com</sub>
