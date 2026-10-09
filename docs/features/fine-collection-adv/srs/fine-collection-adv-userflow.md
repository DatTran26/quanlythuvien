---
type: srs-userflow
feature: fine-collection-adv
updated: 2026-10-09
primary_device: mobile
stage: flow-approved
flow_approved_at: 2026-10-09
flow_hash: "2f2e8573"
---
# Thu phạt nâng cao — User Flow

## 1. User Flow

### Flow: fine-adv-flow — R1B

```mermaid
flowchart TD
    n1["[1] Sự kiện tài chính"]
    n2["[2] Miễn / điều chỉnh / hoàn"]
    n3["[3] Biên nhận thu phạt"]
    d1{"Step-up và quyền hợp lệ?"}
    e1["E-core-002 / audit fail"]

    n1 -->|"Tác vụ nâng cao"| n2
    n2 -->|"Xác thực lại"| d1
    d1 -->|"Có"| n3
    d1 -->|"Không"| e1
    e1 -.->|"Hủy"| n1
    n3 -.->|"Quay ledger"| n1

    classDef happy fill:#d4edda,stroke:#28a745
    classDef error fill:#f8d7da,stroke:#dc3545
    classDef edge fill:#fff3cd,stroke:#ffc107
    class n1,n3 happy
    class e1 error
    class n2 edge
```

## 2. Danh sách màn hình

| [#] | Slug | Màn hình | Mục đích | Thuộc flow |
|-----|------|----------|----------|------------|
| 1 | financial-events | Sự kiện tài chính | Ledger khoản phạt và sự kiện thu/miễn/điều chỉnh. | fine-adv-flow |
| 2 | fine-adjust | Miễn điều chỉnh hoàn | Step-up re-auth cho waiver/adjustment/refund. | fine-adv-flow |
| 3 | fine-receipt | Biên nhận thu phạt | R1B loại biên nhận thu phạt. | fine-adv-flow |

## 3. Danh sách flow

| Flow-slug | Tên flow | Màn hình gồm |
|-----------|----------|--------------|
| fine-adv-flow | Tài chính nâng cao | financial-events → fine-adjust → fine-receipt |

## 3.5. Chuyển màn (transitions)

Chuyển màn sang feature khác ghi bằng chữ khi đích chưa có wireframe; feature R0 dùng `../../{slug}/html-wireframe/`.

| Từ màn [#] | Đến màn [#] | Trigger | Điều kiện |
|-----------|------------|---------|-----------|
| Ledger [1] | Điều chỉnh [2] | Tác vụ R1B | Cần step-up |
| Điều chỉnh [2] | Biên nhận [3] | Duyệt thành công | Quyền và re-auth |
| Điều chỉnh [2] | Ledger [1] | Thất bại | E-core-002 |

## 4. Open Questions

- [ ] OQ-fine-collection-adv-001 — Thu một phần, miễn, điều chỉnh, đảo, hoàn: chính sách và quyền? Owner: finance.
- [ ] OQ-fine-collection-adv-002 — Ai duyệt khi đối soát lệch và ngưỡng duyệt cấp cao? Owner: finance.
- [ ] OQ-fine-collection-adv-003 — Mẫu biên nhận thu phạt? Owner: vận hành.
