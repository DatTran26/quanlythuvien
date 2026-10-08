---
type: srs-userflow
feature: notification-core
updated: 2026-10-09
primary_device: mobile
stage: flow-approved
flow_approved_at: 2026-10-09
flow_hash: "408ffb6b"
---
# Trạng thái thông báo — User Flow

## 1. User Flow

### Flow: notification-status-flow — R1A

```mermaid
flowchart TD
    n1["[1] Trạng thái thông báo"]
    d1{"Gửi kênh ngoài thành công?"}
    e1["E-notification-core-001 — retry"]
    e2["E-notification-core-002 — dead-letter"]
    ok1["Giao dịch nghiệp vụ đã commit"]

    n1 -->|"Xem outbox"| d1
    d1 -->|"Có"| ok1
    d1 -->|"Lỗi tạm"| e1
    e1 -.->|"Retry"| n1
    d1 -->|"Hết lần thử"| e2
    e2 -.->|"Xử lý hàng lỗi"| n1

    classDef happy fill:#d4edda,stroke:#28a745
    classDef error fill:#f8d7da,stroke:#dc3545
    classDef edge fill:#fff3cd,stroke:#ffc107
    class n1,ok1 happy
    class e1,e2 error
```

## 2. Danh sách màn hình

| [#] | Slug | Màn hình | Mục đích | Thuộc flow |
|-----|------|----------|----------|------------|
| 1 | notification-status | Trạng thái thông báo | Outbox, retry, dead-letter; gửi lỗi không làm hỏng giao dịch chính. | notification-status-flow |

## 3. Danh sách flow

| Flow-slug | Tên flow | Màn hình gồm |
|-----------|----------|--------------|
| notification-status-flow | Outbox thông báo | notification-status |

## 3.5. Chuyển màn (transitions)

Chuyển màn sang feature khác ghi bằng chữ khi đích chưa có wireframe; feature R0 dùng `../../{slug}/html-wireframe/`.

| Từ màn [#] | Đến màn [#] | Trigger | Điều kiện |
|-----------|------------|---------|-----------|
| Trạng thái [1] | (giữ) [1] | Retry | E-notification-core-001 |
| Trạng thái [1] | (giữ) [1] | Dead-letter | E-notification-core-002 |

## 4. Open Questions

- [ ] OQ-notification-core-001 — Kênh bắt buộc: chỉ in-app + email hay thêm kênh khác? Owner: Product Owner.
- [ ] OQ-notification-core-002 — Số lần thử lại và khoảng cách thử? Owner: vận hành.
- [ ] OQ-notification-core-003 — Danh sách sự kiện quan trọng gửi email? Owner: Product Owner.
- [ ] OQ-notification-core-004 — Ai xử lý hàng lỗi, có báo Thủ thư trực quầy (DEC-D3-08)? Owner: Thủ thư trưởng.
