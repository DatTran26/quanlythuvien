---
type: usecase
feature: fine-collection-basic
status: draft
updated: 2026-10-08
links:
  - docs/features/fine-collection-basic/usecases/fine-collection-basic-usecase-index.md
  - docs/features/fine-collection-basic/srs/fine-collection-basic-spec.md
  - docs/_shared/domain/lifecycle-inventory.md
---

# Use Case: Thu phạt bằng tiền mặt (uc-fine-cash-payment)

> Scope: fine-collection-basic · Level: sea
> Screens: `fine-list`, `fine-detail`, `fine-payment` · Release: R1A (thu tiền mặt tối thiểu — DEC-P2-04). Biên nhận, miễn, điều chỉnh, đảo, hoàn thuộc `uc-fine-adjustment` (R1B).

## Primary Actor

Thủ thư (quầy) (thu tiền mặt tại quầy — `PAYMENT`; tương đương `Nhân viên` nguồn — "Ghi nhận mất sách, thu phạt" ✓ cả hai vai trò nguồn) · Quản trị viên (`WAIVER`/`ADJUSTMENT`/`REVERSAL`/`REFUND`/`RECONCILIATION` — R1B, cần finance approver theo DEC-D3-04 — PROPOSAL, OQ-fine-collection-adv-001/OQ-fine-collection-adv-002) · Người đọc (xem công nợ — SRC-FR-R09/R1B; tự thanh toán chỉ khi được phép) · Hệ thống (assessment tự động khi đóng Loan, reconcile job)

## Stakeholders & Interests

| Stakeholder | Interest |
|-------------|----------|
| Bộ phận tài chính/kế toán | Ledger append-only có thể đối soát: `balance` tính lại được từ Σ events (AT-FIN-01); policy partial payment/waiver/adjustment/reversal/refund là **Open** (OQ-fine-collection-adv-001/OQ-fine-collection-adv-002, hard-stop DEC-D3-04/05) |
| Thủ thư trưởng | SoD: người duyệt `WAIVER`/`ADJUSTMENT` không được là người đã tạo `ASSESSMENT` thủ công cho cùng khoản (PROPOSAL — DEC-D3-04); ngưỡng cần duyệt cấp cao hơn là OQ — không tự chốt con số |
| Người đọc | Số dư minh bạch, biên nhận `receipt_no` duy nhất cho mỗi khoản đã thu (PROPOSAL — DEC-D3-08) |
| Vận hành | Reconcile ca/ngày phát hiện lệch tiền mặt vs events → `RECONCILIATION` event + alert (PROPOSAL — AT-FIN-03) |

## Trigger

- Thu phạt: Thủ thư (quầy) mở `fine-payment` để ghi nhận tiền mặt cho một `Fine` đang `UNPAID`.
- Assessment: hệ thống tự động khi đóng Loan quá hạn/hư hỏng/mất (SRC-BR05/06/07) hoặc Quản trị viên tạo thủ công (PROPOSAL).
- Điều chỉnh: Quản trị viên có thẩm quyền tạo `WAIVER`/`ADJUSTMENT`/`REVERSAL`/`REFUND` (R1B).

## Preconditions

- Actor đã xác thực (include uc-access-control); quyền theo event type — Thủ thư (quầy) **chỉ** `PAYMENT`; Quản trị viên mới được `WAIVER`/`ADJUSTMENT`/`REVERSAL`/`REFUND`/`RECONCILIATION` (+ finance approver theo DEC-D3-04 — PROPOSAL, OQ-fine-collection-adv-001/OQ-fine-collection-adv-002).
- `Fine` tồn tại ở trạng thái mở (`UNPAID`) cho payment/waiver/adjustment; `REVERSAL`/`REFUND` tham chiếu event gốc đã ghi.
- Client đã phát sinh `operation_id`/idempotency key cho lần submit payment (AT-FIN-02, BR-fine-collection-basic-001).
- Financial-control decision (DEC-D3-04, OQ-fine-collection-adv-001/OQ-fine-collection-adv-002) **Resolved + Approved** trước khi bật waiver/adjustment/partial — hard-stop, non-waivable trước GATE-GNG.

## Guarantees

- **Minimal Guarantee:** `FinancialEvent` append-only — không UPDATE/DELETE; sai sót chỉ sửa bằng `REVERSAL` trỏ event gốc (BR-core-002). Double-submit/retry không tạo hai `PAYMENT` cho cùng request (E-core-005/E-fine-collection-basic-002). Audit fail → rollback business write (E-core-007, BR-core-003). Nghĩa vụ không bao giờ mất dấu: payment thất bại thì `Fine` giữ `UNPAID`.
- **Success Guarantee:** `PAYMENT` ghi đúng số tiền, `receipt_no` unique, Fine chuyển `PAID` khi balance = 0; mọi event nhạy cảm có `reason` + actor + audit cùng transaction; số dư đối soát được với Σ events (SC-overdue-fines-01).

