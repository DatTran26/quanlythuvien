---
type: brainstorm
feature: overdue-fines
status: draft
updated: 2026-10-12
links:
  - docs/_product/prd.md
  - docs/_product/decision-register.md
  - docs/_shared/core-spec.md
  - docs/_shared/id-crosswalk-lmp.md
---

# Job quá hạn và sổ phạt

## 1. Idea Seed

Hằng ngày hệ thống quét phiếu mượn, chuyển phiếu quá hạn, nhắc người đọc trước hạn và khi quá hạn, và ghi nghĩa vụ phạt vào sổ chỉ thêm (không sửa, không xóa) để công nợ luôn đúng và truy vết được.

## 2. Context

- Chặn mượn vì nợ phạt ở `checkout` chỉ đúng khi job này và sổ phạt đã chạy (DEC-P2-02).
- Nghĩa vụ phạt phát sinh từ 3 nguồn: quá hạn (job này và lúc trả), hư hỏng (`damage-lifecycle`), mất (`lost-handling`). Feature này giữ quy tắc chung của sổ phạt; thu tiền thuộc `fine-collection-basic`, miễn/điều chỉnh thuộc `fine-collection-adv`.
- Không có màn hình riêng.

## 3. User Types (preliminary)

| User Type | Pain Point | Primary Need |
|-----------|-----------|--------------|
| Người đọc | Không biết sắp đến hạn, bị phạt bất ngờ | Được nhắc trước hạn và khi quá hạn |
| Nhân viên | Tính phạt tay, dễ sai | Phạt tự động, đúng quy định |
| Thủ thư trưởng | Công nợ không khớp | Số dư luôn bằng tổng các sự kiện tài chính |

## 4. Capabilities Breakdown

### P0 — must have

- Job hằng ngày lúc 00:05: chuyển phiếu quá hạn, cập nhật phạt tạm tính, gửi nhắc quá hạn.
- Job hằng ngày lúc 08:00: nhắc người đọc có phiếu đến hạn trong 2 ngày tới.
- Nhắc quá hạn ngày đầu, sau đó mỗi 3 ngày.
- Ghi nghĩa vụ phạt vào sổ chỉ thêm; số dư khoản phạt tính từ tổng các sự kiện.
- Job chạy lại không ghi phạt hay thông báo lần hai.
- Audit mỗi lần ghi nghĩa vụ.

### P1 — should have

- Không có.

### P2 — nice to have

- Không có.

## 5. Core Flows (Happy Path)

### 5.1 Job quá hạn

1) 00:05 hệ thống quét phiếu đang mở đã quá hạn.
2) Chuyển phiếu sang Quá hạn, cập nhật phạt tạm tính vào sổ.
3) Phát thông báo quá hạn cho người đọc (ngày đầu, rồi mỗi 3 ngày).

### 5.2 Nhắc sắp đến hạn

1) 08:00 hệ thống tìm phiếu đến hạn trong 2 ngày tới.
2) Phát thông báo nhắc cho người đọc.

```
00:05 ──> Phiếu đang mở đã quá hạn? ──không──> Bỏ qua
                     │ có
                     ▼
        Đã xử lý kỳ này? ──có──> Bỏ qua (chạy lại không nhân đôi)
                     │ không
                     ▼
     Chuyển Quá hạn + cập nhật phạt tạm tính + audit ──> Đến lượt nhắc? ──có──> Phát thông báo
```

## 6. System Behavior Deep Dive

### 6.1 Decision Points

| ID | Flow | Khi nào | YES (nhánh đồng ý) | NO (nhánh từ chối) |
|---|---|---|---|---|
| D1 | Job quá hạn | Phiếu đang mở đã quá hạn? | Chuyển Quá hạn, ghi phạt | Bỏ qua |
| D2 | Job quá hạn | Kỳ này đã xử lý phiếu này? | Bỏ qua | Xử lý |
| D3 | Job quá hạn | Đến lượt nhắc (ngày đầu hoặc mỗi 3 ngày)? | Phát thông báo | Không gửi |
| D4 | Ghi phạt | Phạt đã chạm trần (bằng giá sách)? | Không tăng thêm | Cộng phạt ngày |
| D5 | Nhắc hạn | Phiếu đến hạn trong 2 ngày tới? | Phát nhắc | Bỏ qua |

