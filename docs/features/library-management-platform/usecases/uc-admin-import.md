---
type: usecase
feature: library-management-platform
status: draft
updated: 2026-10-05
links:
  - docs/features/library-management-platform/usecases/library-management-platform-usecase-index.md
  - docs/features/library-management-platform/srs/library-management-platform-spec.md
  - docs/features/library-management-platform/brainstorms/product-roadmap-baseline.md
  - docs/_product/decision-register.md
---

# Use Case: Cấu hình nghiệp vụ, import dữ liệu ban đầu và báo cáo vận hành (uc-admin-import)

> Scope: library-management-platform · Level: sea
> Screens: `admin-config`, `import-upload`, `import-report`, `report-dashboard` · Release: import + đối soát + cấu hình **R0** (CAP-IMPORT/CAP-POLICY — DEC-P2-09); báo cáo vận hành RP-01/02/04 **R1A**, báo cáo xu hướng RP-03/05/06/07 **R2** (FR-LMP-023).
>
> **External blocker:** file Excel đại diện chưa có — OQ-LMP-002 (owner: data owner/Thủ thư trưởng, gate GATE-MIG; DEC-P2-09 hard-stop). UC này **không suy đoán schema**; mọi validation chi tiết theo cột chỉ định nghĩa khi có representative source.

## Primary Actor

Quản trị viên (cấu hình PolicyConfig, chạy import, xem báo cáo — FR-LMP-021/022/023; FACT ma trận nguồn §2/§9 theo mapping spec §2) · Thủ thư (quầy) (đối soát vật lý sau import — FACT baseline §5.1; xem báo cáo vận hành — **PROPOSAL (lệch ma trận quyền nguồn §2)**: nguồn §9 chỉ cấp báo cáo cho `Thủ thư` nguồn = Quản trị viên, lý do: quầy cần số liệu vận hành hằng ngày — chờ chốt)

## Stakeholders & Interests

| Stakeholder | Interest |
|-------------|----------|
| Data owner / Thủ thư trưởng | Cung cấp file Excel đại diện và xác nhận mapping (OQ-LMP-002 — external blocker, không có evidence thì GATE-MIG fail); chịu trách nhiệm chất lượng dữ liệu nguồn |
| Thủ thư (quầy) | Dán nhãn QR và quét đối soát vật lý sau import (baseline §5.1 bước 4); dữ liệu sạch để quầy vận hành được |
| Bảo mật/vận hành | Import và đổi cấu hình là sensitive action — audit cùng transaction; quyền deny mặc định; không commit dữ liệu nhập dở (baseline §6.4) |
| Product owner | Giá trị mặc định của tham số nghiệp vụ là **Open** (OQ-LMP-010/OQ-04); override commit khi dry-run chưa pass cần approver (BR-LMP-014 — PROPOSAL) |

## Trigger

- Quản trị viên tải file dữ liệu ban đầu tại `import-upload` (đầu sách, bản sao, vị trí — phạm vi theo file đại diện khi có).
- Quản trị viên chỉnh tham số nghiệp vụ tại `admin-config` (hạn mượn, số lần gia hạn, hạn giữ chỗ, vai trò, kênh thông báo — FR-LMP-021).
- Quản trị viên mở `report-dashboard` xem báo cáo vận hành (FR-LMP-023); Thủ thư quầy xem báo cáo theo PROPOSAL ở Primary Actor.

## Preconditions

- Actor đã xác thực, vai trò Quản trị viên (import/cấu hình/báo cáo — FACT nguồn §9) hoặc Thủ thư quầy (đối soát vật lý; xem báo cáo — PROPOSAL lệch ma trận, xem Primary Actor) — deny mặc định (BR-LMP-015); include uc-access-control.
- File nguồn đọc được và thuộc phạm vi đã định nghĩa; **schema mapping chỉ tồn tại sau khi OQ-LMP-002 resolved** — không bịa cột/định dạng.
- Audit sink khả dụng; môi trường R0 (chưa có giao dịch mượn–trả) cho import ban đầu.
- Với commit khi dry-run chưa pass: override phải có approver được phê duyệt (BR-LMP-014 — PROPOSAL, approver cụ thể là Open).

