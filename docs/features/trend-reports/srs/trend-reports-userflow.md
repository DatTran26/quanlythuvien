---
type: srs-userflow
feature: trend-reports
updated: 2026-10-09
primary_device: mobile
stage: flow-approved
flow_approved_at: 2026-10-09
flow_hash: "728b2f6f"
---
# Báo cáo xu hướng — User Flow

## 1. User Flow

### Flow: trend-reports-flow — R2

```mermaid
flowchart TD
    n1["[1] Dashboard xu hướng"]
    d1{"Có quyền và có dữ liệu?"}
    r1["RP-03, RP-05, RP-06, RP-07"]
    e1["E-core-002"]
    empty["Empty kỳ"]

    n1 -->|"Tải"| d1
    d1 -->|"Có"| r1
    d1 -->|"Empty"| empty
    d1 -->|"Không quyền"| e1
    empty -.->|"Đổi lọc"| n1

    classDef happy fill:#d4edda,stroke:#28a745
    classDef error fill:#f8d7da,stroke:#dc3545
    classDef edge fill:#fff3cd,stroke:#ffc107
    class n1,r1 happy
    class e1 error
    class empty edge
```

## 2. Danh sách màn hình

| [#] | Slug | Màn hình | Mục đích | Thuộc flow |
|-----|------|----------|----------|------------|
| 1 | trend-dashboard | Dashboard xu hướng | RP-03 lưu thông, RP-05 phạt, RP-06 top/không mượn, RP-07 hư hỏng; xuất Excel/PDF. | trend-reports-flow |

## 3. Danh sách flow

| Flow-slug | Tên flow | Màn hình gồm |
|-----------|----------|--------------|
| trend-reports-flow | Báo cáo xu hướng | trend-dashboard |

## 3.5. Chuyển màn (transitions)

Chuyển màn sang feature khác ghi bằng chữ khi đích chưa có wireframe; feature R0 dùng `../../{slug}/html-wireframe/`.

| Từ màn [#] | Đến màn [#] | Trigger | Điều kiện |
|-----------|------------|---------|-----------|
| Dashboard [1] | (giữ) [1] | Tải RP | Có quyền |
| Dashboard [1] | (giữ) [1] | Tải | Empty hoặc E-core-002 |

## 4. Open Questions

- [ ] OQ-trend-reports-001 — Số sách trong danh sách top? Owner: Product Owner.
