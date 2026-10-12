---
type: brainstorm
feature: catalog-admin
status: draft
updated: 2026-10-12
links:
  - docs/_product/prd.md
  - docs/_shared/core-spec.md
  - docs/_shared/domain/library-erd.md
  - docs/_shared/id-crosswalk-lmp.md
---

# Danh mục và đầu sách

## 1. Idea Seed

Thủ thư quản lý đầu sách và danh mục (thể loại, tác giả, nhà xuất bản, vị trí kệ); Nhân viên và Thủ thư tra cứu đầu sách cùng số bản đang khả dụng, đang giữ, đang mượn, không khả dụng.

## 2. Context

- Mọi giao dịch mượn, trả, đặt trước đều cần đầu sách chuẩn. Đầu sách là cha của các bản sao (`copy-inventory`).
- Phần lớn đầu sách đi vào hệ thống qua import Excel (`data-import`); feature này lo tạo, sửa, vô hiệu từng bản ghi và tra cứu.
- Tra cứu phía người đọc thuộc `reader-self-service` (DEC-SF-07). Số bản khả dụng chỉ có ý nghĩa đầy đủ khi lưu thông chạy từ R1A.
- Số lượng khả dụng luôn tính từ trạng thái các bản sao, không nhập tay (SRC-BR11 nguồn).

## 3. User Types (preliminary)

| User Type | Pain Point | Primary Need |
|-----------|-----------|--------------|
| Thủ thư | Đầu sách trùng, thiếu thông tin | Tạo, sửa đầu sách với kiểm tra trùng |
| Nhân viên | Không biết còn bản nào để mượn | Tra cứu nhanh số bản theo trạng thái |

## 4. Capabilities Breakdown

### P0 — must have

- Tạo, sửa, ẩn (vô hiệu hóa) đầu sách: tiêu đề, tác giả, thể loại, nhà xuất bản, năm, ISBN, mô tả, ảnh bìa.
- Quản lý danh mục: thể loại, tác giả, nhà xuất bản, vị trí kệ.
- Kiểm trùng đầu sách khi lưu.
- Tra cứu đầu sách theo tên, tác giả, ISBN, thể loại; lọc còn hoặc hết.
- Xem số bản theo nhóm trạng thái: khả dụng, đang giữ, đang mượn, không khả dụng.
- Không xóa cứng đầu sách hoặc danh mục đã có lịch sử nghiệp vụ.
- Hai người cùng sửa một đầu sách: không ghi đè im lặng.
- Audit mọi thay đổi.

### P1 — should have

- Không có.

### P2 — nice to have

- Không có.

## 5. Core Flows (Happy Path)

### 5.1 Tạo hoặc sửa đầu sách

1) Thủ thư mở tra cứu, chọn tạo mới hoặc mở một đầu sách.
2) Nhập hoặc sửa thông tin; hệ thống kiểm tra trường bắt buộc và kiểm trùng.
3) Lưu; hệ thống ghi audit, đầu sách xuất hiện trong tra cứu.

### 5.2 Tra cứu khả dụng

1) Nhân viên tìm theo tên, tác giả, ISBN hoặc thể loại.
2) Mở chi tiết đầu sách; hệ thống hiện số bản theo nhóm trạng thái và vị trí kệ.

### 5.3 Vô hiệu đầu sách

1) Thủ thư chọn vô hiệu hóa.
2) Hệ thống chặn nếu còn bản sao đang mượn hoặc đang giữ; đầu sách đã có lịch sử chỉ được vô hiệu, không xóa.

```
Lưu đầu sách ──> Có quyền? ──không──> Từ chối, ghi audit
                     │ có
                     ▼
         Đủ trường, đúng định dạng? ──không──> Báo lỗi tại trường
                     │ có
                     ▼
         Trùng đầu sách? ──có──> Báo trùng, mở bản ghi hiện có
                     │ không
                     ▼
         Có người sửa trước? ──có──> Báo xung đột, hiện bản mới nhất
                     │ không
                     ▼
         Lưu + audit
```

## 6. System Behavior Deep Dive

### 6.1 Decision Points

