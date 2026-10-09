---
type: srs-userflow
feature: checkout
updated: 2026-10-09
primary_device: mobile
stage: flow-approved
flow_approved_at: 2026-10-09
flow_hash: "57f70e31"
---
# Mượn tại quầy — User Flow

## 1. User Flow

### Flow: checkout-flow — R1A

```mermaid
flowchart TD
    n1["[1] Quầy lưu thông"]
    n2["[2] Quét người đọc và bản sao"]
    n3["[3] Rà soát mượn"]
    d1{"Người đọc đủ điều kiện?"}
    d2{"Bản sao hợp lệ để mượn?"}
    d3{"Commit nguyên tử thành công?"}
    n4["[4] Xung đột checkout"]
    ok1["Biên nhận trên màn hình"]
    e1["E-core-006 — khóa, quá hạn, vượt 5 cuốn, nợ từ 50.000đ"]
    e2["E-checkout-001 — loại cuốn lỗi, giữ giỏ hợp lệ"]
    e3["E-core-003 — mã không tìm thấy"]

    n1 -->|"Bắt đầu mượn"| n2
    n2 -->|"Locate reader"| d1
    d1 -->|"Không"| e1
    e1 -.->|"Khắc phục hoặc đổi người đọc"| n2
    d1 -->|"Có"| d2
    d2 -->|"Không"| e2
    e2 -.->|"Quét cuốn khác"| n2
    n2 -->|"Mã không tồn tại"| e3
    e3 -.->|"Quét hoặc nhập lại"| n2
    d2 -->|"Giỏ hợp lệ"| n3
    n3 -->|"Xác nhận"| d3
    d3 -->|"Có"| ok1
    d3 -->|"Conflict E-core-004"| n4
    n4 -.->|"Tải trạng thái mới"| n3
    ok1 -.->|"Giao dịch mới"| n1

    classDef happy fill:#d4edda,stroke:#28a745
    classDef error fill:#f8d7da,stroke:#dc3545
    classDef edge fill:#fff3cd,stroke:#ffc107
    class n1,n2,n3,ok1 happy
    class e1,e2,e3 error
    class n4 edge
```

## 2. Danh sách màn hình

| [#] | Slug | Màn hình | Mục đích | Thuộc flow |
|-----|------|----------|----------|------------|
| 1 | circulation-desk | Quầy lưu thông | Điểm vào mượn tại quầy. | checkout-flow |
| 2 | checkout-scan | Quét checkout | Quét thẻ và từng bản sao, kiểm tra D1/D2 ngay. | checkout-flow |
| 3 | checkout-review | Rà soát mượn | Xác nhận giỏ, commit nguyên tử, hiện biên nhận. | checkout-flow |
| 4 | checkout-conflict | Xung đột checkout | Hai quầy tranh bản sao — tải lại an toàn. | checkout-flow |

## 3. Danh sách flow

| Flow-slug | Tên flow | Màn hình gồm |
|-----------|----------|--------------|
| checkout-flow | Mượn tại quầy | circulation-desk → checkout-scan → checkout-review → checkout-conflict |

## 3.5. Chuyển màn (transitions)

Chuyển màn sang feature khác ghi bằng chữ khi đích chưa có wireframe; feature R0 dùng `../../{slug}/html-wireframe/`.

| Từ màn [#] | Đến màn [#] | Trigger | Điều kiện |
|-----------|------------|---------|-----------|
| Quầy [1] | Quét [2] | Bắt đầu mượn | Luôn |
| Quét [2] | (giữ) [2] | Locate reader | E-core-006 hoặc E-core-003 |
| Quét [2] | Rà soát [3] | Giỏ hợp lệ | D1 và D2 đạt |
| Rà soát [3] | Xung đột [4] | Xác nhận | E-core-004 |
| Xung đột [4] | Rà soát [3] | Tải lại | Luôn |
| Rà soát [3] | Quầy [1] | Commit thành công | Hiện biên nhận trên màn; in — OQ-checkout-001 |

## 4. Open Questions

- [ ] OQ-checkout-001 — Khổ giấy và loại máy in biên nhận tại quầy? Owner: vận hành.
