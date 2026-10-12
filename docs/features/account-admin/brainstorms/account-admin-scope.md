---
type: brainstorm
feature: account-admin
status: draft
updated: 2026-10-12
links:
  - docs/_product/prd.md
  - docs/_product/decision-register.md
  - docs/_shared/core-spec.md
  - docs/_shared/id-crosswalk-lmp.md
---

# Quản trị tài khoản

## 1. Idea Seed

Thủ thư quản lý vòng đời tài khoản người đọc và tài khoản Nhân viên (sửa, khóa, xóa mềm); Nhân viên sửa thông tin và khóa tạm người đọc khi phục vụ tại quầy. Mọi thay đổi có lý do và dấu vết.

## 2. Context

- Cấp tài khoản người đọc mới thuộc `reader-onboarding`; feature này lo phần sau khi tài khoản đã tồn tại.
- Tài khoản Nhân viên do Thủ thư tạo, khóa, đặt lại mật khẩu, xóa mềm (FR-L06 nguồn). Ai quản lý tài khoản Thủ thư vẫn còn mở.
- Phần R1B: Nhân viên được sửa thông tin và khóa tạm người đọc nhưng không được xóa (FR-S10 nguồn).
- Khóa tài khoản có hiệu lực ngay với điều kiện mượn ở `checkout` và `renewal`.

## 3. User Types (preliminary)

| User Type | Pain Point | Primary Need |
|-----------|-----------|--------------|
| Thủ thư | Không biết ai đã sửa hoặc khóa tài khoản | Quản lý vòng đời tài khoản có dấu vết |
| Nhân viên | Không khóa tạm được người đọc vi phạm ngay tại quầy | Khóa tạm có lý do, không cần chờ quản trị |
| Người đọc | Bị khóa mà không biết lý do | Trạng thái khóa có lý do rõ ràng |

## 4. Capabilities Breakdown

### P0 — must have

- Tra cứu, xem chi tiết tài khoản người đọc kèm khoản đang mượn, đặt trước, công nợ.
- Thủ thư sửa tài khoản người đọc và xóa mềm (vô hiệu hóa); chặn xóa khi còn phiếu mượn mở hoặc nợ phạt.
- Thủ thư tạo, khóa, đặt lại mật khẩu, xóa mềm tài khoản Nhân viên.
- Không xóa cứng tài khoản đã có lịch sử nghiệp vụ.
- Hai người cùng sửa một hồ sơ: không ghi đè im lặng, người sau thấy bản mới nhất.
- Audit mọi thay đổi tài khoản cùng giao dịch.

### P1 — should have

- Nhân viên sửa thông tin và khóa tạm, mở lại người đọc với lý do bắt buộc (R1B).

### P2 — nice to have

- Không có.

## 5. Core Flows (Happy Path)

### 5.1 Sửa tài khoản

1) Người thao tác tra cứu tài khoản, mở chi tiết.
2) Sửa thông tin, lưu; hệ thống kiểm tra hợp lệ, kiểm tra không có ai sửa trước đó, ghi audit.

### 5.2 Khóa tạm và mở lại người đọc

1) Nhân viên hoặc Thủ thư chọn khóa, nhập lý do bắt buộc.
2) Hệ thống cảnh báo nếu người đọc đang có phiếu mượn hoặc đặt trước.
3) Xác nhận; hệ thống chuyển trạng thái, ghi audit; từ thời điểm này người đọc không mượn, gia hạn được.
4) Mở lại cũng cần lý do và có audit.

### 5.3 Xóa mềm tài khoản

1) Thủ thư chọn vô hiệu hóa tài khoản.
2) Hệ thống kiểm tra nghĩa vụ đang mở; còn phiếu mượn mở hoặc nợ phạt thì chặn và liệt kê.
3) Không còn nghĩa vụ: tài khoản bị vô hiệu, không đăng nhập hay mượn được; hồ sơ và lịch sử vẫn tra cứu được.

```
Chọn thao tác trên tài khoản ──> Có quyền? ──không──> Từ chối, ghi audit
                                     │ có
                                     ▼
                         Thao tác hợp lệ với trạng thái hiện tại? ──không──> Giải thích, chỉ hiện thao tác hợp lệ
                                     │ có
                                     ▼
                 Khóa / vô hiệu: có lý do? ──không──> Báo thiếu lý do
                                     │ có
                                     ▼
                 Vô hiệu: còn nghĩa vụ mở? ──có──> Chặn, liệt kê nghĩa vụ
                                     │ không
                                     ▼
                         Có người sửa trước? ──có──> Báo xung đột, hiện bản mới nhất
                                     │ không
                                     ▼
                         Lưu + audit
```

## 6. System Behavior Deep Dive

### 6.1 Decision Points

| ID | Flow | Khi nào | YES (nhánh đồng ý) | NO (nhánh từ chối) |
|---|---|---|---|---|
| D1 | Mọi thao tác | Người thao tác có quyền? | Tiếp tục | Từ chối, ghi audit |
| D2 | Khóa/mở | Thao tác hợp lệ với trạng thái hiện tại? | Tiếp tục | Giải thích, chỉ hiện thao tác hợp lệ |
| D3 | Khóa/mở, vô hiệu | Có lý do? | Tiếp tục | Báo thiếu lý do |
| D4 | Vô hiệu | Còn phiếu mượn mở hoặc nợ phạt? | Chặn, liệt kê nghĩa vụ | Vô hiệu tài khoản |
| D5 | Sửa | Bản ghi đã bị người khác sửa sau khi mở? | Báo xung đột, hiện bản mới nhất | Lưu |

