---
type: srs-userflow
feature: reader-self-service
updated: 2026-10-09
primary_device: mobile
stage: flow-approved
flow_approved_at: 2026-10-09
flow_hash: "44e3cbf5"
---
# Cổng người đọc — User Flow

## 1. User Flow

### Flow: reader-portal-flow — R1A/R1B

```mermaid
flowchart TD
    n1["[1] Tra cứu sách"]
    n2["[2] Chi tiết đầu sách"]
    n3["[3] Thẻ QR"]
    n4["[4] Đang mượn"]
    n5["[5] Lịch sử mượn"]
    n6["[6] Công nợ của tôi — R1B"]
    e1["Empty — không có kết quả"]
    e2["Thẻ chưa kích hoạt — ẩn QR"]
    e3["E-core-002 — xem dữ liệu người khác"]

    n1 -->|"Chọn kết quả"| n2
    n1 -->|"Không khớp"| e1
    e1 -.->|"Đổi từ khóa"| n1
    n3 -->|"Thẻ không hiện"| e2
    n4 -->|"Lọc lịch sử"| n5
    n4 -->|"Xem công nợ R1B"| n6
    n2 -->|"Xem dữ liệu người khác"| e3

    classDef happy fill:#d4edda,stroke:#28a745
    classDef error fill:#f8d7da,stroke:#dc3545
    classDef edge fill:#fff3cd,stroke:#ffc107
    class n1,n2,n3,n4,n5 happy
    class e1,e2,e3 error
    class n6 edge
```

## 2. Danh sách màn hình

| [#] | Slug | Màn hình | Mục đích | Thuộc flow |
|-----|------|----------|----------|------------|
| 1 | reader-search | Tra cứu sách | Tìm theo tên, tác giả, ISBN, thể loại; lọc còn/hết. | reader-portal-flow |
| 2 | reader-bib-detail | Chi tiết đầu sách | Chỉ xem thông tin, số khả dụng, vị trí kệ. | reader-portal-flow |
| 3 | reader-qr | Thẻ QR | Hiện mã QR khi tài khoản đã kích hoạt và thẻ còn hạn. | reader-portal-flow |
| 4 | reader-current-loans | Đang mượn | Phiếu mở, hạn trả, quá hạn. | reader-portal-flow |
| 5 | reader-loan-history | Lịch sử mượn | Phiếu đã đóng, lọc thời gian. | reader-portal-flow |
| 6 | reader-my-fines | Công nợ của tôi | R1B xem công nợ, không thanh toán online. | reader-portal-flow |

## 3. Danh sách flow

| Flow-slug | Tên flow | Màn hình gồm |
|-----------|----------|--------------|
| reader-portal-flow | Cổng người đọc | reader-search → reader-bib-detail → reader-qr → reader-current-loans → reader-loan-history → reader-my-fines |

## 3.5. Chuyển màn (transitions)

Chuyển màn sang feature khác ghi bằng chữ khi đích chưa có wireframe; feature R0 dùng `../../{slug}/html-wireframe/`.

| Từ màn [#] | Đến màn [#] | Trigger | Điều kiện |
|-----------|------------|---------|-----------|
| Tra cứu [1] | Chi tiết [2] | Chọn kết quả | Có bản ghi |
| Tra cứu [1] | (giữ) [1] | Tìm | Empty |
| Thẻ QR [3] | (giữ) [3] | Mở thẻ | Chưa kích hoạt thì ẩn QR |
| Đang mượn [4] | Lịch sử [5] | Xem lịch sử | Luôn |
| Đang mượn [4] | Công nợ [6] | Xem công nợ | R1B |

## 4. Open Questions

- [ ] OQ-reader-self-service-001 — Thiết bị và hình thức cổng người đọc (mobile-first hay responsive)? Owner: Product Owner.
- [ ] OQ-reader-self-service-002 — Màn công nợ R1B làm tối thiểu hay chờ cổng đầy đủ? Owner: Product Owner.
- [ ] OQ-reader-self-service-003 — Người đọc bị khóa có đăng nhập cổng được không? Owner: domain approver.
- [ ] OQ-reader-self-service-004 — Ai được xem lịch sử mượn, có tự xóa sau N năm (OQ-12 nguồn)? Owner: pháp chế.
