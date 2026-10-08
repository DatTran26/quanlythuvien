---
type: brainstorm
feature: renewal
status: draft
updated: 2026-10-08
links:
  - docs/_product/prd.md
  - docs/_product/decision-register.md
  - docs/_shared/core-spec.md
  - docs/_shared/id-crosswalk-lmp.md
---

# Gia hạn tại quầy và online

## 1. Idea Seed

Người đọc tự gia hạn online hoặc nhờ Thủ thư gia hạn tại quầy; hệ thống chỉ gia hạn khi phiếu chưa quá hạn, chưa hết lượt gia hạn và không có người đặt trước đầu sách đó, và luôn nêu rõ lý do khi từ chối.

## 2. Context

- Gia hạn tại quầy (FR-S06 nguồn) và online (FR-R06) đều ở R1B (DEC-SF-02).
- Điều kiện "có người đặt trước" vẫn được kiểm, nhưng hàng chờ rỗng cho tới khi `reservation` bật ở R2; quy tắc vẫn đúng nghĩa (DEC-P2-05).
- Điều kiện người đọc (khóa, quá hạn, nợ) dùng chung với `checkout` (BR-core-001).

## 3. User Types (preliminary)

| User Type | Pain Point | Primary Need |
|-----------|-----------|--------------|
| Người đọc | Phải mang sách ra quầy để gia hạn | Tự gia hạn online |
| Thủ thư | Không biết vì sao không gia hạn được | Lý do từ chối rõ ràng |

## 4. Capabilities Breakdown

### P0 — must have

- Không có (feature thuộc R1B).

### P1 — should have

- Gia hạn tại quầy: Thủ thư chọn phiếu đang mở của người đọc, gia hạn.
- Gia hạn online: người đọc chọn khoản đang mượn của mình, gia hạn.
- Kiểm tra: phiếu chưa quá hạn, chưa hết lượt gia hạn, đầu sách không có người đặt trước, người đọc đủ điều kiện.
- Gia hạn thành công: hạn trả cộng thêm theo cấu hình, tăng đếm lượt, ghi audit, thông báo hạn mới.
- Từ chối nêu lý do cụ thể.
- Bấm lặp không gia hạn hai lần.

### P2 — nice to have

- Không có.

## 5. Core Flows (Happy Path)

### 5.1 Gia hạn

1) Người đọc hoặc Thủ thư chọn phiếu đang mở, chọn gia hạn.
2) Hệ thống kiểm tra điều kiện.
3) Đạt: cập nhật hạn trả, tăng đếm lượt, ghi audit, thông báo hạn mới.
4) Không đạt: hiển thị lý do cụ thể.

```
Chọn phiếu ──> Đã quá hạn? ──có──> Từ chối: trả sách và nộp phạt
                    │ không
                    ▼
         Hết lượt gia hạn? ──có──> Từ chối: đã hết lượt
                    │ không
                    ▼
         Có người đặt trước? ──có──> Từ chối: đang có người chờ (chỉ xảy ra từ R2)
                    │ không
                    ▼
         Người đọc đủ điều kiện? ──không──> Từ chối: nêu lý do khóa / nợ
                    │ có
                    ▼
         Hạn trả + 7 ngày, lượt +1, audit, thông báo
```

## 6. System Behavior Deep Dive

### 6.1 Decision Points

| ID | Flow | Khi nào | YES (nhánh đồng ý) | NO (nhánh từ chối) |
|---|---|---|---|---|
| D1 | Gia hạn | Phiếu đã quá hạn? | Từ chối | Tiếp tục |
| D2 | Gia hạn | Đã hết lượt gia hạn? | Từ chối | Tiếp tục |
| D3 | Gia hạn | Đầu sách có người đặt trước? | Từ chối | Tiếp tục |
| D4 | Gia hạn | Người đọc đủ điều kiện? | Gia hạn | Từ chối |
| D5 | Gia hạn | Lần bấm này đã ghi? | Trả kết quả gốc | Ghi |

### 6.2 Scenario Matrix

| From State | To State | Rule | Action | Result |
|------------|----------|------|--------|--------|
| Người đọc | Phiếu của chính mình | Gia hạn online | Gia hạn | Thực hiện nếu đạt điều kiện |
| Thủ thư | Phiếu của người đọc | Gia hạn thay | Gia hạn | Thực hiện nếu đạt điều kiện |
| Người đọc | Phiếu của người khác | Không có quyền | Gia hạn | Từ chối |

### 6.3 State Transitions

| Entity | Từ | Sang | Trigger | Quay lại được? |
|--------|------|----|---------|-------------|
| Phiếu mượn | Đang mở | Đang mở (hạn mới) | Gia hạn thành công | Không hoàn tác |

### 6.4 Interrupted Transactions

| Tình huống | Hệ thống còn lại gì | Resume | Cleanup |
|---|---|---|---|
| Gia hạn đua với trả hoặc ghi nhận mất | Thao tác đầu tiên thắng | Tải lại trạng thái mới | Không có |
| Mất kết nối sau xác nhận | Đã gia hạn hoặc chưa | Xem lại hạn trả | Không gia hạn lần hai |

### 6.5 Other Edge Cases

- Phiếu quá hạn không thể quay lại đang mở qua gia hạn.

## 7. Validation, Limits & Wording

### 7.1 Validation rules

| Field | Rule |
|---|---|
| Phiếu | Phải đang mở, chưa quá hạn |

### 7.2 Limits & Quotas (exact values)

| Tham số | Giá trị | Window | Behavior khi vượt |
|---|---|---|---|
| Số lần gia hạn | 1 lần (mặc định nguồn, chưa chốt) | Mỗi phiếu | Từ chối |
| Thời gian cộng thêm | 7 ngày (mặc định nguồn, chưa chốt) | Mỗi lần gia hạn | — |

### 7.3 Wording samples (exact strings)

#### Error messages

| Tình huống | Wording | Code |
|---|---|---|
| Phiếu quá hạn | "Không thể gia hạn vì sách đã quá hạn. Vui lòng trả sách và thanh toán phạt." (đề xuất) | E-core-008 |
| Hết lượt | "Không thể gia hạn vì đã dùng hết số lần gia hạn." (đề xuất) | E-core-008 |
| Có người đặt trước | "Không thể gia hạn vì đang có người đặt trước sách này." (đề xuất) | E-core-008 |
| Người đọc không đủ điều kiện | "Không thể gia hạn. Vui lòng kiểm tra trạng thái thẻ, sách quá hạn và công nợ." (đề xuất) | E-core-006 |

#### Success messages

| Tình huống | Wording |
|---|---|
| Gia hạn thành công | "Đã gia hạn. Hạn trả mới: {ngày}." (đề xuất) |

#### Info / neutral messages

| Tình huống | Wording |
|---|---|
| — | — |

## 8. Assumptions

- Người đọc gia hạn online từ cổng `reader-self-service`.

## 9. Risks

| Rủi ro | Khả năng | Hậu quả nghiệp vụ | Cách phòng |
|--------|----------|-------------------|-----------|
| Process: bật đặt trước ở R2 làm đổi kết quả gia hạn | thỉnh thoảng | Người đọc bị từ chối bất ngờ | Thông báo khi bật R2, quy tắc đã có từ R1B |

## 10. Success Criteria (preliminary)

- Chưa có — định nghĩa khi viết SRS.

## 11. Open Questions

- [ ] OQ-1: Số lần gia hạn và thời gian cộng thêm chính thức? (OQ-policy-config-001; hold — Thủ thư trưởng)

## 12. Next Steps

- `/srs renewal`