### 6.2 Scenario Matrix

| From State | To State | Rule | Action | Result |
|------------|----------|------|--------|--------|
| Thủ thư | Tài khoản người đọc | Có quyền sửa, khóa, vô hiệu | Thao tác | Thực hiện |
| Thủ thư | Tài khoản Nhân viên | Có quyền tạo, khóa, đặt lại mật khẩu, vô hiệu | Thao tác | Thực hiện |
| Nhân viên (R1B) | Tài khoản người đọc | Chỉ sửa thông tin, khóa tạm, mở lại | Thao tác | Thực hiện |
| Nhân viên | Vô hiệu tài khoản người đọc hoặc tài khoản Nhân viên khác | Không có quyền | Thao tác | Từ chối |
| Thủ thư | Tài khoản Thủ thư khác | Chưa xác định | — | Còn mở (OQ-1) |

### 6.3 State Transitions

| Entity | Từ | Sang | Trigger | Quay lại được? |
|--------|------|----|---------|-------------|
| Tài khoản người đọc | Đang hoạt động | Bị khóa | Khóa có lý do | Có, mở lại có lý do |
| Tài khoản người đọc | Đang hoạt động / Bị khóa | Vô hiệu | Thủ thư vô hiệu, không còn nghĩa vụ | Không |
| Tài khoản Nhân viên | Đang hoạt động | Bị khóa | Thủ thư khóa | Có |
| Tài khoản Nhân viên | Đang hoạt động / Bị khóa | Vô hiệu | Thủ thư vô hiệu | Không |

### 6.4 Interrupted Transactions

| Tình huống | Hệ thống còn lại gì | Resume | Cleanup |
|---|---|---|---|
| Hai người cùng khóa hoặc sửa một tài khoản | Chỉ thao tác lưu trước thành công | Người sau thấy trạng thái mới, quyết định lại | Không có |
| Mất kết nối trước khi xác nhận | Trạng thái cũ | Thao tác lại | Không có |

### 6.5 Other Edge Cases

- Khóa tài khoản không đóng hay hủy nghĩa vụ đang có: phiếu mượn vẫn chạy tới trả hoặc mất, đặt trước và công nợ giữ nguyên; chỉ chặn giao dịch mới.
- Tài khoản bị khóa trong lúc người đọc đang đăng nhập: thao tác kế tiếp bị từ chối ngay.

## 7. Validation, Limits & Wording

### 7.1 Validation rules

| Field | Rule |
|---|---|
| Lý do khóa, mở, vô hiệu | Bắt buộc |
| Thông tin hồ sơ | Theo quy tắc của `reader-onboarding` |

### 7.2 Limits & Quotas (exact values)

| Tham số | Giá trị | Window | Behavior khi vượt |
|---|---|---|---|
| — | Không có giới hạn số liệu | — | — |

### 7.3 Wording samples (exact strings)

#### Error messages

| Tình huống | Wording | Code |
|---|---|---|
| Còn nghĩa vụ khi vô hiệu | "Không thể vô hiệu tài khoản vì còn sách đang mượn hoặc công nợ chưa thanh toán." (đề xuất) | E-core-008 |
| Hồ sơ vừa được người khác sửa | "Hồ sơ vừa được cập nhật. Vui lòng xem bản mới nhất trước khi lưu." (đề xuất) | E-core-004 |
| Thiếu lý do | "Vui lòng nhập lý do." (đề xuất) | E-core-001 |

#### Success messages

| Tình huống | Wording |
|---|---|
| Khóa tạm thành công | "Đã khóa tạm tài khoản người đọc." (đề xuất) |

#### Info / neutral messages

| Tình huống | Wording |
|---|---|
| Người đọc đang có nghĩa vụ khi khóa | "Người đọc đang có sách mượn hoặc đặt trước. Khóa tạm chỉ chặn giao dịch mới." (đề xuất) |

## 8. Assumptions

- Khóa tạm không thu hồi sách đang mượn và không hủy đặt trước.
- Thủ thư đầu tiên được tạo sẵn khi triển khai.

## 9. Risks

| Rủi ro | Khả năng | Hậu quả nghiệp vụ | Cách phòng |
|--------|----------|-------------------|-----------|
| Compliance: Thủ thư tự nâng quyền hoặc khóa lẫn nhau | hiếm | Mất kiểm soát hệ thống | Chốt OQ-1 trước R0 |
| Process: Nhân viên khóa nhầm người đọc | thỉnh thoảng | Người đọc bị chặn mượn oan | Lý do bắt buộc, mở lại được ngay |

## 10. Success Criteria (preliminary)

- 100% thay đổi tài khoản có audit.
- 0 tài khoản có lịch sử bị xóa cứng.

## 11. Open Questions

- [ ] OQ-1: Ai quản lý tài khoản Thủ thư và cơ chế chống tự nâng quyền? (OQ-account-admin-001; hold — security/IT)

## 12. Next Steps

- `/srs account-admin`
