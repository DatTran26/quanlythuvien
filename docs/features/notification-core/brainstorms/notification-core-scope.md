---
type: brainstorm
feature: notification-core
status: draft
updated: 2026-10-12
links:
  - docs/_product/prd.md
  - docs/_product/decision-register.md
  - docs/_shared/core-spec.md
  - docs/_shared/id-crosswalk-lmp.md
---

# Thông báo tối thiểu

## 1. Idea Seed

Mọi giao dịch nghiệp vụ phát sự kiện thông báo vào hàng đợi bền cùng giao dịch; hệ thống gửi qua in-app và email cho sự kiện quan trọng, thử lại khi lỗi, chuyển hàng lỗi khi quá số lần, và không bao giờ làm hỏng giao dịch chính.

## 2. Context

- Kênh baseline: in-app + email cho sự kiện quan trọng (DEC-P2-01). SMS, push, Zalo là candidate R3.
- Trung tâm thông báo đầy đủ (danh sách, đánh dấu đã đọc) thuộc `notification-audit-ui` (R1B).
- Các feature khác (`checkout`, `return-handling`, `overdue-fines`, `damage-lifecycle`, `account-admin`, `reservation`) phát sự kiện vào đây.

## 3. User Types (preliminary)

| User Type | Pain Point | Primary Need |
|-----------|-----------|--------------|
| Người đọc | Không được nhắc hạn trả, bị phạt | Nhận thông báo đúng lúc |
| Thủ thư | Không biết thông báo nào gửi lỗi | Theo dõi trạng thái gửi, xử lý hàng lỗi |

## 4. Capabilities Breakdown

### P0 — must have

- Ghi sự kiện thông báo vào hàng đợi bền cùng giao dịch nghiệp vụ.
- Gửi in-app cho mọi sự kiện; thêm email cho sự kiện quan trọng.
- Thử lại khi kênh lỗi; quá số lần thì chuyển hàng lỗi và cảnh báo vận hành.
- Kênh ngoài lỗi thì thông báo vẫn có trong in-app.
- Gửi lỗi không làm hỏng giao dịch chính.
- Màn trạng thái thông báo: đang chờ, đã gửi, lỗi, hàng lỗi.

### P1 — should have

- Không có.

### P2 — nice to have

- Không có.

## 5. Core Flows (Happy Path)

### 5.1 Phát và gửi thông báo

1) Giao dịch nghiệp vụ ghi sự kiện thông báo cùng giao dịch.
2) Hệ thống lấy sự kiện chờ, gửi qua kênh tương ứng.
3) Kênh xác nhận: đánh dấu đã gửi.
4) Kênh lỗi: thử lại; quá số lần thì chuyển hàng lỗi.

```
Giao dịch commit ──> Sự kiện vào hàng đợi
                          │
                          ▼
                   Gửi qua kênh ──> Thành công? ──có──> Đã gửi
                          │ không
                          ▼
                   Còn lượt thử? ──có──> Thử lại sau
                          │ không
                          ▼
                   Hàng lỗi + cảnh báo vận hành (in-app vẫn còn)
```

## 6. System Behavior Deep Dive

### 6.1 Decision Points

| ID | Flow | Khi nào | YES (nhánh đồng ý) | NO (nhánh từ chối) |
|---|---|---|---|---|
| D1 | Gửi | Sự kiện quan trọng? | In-app + email | Chỉ in-app |
| D2 | Gửi | Kênh xác nhận? | Đã gửi | Thử lại |
| D3 | Gửi | Còn lượt thử? | Thử lại | Hàng lỗi |
| D4 | Gửi | Địa chỉ nhận hợp lệ? | Gửi | Lỗi có lý do riêng, giữ in-app |

### 6.2 Scenario Matrix

| From State | To State | Rule | Action | Result |
|------------|----------|------|--------|--------|
| Đang chờ | Đã gửi | Kênh xác nhận | Gửi | Hoàn tất |
| Đang chờ | Lỗi | Kênh từ chối hoặc hết giờ | Gửi | Thử lại |
| Lỗi | Hàng lỗi | Hết lượt thử | — | Cảnh báo vận hành |

### 6.3 State Transitions

