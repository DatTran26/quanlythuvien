---
type: srs-userflow
feature: data-import
updated: 2026-10-09
primary_device: mobile
stage: flow-approved
flow_approved_at: 2026-10-09
flow_hash: "eb7d6a51"
---
# Import Excel và đối soát — User Flow

## 1. User Flow

### Flow: data-import-flow — R0

```mermaid
flowchart TD
    x1["Cấu hình quản trị — policy-config"]
    n1["[1] Tải file import"]
    n2["[2] Báo cáo import và đối soát"]
    d1{"Chạy thử đạt?"}
    s1["Xác thực lại cho override — OQ-data-import-002"]
    ok1["Ghi cả lô, sinh QR, đối soát vật lý"]
    e1["E-data-import-001, E-core-002, 004, 005 — sửa file và chạy lại"]

    x1 -->|"Mở import"| n1
    n1 -->|"Tải file và chạy thử"| d1
    d1 -->|"Đạt"| ok1
    d1 -->|"Không đạt"| e1
    d1 -->|"Yêu cầu override"| s1
    s1 -->|"Được duyệt"| ok1
    s1 -->|"Không được duyệt"| e1
    e1 -.->|"Sửa file"| n1
    ok1 --> n2
    n2 -.->|"Chạy lô mới"| n1

    classDef happy fill:#d4edda,stroke:#28a745
    classDef error fill:#f8d7da,stroke:#dc3545
    classDef edge fill:#fff3cd,stroke:#ffc107
    class n1,n2,ok1 happy
    class e1 error
    class s1,x1 edge
```

## 2. Danh sách màn hình

| [#] | Slug | Màn hình | Mục đích | Thuộc flow |
|-----|------|----------|----------|------------|
| 1 | import-upload | Tải file import | Tải file, chạy thử, xin override. | data-import-flow |
| 2 | import-report | Báo cáo import | Lỗi theo dòng, kết quả ghi lô, đối soát. | data-import-flow |

## 3. Danh sách flow

| Flow-slug | Tên flow | Màn hình gồm |
|-----------|----------|--------------|
| data-import-flow | Import và đối soát | import-upload → import-report |

## 3.5. Chuyển màn (transitions)

Chuyển màn sang feature khác xem `docs/_shared/navigation-map.md`.

| Từ màn [#] | Đến màn [#] | Trigger | Điều kiện |
|-----------|------------|---------|-----------|
| Cấu hình quản trị (`policy-config`) | Tải file import [1] | Mở import | Có quyền. |
| Tải file import [1] | Báo cáo import [2] | Chạy thử/ghi lô | Chạy thử đạt hoặc override được duyệt. |
| Tải file import [1] | (giữ nguyên) [1] | Chạy thử | E-data-import-001; sửa file chạy lại. |
| Tải file import [1] | Phiên hết hạn (`access-control`) | Yêu cầu override | Xác thực lại. |
| Báo cáo import [2] | Tải file import [1] | Chạy lô mới | Lô trước đã kết thúc. |

## 4. Open Questions

- [ ] OQ-data-import-001 — File Excel đại diện.
- [ ] OQ-data-import-002 — Người duyệt override.
