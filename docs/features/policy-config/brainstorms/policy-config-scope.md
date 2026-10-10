---
type: brainstorm
feature: policy-config
status: draft
updated: 2026-10-08
links:
  - docs/_product/prd.md
  - docs/_product/decision-register.md
  - docs/_shared/domain/library-erd.md
  - docs/_shared/id-crosswalk-lmp.md
---

# Cấu hình quy định

## 1. Idea Seed

Quản trị viên cấu hình tham số mượn, gia hạn, giữ chỗ, phạt, chặn mượn và kênh thông báo, có hiệu lực từ một thời điểm, không cần sửa phần mềm; phiếu đã tạo giữ quy định tại thời điểm tạo.

## 2. Context

- Các feature lưu thông (`checkout`, `return-handling`, `renewal`, `reservation`, `overdue-fines`) đọc tham số từ đây.
- Đã chốt 3 giá trị theo DEC-SF-10: tối đa 5 cuốn đang mượn, mượn 14 ngày, nợ từ 50.000đ chặn mượn. Các giá trị còn lại là mặc định của tài liệu nguồn, chưa chốt.
- Một bộ quy định chung cho mọi người đọc; phân loại người đọc là candidate R3.

## 3. User Types (preliminary)

| User Type | Pain Point | Primary Need |
|-----------|-----------|--------------|
| Quản trị viên | Đổi quy định phải chờ sửa phần mềm | Tự đổi tham số, chọn thời điểm hiệu lực |
| Thủ thư trưởng | Không biết quy định đổi khi nào, ai đổi | Lịch sử thay đổi có người và thời điểm |

## 4. Capabilities Breakdown

### P0 — must have

- Xem và sửa danh sách tham số quy định.
- Chọn thời điểm hiệu lực; giao dịch bắt đầu trước thời điểm đó giữ quy định cũ.
- Kiểm tra giá trị trong miền cho phép.
- Audit mỗi thay đổi kèm giá trị trước và sau, người đổi, thời điểm.

### P1 — should have

- Không có.

### P2 — nice to have

- Bộ quy định theo loại người đọc (candidate R3).

## 5. Core Flows (Happy Path)

### 5.1 Đổi tham số

1) Quản trị viên mở cấu hình, chọn tham số.
2) Nhập giá trị mới và thời điểm hiệu lực.
3) Hệ thống kiểm tra miền giá trị, lưu, ghi audit trước/sau.
4) Từ thời điểm hiệu lực, giao dịch mới dùng giá trị mới.

## 6. System Behavior Deep Dive

### 6.1 Decision Points

| ID | Flow | Khi nào | YES (nhánh đồng ý) | NO (nhánh từ chối) |
|---|---|---|---|---|
| D1 | Đổi tham số | Có quyền cấu hình? | Tiếp tục | Từ chối, ghi audit |
| D2 | Đổi tham số | Giá trị trong miền cho phép? | Lưu | Báo lỗi |
| D3 | Áp dụng | Giao dịch bắt đầu sau thời điểm hiệu lực? | Dùng giá trị mới | Dùng giá trị cũ |

### 6.2 Scenario Matrix

Không áp dụng — một vai trò.

### 6.3 State Transitions

Không áp dụng — tham số không có trạng thái, chỉ có lịch sử giá trị theo thời điểm hiệu lực.

### 6.4 Interrupted Transactions

Không áp dụng.

### 6.5 Other Edge Cases

- Hai Quản trị viên cùng sửa một tham số: người lưu sau thấy giá trị mới nhất trước khi lưu.
- Phiếu mượn đã tạo không đổi hạn trả khi đổi thời hạn mượn.

## 7. Validation, Limits & Wording

### 7.1 Validation rules

| Field | Rule |
|---|---|
| Giá trị tham số | Số dương, trong miền cho phép của từng tham số |
| Thời điểm hiệu lực | Không sớm hơn hiện tại |

### 7.2 Limits & Quotas (exact values)

| Tham số | Giá trị | Window | Behavior khi vượt |
|---|---|---|---|
| Sách đang mượn tối đa | 5 bản sao (chốt — DEC-SF-10) | Tại thời điểm xác nhận | Từ chối phần vượt |
| Thời hạn mượn | 14 ngày (chốt — DEC-SF-10) | Mỗi phiếu | Tính quá hạn |
| Ngưỡng nợ chặn mượn | 50.000đ (chốt — DEC-SF-10) | Khi quét thẻ | Chặn mượn |
| Gia hạn | 1 lần, thêm 7 ngày (mặc định nguồn, chưa chốt) | Mỗi phiếu | Từ chối |
| Phạt quá hạn | 2.000đ/ngày, tối đa bằng giá sách (mặc định nguồn, chưa chốt) | Mỗi phiếu | — |
| Bồi thường mất | 100% giá sách + phí xử lý (mặc định nguồn, chưa chốt) | Mỗi bản sao | — |
| Phạt hư hỏng | 0% / 30% / 100% giá sách theo mức nhẹ / vừa / nặng (mặc định nguồn, chưa chốt) | Mỗi báo cáo | — |
| Đặt trước đang mở | 3 yêu cầu (mặc định nguồn, chưa chốt) | Mỗi người đọc | Từ chối |
| Thời gian giữ | 48 giờ (mặc định nguồn, chưa chốt) | Từ lúc sẵn sàng | Chuyển người kế tiếp |

### 7.3 Wording samples (exact strings)

#### Error messages

| Tình huống | Wording | Code |
|---|---|---|
| Giá trị ngoài miền | "Giá trị không hợp lệ cho tham số này." (đề xuất) | E-core-001 |

#### Success messages

| Tình huống | Wording |
|---|---|
| Lưu cấu hình | "Đã lưu. Giá trị mới có hiệu lực từ {thời điểm}." (đề xuất) |

#### Info / neutral messages

| Tình huống | Wording |
|---|---|
| — | — |

## 8. Assumptions

- Một bộ quy định chung, một cơ sở.
- Các giá trị mặc định nguồn được dùng để chạy thử cho tới khi chốt.

## 9. Risks

| Rủi ro | Khả năng | Hậu quả nghiệp vụ | Cách phòng |
|--------|----------|-------------------|-----------|
| Timeline: giá trị phạt, gia hạn, giữ chỗ chốt muộn | thỉnh thoảng | Trễ `overdue-fines`, `renewal`, `reservation` | Chốt ở GATE-DEC trước SRS của các feature đó |
| Process: đổi tham số nhầm giờ cao điểm | hiếm | Quầy áp quy định sai | Thời điểm hiệu lực bắt buộc, có audit |

## 10. Success Criteria (preliminary)

- 100% thay đổi tham số có audit trước/sau.
- 0 phiếu đã tạo bị đổi hạn trả do đổi cấu hình.

## 11. Open Questions

- [ ] OQ-1: Giá trị chính thức của gia hạn, phạt quá hạn, bồi thường mất, phạt hư hỏng, giới hạn đặt trước, thời gian giữ? (OQ-policy-config-001 phần còn lại; hold — Thủ thư trưởng)
- [ ] OQ-2: Miền giá trị cho phép của từng tham số? (hold)

## 12. Next Steps

- `/srs policy-config`