## Guarantees

- **Minimal Guarantee:** Dry-run **không ghi** dữ liệu nghiệp vụ (baseline §5.1); commit fail ở bất kỳ dòng nào → rollback **toàn batch**, không để dữ liệu nhập dở (E-LMP-014); mọi lỗi được báo theo dòng (NFR-LMP-011); mọi thao tác có audit.
- **Success Guarantee:** Batch commit chỉ khi dry-run pass hoặc override approved; reconciliation report đối chiếu số lượng / bản ghi lỗi / bản ghi bỏ qua (BR-LMP-014) và sai lệch kho vật lý ≤ ngưỡng target (≤1% — baseline §10, GATE-MIG); cấu hình mới chỉ áp dụng cho giao dịch bắt đầu sau thời điểm hiệu lực (baseline §6.5).

## Main Success Scenario

Luồng theo baseline §5.1: `Excel thật → Dry-run → Danh sách lỗi → Làm sạch → Import → Sinh QR → Dán nhãn → Đối soát`.

1. Quản trị viên mở `import-upload`, chọn file Excel nguồn; hệ thống kiểm tra file đọc được/đúng định dạng tổng quát và tạo `ImportBatch` ở trạng thái dry-run (E-LMP-014 nếu sai format — extension 1a).
2. Hệ thống chạy **dry-run**: parse từng dòng, validate theo rule đã định nghĩa (mã nhận diện, trạng thái hợp lệ, trùng — chi tiết schema chờ OQ-LMP-002), ghi `ImportIssue` **theo dòng**; không ghi bảng nghiệp vụ.
3. `import-report` hiển thị kết quả dry-run: tổng dòng, số hợp lệ, số lỗi (kèm dòng + lý do), số trùng, số bỏ qua.
4. Quản trị viên sửa file nguồn và chạy lại dry-run cho tới khi đạt (hoặc xin override — extension 4a).
5. Quản trị viên xác nhận **commit batch**: hệ thống ghi toàn bộ bản ghi hợp lệ trong một transaction theo batch; thất bại → rollback toàn batch (extension 5a). Audit `ImportBatch` + kết quả.
6. Sau commit: hệ thống sinh QR cho bản sao mới; Thủ thư (quầy) dán nhãn và quét **đối soát vật lý** khớp hệ thống (baseline §5.1 — FACT).
7. Hệ thống xuất **reconciliation report**: số lượng ghi nhận vs nguồn, bản ghi lỗi, bản ghi bỏ qua, kết quả đối soát vật lý (BR-LMP-014, NFR-LMP-011); GATE-MIG đạt khi dry-run chỉ rõ 100% lỗi và đối soát khớp trong ngưỡng (≤1% target — PROPOSAL).

## Extensions

**1a. File sai format/không đọc được (E-LMP-014):**
- 1a1. Batch kết thúc sớm ở trạng thái lỗi; cho tải file sửa hoặc đổi file; không tạo `ImportIssue` nghiệp vụ ngoài ghi nhận lỗi file.

**1b. Batch trùng (cùng checksum/operation key — E-LMP-006):**
- 1b1. Upload lặp cùng file (checksum trùng) hoặc retry cùng `operation_id` → hệ thống trả về `ImportBatch` **gốc** với trạng thái hiện tại (dry-run/committed/failed), không tạo batch thứ hai — idempotent theo operation key (PROPOSAL, pattern AT-CHK-02).
- 1b2. File **khác checksum** nhưng trùng tên → coi là batch mới; hiển thị cảnh báo khác-nội-dung để actor xác nhận.

