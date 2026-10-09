---
type: srs-flows
feature: ops-foundation
updated: 2026-10-08
---

# ops-foundation — Flows

## Flow: Ghi audit trong giao dịch

```mermaid
flowchart TD
    AStart(["Bắt đầu — sensitive action"]) --> AWrite["Ghi AuditEvent cùng TX: actor, thời điểm, resource, trước sau, lý do"]
    AWrite --> AOk{"Audit ghi được?"}
    AOk -->|"có"| ACommit["Commit cả business write và audit"]
    ACommit --> ADone(["Kết thúc — đã ghi"])
    AOk -->|"không"| ARoll["Rollback business write — E-core-007 blocking + alert vận hành"]
    ARoll --> AEnd(["Kết thúc — hành động thất bại"])
```

### Bảng bước

| Bước | Actor | Quyết định / điều kiện | Phản hồi hệ thống | Error path |
|------|-------|------------------------|--------------------|------------|
| A1 | Hệ thống | Sensitive action (checkout, payment, disposition, lock, config, import) | AuditEvent trong cùng TX — fail thì business write fail (fail-closed) | E-core-007 — rollback + alert; không để sensitive action không audit |

## Flow: Backup hằng ngày và diễn tập khôi phục

**Trigger:** Lịch backup hằng ngày; lịch diễn tập trước go-live. · **UC:** uc-backup-restore · **Release:** R0

```mermaid
flowchart TD
    Start(["Bắt đầu — đến giờ backup hằng ngày"]) --> Run["Backup toàn bộ dữ liệu nghiệp vụ"]
    Run --> Ok{"Backup thành công?"}
    Ok -->|"không"| Alert["Giữ bản cũ, cảnh báo vận hành, chạy lại"]
    Alert --> Run
    Ok -->|"có"| Keep["Lưu bản mới, xóa bản cũ hơn bản thứ 30"]
    Keep --> Drill{"Đến lịch diễn tập khôi phục?"}
    Drill -->|"không"| End(["Kết thúc"])
    Drill -->|"có"| Restore["Khôi phục một bản vào môi trường thử"]
    Restore --> Match{"Dữ liệu khôi phục khớp?"}
    Match -->|"có"| Evidence["Ghi biên bản cho GATE-OPS"]
    Match -->|"không"| Fix["Sửa quy trình, diễn tập lại"]
    Fix --> Restore
    Evidence --> End
```