| ID | Flow | Khi nào | YES (nhánh đồng ý) | NO (nhánh từ chối) |
|---|---|---|---|---|
| D1 | Tạo/sửa | Có quyền quản trị danh mục? | Tiếp tục | Từ chối, chỉ cho xem |
| D2 | Tạo/sửa | Đủ trường bắt buộc, đúng định dạng? | Kiểm trùng | Báo lỗi tại trường |
| D3 | Tạo/sửa | Trùng đầu sách? | Báo trùng, mở bản hiện có | Lưu |
| D4 | Sửa | Bản ghi đã bị sửa sau khi mở? | Báo xung đột | Lưu |
| D5 | Vô hiệu | Còn bản sao đang mượn hoặc đang giữ? | Chặn | Vô hiệu |

### 6.2 Scenario Matrix

| From State | To State | Rule | Action | Result |
|------------|----------|------|--------|--------|
| Thủ thư | Đầu sách, danh mục | Có quyền | Tạo, sửa, vô hiệu | Thực hiện |
| Nhân viên | Đầu sách, danh mục | Chỉ xem | Tra cứu | Thực hiện |
| Nhân viên | Tạo, sửa đầu sách | Không có quyền | Lưu | Từ chối |

### 6.3 State Transitions

| Entity | Từ | Sang | Trigger | Quay lại được? |
|--------|------|----|---------|-------------|
| Đầu sách | Đang dùng | Vô hiệu | Thủ thư vô hiệu | TBD |

### 6.4 Interrupted Transactions

Không áp dụng — thao tác ghi đơn lẻ, mất kết nối trước khi lưu thì không có dữ liệu ghi.

### 6.5 Other Edge Cases

- Đầu sách vô hiệu không xuất hiện trong tra cứu và lựa chọn mới, nhưng lịch sử cũ vẫn đọc được.
- Sách chỉ đọc tại chỗ được đánh dấu ở đầu sách; bản sao có thể ghi đè (DEC-D3-09).

## 7. Validation, Limits & Wording

### 7.1 Validation rules

| Field | Rule |
|---|---|
| Tiêu đề | Bắt buộc |
| Tác giả, thể loại | Chọn từ danh mục |
| ISBN | Định dạng ISBN khi có; dùng để kiểm trùng |
| Năm xuất bản | Số năm hợp lệ |
| Bộ trường bắt buộc chính thức | Chưa chốt |

### 7.2 Limits & Quotas (exact values)

| Tham số | Giá trị | Window | Behavior khi vượt |
|---|---|---|---|
| Thời gian tra cứu | Dưới 2 giây | Ở quy mô 50.000 bản sao | Lỗi hiệu năng cần xử lý trước pilot |

### 7.3 Wording samples (exact strings)

#### Error messages

| Tình huống | Wording | Code |
|---|---|---|
| Trùng đầu sách | "Đầu sách này đã có trong hệ thống. Mở bản ghi hiện có?" (đề xuất) | E-core-003 |
| Còn bản sao đang lưu thông khi vô hiệu | "Không thể vô hiệu đầu sách vì còn bản sao đang mượn hoặc đang giữ." (đề xuất) | E-core-008 |

#### Success messages

| Tình huống | Wording |
|---|---|
| Lưu đầu sách | "Đã lưu đầu sách." (đề xuất) |

#### Info / neutral messages

| Tình huống | Wording |
|---|---|
| Tra cứu không có kết quả | "Không tìm thấy đầu sách phù hợp." (đề xuất) |

## 8. Assumptions

- Kiểm trùng đầu sách theo ISBN khi có; đầu sách không có ISBN kiểm theo tiêu đề và tác giả.
- Một bộ danh mục chung cho cả thư viện, một cơ sở.

## 9. Risks

| Rủi ro | Khả năng | Hậu quả nghiệp vụ | Cách phòng |
|--------|----------|-------------------|-----------|
| Data: dữ liệu Excel cũ trùng hoặc thiếu ISBN | thường | Đầu sách trùng, tra cứu sai | Làm sạch ở chạy thử import |
| Process: bộ trường bắt buộc chốt muộn | thỉnh thoảng | Phải sửa biểu mẫu và import | Chốt trước GATE-MIG |

## 10. Success Criteria (preliminary)

- Tra cứu dưới 2 giây ở 50.000 bản sao.
- 0 đầu sách trùng sau đối soát import.

## 11. Open Questions

- [ ] OQ-1: Bộ trường bắt buộc và quy tắc ISBN chính thức của đầu sách? (hold — domain approver)
- [ ] OQ-2: Đầu sách đã vô hiệu có được kích hoạt lại không? (hold)

## 12. Next Steps

- `/srs catalog-admin`
