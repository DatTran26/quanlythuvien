---
type: srs-userflow
feature: account-admin
updated: 2026-10-09
primary_device: mobile
stage: flow-approved
flow_approved_at: 2026-10-09
flow_hash: "4804f246"
---
# Quản trị tài khoản — User Flow

## 1. User Flow

### Flow: account-admin-flow — R0/R1B

```mermaid
flowchart TD
    n1["[1] Danh sách người đọc"]
    n2["[2] Chi tiết người đọc"]
    n3["[3] Tài khoản Thủ thư"]
    d1{"Có quyền, trạng thái hợp lệ, đủ lý do?"}
    d2{"Vô hiệu: còn nghĩa vụ mở?"}
    e1["E-core-001, 002, 004, 008 — báo lỗi hoặc xung đột"]
    e2["Chặn, liệt kê nghĩa vụ tồn đọng"]
    x1["Biểu mẫu người đọc — reader-onboarding"]

    n1 -->|"Chọn hồ sơ"| n2
    n1 -->|"Cấp tài khoản mới"| x1
    n2 -->|"Sửa, khóa tạm, mở lại"| d1
    n2 -->|"Vô hiệu"| d2
    d2 -->|"Còn"| e2
    d2 -->|"Không"| d1
    d1 -->|"Có"| n2
    d1 -->|"Không"| e1
    e1 -.->|"Tải lại hoặc sửa"| n2
    n1 -->|"Quản trị tài khoản Thủ thư"| n3
    n3 -->|"Tạo, khóa, đặt lại mật khẩu, vô hiệu"| d1

    classDef happy fill:#d4edda,stroke:#28a745
    classDef error fill:#f8d7da,stroke:#dc3545
    classDef edge fill:#fff3cd,stroke:#ffc107
    class n1,n2,n3 happy
    class e1,e2 error
    class x1 edge
```

## 2. Danh sách màn hình

| [#] | Slug | Màn hình | Mục đích | Thuộc flow |
|-----|------|----------|----------|------------|
| 1 | reader-list | Danh sách người đọc | Tra cứu tài khoản người đọc, dữ liệu cá nhân che theo quyền. | account-admin-flow |
| 2 | reader-detail | Chi tiết người đọc | Hồ sơ, khoản đang mượn, đặt trước, công nợ; sửa, khóa tạm, mở lại, vô hiệu. | account-admin-flow |
| 3 | staff-accounts | Tài khoản Thủ thư | Quản trị viên tạo, khóa, đặt lại mật khẩu, vô hiệu tài khoản Thủ thư (mới). | account-admin-flow |

## 3. Danh sách flow

| Flow-slug | Tên flow | Màn hình gồm |
|-----------|----------|--------------|
| account-admin-flow | Quản trị tài khoản người đọc và Thủ thư | reader-list → reader-detail → staff-accounts |

## 3.5. Chuyển màn (transitions)

Chuyển màn sang feature khác xem `docs/_shared/navigation-map.md`.

| Từ màn [#] | Đến màn [#] | Trigger | Điều kiện |
|-----------|------------|---------|-----------|
| Danh sách người đọc [1] | Chi tiết người đọc [2] | Chọn hồ sơ | Hồ sơ tồn tại. |
| Danh sách người đọc [1] | Biểu mẫu người đọc (`reader-onboarding`) | Cấp tài khoản mới | Có quyền cấp. |
| Chi tiết người đọc [2] | (giữ nguyên) [2] | Sửa, khóa tạm, mở lại, vô hiệu | Lý do bắt buộc; E-core-004/008 hiển thị tại chỗ. |
| Danh sách người đọc [1] | Tài khoản Thủ thư [3] | Quản trị tài khoản Thủ thư | Chỉ Quản trị viên. |

## 4. Open Questions

- [ ] OQ-account-admin-001 — Quản lý tài khoản Quản trị viên.
