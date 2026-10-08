---
type: brainstorm
feature: data-import
status: draft
updated: 2026-10-08
links:
  - docs/_product/prd.md
  - docs/_product/readiness-gates.md
  - docs/_shared/core-spec.md
  - docs/_shared/id-crosswalk-lmp.md
---

# Import Excel và đối soát

## 1. Idea Seed

Quản trị viên nhập dữ liệu đầu sách và bản sao có sẵn từ file Excel: hệ thống chạy thử, báo lỗi theo từng dòng, chỉ ghi khi chạy thử đạt, ghi cả lô một lần, rồi đối soát với kiểm kê vật lý.

## 2. Context

- Thư viện đã có dữ liệu sách cũ trên Excel; kho phải sạch trước khi mở quầy (GATE-MIG là điều kiện thoát R0).
- File Excel đại diện chưa có: đây là blocker bên ngoài, nên cấu trúc cột chính thức chưa thể chốt.
- Sau khi ghi, mã QR cho bản sao mới được sinh ở `copy-inventory`; Thủ thư dán nhãn và quét đối soát.

## 3. User Types (preliminary)

| User Type | Pain Point | Primary Need |
|-----------|-----------|--------------|
| Quản trị viên | Không biết dữ liệu cũ sai ở đâu | Danh sách lỗi theo dòng trước khi ghi |
| Thủ thư | Kho trên hệ thống lệch kho thật | Đối soát vật lý có số liệu |
| Thủ thư trưởng | Không có căn cứ cho phép mở quầy | Báo cáo đối soát đạt ngưỡng |

## 4. Capabilities Breakdown

### P0 — must have

- Tải file Excel, kiểm tra file đọc được.
- Chạy thử: kiểm từng dòng (mã nhận diện, trạng thái hợp lệ, trùng), ghi lỗi theo dòng, không ghi dữ liệu nghiệp vụ.
- Báo cáo chạy thử: tổng dòng, hợp lệ, lỗi kèm lý do, trùng, bỏ qua.
- Ghi chính thức cả lô trong một lần; lỗi giữa chừng thì hủy toàn lô.
- Chặn ghi khi chạy thử còn lỗi, trừ khi có override được duyệt.
- Một lô đang chạy tại một thời điểm.
- Tải lại cùng file hoặc thử lại cùng lần xác nhận không tạo lô thứ hai.
- Báo cáo đối soát sau ghi: số ghi nhận so với nguồn, lỗi, bỏ qua, kết quả kiểm kê vật lý.
- Audit lô và kết quả.

### P1 — should have

- Không có.

### P2 — nice to have

- Không có.

## 5. Core Flows (Happy Path)

### 5.1 Import và đối soát

1) Quản trị viên tải file Excel.
2) Hệ thống chạy thử, báo lỗi theo dòng.
3) Quản trị viên sửa file, chạy thử lại cho tới khi đạt.
4) Quản trị viên xác nhận ghi; hệ thống ghi cả lô một lần, ghi audit.
5) Hệ thống sinh QR cho bản sao mới; Thủ thư dán nhãn và quét đối soát.
6) Hệ thống xuất báo cáo đối soát.

```
Tải file ──> Đọc được? ──không──> Báo lỗi file
                 │ có
                 ▼
          Đang có lô khác chạy? ──có──> Từ chối, chờ lô hiện tại
                 │ không
                 ▼
          Chạy thử ──> Còn lỗi? ──có──> Báo lỗi theo dòng ──> Sửa file, chạy thử lại
                 │ không                        └── hoặc xin override (người duyệt chưa chốt)
                 ▼
          Xác nhận ghi ──> Ghi cả lô thành công? ──không──> Hủy toàn lô, báo lỗi
                 │ có
                 ▼
          Sinh QR ──> Dán nhãn ──> Quét đối soát ──> Lệch vượt ngưỡng? ──có──> GATE-MIG chưa đạt
                                                          │ không
                                                          ▼
                                                   Báo cáo đối soát đạt
```

## 6. System Behavior Deep Dive

### 6.1 Decision Points

| ID | Flow | Khi nào | YES (nhánh đồng ý) | NO (nhánh từ chối) |
|---|---|---|---|---|
| D1 | Import | File đọc được, đúng định dạng chung? | Tạo lô chạy thử | Báo lỗi file |
| D2 | Import | Đang có lô khác chạy? | Từ chối | Tiếp tục |
| D3 | Import | Chạy thử còn lỗi? | Chặn ghi, báo lỗi theo dòng | Cho xác nhận ghi |
| D4 | Import | Override được duyệt? | Cho ghi kèm lý do và số dòng lỗi chấp nhận | Giữ chặn |
| D5 | Import | Ghi cả lô thành công? | Sinh QR | Hủy toàn lô |
| D6 | Đối soát | Sai lệch vượt ngưỡng? | GATE-MIG chưa đạt | Đạt |

### 6.2 Scenario Matrix

