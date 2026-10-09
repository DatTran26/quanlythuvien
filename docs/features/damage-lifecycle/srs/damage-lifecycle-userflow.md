---
type: srs-userflow
feature: damage-lifecycle
updated: 2026-10-09
primary_device: mobile
stage: flow-approved
flow_approved_at: 2026-10-09
flow_hash: "8c2f190e"
---
# Báo cáo hư hỏng — User Flow

## 1. User Flow

### Flow: damage-lifecycle-flow — R1A

```mermaid
flowchart TD
    n1["[1] Biểu mẫu báo hư hỏng"]
    d1{"Dữ liệu và 1 đến 5 ảnh hợp lệ?"}
    n2["[2] Chi tiết báo cáo hư hỏng"]
    e1["E-damage-lifecycle-001 — ảnh hoặc dữ liệu lỗi"]
    x1["Tính phí — fine-collection-basic"]
    x2["Ghi nhận mất — lost-handling"]
    s1["Step-up thanh lý"]

    n1 -->|"Gửi báo cáo"| d1
    d1 -->|"Có"| n2
    d1 -->|"Không"| e1
    e1 -.->|"Sửa"| n1
    n2 -->|"Tính phí"| x1
    n2 -->|"Chuyển mất"| x2
    n2 -->|"Thanh lý"| s1
    s1 -.->|"Xác thực lại"| n2

    classDef happy fill:#d4edda,stroke:#28a745
    classDef error fill:#f8d7da,stroke:#dc3545
    classDef edge fill:#fff3cd,stroke:#ffc107
    class n1,n2 happy
    class e1 error
    class x1,x2,s1 edge
```

## 2. Danh sách màn hình

| [#] | Slug | Màn hình | Mục đích | Thuộc flow |
|-----|------|----------|----------|------------|
| 1 | damage-report-form | Biểu mẫu hư hỏng | Gửi báo cáo và 1–5 ảnh, cách ly bản sao. | damage-lifecycle-flow |
| 2 | damage-report-detail | Chi tiết hư hỏng | Duyệt disposition: sửa, tính phí, thanh lý, chuyển mất. | damage-lifecycle-flow |

## 3. Danh sách flow

| Flow-slug | Tên flow | Màn hình gồm |
|-----------|----------|--------------|
| damage-lifecycle-flow | Báo hư và duyệt | damage-report-form → damage-report-detail |

## 3.5. Chuyển màn (transitions)

Chuyển màn sang feature khác ghi bằng chữ khi đích chưa có wireframe; feature R0 dùng `../../{slug}/html-wireframe/`.

| Từ màn [#] | Đến màn [#] | Trigger | Điều kiện |
|-----------|------------|---------|-----------|
| Form [1] | Chi tiết [2] | Gửi hợp lệ | 1–5 ảnh, dữ liệu đủ |
| Form [1] | (giữ) [1] | Gửi | E-damage-lifecycle-001 |
| Chi tiết [2] | fine-collection-basic (chữ) | Tính phí | Sau duyệt |
| Chi tiết [2] | lost-handling (chữ) | Chuyển mất | Khi không sửa được |

## 4. Open Questions

- [ ] OQ-damage-lifecycle-001 — Ảnh lưu theo báo cáo hay quản lý như tệp đính kèm riêng, lưu giữ bao lâu? Owner: domain/tech.
- [ ] OQ-damage-lifecycle-002 — Mức phạt hư hỏng chính thức (mặc định nguồn 0%/30%/100%)? Owner: Thủ thư trưởng.
