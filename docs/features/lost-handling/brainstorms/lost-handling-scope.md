---
type: brainstorm
feature: lost-handling
status: draft
updated: 2026-10-12
links:
  - docs/_product/prd.md
  - docs/_product/decision-register.md
  - docs/_shared/domain/lifecycle-inventory.md
  - docs/_shared/id-crosswalk-lmp.md
---

# Ghi nhận mất và tìm lại

## 1. Idea Seed

Khi người đọc làm mất sách, Nhân viên ghi nhận mất: phiếu mượn đóng ở trạng thái Mất, bản sao chuyển Mất, hệ thống ghi nghĩa vụ bồi thường. Nếu sau đó tìm lại sách, nghĩa vụ đã ghi được đối soát trước khi bản sao quay về kho.

## 2. Context

- Phiếu mượn phải luôn có đường kết thúc, kể cả khi mất sách; vì vậy ghi nhận mất tối thiểu nằm ở R1A (DEC-P2-07, DEC-SF-06).
- Tìm lại sau khi mất chạm tới hoàn hoặc đảo nghĩa vụ tài chính, cần chính sách tài chính, nên để R1B (DEC-D3-05).
- Bồi thường ghi vào sổ phạt chung; hoàn tiền thuộc `fine-collection-adv`.

## 3. User Types (preliminary)

| User Type | Pain Point | Primary Need |
|-----------|-----------|--------------|
| Nhân viên | Phiếu mượn sách mất treo mãi | Đóng phiếu ở trạng thái Mất, có nghĩa vụ bồi thường |
| Người đọc | Tìm lại sách nhưng vẫn bị ghi nợ | Đối soát nghĩa vụ khi tìm lại |

## 4. Capabilities Breakdown

### P0 — must have

- Ghi nhận mất: trong một giao dịch, phiếu mượn sang Mất, bản sao sang Mất, ghi nghĩa vụ bồi thường, audit, thông báo người đọc.
- Phiếu đã Mất không mở lại; ghi nhận mất lặp trả kết quả gốc.

### P1 — should have

- Tìm lại sau khi mất (R1B): kiểm tra vật lý, đối soát nghĩa vụ đã ghi (không tự xóa), rồi mới đưa bản sao về Sẵn sàng.
- Chưa có duyệt tài chính thì chỉ ghi "đã tìm thấy — chờ đối soát", bản sao giữ trạng thái Mất.

### P2 — nice to have

- Không có.

## 5. Core Flows (Happy Path)

### 5.1 Ghi nhận mất (R1A)

1) Nhân viên xác nhận với người đọc, mở phiếu đang mượn, chọn ghi nhận mất.
2) Hệ thống đóng phiếu ở trạng thái Mất, chuyển bản sao sang Mất, ghi bồi thường, audit, thông báo.

### 5.2 Tìm lại sau khi mất (R1B)

1) Nhân viên kiểm tra bản sao tìm lại, xác nhận đã tìm thấy.
2) Có duyệt tài chính: đối soát nghĩa vụ (đảo nếu chưa thu, hoàn nếu đã thu theo chính sách), bản sao về Sẵn sàng.
3) Chưa có duyệt: ghi "đã tìm thấy — chờ đối soát", bản sao vẫn Mất.

```
Ghi nhận mất ──> Phiếu còn mở? ──không (đã Mất)──> Trả kết quả gốc
                       │ có
                       ▼
        Phiếu Mất + bản sao Mất + bồi thường + audit + thông báo

Tìm lại (R1B) ──> Kiểm tra vật lý đạt? ──không──> Giữ bản sao Mất
                       │ có
                       ▼
        Có duyệt tài chính? ──không──> "Đã tìm thấy — chờ đối soát"
                       │ có
                       ▼
        Đối soát nghĩa vụ + bản sao Sẵn sàng (hoặc Đang giữ nếu có hàng chờ, từ R2) + audit
```

## 6. System Behavior Deep Dive

### 6.1 Decision Points

| ID | Flow | Khi nào | YES (nhánh đồng ý) | NO (nhánh từ chối) |
|---|---|---|---|---|
| D1 | Ghi nhận mất | Phiếu còn mở? | Ghi nhận mất | Trả kết quả gốc |
| D2 | Tìm lại | Kiểm tra vật lý đạt? | Tiếp tục | Giữ Mất |
| D3 | Tìm lại | Có duyệt tài chính? | Đối soát, đưa về kho | Ghi chờ đối soát |
| D4 | Tìm lại | Nghĩa vụ đã thu tiền? | Hoàn theo chính sách | Đảo nghĩa vụ về 0 |

