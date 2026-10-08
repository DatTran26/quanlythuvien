---
type: srs-userflow
feature: reservation
updated: 2026-10-09
primary_device: mobile
stage: flow-approved
flow_approved_at: 2026-10-09
flow_hash: "80295690"
---
# Đặt trước — User Flow

## 1. User Flow

### Flow: reservation-flow — R2

```mermaid
flowchart TD
    n1["[1] Tìm tài liệu đặt trước"]
    n2["[2] Biểu mẫu đặt trước"]
    n3["[3] Hàng đợi đặt trước"]
    n4["[4] Nhận bản giữ"]
    d1{"Reservation còn hợp lệ?"}
    e1["E-reservation-001 — conflict"]
    empty["Empty — chưa có hàng đợi"]
    x1["Checkout — chữ"]

    n1 -->|"Chọn"| n2
    n2 -->|"Gửi"| d1
    d1 -->|"Có"| n3
    d1 -->|"Không"| e1
    e1 -.->|"Sửa"| n2
    n3 -->|"Đến lượt"| n4
    n3 -->|"Hủy"| empty
    n4 -->|"Nhận sách"| x1
    empty -.->|"Tạo mới"| n1

    classDef happy fill:#d4edda,stroke:#28a745
    classDef error fill:#f8d7da,stroke:#dc3545
    classDef edge fill:#fff3cd,stroke:#ffc107
    class n1,n2,n3,n4 happy
    class e1 error
    class empty,x1 edge
```

## 2. Danh sách màn hình

| [#] | Slug | Màn hình | Mục đích | Thuộc flow |
|-----|------|----------|----------|------------|
| 1 | reservation-search | Tìm đặt trước | Chọn tài liệu cho reservation, quầy hoặc cổng. | reservation-flow |
| 2 | reservation-form | Biểu mẫu đặt trước | Gửi yêu cầu giữ chỗ. | reservation-flow |
| 3 | reservation-queue | Hàng đợi | Vị trí, hủy, empty state. | reservation-flow |
| 4 | reservation-pickup | Nhận bản giữ | Pickup, hủy hoặc hết hạn; tiếp tục checkout. | reservation-flow |

## 3. Danh sách flow

| Flow-slug | Tên flow | Màn hình gồm |
|-----------|----------|--------------|
| reservation-flow | Đặt trước trọn vòng | reservation-search → reservation-form → reservation-queue → reservation-pickup |

## 3.5. Chuyển màn (transitions)

Chuyển màn sang feature khác ghi bằng chữ khi đích chưa có wireframe; feature R0 dùng `../../{slug}/html-wireframe/`.

| Từ màn [#] | Đến màn [#] | Trigger | Điều kiện |
|-----------|------------|---------|-----------|
| Tìm [1] | Form [2] | Chọn tài liệu | Luôn |
| Form [2] | Hàng đợi [3] | Gửi hợp lệ | Còn slot |
| Form [2] | (giữ) [2] | Gửi | E-reservation-001 |
| Hàng đợi [3] | Nhận [4] | Đến lượt còn hạn | Hold còn hạn |
| Nhận [4] | checkout (chữ) | Nhận sách | Tiếp tục mượn |

## 4. Open Questions

- [ ] OQ-reservation-001 — Đặt trước thuộc R2 (DEC-P2-05) cần Product Owner duyệt. Owner: Product Owner.
- [ ] OQ-reservation-002 — Giới hạn đặt trước và thời gian giữ chính thức (mặc định nguồn 3 yêu cầu / 48 giờ)? Owner: Thủ thư trưởng.
- [ ] OQ-reservation-003 — Có thời gian ân hạn khi đến nhận sát hạn? Owner: Thủ thư trưởng.
