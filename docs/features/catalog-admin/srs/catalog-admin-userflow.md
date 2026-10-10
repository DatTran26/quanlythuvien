---
type: srs-userflow
feature: catalog-admin
updated: 2026-10-09
primary_device: mobile
stage: flow-approved
flow_approved_at: 2026-10-09
flow_hash: "bc0a94f2"
---
# Danh mục và đầu sách — User Flow

## 1. User Flow

### Flow: catalog-admin-flow — R0

```mermaid
flowchart TD
    n1["[1] Tra cứu danh mục"]
    n2["[2] Chi tiết đầu sách"]
    n3["[3] Biểu mẫu đầu sách"]
    n4["[4] Quản lý danh mục"]
    d1{"Có quyền và dữ liệu hợp lệ, không trùng?"}
    e1["E-core-001, 002, 003, 004 — báo lỗi hoặc xung đột"]
    x1["Kho bản sao — copy-inventory"]

    n1 -->|"Chọn kết quả"| n2
    n1 -->|"Tạo đầu sách"| n3
    n2 -->|"Sửa hoặc vô hiệu"| n3
    n2 -->|"Xem bản sao"| x1
    n3 -->|"Lưu"| d1
    d1 -->|"Có"| n2
    d1 -->|"Không"| e1
    e1 -.->|"Sửa hoặc tải lại"| n3
    n1 -->|"Quản lý danh mục"| n4

    classDef happy fill:#d4edda,stroke:#28a745
    classDef error fill:#f8d7da,stroke:#dc3545
    classDef edge fill:#fff3cd,stroke:#ffc107
    class n1,n2,n3,n4 happy
    class e1 error
    class x1 edge
```

## 2. Danh sách màn hình

| [#] | Slug | Màn hình | Mục đích | Thuộc flow |
|-----|------|----------|----------|------------|
| 1 | catalog-search | Tra cứu danh mục | Tìm đầu sách, xem số bản theo trạng thái. | catalog-admin-flow |
| 2 | bibliographic-detail | Chi tiết đầu sách | Thông tin đầu sách, số bản khả dụng, vị trí kệ. | catalog-admin-flow |
| 3 | bibliographic-form | Biểu mẫu đầu sách | Tạo, sửa, vô hiệu đầu sách. | catalog-admin-flow |
| 4 | category-admin | Quản lý danh mục | Thể loại, tác giả, nhà xuất bản, vị trí kệ (mới). | catalog-admin-flow |

## 3. Danh sách flow

| Flow-slug | Tên flow | Màn hình gồm |
|-----------|----------|--------------|
| catalog-admin-flow | Đầu sách và danh mục | catalog-search → bibliographic-detail → bibliographic-form → category-admin |

## 3.5. Chuyển màn (transitions)

Chuyển màn sang feature khác xem `docs/_shared/navigation-map.md`.

| Từ màn [#] | Đến màn [#] | Trigger | Điều kiện |
|-----------|------------|---------|-----------|
| Tra cứu danh mục [1] | Chi tiết đầu sách [2] | Chọn kết quả | Bản ghi tồn tại. |
| Tra cứu danh mục [1] | Biểu mẫu đầu sách [3] | Tạo mới | Có quyền. |
| Chi tiết đầu sách [2] | Biểu mẫu đầu sách [3] | Sửa/vô hiệu | Có quyền; BR-core-006. |
| Biểu mẫu đầu sách [3] | Chi tiết đầu sách [2] | Lưu | Hợp lệ, không trùng. |
| Chi tiết đầu sách [2] | Kho bản sao (`copy-inventory`) | Xem bản sao | Luôn. |
| Tra cứu danh mục [1] | Quản lý danh mục [4] | Quản lý danh mục | Chỉ Quản trị viên. |

## 4. Open Questions

- [ ] OQ-catalog-admin-001 — Bộ trường bắt buộc và quy tắc ISBN.
