---
type: srs-flows
feature: data-import
updated: 2026-10-12
---

# data-import — Flows

## Flow: Import và đối soát

```mermaid
flowchart TD
    IStart(["Bắt đầu — upload file đại diện"]) --> IDry["Dry-run — validate staging, báo lỗi và trùng theo dòng"]
    IDry --> IPass{"Dry-run pass hoặc override được duyệt?"}
    IPass -->|"chưa pass"| IErr["E-data-import-001 — import report lỗi, sửa file rồi dry-run lại, không commit"]
    IErr --> IDry
    IPass -->|"pass"| ICommit["Commit batch — rollback được theo batch + audit"]
    ICommit --> IRecon{"Đối soát — số lượng, lỗi, bỏ qua khớp?"}
    IRecon -->|"lệch"| IMis["E-data-import-001 — reconciliation report, xử lý lệch"]
    IMis --> IEndX(["Kết thúc — chờ xử lý"])
    IRecon -->|"khớp"| IDone(["Kết thúc — import hoàn tất"])
```

### Bảng bước

| Bước | Actor | Quyết định / điều kiện | Phản hồi hệ thống | Error path |
|------|-------|------------------------|--------------------|------------|
| I1 | Thủ thư | Upload file import đại diện (schema Open OQ-data-import-001) | Staging + validate: mã nhận diện, trạng thái hợp lệ, lỗi/trùng theo dòng | E-data-import-001 — file sai format/dòng lỗi → báo theo dòng, không commit |
| I2 | Hệ thống | Dry-run | Pass hoặc override được duyệt (BR-data-import-001) mới cho commit | Chưa pass → chỉ báo cáo, rollback toàn batch nếu lỗi giữa chừng — không để dữ liệu nhập dở (§6.4) |
| I3 | Hệ thống | Commit batch + reconciliation | Đối chiếu số lượng, bản ghi lỗi, bản ghi bỏ qua | E-data-import-001 — reconcile lệch → report, xử lý trước GATE-MIG |
