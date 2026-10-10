---
type: brainstorm
feature: fine-collection-basic
status: draft
updated: 2026-10-08
links:
  - docs/_product/prd.md
  - docs/_product/decision-register.md
  - docs/_shared/core-spec.md
  - docs/_shared/id-crosswalk-lmp.md
---

# Thu phạt tiền mặt tối thiểu

## 1. Idea Seed

Thủ thư tra công nợ của người đọc, thu tiền mặt tại quầy và ghi khoản thu vào sổ; bấm lặp hay mất mạng không ghi trùng, và không ai sửa hay xóa được khoản đã ghi.

## 2. Context

- Công nợ phải có đường thanh toán ngay trong pilot, nên thu tiền mặt tối thiểu nâng lên R1A (DEC-P2-04).
- Biên nhận thu phạt đầy đủ, miễn, điều chỉnh, hoàn thuộc `fine-collection-adv` (R1B).
- Mặc định thu tiền mặt tại quầy; thanh toán online là candidate R3 (OQ-08 nguồn).

## 3. User Types (preliminary)

| User Type | Pain Point | Primary Need |
|-----------|-----------|--------------|
| Thủ thư | Ghi sổ tay, lệch tiền cuối ca | Ghi khoản thu một lần, đúng số dư |
| Người đọc | Không biết còn nợ bao nhiêu | Thấy số dư rõ ràng khi nộp |

## 4. Capabilities Breakdown

### P0 — must have

- Xem danh sách khoản phạt chưa thanh toán của người đọc và chi tiết từng khoản.
- Thu tiền mặt: nhập số tiền, xác nhận; số tiền phải lớn hơn 0 và không vượt số dư tại thời điểm ghi.
- Ghi khoản thu vào sổ chỉ thêm, kèm mã khoản thu duy nhất; số dư về 0 thì khoản phạt chuyển Đã thanh toán.
- Bấm lặp hoặc mất mạng sau xác nhận không ghi khoản thu thứ hai.
- Hai quầy cùng thu một khoản: chỉ lần ghi trước thành công, quầy sau thấy số dư mới.
- Thủ thư chỉ được ghi khoản thu, không được miễn hay điều chỉnh.
- Audit và sự kiện thông báo trong cùng giao dịch.

### P1 — should have

- Không có.

### P2 — nice to have

- Không có.

## 5. Core Flows (Happy Path)

### 5.1 Thu tiền mặt

1) Thủ thư mở công nợ của người đọc, chọn một khoản.
2) Chọn thu tiền, nhập số tiền, xác nhận.
3) Hệ thống kiểm tra số tiền, ghi khoản thu, cập nhật số dư, ghi audit và thông báo.
4) Hệ thống hiển thị mã khoản thu và số dư còn lại.

```
Chọn khoản phạt ──> Nhập số tiền ──> Lớn hơn 0 và ≤ số dư hiện tại? ──không──> Báo lỗi kèm số dư mới
                                                   │ có
                                                   ▼
                              Lần xác nhận này đã ghi? ──có──> Trả kết quả gốc
                                                   │ chưa
                                                   ▼
                              Ghi khoản thu + cập nhật số dư + audit ──> Số dư = 0? ──có──> Khoản phạt Đã thanh toán
```

## 6. System Behavior Deep Dive

### 6.1 Decision Points

| ID | Flow | Khi nào | YES (nhánh đồng ý) | NO (nhánh từ chối) |
|---|---|---|---|---|
| D1 | Thu tiền | Số tiền > 0 và ≤ số dư lúc ghi? | Tiếp tục | Báo lỗi, hiện số dư mới |
| D2 | Thu tiền | Lần xác nhận đã ghi trước đó? | Trả kết quả gốc | Ghi khoản thu |
| D3 | Thu tiền | Số dư sau khi thu bằng 0? | Khoản phạt Đã thanh toán | Giữ Chưa thanh toán |
| D4 | Thu tiền | Ghi audit thành công? | Hoàn tất | Hủy khoản thu |

