---
type: brainstorm
feature: reader-onboarding
status: draft
updated: 2026-10-12
links:
  - docs/_product/prd.md
  - docs/_product/decision-register.md
  - docs/_shared/core-spec.md
  - docs/_shared/id-crosswalk-lmp.md
---

# Cấp và kích hoạt tài khoản người đọc tại quầy

## 1. Idea Seed

Nhân viên cấp tài khoản cho người đọc ngay tại quầy, kiểm trùng định danh, kích hoạt để thẻ QR có hiệu lực; người đọc không tự đăng ký online.

## 2. Context

- Người đọc phải có thẻ QR hợp lệ trước khi mượn sách; thẻ chỉ có hiệu lực khi tài khoản đã được kích hoạt.
- Tài liệu nguồn mặc định cho người đọc tự đăng ký online rồi kích hoạt tại quầy; quyết định DEC-SF-03 đổi thành chỉ cấp tại quầy.
- Cập nhật, khóa tạm và xóa mềm tài khoản người đọc thuộc `account-admin`.
- Có thể tạo hàng loạt hồ sơ người đọc qua import (`data-import`).

## 3. User Types (preliminary)

| User Type | Pain Point | Primary Need |
|-----------|-----------|--------------|
| Người đọc | Làm thẻ mất thời gian, không biết khi nào dùng được | Nhận thẻ QR dùng được ngay tại quầy |
| Nhân viên | Tạo trùng hồ sơ cho cùng một người | Hệ thống báo trùng ngay khi nhập |
| Thủ thư | Hồ sơ cá nhân bị nhập thiếu, sai | Bộ thông tin tối thiểu thống nhất, có dấu vết |

## 4. Capabilities Breakdown

### P0 — must have

- Tạo hồ sơ người đọc: định danh (mã độc giả), họ tên, thông tin liên hệ tối thiểu, hạn thẻ nếu có.
- Kiểm trùng định danh và mã QR thẻ trước khi lưu.
- Kích hoạt tài khoản và cấp thẻ QR.
- Ghi audit cùng giao dịch khi tạo và kích hoạt.

### P1 — should have

- Không có.

### P2 — nice to have

- Không có. Tự đăng ký online không làm (DEC-SF-03).

## 5. Core Flows (Happy Path)

### 5.1 Cấp tài khoản tại quầy

1) Người đọc đến quầy, xuất trình giấy tờ.
2) Nhân viên mở biểu mẫu người đọc, nhập thông tin.
3) Hệ thống kiểm tra trường bắt buộc và kiểm trùng định danh.
4) Nhân viên xác nhận; hệ thống lưu hồ sơ, kích hoạt tài khoản, sinh thẻ QR, ghi audit.
5) Nhân viên giao thẻ QR cho người đọc.

```
Nhân viên nhập hồ sơ ──> Đủ trường bắt buộc? ──không──> Báo lỗi tại trường, giữ dữ liệu đã nhập
                              │ có
                              ▼
                   Định danh đã tồn tại? ──có──> Báo trùng, mở hồ sơ hiện có
                              │ không
                              ▼
            Lưu hồ sơ + kích hoạt + sinh thẻ QR + audit ──> Giao thẻ
```

## 6. System Behavior Deep Dive

### 6.1 Decision Points

| ID | Flow | Khi nào | YES (nhánh đồng ý) | NO (nhánh từ chối) |
|---|---|---|---|---|
| D1 | Cấp tài khoản | Đủ trường bắt buộc, đúng định dạng? | Kiểm trùng | Báo lỗi tại trường |
| D2 | Cấp tài khoản | Định danh hoặc mã QR đã tồn tại? | Báo trùng, mở hồ sơ hiện có | Lưu và kích hoạt |
| D3 | Cấp tài khoản | Người thao tác có quyền cấp tài khoản? | Thực hiện | Từ chối, ghi audit |

### 6.2 Scenario Matrix

Không áp dụng — một vai trò, một trạng thái đầu vào.

### 6.3 State Transitions

| Entity | Từ | Sang | Trigger | Quay lại được? |
|--------|------|----|---------|-------------|
| Tài khoản người đọc | — | Đang hoạt động | Nhân viên xác nhận cấp tài khoản | Không quay lại; khóa/vô hiệu thuộc `account-admin` |