**2a. Dòng dữ liệu lỗi/trùng (E-LMP-014, NFR-LMP-011):**
- 2a1. Mỗi dòng lỗi → một `ImportIssue` có số dòng + lý do + giá trị vi phạm (ẩn giá trị nhạy cảm theo quyền — E-LMP-016).
- 2a2. Commit bị chặn khi còn lỗi chưa xử lý trừ khi override approved (BR-LMP-014). 100% bản ghi lỗi/trùng phải được chỉ rõ trước khi ghi chính thức (baseline §10 — FACT).

**4a. Override commit khi dry-run chưa pass (PROPOSAL — BR-LMP-014):**
- 4a1. Hệ thống yêu cầu approver có thẩm quyền (Open — ai approve chưa chốt); ghi rõ lý do override + số dòng lỗi chấp nhận vào `ImportBatch` + audit.
- 4a2. Actor không có quyền override → E-LMP-002, audit denial.

**5a. Commit thất bại giữa batch (E-LMP-014):**
- 5a1. Rollback **toàn batch** (import có rollback theo batch — roadmap R0 rollback boundary); batch ghi trạng thái failed + lỗi; không để dữ liệu nhập dở.
- 5a2. Sửa nguồn/dữ liệu xung đột và chạy lại dry-run → commit mới.

**5b. Đã có một import batch đang in-progress (E-LMP-005):**
- 5b1. Rule: chỉ **một** `ImportBatch` ở trạng thái in-progress (dry-run đang chạy/commit đang xử lý) tại một thời điểm — chống commit chồng chéo ghi cùng danh mục/bản sao (PROPOSAL). Actor bắt đầu batch mới khi batch khác còn in-progress → từ chối E-LMP-005 + hiển thị batch đang chạy và owner.
- 5b2. Recovery: đợi batch hiện tại kết thúc hoặc hủy batch đó (Quản trị viên có quyền hủy batch in-progress — lý do + audit); sau đó tạo batch mới.

**5c. Mất phản hồi sau khi xác nhận commit (client không nhận được kết quả):**
- 5c1. Query-by-operation recovery như AT-CHK-02: client tra lại batch theo `operation_id` → nhận trạng thái thật (committed/failed/in-progress); **không** tự động tạo batch/commit mới vì có thể nhân đôi dữ liệu.
- 5c2. Nếu batch đã commit → trả kết quả gốc (idempotent, E-LMP-006); nếu failed → hiển thị lỗi và cho chạy lại qua dry-run mới.

**7a. Reconcile lệch (E-LMP-014):**
- 7a1. Báo cáo lệch: số bản ghi hệ thống ≠ số kiểm đếm vật lý hoặc lệch vs nguồn → hiển thị danh sách chênh; **không auto-fix** (PROPOSAL) — quản trị viên quyết định điều chỉnh thủ công có audit hoặc re-import.
- 7a2. Sai lệch vượt ngưỡng target (≤1% — PROPOSAL) → GATE-MIG chưa đạt, chặn entry R1A.

**Nhánh B — Cấu hình nghiệp vụ (`admin-config`, FR-LMP-021 — FACT + PROPOSAL):**
- B1. Quản trị viên chỉnh tham số `PolicyConfig`: hạn mượn, số lần gia hạn, hạn giữ chỗ, ngưỡng nợ chặn mượn, vai trò và kênh thông báo; giá trị hiển thị là baseline đề xuất (BR-01..13 — giá trị thật **Open** OQ-LMP-010/OQ-04).
- B2. Lưu cấu hình trong transaction + audit `before/after` + `updated_by/updated_at` (nguồn §7 Setting — FACT); thay đổi chỉ có hiệu lực cho giao dịch bắt đầu sau thời điểm hiệu lực — Loan đã tạo giữ quy định tại thời điểm mượn (baseline §6.5 — FACT).
- B3. Giá trị vi phạm miền cho phép → E-LMP-001; actor thiếu quyền → E-LMP-002.