### 6.2 Scenario Matrix

| From State | To State | Rule | Action | Result |
|------------|----------|------|--------|--------|
| Chưa thanh toán | Đã thanh toán | Thu đủ số dư | Thu tiền | Khoản phạt đóng |
| Chưa thanh toán | Chưa thanh toán | Thu một phần (nếu chính sách cho phép) | Thu tiền | Số dư giảm |
| Đã thanh toán | — | Trạng thái cuối | Thu tiền | Từ chối |

### 6.3 State Transitions

| Entity | Từ | Sang | Trigger | Quay lại được? |
|--------|------|----|---------|-------------|
| Khoản phạt | Chưa thanh toán | Đã thanh toán | Số dư về 0 sau khoản thu | Không; sửa sai bằng điều chỉnh (`fine-collection-adv`) |

### 6.4 Interrupted Transactions

| Tình huống | Hệ thống còn lại gì | Resume | Cleanup |
|---|---|---|---|
| Mất kết nối sau xác nhận | Khoản thu đã ghi hoặc chưa | Tra lại theo lần xác nhận | Không có |
| Ghi khoản thu lỗi | Khoản phạt giữ nguyên | Thử lại với cùng lần xác nhận | Không có |
| Hai quầy cùng thu | Một khoản thu | Quầy sau thấy số dư mới | Không ghi trùng |

### 6.5 Other Edge Cases

- Thủ thư cố miễn hoặc điều chỉnh: bị từ chối, ghi audit.

## 7. Validation, Limits & Wording

### 7.1 Validation rules

| Field | Rule |
|---|---|
| Số tiền | Bắt buộc, > 0, ≤ số dư tại thời điểm ghi |

### 7.2 Limits & Quotas (exact values)

| Tham số | Giá trị | Window | Behavior khi vượt |
|---|---|---|---|
| Hình thức thu | Tiền mặt tại quầy | — | Thanh toán online không có |

### 7.3 Wording samples (exact strings)

#### Error messages

| Tình huống | Wording | Code |
|---|---|---|
| Ghi khoản thu thất bại | "Chưa ghi được khoản thu. Khoản phạt chưa thay đổi, vui lòng thử lại." (đề xuất) | E-fine-collection-basic-001 |
| Số tiền vượt số dư | "Số tiền vượt số dư hiện tại {số dư}." (đề xuất) | E-core-001 |

#### Success messages

| Tình huống | Wording |
|---|---|
| Thu tiền thành công | "Đã ghi nhận khoản thu {mã}. Số dư còn lại: {số tiền}." (đề xuất) |

#### Info / neutral messages

| Tình huống | Wording |
|---|---|
| Bấm xác nhận lặp | "Khoản thu này đã được ghi nhận." (đề xuất) — mã E-fine-collection-basic-002 |

## 8. Assumptions

- Hiển thị mã khoản thu trên màn hình ở R1A; biên nhận thu phạt in đầy đủ ở R1B.

## 9. Risks

| Rủi ro | Khả năng | Hậu quả nghiệp vụ | Cách phòng |
|--------|----------|-------------------|-----------|
| Process: lệch tiền mặt cuối ca | thỉnh thoảng | Thất thoát, tranh chấp | Đối soát cuối ca ở `fine-collection-adv` |
| Compliance: chính sách thu một phần chưa duyệt | thỉnh thoảng | Thu sai quy định | Chờ OQ-1 |

## 10. Success Criteria (preliminary)

- 0 khoản thu bị ghi hai lần cho một yêu cầu.
- Số dư mọi khoản phạt khớp tổng sự kiện tài chính.

## 11. Open Questions

- [ ] OQ-1: Có cho thu một phần không, giới hạn số lần? (OQ-fine-collection-adv-001; hold — finance)

## 12. Next Steps

- `/srs fine-collection-basic`