### 6.4 Interrupted Transactions

| Tình huống | Hệ thống còn lại gì | Resume | Cleanup |
|---|---|---|---|
| Mất kết nối trước khi xác nhận | Không có hồ sơ | Nhập lại hoặc khôi phục dữ liệu nhập dở nếu còn | Không có |
| Hai quầy cùng cấp cho một người | Chỉ lần lưu đầu thành công | Quầy sau thấy báo trùng, mở hồ sơ hiện có | Không phát sinh hồ sơ thứ hai |

### 6.5 Other Edge Cases

- Thẻ QR chỉ dùng để tìm người đọc, không thay cho kiểm tra quyền.
- Hồ sơ đã có từ import thì không tạo lại; Nhân viên mở hồ sơ đó để kích hoạt.

## 7. Validation, Limits & Wording

### 7.1 Validation rules

| Field | Rule |
|---|---|
| Mã độc giả | Bắt buộc, duy nhất |
| Họ tên | Bắt buộc |
| Thông tin liên hệ | Ít nhất một kênh; bộ trường chính thức chưa chốt |
| Hạn thẻ | Không bắt buộc; nếu có phải sau ngày cấp |
| Mã QR thẻ | Duy nhất, trỏ đúng một tài khoản |

### 7.2 Limits & Quotas (exact values)

| Tham số | Giá trị | Window | Behavior khi vượt |
|---|---|---|---|
| Thời hạn thẻ | TBD (mặc định nguồn: 1 năm, không thu phí) | Từ ngày cấp | Thẻ hết hạn không mượn được |

### 7.3 Wording samples (exact strings)

#### Error messages

| Tình huống | Wording | Code |
|---|---|---|
| Thiếu hoặc sai thông tin | "Vui lòng kiểm tra lại các trường được đánh dấu." (đề xuất) | E-core-001 |
| Trùng định danh | "Mã độc giả đã tồn tại. Mở hồ sơ hiện có?" (đề xuất) | E-core-003 |

#### Success messages

| Tình huống | Wording |
|---|---|
| Cấp tài khoản thành công | "Đã cấp tài khoản và kích hoạt thẻ cho người đọc." (đề xuất) |

#### Info / neutral messages

| Tình huống | Wording |
|---|---|
| — | — |

## 8. Assumptions

- Nhân viên cấp được tài khoản tại quầy theo DEC-SF-03, dù ma trận quyền nguồn chỉ cho vai trò quản trị tạo tài khoản người đọc.
- Thẻ có thời hạn 1 năm, không thu phí (mặc định OQ-05 nguồn) cho tới khi chốt.

## 9. Risks

| Rủi ro | Khả năng | Hậu quả nghiệp vụ | Cách phòng |
|--------|----------|-------------------|-----------|
| Compliance: lưu dữ liệu cá nhân khi chưa có chính sách lưu giữ | thỉnh thoảng | Vi phạm quy định dữ liệu cá nhân | Chỉ lưu bộ thông tin tối thiểu, chờ OQ-core-003 |
| Process: quầy đông giờ cao điểm vì mọi thẻ đều làm tại quầy | thỉnh thoảng | Người đọc chờ lâu | Biểu mẫu tối thiểu, có thể import trước danh sách người đọc |

## 10. Success Criteria (preliminary)

- 0 hồ sơ trùng định danh.
- 100% tài khoản được tạo và kích hoạt có audit.

## 11. Open Questions

- [ ] OQ-1: Bộ thông tin liên hệ bắt buộc của người đọc? (hold — domain approver)
- [ ] OQ-2: Thẻ có thời hạn và có thu phí không? (OQ-05 nguồn; hold — Thủ thư trưởng)
- [ ] OQ-3: Chính sách lưu giữ và xóa dữ liệu cá nhân người đọc? (OQ-core-003; hold — pháp chế)
- [ ] OQ-4: Nhân viên được cấp tài khoản thay vì chỉ Thủ thư như ma trận nguồn — cần Thủ thư trưởng xác nhận lại theo DEC-SF-03? (hold)

## 12. Next Steps

- `/srs reader-onboarding`