## Main Success Scenario

1. Thủ thư (quầy) mở `fine-list` của reader; hệ thống hiển thị các `Fine UNPAID` với `balance` suy từ ledger: `Σ ASSESSMENT + Σ ADJUSTMENT(+) − Σ PAYMENT − Σ WAIVER − Σ ADJUSTMENT(−) − Σ REVERSAL` (PROPOSAL — công thức; FACT nguyên tắc append-only).
2. Actor chọn một Fine, mở `fine-detail` xem breakdown events và lịch sử; chọn "Thu tiền" → `fine-payment`.
3. Actor nhập số tiền thu bằng tiền mặt (baseline OQ-08), xác nhận; client gửi kèm idempotency key.
4. Hệ thống kiểm tra: quyền `PAYMENT`, số tiền > 0 và ≤ `balance` hiện tại (CAS theo trạng thái ledger tại commit).
5. Trong **một transaction**: append `FinancialEvent{ type: PAYMENT, amount, receipt_no unique, collected_by }` → tính lại `balance` → nếu `balance = 0` thì `Fine → PAID` → ghi AuditEvent → ghi outbox NotificationEvent.
6. Hệ thống trả kết quả kèm `receipt_no` (in biên nhận đầy đủ ở R1B — SRC-FR-S08/DEC-P2-04); trạng thái delivery notify xem `notification-status`.

## Extensions

**3a. Double-submit / retry cùng idempotency key (E-core-005, E-fine-collection-basic-002, BR-fine-collection-basic-001):**
- 3a1. Server phát hiện `operation_id` đã commit → trả về kết quả + `receipt_no` gốc (query-by-operation recovery), không tạo `PAYMENT` thứ hai.
- 3a2. UI hiển thị duplicate notice trên payment event đã ghi.

**4a. Số tiền thu nhỏ hơn balance — partial payment:**
- 4a1. `PAYMENT` được ghi với amount < balance; Fine **vẫn `UNPAID`** — không có trạng thái `PARTIALLY_PAID` (PROPOSAL — chờ finance approval, DEC-D3-04 / OQ-fine-collection-adv-001).
- 4a2. Chính sách cho phép partial payment hay không, giới hạn số lần, và cách áp dụng là **Open** (OQ-fine-collection-adv-001); UC này không tự chốt.

**4b. Ghi payment thất bại (E-fine-collection-basic-001 — critical):**
- 4b1. Rollback transaction; `Fine` giữ `UNPAID`, không mất nghĩa vụ.
- 4b2. Cho retry idempotent với cùng key; wording rõ ràng trên payment error panel.

**4c. Audit write thất bại (E-core-007 — critical):**
- 4c1. Toàn bộ business write rollback (fail-closed, BR-core-003/NFR-core-005); alert vận hành. Không để `PAYMENT`/`WAIVER` nào tồn tại mà không có audit.

**4d. Actor thiếu quyền tài chính/field nhạy cảm (E-core-009, BR-core-004):**
- 4d1. Thủ thư (quầy) cố tạo `WAIVER`/`ADJUSTMENT`/`REVERSAL`/`REFUND` → deny mặc định, mask/block field, audit access attempt.
- 4d2. Vi phạm SoD (người duyệt = người tạo `ASSESSMENT` thủ công cùng khoản) → từ chối + audit (PROPOSAL — DEC-D3-04).

**4e. Hai actor thu cùng một `Fine` đồng thời (`operation_id` khác nhau — không bắt được bởi idempotency):**
- 4e1. CAS trên phiên bản ledger/`Fine.version` tại commit: chỉ transaction ghi trước thắng; transaction thua nhận E-core-004 + hiển thị **balance mới** (sau khi khoản kia đã ghi) — không silent overwrite.
- 4e2. Rule: amount phải **≤ balance tại thời điểm commit, không chỉ tại lúc load màn** — nếu balance mới < amount đã nhập thì từ chối kèm số dư cập nhật; actor nhập lại theo balance thật.
- 4e3. Recovery: retry an toàn sau khi reload — khoản `PAYMENT` thua không tạo event mồ côi; nếu Fine đã `PAID` bởi transaction thắng → xử lý như thao tác trên Fine terminal (ext 5d).

## Related Requirements

- FR: FR-fine-collection-basic-001.
- BR: BR-fine-collection-basic-001; dùng chung BR-core-002, BR-core-003, BR-core-004.
- Errors: E-fine-collection-basic-001, E-fine-collection-basic-002; dùng chung E-core-001, E-core-002, E-core-004, E-core-005, E-core-007, E-core-009.
- Open: OQ-fine-collection-basic-001.
- UC liên quan: `uc-access-control` (include), `uc-overdue-assessment` (tạo nghĩa vụ), `uc-fine-adjustment` (miễn, điều chỉnh — R1B).
