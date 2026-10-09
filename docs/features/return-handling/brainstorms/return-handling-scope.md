---
type: brainstorm
feature: return-handling
status: draft
updated: 2026-10-08
links:
  - docs/_product/prd.md
  - docs/_shared/core-spec.md
  - docs/_shared/domain/lifecycle-inventory.md
  - docs/_shared/id-crosswalk-lmp.md
---

# Trả sách và ngoại lệ

## 1. Idea Seed

Thủ thư quét sách trả; hệ thống tìm phiếu mượn đang mở, ghi tình trạng, đóng phiếu, tính phạt nếu quá hạn, rồi đưa bản sao về Sẵn sàng hoặc Chờ duyệt nếu hư hỏng — tất cả trong một giao dịch.

## 2. Context

- Đi cặp với `checkout`: không có đường trả thì phiếu mượn không bao giờ đóng.
- Thứ tự "đóng phiếu và tính phạt trước, rồi mới đổi trạng thái bản sao" là FACT của nguồn; chi tiết luồng là bản dựng lại, chờ duyệt (DEC-D3-02).
- Ở R1A luồng trả không phân bổ hàng chờ đặt trước (D5 luôn "không có hàng chờ" — DEC-P2-05); nhánh có hàng chờ bật ở R2 cùng `reservation`.
- Hư hỏng phát hiện lúc trả tạo báo cáo ở `damage-lifecycle`; mất sách ghi ở `lost-handling`; phạt quá hạn ghi theo `overdue-fines`.

## 3. User Types (preliminary)

| User Type | Pain Point | Primary Need |
|-----------|-----------|--------------|
| Thủ thư | Không biết cuốn trả thuộc phiếu nào, phạt bao nhiêu | Quét là đóng đúng phiếu, thấy ngay phạt |
| Người đọc | Trả rồi mà hệ thống vẫn ghi đang mượn | Phiếu đóng ngay, biết số phạt nếu có |

## 4. Capabilities Breakdown

### P0 — must have

- Quét QR bản sao để tìm phiếu mượn đang mở.
- Ghi tình trạng trả: bình thường hoặc hư hỏng (mức độ, mô tả, 1–5 ảnh).
- Trong một giao dịch: đóng phiếu, ghi phạt quá hạn nếu trả trễ, đổi trạng thái bản sao, ghi audit, phát sự kiện thông báo.
- Trả bình thường: bản sao về Sẵn sàng. Trả hư hỏng: bản sao sang Chờ duyệt, tạo báo cáo hư hỏng.
- Quét lặp cuốn đã trả không đóng phiếu lần hai, không tính phạt lần hai.
- Hai quầy cùng xử lý một bản sao: chỉ thao tác đầu tiên thành công.
- Màn kết quả trả: phiếu đã đóng, phạt tạm tính nếu có, trạng thái mới của bản sao.

### P1 — should have

- Không có.

### P2 — nice to have

- Không có. Phân bổ hàng chờ khi trả thuộc R2 (`reservation`).

## 5. Core Flows (Happy Path)

### 5.1 Trả sách

1) Thủ thư mở màn quét trả, quét QR bản sao.
2) Hệ thống tìm phiếu mượn đang mở của bản sao.
3) Thủ thư ghi tình trạng: bình thường hoặc hư hỏng.
4) Hệ thống đóng phiếu, ghi phạt nếu quá hạn, đổi trạng thái bản sao, ghi audit và sự kiện thông báo trong một giao dịch.
5) Hệ thống hiển thị kết quả trả.

```
Quét QR bản sao ──> Có phiếu đang mở? ──không──> "Không tìm thấy phiếu mượn đang mở cho cuốn sách này."
                          │ có
                          ▼
                Ghi tình trạng ──> Hư hỏng? ──có──> Đóng phiếu + phạt (nếu quá hạn) + phạt hư hỏng
                          │ không                     + bản sao Chờ duyệt + báo cáo hư hỏng
                          ▼
              Đóng phiếu + phạt nếu quá hạn
                          │
                          ▼
              Có hàng chờ đặt trước? ──có (chỉ từ R2)──> Bản sao Đang giữ cho người kế tiếp
                          │ không (luôn ở R1A)
                          ▼
                Bản sao Sẵn sàng ──> "Đã nhận trả sách và cập nhật trạng thái bản sao."
```

## 6. System Behavior Deep Dive

### 6.1 Decision Points

| ID | Flow | Khi nào | YES (nhánh đồng ý) | NO (nhánh từ chối) |
|---|---|---|---|---|
| D1 | Trả | Bản sao có phiếu mượn đang mở? | Ghi tình trạng | Báo không tìm thấy phiếu |
| D2 | Trả | Trả hư hỏng? | Tạo báo cáo hư hỏng, bản sao Chờ duyệt | Tiếp tục |
| D3 | Trả | Trả sau hạn? | Ghi phạt quá hạn | Không phạt |
| D4 | Trả | Đầu sách có hàng chờ đặt trước? | Giữ bản sao cho người kế tiếp (R2) | Bản sao Sẵn sàng |
| D5 | Trả | Phiếu đã đóng trước đó (quét lặp)? | Trả kết quả gốc, không làm gì thêm | Tiếp tục |