### 6.2 Scenario Matrix

| From State | To State | Rule | Action | Result |
|------------|----------|------|--------|--------|
| Phiếu Đang mở / Quá hạn | Mất | Ghi nhận mất | Xác nhận | Bồi thường được ghi |
| Bản sao Mất, nghĩa vụ chưa thu | Sẵn sàng | Tìm lại, có duyệt | Xác nhận | Đảo nghĩa vụ |
| Bản sao Mất, nghĩa vụ đã thu | Sẵn sàng | Tìm lại, có duyệt | Xác nhận | Hoàn theo chính sách |
| Bản sao Mất | Mất | Tìm lại, chưa có duyệt | Xác nhận | Chờ đối soát |

### 6.3 State Transitions

| Entity | Từ | Sang | Trigger | Quay lại được? |
|--------|------|----|---------|-------------|
| Phiếu mượn | Đang mở / Quá hạn | Mất | Ghi nhận mất | Không |
| Bản sao | Đang mượn | Mất | Ghi nhận mất | Có, qua tìm lại (R1B) |
| Bản sao | Mất | Sẵn sàng | Tìm lại, đối soát xong | — |

### 6.4 Interrupted Transactions

| Tình huống | Hệ thống còn lại gì | Resume | Cleanup |
|---|---|---|---|
| Ghi nhận mất lặp | Một lần ghi | Trả kết quả gốc | Không có |
| Mất kết nối sau xác nhận | Đã ghi hoặc chưa | Mở lại phiếu để xem | Không có |

### 6.5 Other Edge Cases

- Tìm lại không mở lại phiếu đã Mất; nghĩa vụ mới (nếu có) mở khoản phạt mới.

## 7. Validation, Limits & Wording

### 7.1 Validation rules

| Field | Rule |
|---|---|
| Ghi nhận mất | Chỉ trên phiếu đang mở |

### 7.2 Limits & Quotas (exact values)

| Tham số | Giá trị | Window | Behavior khi vượt |
|---|---|---|---|
| Bồi thường mất | 100% giá sách + phí xử lý (mặc định nguồn, chưa chốt) | Mỗi bản sao | — |

### 7.3 Wording samples (exact strings)

#### Error messages

| Tình huống | Wording | Code |
|---|---|---|
| — | — | — |

#### Success messages

| Tình huống | Wording |
|---|---|
| Ghi nhận mất | "Đã ghi nhận mất sách và tạo khoản bồi thường." (đề xuất) |

#### Info / neutral messages

| Tình huống | Wording |
|---|---|
| Ghi nhận lặp | "Sách này đã được ghi nhận mất trước đó." (đề xuất) |
| Tìm lại chưa đối soát | "Đã ghi nhận tìm thấy. Bản sao chờ đối soát nghĩa vụ trước khi về kho." (đề xuất) |

## 8. Assumptions

- Ghi nhận mất chỉ thực hiện trên phiếu đang mở (sách đang mượn).
- Mất sách ngoài lúc đang mượn (mất khỏi kệ) không thuộc feature này.

## 9. Risks

| Rủi ro | Khả năng | Hậu quả nghiệp vụ | Cách phòng |
|--------|----------|-------------------|-----------|
| Compliance: chính sách bồi thường và hoàn tiền chưa duyệt | thỉnh thoảng | Không đưa được sách tìm lại về kho | Duyệt DEC-D3-05 trước R1B |
| Process: ghi nhận mất nhầm | hiếm | Người đọc bị ghi nợ oan | Xác nhận với người đọc trước khi ghi |

## 10. Success Criteria (preliminary)

- 100% phiếu sách mất có đường kết thúc.
- Không nghĩa vụ nào bị xóa khi tìm lại sách.

## 11. Open Questions

- [ ] OQ-1: Mức bồi thường mất và phí xử lý chính thức? (OQ-policy-config-001; hold — Thủ thư trưởng)
- [ ] OQ-2: Chính sách đảo/hoàn khi tìm lại sau khi mất (DEC-D3-05, OQ-fine-collection-adv-001; hold — finance)
- [ ] OQ-3: Mất sách khỏi kệ (không đang mượn) xử lý ở đâu? (hold)

## 12. Next Steps

- `/srs lost-handling`
