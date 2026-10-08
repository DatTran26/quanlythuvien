---
type: brainstorm
feature: damage-lifecycle
status: draft
updated: 2026-10-08
links:
  - docs/_product/prd.md
  - docs/_shared/core-spec.md
  - docs/_shared/domain/lifecycle-inventory.md
  - docs/_shared/id-crosswalk-lmp.md
---

# Báo cáo hư hỏng và duyệt

## 1. Idea Seed

Thủ thư báo hư hỏng kèm 1–5 ảnh, bản sao chuyển Chờ duyệt ngay; Quản trị viên xem bằng chứng và quyết định Bác bỏ, Sửa hoặc Thanh lý để bản sao không kẹt trạng thái.

## 2. Context

- Hư hỏng được phát hiện lúc trả (`return-handling`) hoặc ngoài luồng trả khi kiểm kho.
- Disposition tối thiểu (Bác bỏ, Sửa, Thanh lý) nâng lên R1A để bản sao không kẹt Chờ duyệt (DEC-P2-03).
- Phạt hư hỏng ghi vào sổ phạt chung (`overdue-fines`); đặt trước bị ảnh hưởng bởi hư hỏng chỉ có từ R2.

## 3. User Types (preliminary)

| User Type | Pain Point | Primary Need |
|-----------|-----------|--------------|
| Thủ thư | Không có cách ghi nhận hư hỏng có bằng chứng | Báo cáo nhanh kèm ảnh |
| Quản trị viên | Sách hỏng nằm mãi không ai xử lý | Danh sách chờ duyệt, quyết định một lần |
| Người đọc | Bị phạt hư hỏng mà không có bằng chứng | Báo cáo có ảnh và mức độ rõ ràng |

## 4. Capabilities Breakdown

### P0 — must have

- Báo cáo hư hỏng: quét bản sao, chọn mức độ (Nhẹ, Vừa, Nặng), mô tả, 1–5 ảnh.
- Kiểm tra ảnh trước khi lưu: loại file, kích thước sau nén, quét nội dung, không tin metadata gốc.
- Bản sao chuyển Chờ duyệt ngay khi báo; ghi audit, thông báo cho Quản trị viên.
- Quản trị viên xem báo cáo, chọn Bác bỏ, Sửa hoặc Thanh lý.
- Sửa xong: xác nhận hoàn tất, cập nhật tình trạng, bản sao về Sẵn sàng.
- Báo cáo đã quyết định không mở lại; một bản sao chỉ có một báo cáo đang chờ.

### P1 — should have

- Không có.

### P2 — nice to have

- Không có.

## 5. Core Flows (Happy Path)

### 5.1 Báo cáo và duyệt hư hỏng

1) Thủ thư quét bản sao, chọn mức độ, mô tả, chụp 1–5 ảnh.
2) Hệ thống kiểm tra ảnh, tạo báo cáo, chuyển bản sao Chờ duyệt, ghi audit, thông báo Quản trị viên.
3) Quản trị viên mở báo cáo, xem ảnh, chọn hướng xử lý.
4) Hệ thống chuyển bản sao theo quyết định, ghi audit.

```
Quét bản sao ──> Đã có báo cáo đang chờ? ──có──> Mở báo cáo hiện có
                        │ không
                        ▼
        Đủ mức độ + mô tả + 1–5 ảnh hợp lệ? ──không──> Báo lỗi, giữ dữ liệu
                        │ có
                        ▼
        Tạo báo cáo + bản sao Chờ duyệt + audit + thông báo Quản trị viên
                        │
                        ▼
        Quản trị viên quyết định ──Bác bỏ──> Bản sao Sẵn sàng
                        ├──Sửa──> Bản sao Đang sửa ──sửa xong──> Sẵn sàng
                        └──Thanh lý──> Bản sao Thanh lý (trạng thái cuối)
```

## 6. System Behavior Deep Dive

### 6.1 Decision Points

| ID | Flow | Khi nào | YES (nhánh đồng ý) | NO (nhánh từ chối) |
|---|---|---|---|---|
| D1 | Báo cáo | Bản sao đã có báo cáo đang chờ? | Mở báo cáo hiện có | Tạo báo cáo |
| D2 | Báo cáo | Đủ thông tin và ảnh hợp lệ? | Lưu | Báo lỗi |
| D3 | Duyệt | Báo cáo còn đang chờ? | Cho quyết định | Từ chối, báo cáo đã có quyết định |
| D4 | Duyệt | Quyết định là gì? | Bác bỏ / Sửa / Thanh lý | — |

### 6.2 Scenario Matrix

| From State | To State | Rule | Action | Result |
|------------|----------|------|--------|--------|
| Chờ duyệt | Sẵn sàng | Bác bỏ | Duyệt | Báo cáo đóng |
| Chờ duyệt | Đang sửa | Sửa | Duyệt | Theo dõi sửa |
| Chờ duyệt | Thanh lý | Thanh lý | Duyệt, xác thực lại | Bản sao ra khỏi lưu thông vĩnh viễn |
| Đang sửa | Sẵn sàng | Sửa xong | Xác nhận | Bản sao về kho |
| Đang sửa | Thanh lý | Sửa không thành | Quyết định | Thanh lý (DEC-D3-07) |

