---
type: brainstorm
feature: copy-inventory
status: draft
updated: 2026-10-08
links:
  - docs/_product/prd.md
  - docs/_shared/core-spec.md
  - docs/_shared/domain/lifecycle-inventory.md
  - docs/_shared/id-crosswalk-lmp.md
---

# Bản sao và nhãn QR

## 1. Idea Seed

Quản trị viên đăng ký từng bản sao vật lý của một đầu sách, sinh mã QR duy nhất hàng loạt, xuất file in nhãn để dán lên sách; QR chỉ dùng để tìm bản ghi, không phải bằng chứng ủy quyền.

## 2. Context

- Mọi giao dịch tại quầy bắt đầu bằng quét QR của bản sao, nên mỗi cuốn thật phải có đúng một mã.
- Bản sao thuộc một đầu sách (`catalog-admin`); bản sao mới từ import cũng được sinh QR ở đây.
- Trạng thái bản sao (Sẵn sàng, Đang mượn, Đang giữ, Chờ duyệt, Đang sửa, Mất, Thanh lý) do các feature nghiệp vụ đổi, không đổi tay ở đây. Vòng đời là bản dựng lại, chờ domain approver duyệt (DEC-D3-01).

## 3. User Types (preliminary)

| User Type | Pain Point | Primary Need |
|-----------|-----------|--------------|
| Quản trị viên | Gõ mã từng cuốn, dễ trùng | Sinh QR hàng loạt và in nhãn |
| Thủ thư | Nhãn mờ hoặc sai cuốn | Mã duy nhất, nhập tay được khi QR mờ |

## 4. Capabilities Breakdown

### P0 — must have

- Nhập N bản sao cho một đầu sách: vị trí kệ, tình trạng ban đầu.
- Sinh mã QR duy nhất hàng loạt, xuất file in nhãn.
- Xem kho bản sao của một đầu sách theo trạng thái.
- Sửa thông tin bản sao (vị trí, tình trạng); không đổi trạng thái lưu thông bằng tay.
- Đánh dấu bản sao chỉ đọc tại chỗ (ghi đè cờ của đầu sách).
- QR chỉ để tìm bản ghi; sau khi tìm vẫn kiểm tra quyền.
- Không xóa cứng bản sao đã có lịch sử; không thao tác trên bản sao đã thanh lý.
- Audit mọi thay đổi.

### P1 — should have

- Không có.

### P2 — nice to have

- Không có.

## 5. Core Flows (Happy Path)

### 5.1 Nhập bản sao và in nhãn

1) Quản trị viên mở chi tiết đầu sách, chọn thêm bản sao.
2) Nhập số bản, vị trí kệ, tình trạng ban đầu.
3) Hệ thống tạo bản sao ở trạng thái Sẵn sàng, sinh QR duy nhất cho từng bản, ghi audit.
4) Quản trị viên xuất file in nhãn; Thủ thư dán nhãn lên sách.

```
Chọn đầu sách ──> Nhập số bản + vị trí + tình trạng ──> Hợp lệ? ──không──> Báo lỗi
                                                           │ có
                                                           ▼
                            Tạo N bản sao (Sẵn sàng) + sinh N mã QR duy nhất + audit
                                                           │
                                                           ▼
                                      Xuất file in nhãn ──> Dán nhãn
```

## 6. System Behavior Deep Dive

### 6.1 Decision Points

| ID | Flow | Khi nào | YES (nhánh đồng ý) | NO (nhánh từ chối) |
|---|---|---|---|---|
| D1 | Nhập bản sao | Đầu sách tồn tại và đang dùng? | Tiếp tục | Báo không tìm thấy |
| D2 | Nhập bản sao | Dữ liệu hợp lệ? | Tạo bản sao | Báo lỗi tại trường |
| D3 | Sửa, vô hiệu | Thao tác hợp lệ với trạng thái hiện tại? | Thực hiện | Giải thích, chỉ hiện thao tác hợp lệ |

