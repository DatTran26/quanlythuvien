---
type: brainstorm
feature: fine-collection-adv
status: draft
updated: 2026-10-08
links:
  - docs/_product/prd.md
  - docs/_product/decision-register.md
  - docs/_shared/core-spec.md
  - docs/_shared/id-crosswalk-lmp.md
---

# Thu phạt nâng cao

## 1. Idea Seed

In biên nhận thu phạt, cho Quản trị viên miễn, điều chỉnh, đảo hoặc hoàn tiền phạt với lý do, thẩm quyền và audit; đối soát tiền thu cuối ca với sổ.

## 2. Context

- Phần thu tiền mặt tối thiểu đã có ở `fine-collection-basic` (R1A); feature này là phần R1B (DEC-P2-04).
- Quyền miễn, điều chỉnh và phân tách trách nhiệm là hard-stop tài chính, chưa được finance duyệt (DEC-D3-04). Mọi thao tác chỉ thêm sự kiện mới, không sửa sự kiện đã ghi.

## 3. User Types (preliminary)

| User Type | Pain Point | Primary Need |
|-----------|-----------|--------------|
| Quản trị viên | Không có cách sửa sai phạt có kiểm soát | Miễn/điều chỉnh có lý do và dấu vết |
| Thủ thư | Không có biên nhận đưa người đọc | In biên nhận thu phạt |
| Thủ thư trưởng | Lệch tiền mặt cuối ca | Đối soát thu ngân |

## 4. Capabilities Breakdown

### P0 — must have

- Không có (feature thuộc R1B).

### P1 — should have

- In biên nhận thu phạt với mã khoản thu duy nhất.
- Miễn phạt có lý do bắt buộc; số dư về 0 thì khoản phạt chuyển Đã miễn.
- Điều chỉnh tăng hoặc giảm có lý do.
- Đảo một sự kiện đã ghi (tham chiếu sự kiện gốc); hoàn tiền khi đã thu thừa.
- Khoản phạt đã đóng không mở lại; nghĩa vụ mới mở khoản mới.
- Mọi thao tác yêu cầu xác thực lại, có audit.
- Người tạo khoản phạt thủ công không được tự duyệt miễn cho chính khoản đó.
- Đối soát cuối ca: tiền mặt ghi nhận so với tổng khoản thu; lệch thì ghi sự kiện đối soát và cảnh báo.

### P2 — nice to have

- Không có.

## 5. Core Flows (Happy Path)

### 5.1 Miễn hoặc điều chỉnh

1) Quản trị viên mở sổ sự kiện của khoản phạt, chọn thao tác.
2) Nhập số tiền và lý do; hệ thống yêu cầu xác thực lại.
3) Hệ thống kiểm tra quyền, thẩm quyền theo số tiền và phân tách trách nhiệm, ghi sự kiện, ghi audit.

### 5.2 Đối soát cuối ca

1) Cuối ca, hệ thống tổng hợp khoản thu của quầy.
2) Thủ thư nhập tiền mặt thực có; lệch thì ghi sự kiện đối soát và cảnh báo vận hành.

```
Chọn thao tác ──> Có quyền? ──không──> Từ chối, audit
                      │ có
                      ▼
          Xác thực lại thành công? ──không──> Hủy
                      │ có
                      ▼
          Vượt ngưỡng cần duyệt cấp cao? ──có──> Chờ người duyệt (chưa chốt)
                      │ không
                      ▼
          Ghi sự kiện mới (không sửa sự kiện cũ) + audit ──> Số dư về 0? ──có──> Đóng khoản phạt
```

## 6. System Behavior Deep Dive

### 6.1 Decision Points

| ID | Flow | Khi nào | YES (nhánh đồng ý) | NO (nhánh từ chối) |
|---|---|---|---|---|
| D1 | Miễn/điều chỉnh | Có quyền tài chính? | Tiếp tục | Từ chối, audit |
| D2 | Miễn/điều chỉnh | Xác thực lại thành công? | Tiếp tục | Hủy |
| D3 | Miễn/điều chỉnh | Người thao tác là người tạo khoản phạt thủ công? | Từ chối | Tiếp tục |
| D4 | Miễn/điều chỉnh | Vượt ngưỡng cần duyệt cấp cao? | Chờ duyệt | Ghi |
| D5 | Đối soát | Tiền mặt khớp tổng khoản thu? | Đóng ca | Ghi đối soát, cảnh báo |

