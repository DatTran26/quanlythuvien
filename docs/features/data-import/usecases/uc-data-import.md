---
type: usecase
feature: data-import
status: draft
updated: 2026-10-12
links:
  - docs/features/data-import/usecases/data-import-usecase-index.md
  - docs/features/data-import/srs/data-import-spec.md
  - docs/_shared/domain/lifecycle-inventory.md
---

# Use Case: Import dữ liệu ban đầu và đối soát (uc-data-import)

> Scope: data-import · Level: sea
> Screens: `import-upload`, `import-report` · Release: import + đối soát + cấu hình **R0** (CAP-IMPORT/CAP-POLICY — DEC-P2-09); báo cáo vận hành RP-01/02/04 **R1A**, báo cáo xu hướng RP-03/05/06/07 **R2** (FR-ops-reports-001).
>
> **External blocker:** file Excel đại diện chưa có — OQ-data-import-001 (owner: data owner/Thủ thư trưởng, gate GATE-MIG; DEC-P2-09 hard-stop). UC này **không suy đoán schema**; mọi validation chi tiết theo cột chỉ định nghĩa khi có representative source.

## Primary Actor

Thủ thư (cấu hình PolicyConfig, chạy import, xem báo cáo — FR-policy-config-001/FR-data-import-001/FR-ops-reports-001; FACT ma trận nguồn §2/§9 theo mapping spec §2) · Nhân viên (quầy) (đối soát vật lý sau import — FACT baseline §5.1; xem báo cáo vận hành — **PROPOSAL (lệch ma trận quyền nguồn §2)**: nguồn §9 chỉ cấp báo cáo cho `Thủ thư` nguồn, lý do: quầy cần số liệu vận hành hằng ngày — chờ chốt)

## Stakeholders & Interests

| Stakeholder | Interest |
|-------------|----------|
| Data owner / Thủ thư trưởng | Cung cấp file Excel đại diện và xác nhận mapping (OQ-data-import-001 — external blocker, không có evidence thì GATE-MIG fail); chịu trách nhiệm chất lượng dữ liệu nguồn |
| Nhân viên (quầy) | Dán nhãn QR và quét đối soát vật lý sau import (baseline §5.1 bước 4); dữ liệu sạch để quầy vận hành được |
| Bảo mật/vận hành | Import và đổi cấu hình là sensitive action — audit cùng transaction; quyền deny mặc định; không commit dữ liệu nhập dở (baseline §6.4) |
| Product owner | Giá trị mặc định của tham số nghiệp vụ là **Open** (OQ-policy-config-001/OQ-04); override commit khi dry-run chưa pass cần approver (BR-data-import-001 — PROPOSAL) |

## Trigger

- Thủ thư tải file dữ liệu ban đầu tại `import-upload` (đầu sách, bản sao, vị trí — phạm vi theo file đại diện khi có).
- Thủ thư chỉnh tham số nghiệp vụ tại `admin-config` (hạn mượn, số lần gia hạn, hạn giữ chỗ, vai trò, kênh thông báo — FR-policy-config-001).
- Thủ thư mở `report-dashboard` xem báo cáo vận hành (FR-ops-reports-001); Nhân viên quầy xem báo cáo theo PROPOSAL ở Primary Actor.

## Preconditions

- Actor đã xác thực, vai trò Thủ thư (import/cấu hình/báo cáo — FACT nguồn §9) hoặc Nhân viên quầy (đối soát vật lý; xem báo cáo — PROPOSAL lệch ma trận, xem Primary Actor) — deny mặc định (BR-core-004); include uc-access-control.
- File nguồn đọc được và thuộc phạm vi đã định nghĩa; **schema mapping chỉ tồn tại sau khi OQ-data-import-001 resolved** — không bịa cột/định dạng.
- Audit sink khả dụng; môi trường R0 (chưa có giao dịch mượn–trả) cho import ban đầu.
- Với commit khi dry-run chưa pass: override phải có approver được phê duyệt (BR-data-import-001 — PROPOSAL, approver cụ thể là Open).

## Guarantees

- **Minimal Guarantee:** Dry-run **không ghi** dữ liệu nghiệp vụ (baseline §5.1); commit fail ở bất kỳ dòng nào → rollback **toàn batch**, không để dữ liệu nhập dở (E-data-import-001); mọi lỗi được báo theo dòng (NFR-data-import-001); mọi thao tác có audit.
- **Success Guarantee:** Batch commit chỉ khi dry-run pass hoặc override approved; reconciliation report đối chiếu số lượng / bản ghi lỗi / bản ghi bỏ qua (BR-data-import-001) và sai lệch kho vật lý ≤ ngưỡng target (≤1% — baseline §10, GATE-MIG); cấu hình mới chỉ áp dụng cho giao dịch bắt đầu sau thời điểm hiệu lực (baseline §6.5).

## Main Success Scenario

Luồng theo baseline §5.1: `Excel thật → Dry-run → Danh sách lỗi → Làm sạch → Import → Sinh QR → Dán nhãn → Đối soát`.

