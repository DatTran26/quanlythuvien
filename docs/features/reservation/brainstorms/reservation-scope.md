---
type: brainstorm
feature: reservation
status: draft
updated: 2026-10-08
links:
  - docs/_product/prd.md
  - docs/_product/decision-register.md
  - docs/_shared/core-spec.md
  - docs/_shared/domain/lifecycle-inventory.md
  - docs/_shared/id-crosswalk-lmp.md
---

# Đặt trước trọn vòng

## 1. Idea Seed

Khi đầu sách hết bản khả dụng, người đọc hoặc Thủ thư đặt trước; hệ thống xếp hàng theo thứ tự thời gian, giữ sách 48 giờ cho người đầu hàng khi có bản về kho, hết hạn thì chuyển người kế tiếp, và người đọc nhận sách qua quầy mượn.

## 2. Context

- Đặt trước có một release duy nhất là R2 (DEC-P2-05). Trước đó luồng trả không phân bổ hàng chờ.
- Bật đặt trước làm đổi hành vi của `return-handling` (điểm quyết định D5), `renewal` (từ chối khi có người chờ) và `damage-lifecycle`.
- Nhận sách đặt trước đi qua `checkout`; thông báo qua `notification-core`.
- Đặt trước online từ cổng người đọc thuộc feature này (DEC-SF-02).

## 3. User Types (preliminary)

| User Type | Pain Point | Primary Need |
|-----------|-----------|--------------|
| Người đọc | Sách hết, phải canh hỏi liên tục | Xếp hàng và được báo khi có sách |
| Thủ thư | Giữ sách tay, nhầm người | Hệ thống giữ đúng người, đúng hạn |

## 4. Capabilities Breakdown

### P0 — must have

- Không có (feature thuộc R2).

### P1 — should have

- Đặt trước chỉ cho đầu sách đang hết bản khả dụng; mỗi người tối đa số đặt trước đang mở theo cấu hình.
- Hàng chờ theo thứ tự thời gian; hiển thị vị trí.
- Bản sao về kho thì giữ cho người đầu hàng, đặt hạn giữ, thông báo sẵn sàng — trong một giao dịch.
- Job mỗi 15 phút: hết hạn giữ thì chuyển người kế tiếp hoặc đưa bản sao về Sẵn sàng.
- Hủy đặt trước khi đang chờ hoặc đang giữ; Thủ thư hủy thay được.
- Nhận sách tại quầy qua `checkout`.
- Chỉ một giao dịch thắng khi có tranh chấp giữ chỗ.

### P2 — nice to have

- Không có. Bỏ lượt, tạm hoãn không làm (DEC-D3-03).

## 5. Core Flows (Happy Path)

### 5.1 Đặt trước và nhận sách

1) Người đọc tìm đầu sách đang hết bản, chọn đặt trước.
2) Hệ thống kiểm tra điều kiện, thêm vào cuối hàng chờ, hiển thị vị trí.
3) Khi một bản sao về kho, hệ thống giữ cho người đầu hàng, đặt hạn 48 giờ, thông báo.
4) Người đọc đến quầy trong hạn; Thủ thư xác nhận và cho mượn.

```
Đặt trước ──> Đầu sách còn bản khả dụng? ──có──> Từ chối, gợi ý mượn trực tiếp
                    │ không
                    ▼
       Đạt điều kiện (dưới giới hạn, chưa đặt trùng, thẻ hợp lệ)? ──không──> Từ chối, nêu lý do
                    │ có
                    ▼
       Vào cuối hàng chờ ──> Có bản về kho ──> Giữ cho người đầu hàng (48 giờ) + thông báo
                                                     │
                       Đến nhận trong hạn? ──có──> Mượn qua quầy
                                │ không
                                ▼
                       Hết hạn ──> Còn người chờ? ──có──> Giữ cho người kế tiếp
                                         │ không
                                         ▼
                                   Bản sao Sẵn sàng
```

## 6. System Behavior Deep Dive

### 6.1 Decision Points

| ID | Flow | Khi nào | YES (nhánh đồng ý) | NO (nhánh từ chối) |
|---|---|---|---|---|
| D1 | Đặt trước | Đầu sách còn bản khả dụng? | Từ chối, gợi ý mượn | Tiếp tục |
| D2 | Đặt trước | Người đọc đạt điều kiện? | Vào hàng chờ | Từ chối |
| D3 | Có bản về kho | Hàng chờ còn người? | Giữ cho người đầu hàng | Bản sao Sẵn sàng |
| D4 | Nhận sách | Còn trong hạn giữ? | Cho mượn | Báo hết hạn |
| D5 | Hết hạn giữ | Còn người chờ? | Giữ cho người kế tiếp | Bản sao Sẵn sàng |

### 6.2 Scenario Matrix

| From State | To State | Rule | Action | Result |
|------------|----------|------|--------|--------|
| Đang chờ | Đã hủy | Người đọc hoặc Thủ thư hủy | Hủy | Rời hàng chờ |
| Sẵn sàng nhận | Hoàn tất | Đến nhận trong hạn | Mượn | Phiếu mượn được tạo |
| Sẵn sàng nhận | Hết hạn | Quá hạn giữ | Job 15 phút | Chuyển người kế tiếp |
| Sẵn sàng nhận | Đã hủy | Hủy khi đang giữ | Hủy | Giải phóng bản sao |
| Hoàn tất / Hết hạn / Đã hủy | — | Trạng thái cuối | Hủy | Từ chối |