### 6.2 Scenario Matrix

Không áp dụng — một actor hệ thống.

### 6.3 State Transitions

| Entity | Từ | Sang | Trigger | Quay lại được? |
|--------|------|----|---------|-------------|
| Phiếu mượn | Đang mở | Quá hạn | Job 00:05 phát hiện quá hạn | Không; kết thúc khi trả hoặc mất |
| Khoản phạt | — | Chưa thanh toán | Ghi nghĩa vụ đầu tiên | — |

### 6.4 Interrupted Transactions

| Tình huống | Hệ thống còn lại gì | Resume | Cleanup |
|---|---|---|---|
| Job dừng giữa chừng | Các phiếu đã xử lý xong | Chạy lại, bỏ qua phiếu đã xử lý kỳ này | Không có |
| Gửi thông báo lỗi | Sự kiện trong hàng đợi | `notification-core` thử lại | Không ảnh hưởng sổ phạt |

### 6.5 Other Edge Cases

- Sổ phạt không sửa, không xóa; mọi sai sót sửa bằng sự kiện điều chỉnh có quyền và lý do.
- Phiếu trả trễ được tính phạt lúc trả nếu job chưa kịp chạy.

## 7. Validation, Limits & Wording

### 7.1 Validation rules

| Field | Rule |
|---|---|
| Sự kiện tài chính | Chỉ thêm; có loại, số tiền, khoản phạt, thời điểm |

### 7.2 Limits & Quotas (exact values)

| Tham số | Giá trị | Window | Behavior khi vượt |
|---|---|---|---|
| Giờ chạy job quá hạn | 00:05 | Hằng ngày | — |
| Giờ chạy nhắc hạn | 08:00 | Hằng ngày | — |
| Nhắc trước hạn | 2 ngày | Trước hạn trả | — |
| Nhắc quá hạn | Ngày đầu, rồi mỗi 3 ngày | Từ ngày quá hạn | — |
| Phạt quá hạn | 2.000đ/ngày/cuốn (mặc định nguồn, chưa chốt) | Mỗi ngày quá hạn | — |
| Trần phạt quá hạn | Bằng giá sách (mặc định nguồn, chưa chốt) | Mỗi phiếu | Không tăng thêm |

### 7.3 Wording samples (exact strings)

#### Error messages

| Tình huống | Wording | Code |
|---|---|---|
| — | — | — |

#### Success messages

| Tình huống | Wording |
|---|---|
| — | — |

#### Info / neutral messages

| Tình huống | Wording |
|---|---|
| Nhắc sắp đến hạn | "Sách {tên sách} đến hạn trả vào {ngày}." (đề xuất) |
| Quá hạn | "Sách {tên sách} đã quá hạn {N} ngày. Phạt tạm tính: {số tiền}." (đề xuất) |

## 8. Assumptions

- Phạt tính theo ngày lịch, múi giờ UTC+7.
- Một khoản phạt cho mỗi phiếu quá hạn, cộng dồn theo ngày.

## 9. Risks

| Rủi ro | Khả năng | Hậu quả nghiệp vụ | Cách phòng |
|--------|----------|-------------------|-----------|
| Timeline: mức phạt chốt muộn | thỉnh thoảng | Trễ bật chặn mượn vì nợ | Chốt OQ-1 trước SRS |
| Process: job không chạy mà không ai biết | hiếm | Công nợ sai, chặn mượn sai | Owner vận hành theo dõi job (GATE-OPS) |

## 10. Success Criteria (preliminary)

- 100% sự kiện tài chính chỉ thêm, không sửa xóa.
- Số dư mọi khoản phạt khớp tổng sự kiện.

## 11. Open Questions

- [ ] OQ-1: Mức phạt quá hạn và trần phạt chính thức? (OQ-policy-config-001; hold — Thủ thư trưởng)
- [ ] OQ-2: Có thời gian ân hạn trước khi tính phạt không? (hold)

## 12. Next Steps

- `/srs overdue-fines`