### 6.2 Scenario Matrix

| From State | To State | Rule | Action | Result |
|------------|----------|------|--------|--------|
| Đang mượn | Sẵn sàng | Trả bình thường, không hàng chờ | Xác nhận trả | Phiếu đóng |
| Đang mượn | Chờ duyệt | Trả hư hỏng | Xác nhận trả | Phiếu đóng, báo cáo hư hỏng |
| Đang mượn | Đang giữ | Trả bình thường, có hàng chờ (R2) | Xác nhận trả | Phiếu đóng, người kế tiếp được báo |
| Sẵn sàng / Chờ duyệt / Đang sửa / Mất / Thanh lý | — | Không có phiếu mở | Quét trả | Báo trạng thái hiện tại |

### 6.3 State Transitions

| Entity | Từ | Sang | Trigger | Quay lại được? |
|--------|------|----|---------|-------------|
| Phiếu mượn | Đang mở / Quá hạn | Đã trả | Xác nhận trả | Không |
| Bản sao | Đang mượn | Sẵn sàng | Trả bình thường | Có, qua mượn |
| Bản sao | Đang mượn | Chờ duyệt | Trả hư hỏng | Có, qua duyệt hư hỏng |
| Bản sao | Đang mượn | Đang giữ | Trả bình thường, có hàng chờ (R2) | Có |

### 6.4 Interrupted Transactions

| Tình huống | Hệ thống còn lại gì | Resume | Cleanup |
|---|---|---|---|
| Mất kết nối trước khi xác nhận | Phiếu vẫn mở | Quét lại | Không có |
| Mất kết nối sau khi xác nhận | Phiếu đã đóng hoặc chưa | Quét lại; đã đóng thì hiển thị kết quả gốc | Không có |
| Hai quầy cùng trả một cuốn | Chỉ thao tác đầu tiên thành công | Quầy sau thấy trạng thái mới | Không tính phạt hai lần |

### 6.5 Other Edge Cases

- Cuốn đã báo mất được mang trả: xử lý ở `lost-handling` (tìm lại sau khi mất, R1B).
- Sửa sai phạt đã ghi: không sửa trực tiếp, dùng điều chỉnh có quyền và lý do (`fine-collection-adv`).

## 7. Validation, Limits & Wording

### 7.1 Validation rules

| Field | Rule |
|---|---|
| Mã bản sao | Bắt buộc, tìm được đúng một bản sao |
| Tình trạng trả | Bắt buộc: bình thường hoặc hư hỏng |
| Hư hỏng | Mức độ, mô tả và 1–5 ảnh theo `damage-lifecycle` |

### 7.2 Limits & Quotas (exact values)

| Tham số | Giá trị | Window | Behavior khi vượt |
|---|---|---|---|
| Thời hạn mượn | 14 ngày (chốt — DEC-SF-10) | Mỗi phiếu | Trả sau hạn thì ghi phạt quá hạn |

### 7.3 Wording samples (exact strings)

#### Error messages

| Tình huống | Wording | Code |
|---|---|---|
| Không có phiếu đang mở | "Không tìm thấy phiếu mượn đang mở cho cuốn sách này." | E-core-008 |
| Bản sao vừa được xử lý ở quầy khác | "Sách vừa được cập nhật. Vui lòng quét lại để xem trạng thái mới." | E-core-004 |

#### Success messages

| Tình huống | Wording |
|---|---|
| Trả thành công | "Đã nhận trả sách và cập nhật trạng thái bản sao." |

#### Info / neutral messages

| Tình huống | Wording |
|---|---|
| Trả quá hạn | "Sách trả sau hạn. Phạt tạm tính: {số tiền}." (đề xuất) |
| Quét lặp cuốn đã trả | "Cuốn sách này đã được nhận trả trước đó." (đề xuất) |

## 8. Assumptions

- Trả từng cuốn; nhiều cuốn của cùng phiếu trả lần lượt.
- Bản sao trả hư hỏng bị chặn lưu thông ngay, chờ duyệt (mặc định OQ-11 nguồn).

## 9. Risks

| Rủi ro | Khả năng | Hậu quả nghiệp vụ | Cách phòng |
|--------|----------|-------------------|-----------|
| Process: luồng trả dựng lại chưa được duyệt | thỉnh thoảng | Phải sửa luồng sát pilot | Domain approver duyệt DEC-D3-02 trước SRS |
| Data: tính phạt sai trên dữ liệu thật | thỉnh thoảng | Người đọc phàn nàn, phải điều chỉnh | Phạt ghi sổ chỉ thêm, sửa bằng điều chỉnh có audit |

## 10. Success Criteria (preliminary)

- 100% lượt trả quá hạn, hư hỏng, mất đều đóng phiếu và tạo đúng nghĩa vụ.
- 0 lần tính phạt hai lần cho một lượt trả.

## 11. Open Questions

- [ ] OQ-1: Luồng trả dựng lại (DEC-D3-02) và vòng đời bản sao (OQ-core-002) cần domain approver duyệt (hold)
- [ ] OQ-2: Báo cáo hư hỏng chặn lưu thông ngay hay chờ duyệt? (OQ-11 nguồn; hold — mặc định chặn ngay)

## 12. Next Steps

- `/srs return-handling`
