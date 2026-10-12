---
type: brainstorm
feature: reader-self-service
status: draft
updated: 2026-10-12
links:
  - docs/_product/prd.md
  - docs/_product/decision-register.md
  - docs/_shared/core-spec.md
  - docs/_shared/id-crosswalk-lmp.md
---

# Tự phục vụ người đọc

## 1. Idea Seed

Người đọc tự đăng nhập để tra cứu sách, mở thẻ QR cho Nhân viên quét, xem các sách đang mượn với hạn trả và lịch sử mượn; từ R1B xem được công nợ của mình.

## 2. Context

- Roadmap đưa phần tra cứu, thẻ QR, đang mượn, lịch sử vào R1A (FR-R02..R05 nguồn, P0); xem công nợ ở R1B (FR-R09) — DEC-SF-02.
- SRS cũ thiếu các yêu cầu thẻ QR, đang mượn, lịch sử; feature này viết mới từ tài liệu nguồn.
- Gia hạn online thuộc `renewal`; đặt trước online thuộc `reservation`; thanh toán online là candidate R3.
- Người đọc chỉ xem dữ liệu của chính mình.

## 3. User Types (preliminary)

| User Type | Pain Point | Primary Need |
|-----------|-----------|--------------|
| Người đọc | Phải ra quầy hỏi còn sách không, đang mượn gì, hạn khi nào | Tự xem trên điện thoại |
| Nhân viên | Mất thời gian trả lời câu hỏi tra cứu | Người đọc tự tra |

## 4. Capabilities Breakdown

### P0 — must have

- Tra cứu sách theo tên, tác giả, ISBN, thể loại; lọc còn/hết; xem số lượng khả dụng và vị trí kệ.
- Thẻ thư viện QR: hiển thị mã QR cá nhân để Nhân viên quét khi mượn, trả.
- Sách đang mượn: danh sách phiếu đang mở, hạn trả, số ngày còn lại hoặc đã quá hạn.
- Lịch sử mượn: các phiếu đã đóng, lọc theo thời gian.
- Chỉ xem dữ liệu của chính mình.

### P1 — should have

- Xem công nợ (R1B): các khoản phạt quá hạn, hư hỏng, mất; trạng thái đã hoặc chưa thanh toán.

### P2 — nice to have

- Không có.

## 5. Core Flows (Happy Path)

### 5.1 Tra cứu sách

1) Người đọc đăng nhập, mở tra cứu.
2) Nhập từ khóa hoặc lọc; hệ thống hiện đầu sách, số bản khả dụng và vị trí kệ.

### 5.2 Mở thẻ QR và xem sách đang mượn

1) Người đọc mở thẻ QR, đưa Nhân viên quét.
2) Người đọc mở "Sách đang mượn" xem hạn trả từng cuốn.

### 5.3 Xem lịch sử và công nợ

1) Người đọc mở lịch sử mượn, lọc theo thời gian.
2) (R1B) Người đọc mở công nợ, xem từng khoản và trạng thái.

## 6. System Behavior Deep Dive

### 6.1 Decision Points

| ID | Flow | Khi nào | YES (nhánh đồng ý) | NO (nhánh từ chối) |
|---|---|---|---|---|
| D1 | Mọi màn | Đăng nhập là người đọc đang hoạt động? | Hiện dữ liệu của chính mình | Chuyển màn đăng nhập |
| D2 | Thẻ QR | Tài khoản đã kích hoạt và thẻ còn hạn? | Hiện mã QR | Báo thẻ chưa dùng được |
| D3 | Tra cứu | Có kết quả? | Hiện danh sách | Báo không tìm thấy |

### 6.2 Scenario Matrix

| From State | To State | Rule | Action | Result |
|------------|----------|------|--------|--------|
| Người đọc đang hoạt động | — | Dữ liệu của chính mình | Xem | Hiện |
| Người đọc bị khóa | — | Vẫn đăng nhập được? | Xem | Còn mở (OQ-3) |
| Người đọc | Dữ liệu người khác | Không có quyền | Xem | Từ chối |

### 6.3 State Transitions

Không áp dụng — feature chỉ đọc.

### 6.4 Interrupted Transactions

Không áp dụng — feature chỉ đọc.

### 6.5 Other Edge Cases

- Thẻ hết hạn: không hiện mã QR dùng được, hướng dẫn đến quầy gia hạn thẻ.
- Không có sách đang mượn: hiện trạng thái trống.

## 7. Validation, Limits & Wording

### 7.1 Validation rules

| Field | Rule |
|---|---|
| Từ khóa tra cứu | Không bắt buộc; lọc theo tên, tác giả, ISBN, thể loại |
| Khoảng thời gian lịch sử | Ngày bắt đầu không sau ngày kết thúc |

### 7.2 Limits & Quotas (exact values)

| Tham số | Giá trị | Window | Behavior khi vượt |
|---|---|---|---|
| Thời gian tra cứu | Dưới 2 giây | Ở quy mô 50.000 bản sao | — |

### 7.3 Wording samples (exact strings)

#### Error messages

| Tình huống | Wording | Code |
|---|---|---|
| Thẻ chưa dùng được | "Thẻ thư viện chưa được kích hoạt hoặc đã hết hạn. Vui lòng liên hệ quầy." (đề xuất) | E-core-008 |

#### Success messages

| Tình huống | Wording |
|---|---|
| — | — |

#### Info / neutral messages

| Tình huống | Wording |
|---|---|
| Không có sách đang mượn | "Bạn không có sách nào đang mượn." (đề xuất) |
| Quá hạn | "Quá hạn {N} ngày." (đề xuất) |

## 8. Assumptions

- Cổng người đọc chạy trên web responsive, khung thiết kế Mobile 375.
- Người đọc bị khóa vẫn xem được dữ liệu của mình nhưng không mượn được.

## 9. Risks

| Rủi ro | Khả năng | Hậu quả nghiệp vụ | Cách phòng |
|--------|----------|-------------------|-----------|
| Adoption: người đọc không dùng cổng | thỉnh thoảng | Quầy vẫn quá tải câu hỏi | Hướng dẫn khi cấp thẻ |
| Compliance: lộ lịch sử mượn | hiếm | Vi phạm quyền riêng tư | Chỉ xem dữ liệu của chính mình |

## 10. Success Criteria (preliminary)

- Chưa có — định nghĩa khi viết SRS.

## 11. Open Questions

- [ ] OQ-1: Thiết bị và hình thức cổng người đọc (mobile-first hay responsive)? (OQ-reader-self-service-001; hold — Product Owner)
- [ ] OQ-2: Màn công nợ R1B làm tối thiểu hay chờ cổng đầy đủ? (OQ-reader-self-service-002; đã chốt phần R1B theo DEC-SF-02, còn mức độ màn — hold)
- [ ] OQ-3: Người đọc bị khóa có đăng nhập cổng được không? (hold)
- [ ] OQ-4: Ai được xem lịch sử mượn, có tự xóa lịch sử sau N năm? (OQ-12 nguồn; hold — pháp chế)

## 12. Next Steps

- `/srs reader-self-service`
