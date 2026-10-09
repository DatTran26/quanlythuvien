---
type: srs-userflow
feature: reader-onboarding
updated: 2026-10-09
primary_device: mobile
stage: flow-approved
flow_approved_at: 2026-10-09
flow_hash: "aa21ec00"
---
# Cấp và kích hoạt tài khoản người đọc — User Flow

## 1. User Flow

### Flow: reader-onboarding-flow — R0

```mermaid
flowchart TD
    n1["[1] Biểu mẫu người đọc"]
    d1{"Đủ trường và không trùng định danh?"}
    ok1["Lưu, kích hoạt, cấp thẻ QR"]
    e1["E-core-001 hoặc E-core-003 — báo lỗi hoặc mở hồ sơ hiện có"]
    x1["Chi tiết người đọc — account-admin"]

    n1 -->|"Lưu"| d1
    d1 -->|"Có"| ok1
    d1 -->|"Không"| e1
    e1 -.->|"Sửa"| n1
    e1 -.->|"Mở hồ sơ hiện có"| x1
    ok1 --> x1

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
| 1 | reader-form | Biểu mẫu người đọc | Nhập hồ sơ, kiểm trùng, kích hoạt và cấp thẻ QR. | reader-onboarding-flow |

## 3. Danh sách flow

| Flow-slug | Tên flow | Màn hình gồm |
|-----------|----------|--------------|
| reader-onboarding-flow | Cấp tài khoản tại quầy | reader-form |

## 3.5. Chuyển màn (transitions)

Chuyển màn sang feature khác xem `docs/_shared/navigation-map.md`.

| Từ màn [#] | Đến màn [#] | Trigger | Điều kiện |
|-----------|------------|---------|-----------|
| Biểu mẫu người đọc [1] | Chi tiết người đọc (`account-admin`) | Lưu thành công | Hồ sơ đã kích hoạt. |
| Biểu mẫu người đọc [1] | (giữ nguyên) [1] | Lưu | E-core-001 hoặc E-core-003. |

## 4. Open Questions

- [ ] OQ-reader-onboarding-001 — Bộ thông tin liên hệ bắt buộc.
