---
type: srs-userflow
feature: renewal
updated: 2026-10-09
primary_device: mobile
stage: flow-approved
flow_approved_at: 2026-10-09
flow_hash: "9f2f9d57"
---
# Gia hạn — User Flow

## 1. User Flow

### Flow: renewal-flow — R1B

```mermaid
flowchart TD
    n1["[1] Yêu cầu gia hạn"]
    d1{"Đủ điều kiện gia hạn?"}
    n2["[2] Kết quả gia hạn"]
    e1["Bị chặn — quá hạn, nợ, hàng chờ R2"]

    n1 -->|"Gửi yêu cầu quầy hoặc cổng"| d1
    d1 -->|"Có"| n2
    d1 -->|"Không"| e1
    e1 -.->|"Xem lý do"| n2

    classDef happy fill:#d4edda,stroke:#28a745
    classDef error fill:#f8d7da,stroke:#dc3545
    classDef edge fill:#fff3cd,stroke:#ffc107
    class n1,n2 happy
    class e1 error
```

## 2. Danh sách màn hình

| [#] | Slug | Màn hình | Mục đích | Thuộc flow |
|-----|------|----------|----------|------------|
| 1 | renewal-request | Yêu cầu gia hạn | Thủ thư tại quầy hoặc Người đọc trên cổng chọn khoản đang mượn. | renewal-flow |
| 2 | renewal-result | Kết quả gia hạn | Thành công hoặc lý do chặn. Số lần/cộng ngày còn OQ-renewal-001. | renewal-flow |

## 3. Danh sách flow

| Flow-slug | Tên flow | Màn hình gồm |
|-----------|----------|--------------|
| renewal-flow | Gia hạn quầy và online | renewal-request → renewal-result |

## 3.5. Chuyển màn (transitions)

Chuyển màn sang feature khác ghi bằng chữ khi đích chưa có wireframe; feature R0 dùng `../../{slug}/html-wireframe/`.

| Từ màn [#] | Đến màn [#] | Trigger | Điều kiện |
|-----------|------------|---------|-----------|
| Yêu cầu [1] | Kết quả [2] | Gửi | Luôn |
| Yêu cầu [1] | Kết quả [2] | Gửi | Bị chặn — hiện lý do |

## 4. Open Questions

- [ ] OQ-renewal-001 — Số lần gia hạn và thời gian cộng thêm chính thức (mặc định nguồn 1 lần / +7 ngày)? Owner: Thủ thư trưởng.
