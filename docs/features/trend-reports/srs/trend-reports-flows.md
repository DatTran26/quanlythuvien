---
type: srs-flows
feature: trend-reports
updated: 2026-10-08
---

# trend-reports — Flows

## Flow: Xem và xuất báo cáo xu hướng

**Trigger:** Quản trị viên mở báo cáo xu hướng. · **UC:** uc-trend-reports · **Release:** R2

```mermaid
flowchart TD
    Start(["Bắt đầu — mở dashboard báo cáo"]) --> Perm{"Là Quản trị viên?"}
    Perm -->|"không"| Deny["E-core-002 — từ chối"]
    Deny --> End(["Kết thúc"])
    Perm -->|"có"| Pick["Chọn RP-03, RP-05, RP-06 hoặc RP-07, chọn khoảng thời gian"]
    Pick --> Data{"Có dữ liệu?"}
    Data -->|"không"| Empty["Hiện trạng thái trống"]
    Data -->|"có"| Show["Hiện số liệu và khoảng dữ liệu thực có"]
    Show --> Export["Xuất Excel hoặc PDF nếu cần"]
    Export --> End
    Empty --> End
```
