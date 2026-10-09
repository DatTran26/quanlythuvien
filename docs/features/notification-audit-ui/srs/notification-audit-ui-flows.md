---
type: srs-flows
feature: notification-audit-ui
updated: 2026-10-08
---

# notification-audit-ui — Flows

## Flow: Trung tâm thông báo và tra cứu nhật ký

**Trigger:** Người dùng mở trung tâm thông báo hoặc nhật ký. · **UC:** uc-notification-audit-view · **Release:** R1B

```mermaid
flowchart TD
    Start(["Bắt đầu"]) --> Which{"Mở gì?"}
    Which -->|"trung tâm thông báo"| List["Danh sách thông báo của chính mình, mới nhất trước"]
    List --> Open["Mở thông báo, đánh dấu đã đọc"]
    Open --> End(["Kết thúc"])
    Which -->|"nhật ký audit"| Perm{"Là Quản trị viên?"}
    Perm -->|"không"| Deny["E-core-002 — từ chối, ghi audit"]
    Deny --> End
    Perm -->|"có"| Filter["Lọc theo người làm, đối tượng, thời gian"]
    Filter --> Mask["Che trường nhạy cảm theo quyền"]
    Mask --> Timeline["Mở dòng thời gian lịch sử của đối tượng"]
    Timeline --> End
```
