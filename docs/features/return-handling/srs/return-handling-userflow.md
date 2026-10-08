---
type: srs-userflow
feature: return-handling
updated: 2026-10-09
primary_device: mobile
stage: flow-approved
flow_approved_at: 2026-10-09
flow_hash: "02beb005"
---
# Trả sách — User Flow

## 1. User Flow

### Flow: return-handling-flow — R1A

```mermaid
flowchart TD
    n1["[1] Quét trả sách"]
    d1{"Kết quả kiểm tra bản sao?"}
    n2["[2] Kết quả trả"]
    e1["E-core-008 — trạng thái không cho trả"]
    x1["Tiếp tục thu phạt — fine-collection-basic"]
    x2["Tiếp tục hư hỏng — damage-lifecycle"]
    x3["Tiếp tục mất — lost-handling"]

    n1 -->|"Quét bản sao"| d1
    d1 -->|"Trả bình thường"| n2
    d1 -->|"Quá hạn"| n2
    n2 -->|"Còn nợ phạt"| x1
    d1 -->|"Hư hỏng"| x2
    d1 -->|"Mất"| x3
    d1 -->|"Không hợp lệ"| e1
    e1 -.->|"Quét lại"| n1
    n2 -.->|"Trả cuốn tiếp"| n1

    classDef happy fill:#d4edda,stroke:#28a745
    classDef error fill:#f8d7da,stroke:#dc3545
    classDef edge fill:#fff3cd,stroke:#ffc107
    class n1,n2 happy
    class e1 error
    class x1,x2,x3 edge
```

## 2. Danh sách màn hình

| [#] | Slug | Màn hình | Mục đích | Thuộc flow |
|-----|------|----------|----------|------------|
| 1 | return-scan | Quét trả sách | Nhận diện bản sao đang mượn và kiểm tra trạng thái. | return-handling-flow |
| 2 | return-result | Kết quả trả | Đóng khoản mượn, báo quá hạn hoặc hướng ngoại lệ. | return-handling-flow |

## 3. Danh sách flow

| Flow-slug | Tên flow | Màn hình gồm |
|-----------|----------|--------------|
| return-handling-flow | Trả tại quầy | return-scan → return-result |

## 3.5. Chuyển màn (transitions)

Chuyển màn sang feature khác ghi bằng chữ khi đích chưa có wireframe; feature R0 dùng `../../{slug}/html-wireframe/`.

| Từ màn [#] | Đến màn [#] | Trigger | Điều kiện |
|-----------|------------|---------|-----------|
| Quét trả [1] | Kết quả [2] | Quét hợp lệ | Bản sao đang mượn |
| Quét trả [1] | (giữ) [1] | Quét | E-core-008 |
| Kết quả [2] | fine-collection-basic (chữ) | Còn nợ | Quá hạn đã ghi fine |
| Quét trả [1] | damage-lifecycle (chữ) | Phát hiện hư | Rẽ báo hư |
| Quét trả [1] | lost-handling (chữ) | Ghi nhận mất | Rẽ mất |

## 4. Open Questions

- [ ] OQ-return-handling-001 — Luồng trả dựng lại (DEC-D3-02) cần domain approver duyệt. Owner: Thủ thư trưởng.
