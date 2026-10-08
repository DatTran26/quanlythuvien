---
type: srs-userflow
feature: ops-reports
updated: 2026-10-09
primary_device: mobile
stage: flow-approved
flow_approved_at: 2026-10-09
flow_hash: "e38292b1"
---
# Báo cáo vận hành — User Flow

## 1. User Flow

### Flow: ops-reports-flow — R1A/R1B

```mermaid
flowchart TD
    n1["[1] Dashboard báo cáo"]
    d1{"Có quyền và có dữ liệu?"}
    r1["RP-01, RP-02, RP-04"]
    n2["[2] Danh sách quá hạn Thủ thư — R1B"]
    e1["E-core-002 — không có quyền"]
    empty["Empty — chưa có dữ liệu kỳ"]

    n1 -->|"Tải"| d1
    d1 -->|"Có quyền R1A"| r1
    d1 -->|"Empty"| empty
    d1 -->|"Không quyền"| e1
    empty -.->|"Đổi lọc"| n1
    n1 -->|"R1B"| n2

    classDef happy fill:#d4edda,stroke:#28a745
    classDef error fill:#f8d7da,stroke:#dc3545
    classDef edge fill:#fff3cd,stroke:#ffc107
    class n1,r1 happy
    class e1 error
    class n2,empty edge
```

## 2. Danh sách màn hình

| [#] | Slug | Màn hình | Mục đích | Thuộc flow |
|-----|------|----------|----------|------------|
| 1 | report-dashboard | Dashboard báo cáo | RP-01 tài khoản, RP-02 kho, RP-04 quá hạn; lọc; xuất Excel/PDF. | ops-reports-flow |
| 2 | overdue-list-staff | Danh sách quá hạn | R1B Thủ thư xem phiếu quá hạn để nhắc. | ops-reports-flow |

## 3. Danh sách flow

| Flow-slug | Tên flow | Màn hình gồm |
|-----------|----------|--------------|
| ops-reports-flow | Báo cáo vận hành | report-dashboard → overdue-list-staff |

## 3.5. Chuyển màn (transitions)

Chuyển màn sang feature khác ghi bằng chữ khi đích chưa có wireframe; feature R0 dùng `../../{slug}/html-wireframe/`.

| Từ màn [#] | Đến màn [#] | Trigger | Điều kiện |
|-----------|------------|---------|-----------|
| Dashboard [1] | (giữ) [1] | Tải RP-01/02/04 | Có quyền và có dữ liệu |
| Dashboard [1] | (giữ) [1] | Tải | Empty hoặc E-core-002 |
| Dashboard [1] | Quá hạn [2] | Mở danh sách Thủ thư | R1B |

## 4. Open Questions

- [ ] OQ-ops-reports-001 — Thủ thư quầy có quyền xem RP-01, RP-02, RP-04 không? Owner: domain approver.
- [ ] OQ-ops-reports-002 — Priority chính thức P0 (PRD) hay P1 (SRS cũ)? Owner: Product Owner.
