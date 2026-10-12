---
type: brainstorm
feature: trend-reports
status: draft
updated: 2026-10-12
links:
  - docs/_product/prd.md
  - docs/_shared/id-crosswalk-lmp.md
---

# Báo cáo xu hướng

## 1. Idea Seed

Thủ thư xem báo cáo xu hướng trên dữ liệu vận hành tích lũy để quyết định mua thêm, sửa hay thanh lý sách.

## 2. Context

- Gồm RP-03, RP-05, RP-06, RP-07 của nguồn, đều ở R2 sau khi pilot có đủ dữ liệu.
- Dùng chung màn dashboard báo cáo của `ops-reports`, chỉ thêm báo cáo mới.
- RP-08 hoạt động nhân viên phụ thuộc điểm danh, là candidate R3.

## 3. User Types (preliminary)

| User Type | Pain Point | Primary Need |
|-----------|-----------|--------------|
| Thủ thư | Mua sách theo cảm tính | Số liệu mượn, phạt, quan tâm, hư hỏng theo thời gian |

## 4. Capabilities Breakdown

### P0 — must have

- Không có (feature thuộc R2).

### P1 — should have

- RP-03 Mượn – trả theo thời gian: số lượt mượn, trả theo ngày, tháng, năm.
- RP-05 Phạt: tổng phạt phát sinh, đã thu, chưa thu, đã miễn.
- RP-06 Sách được quan tâm: top sách mượn nhiều, sách có hàng chờ dài, sách không ai mượn trong 12 tháng.
- RP-07 Hư hỏng và thanh lý: báo cáo hư hỏng theo trạng thái duyệt, số sách thanh lý trong kỳ.
- Lọc theo khoảng thời gian, xuất Excel và PDF.

### P2 — nice to have

- Không có.

## 5. Core Flows (Happy Path)

### 5.1 Xem báo cáo xu hướng

1) Thủ thư mở dashboard báo cáo, chọn báo cáo xu hướng.
2) Chọn khoảng thời gian; hệ thống hiện số liệu.
3) Xuất Excel hoặc PDF.

## 6. System Behavior Deep Dive

### 6.1 Decision Points

| ID | Flow | Khi nào | YES (nhánh đồng ý) | NO (nhánh từ chối) |
|---|---|---|---|---|
| D1 | Xem | Người xem có quyền? | Hiện | Từ chối |
| D2 | Xem | Có dữ liệu trong khoảng? | Hiện | Trạng thái trống |

### 6.2 Scenario Matrix

Không áp dụng — một vai trò.

### 6.3 State Transitions

Không áp dụng — feature chỉ đọc.

### 6.4 Interrupted Transactions

Không áp dụng — feature chỉ đọc.

### 6.5 Other Edge Cases

- Dữ liệu chưa đủ 12 tháng: báo cáo "không ai mượn trong 12 tháng" ghi rõ khoảng dữ liệu thực có.

## 7. Validation, Limits & Wording

### 7.1 Validation rules

| Field | Rule |
|---|---|
| Khoảng thời gian | Ngày bắt đầu không sau ngày kết thúc |

### 7.2 Limits & Quotas (exact values)

| Tham số | Giá trị | Window | Behavior khi vượt |
|---|---|---|---|
| Ngưỡng "không ai mượn" | 12 tháng | Từ ngày xem báo cáo | — |
| Số sách trong top | TBD | — | — |

### 7.3 Wording samples (exact strings)

#### Error messages

| Tình huống | Wording | Code |
|---|---|---|
| Không có quyền | "Bạn không có quyền xem báo cáo này." (đề xuất) | E-core-002 |

#### Success messages

| Tình huống | Wording |
|---|---|
| — | — |

#### Info / neutral messages

| Tình huống | Wording |
|---|---|
| Không có dữ liệu | "Không có dữ liệu trong khoảng thời gian đã chọn." (đề xuất) |

## 8. Assumptions

- Chỉ Thủ thư xem báo cáo xu hướng.

## 9. Risks

| Rủi ro | Khả năng | Hậu quả nghiệp vụ | Cách phòng |
|--------|----------|-------------------|-----------|
| Data: dữ liệu pilot chưa đủ dài | thường | Kết luận sai | Hiện rõ khoảng dữ liệu |

## 10. Success Criteria (preliminary)

- Chưa có — định nghĩa khi viết SRS.

## 11. Open Questions

- [ ] OQ-1: Số sách trong danh sách top? (hold)

## 12. Next Steps

- `/srs trend-reports`