### 6.3 State Transitions

| Entity | Từ | Sang | Trigger | Quay lại được? |
|--------|------|----|---------|-------------|
| Báo cáo hư hỏng | — | Chờ duyệt | Gửi báo cáo | — |
| Báo cáo hư hỏng | Chờ duyệt | Bác bỏ / Sửa / Thanh lý | Quản trị viên quyết định | Không |
| Bản sao | Sẵn sàng / Đang mượn | Chờ duyệt | Gửi báo cáo | Có, qua quyết định |
| Bản sao | Chờ duyệt | Sẵn sàng / Đang sửa / Thanh lý | Quyết định | Thanh lý là trạng thái cuối |

### 6.4 Interrupted Transactions

| Tình huống | Hệ thống còn lại gì | Resume | Cleanup |
|---|---|---|---|
| Tải ảnh lỗi | Chưa có báo cáo | Chọn ảnh khác | Không lưu file lỗi |
| Hai người cùng duyệt một báo cáo | Chỉ quyết định đầu tiên được ghi | Người sau thấy quyết định đã có | Không có |

### 6.5 Other Edge Cases

- Bản sao đang giữ cho đặt trước bị báo hư hỏng: đặt trước quay lại chờ và giữ vị trí (từ R2, DEC-D3-06).
- Thanh lý không xóa khoản phạt hư hỏng đã ghi.

## 7. Validation, Limits & Wording

### 7.1 Validation rules

| Field | Rule |
|---|---|
| Mức độ | Bắt buộc: Nhẹ, Vừa, Nặng |
| Mô tả | Bắt buộc |
| Ảnh | 1–5 ảnh; mỗi ảnh sau nén không quá 500 KB; đúng loại ảnh |

### 7.2 Limits & Quotas (exact values)

| Tham số | Giá trị | Window | Behavior khi vượt |
|---|---|---|---|
| Số ảnh | 1–5 | Mỗi báo cáo | Không cho gửi ngoài giới hạn |
| Dung lượng ảnh | ≤ 500 KB sau nén | Mỗi ảnh | Từ chối ảnh |
| Phạt hư hỏng | 0% / 30% / 100% giá sách theo Nhẹ / Vừa / Nặng (mặc định nguồn, chưa chốt) | Mỗi báo cáo gắn phiếu mượn | — |

### 7.3 Wording samples (exact strings)

#### Error messages

| Tình huống | Wording | Code |
|---|---|---|
| Ảnh bị từ chối | "Ảnh không hợp lệ hoặc vượt dung lượng. Vui lòng chọn ảnh khác." (đề xuất) | E-damage-lifecycle-001 |
| Báo cáo đã có quyết định | "Báo cáo này đã được xử lý." (đề xuất) | E-core-008 |

#### Success messages

| Tình huống | Wording |
|---|---|
| Gửi báo cáo | "Đã gửi báo cáo hư hỏng." (đề xuất) |

#### Info / neutral messages

| Tình huống | Wording |
|---|---|
| Hư hỏng chờ duyệt | "Bản sao đã được tạm ngừng lưu thông và đang chờ quản trị viên xử lý." |

## 8. Assumptions

- Bản sao bị chặn lưu thông ngay khi báo hư hỏng (mặc định OQ-11 nguồn).
- Thanh lý là tác vụ nhạy cảm, cần xác thực lại.

## 9. Risks

| Rủi ro | Khả năng | Hậu quả nghiệp vụ | Cách phòng |
|--------|----------|-------------------|-----------|
| Process: Quản trị viên chậm duyệt | thỉnh thoảng | Giảm số sách khả dụng | Theo dõi tuổi báo cáo chờ duyệt |
| Compliance: ảnh lưu lâu không có chính sách | hiếm | Lưu dữ liệu không cần thiết | Chờ chính sách lưu giữ |

## 10. Success Criteria (preliminary)

- 0 bản sao kẹt trạng thái tạm không có owner.
- 100% báo cáo có 1–5 ảnh hợp lệ.

## 11. Open Questions

- [ ] OQ-1: Ảnh lưu theo từng báo cáo hay quản lý như tệp đính kèm riêng, lưu giữ bao lâu? (OQ-damage-lifecycle-001; hold — domain/tech)
- [ ] OQ-2: Mức phạt hư hỏng chính thức? (OQ-policy-config-001; hold — Thủ thư trưởng)
- [ ] OQ-3: Duyệt bản sao đang giữ bị hư hỏng và thanh lý trực tiếp (DEC-D3-06, DEC-D3-07; hold — domain approver)

## 12. Next Steps

- `/srs damage-lifecycle`