1. Thủ thư mở `import-upload`, chọn file Excel nguồn; hệ thống kiểm tra file đọc được/đúng định dạng tổng quát và tạo `ImportBatch` ở trạng thái dry-run (E-data-import-001 nếu sai format — extension 1a).
2. Hệ thống chạy **dry-run**: parse từng dòng, validate theo rule đã định nghĩa (mã nhận diện, trạng thái hợp lệ, trùng — chi tiết schema chờ OQ-data-import-001), ghi `ImportIssue` **theo dòng**; không ghi bảng nghiệp vụ.
3. `import-report` hiển thị kết quả dry-run: tổng dòng, số hợp lệ, số lỗi (kèm dòng + lý do), số trùng, số bỏ qua.
4. Thủ thư sửa file nguồn và chạy lại dry-run cho tới khi đạt (hoặc xin override — extension 4a).
5. Thủ thư xác nhận **commit batch**: hệ thống ghi toàn bộ bản ghi hợp lệ trong một transaction theo batch; thất bại → rollback toàn batch (extension 5a). Audit `ImportBatch` + kết quả.
6. Sau commit: hệ thống sinh QR cho bản sao mới; Nhân viên (quầy) dán nhãn và quét **đối soát vật lý** khớp hệ thống (baseline §5.1 — FACT).
7. Hệ thống xuất **reconciliation report**: số lượng ghi nhận vs nguồn, bản ghi lỗi, bản ghi bỏ qua, kết quả đối soát vật lý (BR-data-import-001, NFR-data-import-001); GATE-MIG đạt khi dry-run chỉ rõ 100% lỗi và đối soát khớp trong ngưỡng (≤1% target — PROPOSAL).

## Extensions

**1a. File sai format/không đọc được (E-data-import-001):**
- 1a1. Batch kết thúc sớm ở trạng thái lỗi; cho tải file sửa hoặc đổi file; không tạo `ImportIssue` nghiệp vụ ngoài ghi nhận lỗi file.

**1b. Batch trùng (cùng checksum/operation key — E-core-005):**
- 1b1. Upload lặp cùng file (checksum trùng) hoặc retry cùng `operation_id` → hệ thống trả về `ImportBatch` **gốc** với trạng thái hiện tại (dry-run/committed/failed), không tạo batch thứ hai — idempotent theo operation key (PROPOSAL, pattern AT-CHK-02).
- 1b2. File **khác checksum** nhưng trùng tên → coi là batch mới; hiển thị cảnh báo khác-nội-dung để actor xác nhận.

**2a. Dòng dữ liệu lỗi/trùng (E-data-import-001, NFR-data-import-001):**
- 2a1. Mỗi dòng lỗi → một `ImportIssue` có số dòng + lý do + giá trị vi phạm (ẩn giá trị nhạy cảm theo quyền — E-core-009).
- 2a2. Commit bị chặn khi còn lỗi chưa xử lý trừ khi override approved (BR-data-import-001). 100% bản ghi lỗi/trùng phải được chỉ rõ trước khi ghi chính thức (baseline §10 — FACT).

**4a. Override commit khi dry-run chưa pass (PROPOSAL — BR-data-import-001):**
- 4a1. Hệ thống yêu cầu approver có thẩm quyền (Open — ai approve chưa chốt); ghi rõ lý do override + số dòng lỗi chấp nhận vào `ImportBatch` + audit.
- 4a2. Actor không có quyền override → E-core-002, audit denial.

**5a. Commit thất bại giữa batch (E-data-import-001):**
- 5a1. Rollback **toàn batch** (import có rollback theo batch — roadmap R0 rollback boundary); batch ghi trạng thái failed + lỗi; không để dữ liệu nhập dở.
- 5a2. Sửa nguồn/dữ liệu xung đột và chạy lại dry-run → commit mới.

**5b. Đã có một import batch đang in-progress (E-core-004):**
- 5b1. Rule: chỉ **một** `ImportBatch` ở trạng thái in-progress (dry-run đang chạy/commit đang xử lý) tại một thời điểm — chống commit chồng chéo ghi cùng danh mục/bản sao (PROPOSAL). Actor bắt đầu batch mới khi batch khác còn in-progress → từ chối E-core-004 + hiển thị batch đang chạy và owner.
- 5b2. Recovery: đợi batch hiện tại kết thúc hoặc hủy batch đó (Thủ thư có quyền hủy batch in-progress — lý do + audit); sau đó tạo batch mới.

**5c. Mất phản hồi sau khi xác nhận commit (client không nhận được kết quả):**
- 5c1. Query-by-operation recovery như AT-CHK-02: client tra lại batch theo `operation_id` → nhận trạng thái thật (committed/failed/in-progress); **không** tự động tạo batch/commit mới vì có thể nhân đôi dữ liệu.
- 5c2. Nếu batch đã commit → trả kết quả gốc (idempotent, E-core-005); nếu failed → hiển thị lỗi và cho chạy lại qua dry-run mới.

**7a. Reconcile lệch (E-data-import-001):**
- 7a1. Báo cáo lệch: số bản ghi hệ thống ≠ số kiểm đếm vật lý hoặc lệch vs nguồn → hiển thị danh sách chênh; **không auto-fix** (PROPOSAL) — thủ thư quyết định điều chỉnh thủ công có audit hoặc re-import.
- 7a2. Sai lệch vượt ngưỡng target (≤1% — PROPOSAL) → GATE-MIG chưa đạt, chặn entry R1A.

## Related Requirements

- FR: FR-data-import-001.
- NFR: NFR-data-import-001.
- BR: BR-data-import-001; dùng chung BR-core-003.
- Errors: E-data-import-001; dùng chung E-core-002, E-core-004, E-core-005, E-core-007, E-core-009.
- Open: OQ-data-import-001 (external blocker GATE-MIG), OQ-data-import-002, OQ-data-import-003.
- UC liên quan: `uc-access-control` (include), `uc-copy-inventory` (sinh QR sau import), `uc-audit-capture` (include).