### 6.3 State Transitions

| Entity | Từ | Sang | Trigger | Quay lại được? |
|--------|------|----|---------|-------------|
| Đặt trước | — | Đang chờ | Tạo đặt trước | — |
| Đặt trước | Đang chờ | Sẵn sàng nhận | Có bản về kho, đến lượt | Có, khi bản giữ bị báo hư hỏng (DEC-D3-06) |
| Đặt trước | Sẵn sàng nhận | Hoàn tất | Mượn thành công | Không |
| Đặt trước | Sẵn sàng nhận | Hết hạn | Quá 48 giờ | Không |
| Đặt trước | Đang chờ / Sẵn sàng nhận | Đã hủy | Hủy | Không |
| Bản sao | Sẵn sàng / Đang mượn | Đang giữ | Giữ cho người đầu hàng | Có |

### 6.4 Interrupted Transactions

| Tình huống | Hệ thống còn lại gì | Resume | Cleanup |
|---|---|---|---|
| Gửi thông báo sẵn sàng lỗi | Đặt trước vẫn Sẵn sàng nhận, hạn giữ vẫn chạy | Thông báo thử lại | Không hủy giữ chỗ |
| Hết hạn đúng lúc đang xác nhận nhận sách | Chỉ một thao tác thắng | Tải lại trạng thái | Không giữ hai lần |
| Hủy đua với giữ chỗ | Thao tác đầu thắng | Tải lại | Không có |

### 6.5 Other Edge Cases

- Đến nhận khi đặt trước đã hết hạn hoặc bị hủy: báo trạng thái, cho đặt lại cuối hàng.
- Bản giữ bị báo hư hỏng: đặt trước quay về Đang chờ và giữ vị trí.

## 7. Validation, Limits & Wording

### 7.1 Validation rules

| Field | Rule |
|---|---|
| Đầu sách | Đang hết bản khả dụng |
| Người đọc | Đủ điều kiện; chưa có đặt trước mở cho cùng đầu sách |

### 7.2 Limits & Quotas (exact values)

| Tham số | Giá trị | Window | Behavior khi vượt |
|---|---|---|---|
| Đặt trước đang mở | 3 yêu cầu (mặc định nguồn, chưa chốt) | Mỗi người đọc | Từ chối |
| Thời gian giữ | 48 giờ (mặc định nguồn, chưa chốt) | Từ lúc sẵn sàng | Chuyển người kế tiếp |
| Job hết hạn giữ | Mỗi 15 phút | — | — |

### 7.3 Wording samples (exact strings)

#### Error messages

| Tình huống | Wording | Code |
|---|---|---|
| Đầu sách còn bản | "Sách này vẫn còn bản để mượn. Vui lòng mượn trực tiếp tại quầy." (đề xuất) | E-reservation-001 |
| Vượt giới hạn đặt trước | "Bạn đã có đủ 3 đặt trước đang mở." (đề xuất) | E-reservation-001 |
| Đặt trước đã hết hạn | "Đặt trước này đã hết hạn giữ." (đề xuất) | E-reservation-001 |

#### Success messages

| Tình huống | Wording |
|---|---|
| Đặt trước thành công | "Đã đặt trước. Vị trí của bạn trong hàng chờ: {N}." (đề xuất) |

#### Info / neutral messages

| Tình huống | Wording |
|---|---|
| Sách được giữ | "Sách đã sẵn sàng. Vui lòng đến nhận trong vòng 48 giờ." |

## 8. Assumptions

- Hàng chờ theo đầu sách, không theo bản sao cụ thể.
- Không có thời gian ân hạn khi đến nhận sát hạn cho tới khi chốt.

## 9. Risks

| Rủi ro | Khả năng | Hậu quả nghiệp vụ | Cách phòng |
|--------|----------|-------------------|-----------|
| Process: bật D5 làm đổi luồng trả đang chạy | thỉnh thoảng | Quầy bỡ ngỡ, giữ nhầm | Bật sau feature flag, kiểm thử hồi quy luồng trả |
| Adoption: người đọc không đến nhận | thường | Sách nằm giữ vô ích | Hết hạn tự động sau 48 giờ |

## 10. Success Criteria (preliminary)

- Tỷ lệ đặt trước được phục vụ trong 48 giờ (đo trên pilot).
- 0 bản sao kẹt Đang giữ quá hạn.

## 11. Open Questions

- [ ] OQ-1: Đặt trước thuộc R2 đã chốt PROPOSAL theo DEC-P2-05, cần Product Owner duyệt (OQ-reservation-001; hold)
- [ ] OQ-2: Giới hạn đặt trước và thời gian giữ chính thức? (OQ-policy-config-001; hold — Thủ thư trưởng)
- [ ] OQ-3: Có thời gian ân hạn khi đến nhận sát hạn? (hold)

## 12. Next Steps

- `/srs reservation`
