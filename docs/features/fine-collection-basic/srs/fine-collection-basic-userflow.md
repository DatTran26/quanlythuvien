---
type: srs-userflow
feature: fine-collection-basic
updated: 2026-10-09
primary_device: mobile
stage: flow-approved
flow_approved_at: 2026-10-09
flow_hash: "5b01872c"
---
# Thu phạt tiền mặt — User Flow

## 1. User Flow

### Flow: fine-collection-basic-flow — R1A

```mermaid
flowchart TD
    n1["[1] Danh sách công nợ"]
    n2["[2] Chi tiết công nợ"]
    n3["[3] Thanh toán tiền mặt"]
    d1{"Thu hợp lệ, chưa trùng?"}
    e1["E-fine-collection-basic-001 — số tiền không hợp lệ"]
    e2["E-fine-collection-basic-002 / E-core-005 — trùng giao dịch"]

    n1 -->|"Chọn khoản"| n2
    n2 -->|"Thu tiền mặt"| n3
    n3 -->|"Xác nhận"| d1
    d1 -->|"Có"| n2
    d1 -->|"Số không hợp lệ"| e1
    d1 -->|"Trùng"| e2
    e1 -.->|"Sửa số"| n3
    e2 -.->|"Xem kết quả gốc"| n2

    classDef happy fill:#d4edda,stroke:#28a745
    classDef error fill:#f8d7da,stroke:#dc3545
    classDef edge fill:#fff3cd,stroke:#ffc107
    class n1,n2,n3 happy
    class e1,e2 error
```

## 2. Danh sách màn hình

| [#] | Slug | Màn hình | Mục đích | Thuộc flow |
|-----|------|----------|----------|------------|
| 1 | fine-list | Danh sách công nợ | Tra cứu khoản phạt của người đọc. | fine-collection-basic-flow |
| 2 | fine-detail | Chi tiết công nợ | Số dư và hành động thu được phép. | fine-collection-basic-flow |
| 3 | fine-payment | Thanh toán tiền mặt | Ghi nhận thu tiền mặt idempotent. | fine-collection-basic-flow |

## 3. Danh sách flow

| Flow-slug | Tên flow | Màn hình gồm |
|-----------|----------|--------------|
| fine-collection-basic-flow | Thu tiền mặt | fine-list → fine-detail → fine-payment |

## 3.5. Chuyển màn (transitions)

Chuyển màn sang feature khác ghi bằng chữ khi đích chưa có wireframe; feature R0 dùng `../../{slug}/html-wireframe/`.

| Từ màn [#] | Đến màn [#] | Trigger | Điều kiện |
|-----------|------------|---------|-----------|
| Danh sách [1] | Chi tiết [2] | Chọn khoản | Luôn |
| Chi tiết [2] | Thu [3] | Thu tiền mặt | R1A |
| Thu [3] | Chi tiết [2] | Xác nhận | Idempotent thành công |
| Thu [3] | (giữ) [3] | Xác nhận | E-fine-collection-basic-001 |

## 4. Open Questions

- [ ] OQ-fine-collection-basic-001 — Có cho thu một phần không, giới hạn số lần (gắn OQ-fine-collection-adv-001)? Owner: finance.