| From State | To State | Rule | Action | Result |
|------------|----------|------|--------|--------|
| Cùng file đã tải | — | Trùng nội dung | Tải lại | Trả lô gốc |
| File khác nội dung, trùng tên | — | Khác nội dung | Tải | Cảnh báo, xác nhận tạo lô mới |
| Lô đã ghi | — | Mất phản hồi sau xác nhận | Tra lại | Trả kết quả gốc |

### 6.3 State Transitions

| Entity | Từ | Sang | Trigger | Quay lại được? |
|--------|------|----|---------|-------------|
| Lô import | Chạy thử | Đạt chạy thử | Không còn lỗi | — |
| Lô import | Đạt chạy thử | Đã ghi | Ghi thành công | Không |
| Lô import | Đang ghi | Thất bại | Lỗi giữa chừng, hủy toàn lô | Chạy thử lô mới |
| Lô import | Đang chạy | Đã hủy | Quản trị viên hủy có lý do | Không |

### 6.4 Interrupted Transactions

| Tình huống | Hệ thống còn lại gì | Resume | Cleanup |
|---|---|---|---|
| Mất phản hồi sau khi xác nhận ghi | Lô đã ghi hoặc thất bại | Tra lại theo lần xác nhận; không tự tạo lô mới | Không có |
| Lỗi giữa lúc ghi | Không có dữ liệu nhập dở | Sửa dữ liệu, chạy thử lô mới | Hủy toàn lô |
| Lô đang chạy bị bỏ dở | Lô ở trạng thái đang chạy | Quản trị viên hủy lô có lý do | Ghi audit |

### 6.5 Other Edge Cases

- Đối soát lệch thì không tự sửa; Quản trị viên điều chỉnh thủ công có audit hoặc nhập lại.
- Lỗi theo dòng che giá trị nhạy cảm nếu người xem không có quyền.

## 7. Validation, Limits & Wording

### 7.1 Validation rules

| Field | Rule |
|---|---|
| Mỗi dòng | Có mã nhận diện, trạng thái hợp lệ; lỗi và trùng báo theo dòng |
| Cấu trúc cột | Chưa chốt — chờ file đại diện |

### 7.2 Limits & Quotas (exact values)

| Tham số | Giá trị | Window | Behavior khi vượt |
|---|---|---|---|
| Sai lệch đối soát chấp nhận | ≤ 1% | Sau đối soát pilot | GATE-MIG chưa đạt |
| Bản ghi lỗi được chỉ rõ trước khi ghi | 100% | Mỗi lô | Không cho ghi |
| Lô đang chạy cùng lúc | 1 | Toàn hệ thống | Từ chối lô mới |

### 7.3 Wording samples (exact strings)

#### Error messages

| Tình huống | Wording | Code |
|---|---|---|
| File không đọc được | "Không đọc được file. Vui lòng kiểm tra định dạng và tải lại." (đề xuất) | E-data-import-001 |
| Chạy thử còn lỗi | "Còn {N} dòng lỗi. Vui lòng sửa file và chạy thử lại." (đề xuất) | E-data-import-001 |
| Có lô khác đang chạy | "Đang có một lô import chưa kết thúc. Vui lòng chờ hoặc hủy lô đó." (đề xuất) | E-core-004 |

#### Success messages

| Tình huống | Wording |
|---|---|
| Import thành công | "Đã nhập dữ liệu và tạo báo cáo đối soát." |

#### Info / neutral messages

| Tình huống | Wording |
|---|---|
| File đã tải trước đó | "File này đã được tải. Đang hiển thị lô trước đó." (đề xuất) |

## 8. Assumptions

- Import gồm đầu sách và bản sao; hồ sơ người đọc có thể import nếu file nguồn có (nguồn mặc định OQ-15).
- Ghi theo lô có thể hoàn tác bằng hủy lô hoặc khôi phục backup trước import (roadmap R0).

## 9. Risks

| Rủi ro | Khả năng | Hậu quả nghiệp vụ | Cách phòng |
|--------|----------|-------------------|-----------|
| Vendor/Data: chưa có file Excel đại diện | thường | Không chốt được cấu trúc, trễ GATE-MIG | Thủ thư trưởng cung cấp file trước khi viết SRS |
| Data: dữ liệu cũ trùng hoặc thiếu mã | thường | Kho lệch, quầy không vận hành được | Chạy thử nhiều vòng, đối soát vật lý |
| Process: override bị dùng để bỏ qua lỗi | hiếm | Dữ liệu bẩn vào hệ thống | Người duyệt override có thẩm quyền, có lý do và audit |

## 10. Success Criteria (preliminary)

- 100% bản ghi lỗi hoặc trùng được chỉ rõ trước khi ghi.
- Sai lệch kho sau đối soát ≤ 1%.

## 11. Open Questions

- [ ] OQ-1: File Excel đại diện và cấu trúc cột chính thức? (OQ-data-import-001; hold — data owner)
- [ ] OQ-2: Ai được duyệt override khi chạy thử chưa đạt, điều kiện và bằng chứng? (OQ-data-import-002; hold — data owner + Thủ thư trưởng)
- [ ] OQ-3: Có import hồ sơ người đọc không? (hold — phụ thuộc OQ-1)

## 12. Next Steps

- `/srs data-import`
