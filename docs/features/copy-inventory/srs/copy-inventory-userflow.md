---
type: srs-userflow
feature: copy-inventory
updated: 2026-10-09
primary_device: mobile
stage: flow-approved
flow_approved_at: 2026-10-09
flow_hash: "a7c70968"
---
# Bản sao và nhãn QR — User Flow

## 1. User Flow

### Flow: copy-inventory-flow — R0

```mermaid
flowchart TD
    x1["Chi tiết đầu sách — catalog-admin"]
    n1["[1] Kho bản sao"]
    n2["[2] Biểu mẫu bản sao"]
    d1{"Dữ liệu hợp lệ và thao tác đúng trạng thái?"}
    ok1["Tạo N bản sao, sinh QR, xuất file in nhãn"]
    e1["E-core-001, 003, 008 — báo lỗi"]

    x1 -->|"Xem bản sao"| n1
    n1 -->|"Thêm hoặc sửa bản sao"| n2
    n2 -->|"Lưu"| d1
    d1 -->|"Có"| ok1
    d1 -->|"Không"| e1
    e1 -.->|"Sửa"| n2
    ok1 --> n1
    n1 -->|"In lại nhãn"| ok1

    classDef happy fill:#d4edda,stroke:#28a745
    classDef error fill:#f8d7da,stroke:#dc3545
    classDef edge fill:#fff3cd,stroke:#ffc107
    class n1,n2,ok1 happy
    class e1 error
    class x1 edge
```

## 2. Danh sách màn hình

| [#] | Slug | Màn hình | Mục đích | Thuộc flow |
|-----|------|----------|----------|------------|
| 1 | copy-inventory | Kho bản sao | Danh sách bản sao của một đầu sách theo trạng thái; in lại nhãn. | copy-inventory-flow |
| 2 | copy-form | Biểu mẫu bản sao | Nhập N bản, vị trí kệ, tình trạng, cờ chỉ đọc tại chỗ. | copy-inventory-flow |

## 3. Danh sách flow

| Flow-slug | Tên flow | Màn hình gồm |
|-----------|----------|--------------|
| copy-inventory-flow | Kho bản sao và in nhãn | copy-inventory → copy-form |

## 3.5. Chuyển màn (transitions)

Chuyển màn sang feature khác xem `docs/_shared/navigation-map.md`.

| Từ màn [#] | Đến màn [#] | Trigger | Điều kiện |
|-----------|------------|---------|-----------|
| Chi tiết đầu sách (`catalog-admin`) | Kho bản sao [1] | Xem bản sao | Luôn. |
| Kho bản sao [1] | Biểu mẫu bản sao [2] | Thêm hoặc sửa | Có quyền. |
| Biểu mẫu bản sao [2] | Kho bản sao [1] | Lưu | Hợp lệ; bản sao mới có QR. |

## 4. Open Questions

- [ ] OQ-copy-inventory-002 — Mẫu nhãn in.
