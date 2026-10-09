---
type: srs-userflow
feature: policy-config
updated: 2026-10-09
primary_device: mobile
stage: flow-approved
flow_approved_at: 2026-10-09
flow_hash: "195c3a6a"
---
# Cấu hình quy định — User Flow

## 1. User Flow

### Flow: policy-config-flow — R0

```mermaid
flowchart TD
    n1["[1] Cấu hình quản trị"]
    d1{"Giá trị trong miền và thời điểm hợp lệ?"}
    ok1["Lưu, ghi audit trước sau"]
    e1["E-core-001, 002, 004 — báo lỗi"]
    x1["Tải file import — data-import"]

    n1 -->|"Lưu tham số"| d1
    d1 -->|"Có"| ok1
    d1 -->|"Không"| e1
    e1 -.->|"Sửa"| n1
    ok1 --> n1
    n1 -->|"Mở import"| x1

    classDef happy fill:#d4edda,stroke:#28a745
    classDef error fill:#f8d7da,stroke:#dc3545
    classDef edge fill:#fff3cd,stroke:#ffc107
    class n1,ok1 happy
    class e1 error
    class x1 edge
```

## 2. Danh sách màn hình

| [#] | Slug | Màn hình | Mục đích | Thuộc flow |
|-----|------|----------|----------|------------|
| 1 | admin-config | Cấu hình quản trị | Sửa tham số quy định với thời điểm hiệu lực; lối vào import. | policy-config-flow |

## 3. Danh sách flow

| Flow-slug | Tên flow | Màn hình gồm |
|-----------|----------|--------------|
| policy-config-flow | Cấu hình quy định | admin-config |

## 3.5. Chuyển màn (transitions)

Chuyển màn sang feature khác xem `docs/_shared/navigation-map.md`.

| Từ màn [#] | Đến màn [#] | Trigger | Điều kiện |
|-----------|------------|---------|-----------|
| Cấu hình quản trị [1] | (giữ nguyên) [1] | Lưu tham số | Hợp lệ, hoặc E-core-001 hiển thị tại chỗ. |
| Cấu hình quản trị [1] | Tải file import (`data-import`) | Mở import | Có quyền. |

## 4. Open Questions

- [ ] OQ-policy-config-002 — Miền giá trị từng tham số.