### 6.2 Scenario Matrix

| From State | To State | Rule | Action | Result |
|------------|----------|------|--------|--------|
| Bản sao Sẵn sàng | Vô hiệu | Không có lịch sử | Vô hiệu | Thực hiện |
| Bản sao Đang mượn / Đang giữ | Vô hiệu | Đang lưu thông | Vô hiệu | Chặn |
| Bản sao Thanh lý | — | Trạng thái cuối | Bất kỳ thao tác | Chặn |

### 6.3 State Transitions

| Entity | Từ | Sang | Trigger | Quay lại được? |
|--------|------|----|---------|-------------|
| Bản sao | — | Sẵn sàng | Đăng ký hoặc import bản sao | — |

Các chuyển trạng thái khác thuộc feature nghiệp vụ; xem `docs/_shared/domain/lifecycle-inventory.md`.

### 6.4 Interrupted Transactions

| Tình huống | Hệ thống còn lại gì | Resume | Cleanup |
|---|---|---|---|
| Mất kết nối giữa lúc tạo N bản sao | Hoặc đủ N bản, hoặc không bản nào | Kiểm tra kho bản sao rồi thao tác lại | Không có bản sao lẻ |

### 6.5 Other Edge Cases

- Mã QR đã dùng không cấp lại cho bản sao khác, kể cả khi bản sao cũ bị thanh lý.
- In lại nhãn cho bản sao có nhãn hỏng dùng đúng mã cũ.

## 7. Validation, Limits & Wording

### 7.1 Validation rules

| Field | Rule |
|---|---|
| Mã QR bản sao | Duy nhất, đang hiệu lực, trỏ đúng một bản sao |
| Số bản | Số nguyên dương |
| Vị trí kệ | Chọn từ danh mục vị trí |

### 7.2 Limits & Quotas (exact values)

| Tham số | Giá trị | Window | Behavior khi vượt |
|---|---|---|---|
| Số bản tối đa một lần nhập | TBD | Một thao tác | Chia nhiều lần |

### 7.3 Wording samples (exact strings)

#### Error messages

| Tình huống | Wording | Code |
|---|---|---|
| Thao tác trên bản sao đang lưu thông hoặc đã thanh lý | "Không thể thực hiện vì bản sao đang {trạng thái}." (đề xuất) | E-core-008 |

#### Success messages

| Tình huống | Wording |
|---|---|
| Nhập bản sao thành công | "Đã tạo {N} bản sao và mã QR. Có thể xuất file in nhãn." (đề xuất) |

#### Info / neutral messages

| Tình huống | Wording |
|---|---|
| — | — |

## 8. Assumptions

- Bản sao mới có trạng thái Sẵn sàng (DEC-D3-01, chờ duyệt).
- Cờ chỉ đọc tại chỗ đặt ở đầu sách, ghi đè được trên bản sao (DEC-D3-09).

## 9. Risks

| Rủi ro | Khả năng | Hậu quả nghiệp vụ | Cách phòng |
|--------|----------|-------------------|-----------|
| Data: dán nhãn nhầm cuốn | thỉnh thoảng | Ghi mượn sai cuốn, kho lệch | Quét đối soát sau dán nhãn (GATE-MIG) |
| Process: vòng đời bản sao chưa được duyệt | thỉnh thoảng | Phải sửa trạng thái khởi tạo | Domain approver duyệt DEC-D3-01 trước SRS |

## 10. Success Criteria (preliminary)

- 0 mã QR trùng.
- 100% bản sao đã dán nhãn quét được và khớp hệ thống khi đối soát.

## 11. Open Questions

- [ ] OQ-1: Trạng thái khởi tạo và cờ chỉ đọc tại chỗ của bản sao (DEC-D3-01, DEC-D3-09; hold — domain approver)
- [ ] OQ-2: Mẫu nhãn in (kích thước, thông tin trên nhãn)? (hold — vận hành)

## 12. Next Steps

- `/srs copy-inventory`
