---
type: srs-flows
feature: fine-collection-basic
updated: 2026-10-08
---

# fine-collection-basic — Flows

## Flow: Thu tiền phạt và sự kiện tài chính


**Trigger:** Thu tiền mặt tại quầy; assess tự động khi đóng Loan; điều chỉnh có thẩm quyền. · **UC:** uc-fine-cash-payment · **Release:** R1A (assessment + thu tiền mặt tối thiểu — DEC-P2-04), R1B (biên nhận đầy đủ, waiver/adjustment/reversal/refund — DEC-D3-04)

**Nhãn:** Ledger append-only, PAYMENT do Thủ thư/Quản trị viên ghi, không sửa/xoá bút toán là FACT (BR-core-002, §7 nguồn). `receipt_no` unique, `RECONCILIATION` cuối ca, SoD waiver-vs-assessment, partial payment là PROPOSAL (DEC-D3-04/08, OQ-fine-collection-adv-001/OQ-fine-collection-adv-002). Ngưỡng nợ chặn mượn là Open (OQ-policy-config-001).

```mermaid
sequenceDiagram
    actor TT as "Thủ thư (quầy)"
    participant UI as "Màn hình phạt"
    participant BE as "Backend fine"
    participant DB as "Ledger + Database"
    participant OUT as "Audit + Outbox"

    TT->>UI: Mở danh sách Fine của reader
    UI->>BE: Đọc Fine + FinancialEvent — balance suy từ ledger
    BE-->>UI: Nghĩa vụ + số dư + trạng thái
    TT->>UI: Thu tiền mặt — submit kèm operation_id
    UI->>BE: POST payment — operation_id + số tiền
    BE->>DB: Tra idempotency key
    alt operation_id đã ghi — double-submit hoặc retry
        DB-->>BE: PAYMENT gốc + receipt_no
        BE-->>UI: E-fine-collection-basic-002 hoặc E-core-005 — trả biên nhận gốc, không ghi event mới
    else operation_id mới
        BE->>DB: BEGIN TX — append PAYMENT + receipt_no unique
        alt Ghi payment thất bại
            DB-->>BE: fail
            BE-->>UI: E-fine-collection-basic-001 — giữ nghĩa vụ, cho retry idempotent
        else Ghi thành công
            BE->>OUT: AuditEvent + notify event trong cùng TX
            BE->>DB: COMMIT — balance tính lại, về 0 thì Fine sang PAID
            BE-->>UI: 200 + biên nhận
        end
    end
    opt Điều chỉnh có thẩm quyền — R1B, PROPOSAL DEC-D3-04
        TT->>UI: Waiver, Adjustment, Reversal hoặc Refund + lý do bắt buộc
        UI->>BE: Kiểm quyền + segregation of duties
        alt Thiếu quyền hoặc vi phạm SoD
            BE-->>UI: E-core-002 hoặc E-core-009 — deny + audit access attempt
        else Hợp lệ
            BE->>DB: Append event mới — không sửa xoá event cũ
            BE->>OUT: audit cùng TX
            BE-->>UI: Balance mới tính lại từ ledger
        end
    end
```

### Bảng bước F6

| Bước | Actor | Quyết định / điều kiện | Phản hồi hệ thống | Error path |
|------|-------|------------------------|--------------------|------------|
| 1 | Thủ thư/Quản trị viên | Mở fine list/detail của reader | `balance` suy từ Σ events (INV-06); hiển thị ledger | E-core-009 — field tài chính mask khi thiếu quyền |
| 2 | Thủ thư/Quản trị viên | Thu tiền mặt + `operation_id` | Append `PAYMENT` + `receipt_no` unique (AT-FIN-02) | E-fine-collection-basic-001 — ghi payment fail → giữ nghĩa vụ, retry idempotent; mất kết nối sau confirm → query-by-operation trả biên nhận gốc (§6.4) |
| 3 | Hệ thống | Replay `operation_id` | Trả PAYMENT gốc — không event thứ hai | E-fine-collection-basic-002/E-core-005 (INV-03) |
| 4 | Hệ thống | Sau commit | Balance tính lại; `=0` → Fine `PAID` (không có trạng thái `PARTIALLY_PAID` — partial là PAYMENT < balance, PROPOSAL DEC-D3-04) | Audit fail → E-core-007 rollback |
| 5 | Thủ thư (R1B) | Waiver/Adjustment/Reversal/Refund — lý do + thẩm quyền + SoD | Append event; sai sót sửa bằng `REVERSAL` trỏ event gốc; Fine đã đóng **không reopen** — dư âm xử lý bằng `REFUND` + reconcile | E-core-002/E-core-009 — deny + audit attempt |
| 6 | Thủ thư/Hệ thống | Đối soát thu ngân cuối ca (PROPOSAL DEC-D3-08) | `RECONCILIATION` event; job đối chiếu `balance` vs Σ events → lệch thì cảnh báo | Lệch → cảnh báo vận hành, không tự sửa ledger |

**Liên kết:** FR-overdue-fines-001, FR-fine-collection-basic-001, FR-fine-collection-adv-002, FR-ops-foundation-001 · BR-core-002, BR-fine-collection-basic-001, BR-core-003 · transitions: Fine `UNPAID→PAID/WAIVED` (suy từ event) · AT-FIN-01..04 · DEC-P2-04, DEC-D3-04/05/08 · OQ-fine-collection-adv-001/OQ-fine-collection-adv-002/OQ-policy-config-001.
