---
type: srs-flows
feature: fine-collection-adv
updated: 2026-10-08
---

# fine-collection-adv — Flows

## Flow: Miễn, điều chỉnh, đảo, hoàn và đối soát cuối ca

**Trigger:** Quản trị viên xử lý ngoại lệ tài chính; kết thúc ca. · **UC:** uc-fine-adjustment · **Release:** R1B

```mermaid
flowchart TD
    Start(["Bắt đầu — mở sổ sự kiện tài chính"]) --> Pick["Chọn miễn, điều chỉnh, đảo hoặc hoàn, nhập số tiền và lý do"]
    Pick --> Reason{"Có lý do?"}
    Reason -->|"không"| Err1["E-core-001 — báo thiếu lý do"]
    Err1 --> Pick
    Reason -->|"có"| StepUp{"Xác thực lại thành công?"}
    StepUp -->|"không"| Cancel["Hủy thao tác"]
    StepUp -->|"có"| Perm{"Có quyền và không phải người tạo khoản?"}
    Perm -->|"không"| Deny["E-core-002 — từ chối, ghi audit"]
    Perm -->|"có"| Limit{"Vượt ngưỡng cần duyệt cấp cao?"}
    Limit -->|"có"| Wait["Chờ người duyệt"]
    Limit -->|"không"| Write["Ghi sự kiện mới và audit trong một giao dịch"]
    Write --> Zero{"Số dư về 0 sau miễn?"}
    Zero -->|"có"| Close["Khoản phạt Đã miễn"]
    Zero -->|"không"| End(["Kết thúc"])
    Close --> End
    Cancel --> End
    Deny --> End
    Wait --> End
    Shift(["Bắt đầu — cuối ca"]) --> Count["Thủ thư nhập tiền mặt thực có"]
    Count --> Match{"Khớp tổng khoản thu của ca?"}
    Match -->|"có"| EndShift(["Kết thúc — đóng ca"])
    Match -->|"không"| Recon["Ghi sự kiện đối soát, cảnh báo vận hành"]
    Recon --> EndShift
```