**Nhánh C — Báo cáo vận hành (`report-dashboard`, FR-LMP-023 — FACT):**
- C1. Quản trị viên xem báo cáo lọc theo khoảng thời gian, xuất Excel/PDF: RP-01 tài khoản, RP-02 tình trạng kho, RP-04 quá hạn (R1A); RP-03 mượn–trả theo thời gian, RP-05 phạt, RP-06 sách được quan tâm, RP-07 hư hỏng/thanh lý (R2).
- C2. Quyền truy cập báo cáo: nguồn §9 chỉ cấp cho `Thủ thư` nguồn = **Quản trị viên** theo mapping spec §2 — FACT. Mở rộng cho Thủ thư quầy xem báo cáo vận hành là **PROPOSAL (lệch ma trận quyền nguồn §2)** — lý do: quầy cần số liệu quá hạn/tình trạng kho hằng ngày để nhắc và xử lý; nếu PROPOSAL không được duyệt thì siết về chỉ Quản trị viên. Thiếu quyền → E-LMP-002; field nhạy cảm → E-LMP-016.

## Related Requirements

- **FR:** FR-LMP-021 (quản trị cấu hình nghiệp vụ — R0), FR-LMP-022 (import + đối soát — R0), FR-LMP-023 (báo cáo vận hành — R1A/R2); liên quan FR-LMP-001/002 (dữ liệu import tạo), FR-LMP-020 (audit), FR-LMP-026 (sinh QR sau import).
- **BR:** BR-LMP-014 (commit chỉ sau dry-run pass hoặc override approved; reconcile đối chiếu số lượng/lỗi/bỏ qua), BR-LMP-013 (audit cùng transaction), BR-LMP-015 (quyền deny mặc định), BR-LMP-016 (notify không fail business).
- **NFR:** NFR-LMP-011 (dry-run + lỗi theo dòng + đối soát trước commit — GATE-MIG), NFR-LMP-004 (authorization), NFR-LMP-010 (log không lộ secrets/PII).
- **Nguồn:** baseline §5.1 (import flow 4 bước + QR + đối soát), §6.4 (import lỗi → dry-run hoặc rollback toàn batch), §7.1 (rule import: mã nhận diện, trạng thái hợp lệ, lỗi theo dòng), §10 (≤1% sai lệch, 100% lỗi được chỉ rõ); OQ-15 (có import Excel); FR-L07 (cấu hình), §9 (báo cáo).
- **Errors:** E-LMP-001 (validation cấu hình/dòng), E-LMP-002 (permission denied — import/override/config/báo cáo), E-LMP-005 (batch in-progress conflict — ext 5b), E-LMP-006 (batch trùng/duplicate operation — ext 1b/5c), E-LMP-014 (import invalid/mismatch/reconcile lệch), E-LMP-016 (field-level access denied); audit fail E-LMP-013 handled chung.
- **Open/Decision:** OQ-LMP-002 (file Excel đại diện + mapping schema — **external blocker**, owner data owner, gate GATE-MIG; DEC-P2-09 hard-stop), OQ-LMP-010/OQ-04 (giá trị tham số BR), Open: ai approve override commit; DEC-P2-09 (import P0/R0).
- **Screens:** `admin-config`, `import-upload`, `import-report`, `report-dashboard`.
- **Nhãn tổng:** FACT = flow dry-run→lỗi theo dòng→làm sạch→import→QR→đối soát, rollback toàn batch, lỗi theo dòng, cấu hình FR-L07, báo cáo chỉ Quản trị viên (nguồn §9 — theo mapping spec §2), đối soát vật lý bởi Thủ thư quầy (baseline §5.1). PROPOSAL = cấu trúc ImportBatch/ImportIssue, override commit, ngưỡng ≤1%, không-auto-fix reconcile, chỉ một batch in-progress (ext 5b), batch dedup theo checksum/operation key (ext 1b), Thủ thư quầy xem báo cáo (lệch ma trận nguồn §2). Open = schema file Excel (OQ-LMP-002 — không được bịa), giá trị BR (OQ-LMP-010), override approver.

<sub>Tài liệu thuộc bộ AI4BA BA-Kit — bản quyền ai4ba.com</sub>