### 6.2 Scenario Matrix

| From State | To State | Rule | Action | Result |
|------------|----------|------|--------|--------|
| Chưa thanh toán | Đã miễn | Miễn hết số dư | Miễn | Đóng khoản |
| Chưa thanh toán | Chưa thanh toán | Điều chỉnh | Điều chỉnh | Số dư đổi |
| Đã thanh toán / Đã miễn | — | Trạng thái cuối | Thu, sửa trực tiếp | Từ chối; chỉ đảo/hoàn/điều chỉnh có tham chiếu |
| Thủ thư | Miễn, điều chỉnh | Không có quyền | Thao tác | Từ chối |

### 6.3 State Transitions

| Entity | Từ | Sang | Trigger | Quay lại được? |
|--------|------|----|---------|-------------|
| Khoản phạt | Chưa thanh toán | Đã miễn | Miễn đưa số dư về 0 | Không |

### 6.4 Interrupted Transactions

| Tình huống | Hệ thống còn lại gì | Resume | Cleanup |
|---|---|---|---|
| Mất kết nối sau xác nhận | Sự kiện đã ghi hoặc chưa | Xem lại sổ | Không ghi trùng |
| Audit lỗi | Không có sự kiện | Thử lại | Cảnh báo vận hành |

### 6.5 Other Edge Cases

- Đảo hoặc hoàn sau khi khoản đã đóng tạo số dư âm: xử lý bằng sự kiện hoàn và đối soát, không mở lại khoản.

## 7. Validation, Limits & Wording

### 7.1 Validation rules

| Field | Rule |
|---|---|
| Lý do | Bắt buộc với miễn, điều chỉnh, đảo, hoàn |
| Đảo | Phải tham chiếu sự kiện gốc |

### 7.2 Limits & Quotas (exact values)

| Tham số | Giá trị | Window | Behavior khi vượt |
|---|---|---|---|
| Ngưỡng tiền cần duyệt cấp cao | TBD | Mỗi thao tác | Chờ duyệt |

### 7.3 Wording samples (exact strings)

#### Error messages

| Tình huống | Wording | Code |
|---|---|---|
| Thao tác trên khoản đã đóng | "Khoản phạt đã đóng. Chỉ có thể đảo, hoàn hoặc điều chỉnh có tham chiếu." (đề xuất) | E-core-008 |
| Tự duyệt khoản do mình tạo | "Bạn không thể duyệt khoản phạt do chính mình tạo." (đề xuất) | E-core-002 |

#### Success messages

| Tình huống | Wording |
|---|---|
| Miễn thành công | "Đã ghi nhận miễn phạt." (đề xuất) |

#### Info / neutral messages

| Tình huống | Wording |
|---|---|
| Lệch đối soát | "Tiền mặt lệch {số tiền} so với tổng khoản thu của ca." (đề xuất) |

## 8. Assumptions

- Chỉ Quản trị viên được miễn, điều chỉnh, đảo, hoàn.

## 9. Risks

| Rủi ro | Khả năng | Hậu quả nghiệp vụ | Cách phòng |
|--------|----------|-------------------|-----------|
| Compliance: kiểm soát tài chính chưa duyệt | thường | Phải tắt miễn/điều chỉnh khi go-live | Finance duyệt DEC-D3-04 trước GATE-GNG |
| Process: lạm dụng miễn phạt | hiếm | Thất thu | Ngưỡng duyệt, phân tách trách nhiệm, audit |

## 10. Success Criteria (preliminary)

- Số dư mọi khoản phạt khớp tổng sự kiện tài chính.
- 100% thao tác miễn, điều chỉnh có lý do và audit.

## 11. Open Questions

- [ ] OQ-1: Thu một phần, miễn, điều chỉnh, đảo, hoàn: chính sách và quyền? (OQ-fine-collection-adv-001; hold — finance)
- [ ] OQ-2: Ai duyệt khi đối soát lệch và ngưỡng duyệt cấp cao? (OQ-fine-collection-adv-002; hold — finance)
- [ ] OQ-3: Mẫu biên nhận thu phạt? (hold)

## 12. Next Steps

- `/srs fine-collection-adv`