| Entity | Từ | Sang | Trigger | Quay lại được? |
|--------|------|----|---------|-------------|
| Thông báo | Đang chờ | Đã gửi | Kênh xác nhận | Không |
| Thông báo | Đang chờ | Lỗi | Kênh lỗi | Có, thử lại |
| Thông báo | Lỗi | Hàng lỗi | Hết lượt thử | Có, gửi lại thủ công (chưa chốt) |

### 6.4 Interrupted Transactions

| Tình huống | Hệ thống còn lại gì | Resume | Cleanup |
|---|---|---|---|
| Toàn bộ kênh ngoài ngưng | Sự kiện tích lũy trong hàng đợi | Gửi tiếp khi kênh phục hồi | Không mất thông báo |
| Job gửi chạy lại | Sự kiện đã gửi | Không gửi lại | Không có |

### 6.5 Other Edge Cases

- Email người nhận sai hoặc bị trả về: đánh dấu lỗi với lý do riêng, thông báo vẫn nằm trong in-app.

## 7. Validation, Limits & Wording

### 7.1 Validation rules

| Field | Rule |
|---|---|
| Sự kiện thông báo | Có loại, người nhận, kênh |

### 7.2 Limits & Quotas (exact values)

| Tham số | Giá trị | Window | Behavior khi vượt |
|---|---|---|---|
| Số lần thử lại | TBD | Mỗi thông báo | Chuyển hàng lỗi |
| Khoảng cách giữa các lần thử | TBD | — | — |

Sự kiện và thời điểm gửi (nguồn Mục 8):

| Sự kiện | Người nhận | Thời điểm |
|---|---|---|
| Phiếu mượn được tạo | Người đọc | Ngay, kèm hạn trả |
| Sắp đến hạn trả | Người đọc | 2 ngày trước hạn |
| Quá hạn | Người đọc | Ngày đầu, sau đó mỗi 3 ngày |
| Sách đặt trước sẵn sàng | Người đọc | Ngay khi gán bản sao (R2) |
| Đặt trước hết hạn giữ | Người đọc | Khi hết 48 giờ (R2) |
| Phát sinh khoản phạt | Người đọc | Khi đóng phiếu |
| Có báo cáo hư hỏng mới | Thủ thư | Ngay |
| Tài khoản bị khóa / mở khóa | Người bị ảnh hưởng | Ngay |

### 7.3 Wording samples (exact strings)

#### Error messages

| Tình huống | Wording | Code |
|---|---|---|
| — | — | — |

#### Success messages

| Tình huống | Wording |
|---|---|
| — | — |

#### Info / neutral messages

| Tình huống | Wording |
|---|---|
| Phiếu mượn được tạo | "Bạn đã mượn {N} cuốn. Hạn trả: {ngày}." (đề xuất) |

## 8. Assumptions

- Sự kiện quan trọng gửi thêm email: phiếu mượn được tạo, quá hạn, phát sinh khoản phạt, sách đặt trước sẵn sàng, tài khoản bị khóa.
- Gửi lại thủ công từ hàng lỗi do vận hành quyết định.

## 9. Risks

| Rủi ro | Khả năng | Hậu quả nghiệp vụ | Cách phòng |
|--------|----------|-------------------|-----------|
| Vendor: dịch vụ email chưa chọn | thỉnh thoảng | Không gửi được email ở pilot | Chọn ở GATE-DEC; in-app luôn có |
| Process: hàng lỗi không ai xử lý | thỉnh thoảng | Người đọc không được nhắc | Owner vận hành cho hàng lỗi |

## 10. Success Criteria (preliminary)

- 100% giao dịch nghiệp vụ có sự kiện thông báo.
- 0 giao dịch bị hủy vì gửi thông báo lỗi.

## 11. Open Questions

- [ ] OQ-1: Kênh bắt buộc: chỉ in-app + email hay thêm kênh khác? (OQ-notification-core-001; hold — Product Owner)
- [ ] OQ-2: Số lần thử lại và khoảng cách thử? (hold — vận hành)
- [ ] OQ-3: Danh sách sự kiện quan trọng gửi email (giả định ở Mục 8)? (hold — Product Owner)
- [ ] OQ-4: Ai xử lý hàng lỗi, có thông báo Nhân viên trực quầy không? (DEC-D3-08; hold)

## 12. Next Steps

- `/srs notification-core`
