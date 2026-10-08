---
type: usecase
feature: library-management-platform
status: draft
updated: 2026-10-05
links:
  - docs/features/library-management-platform/usecases/library-management-platform-usecase-index.md
  - docs/features/library-management-platform/srs/library-management-platform-spec.md
  - docs/features/library-management-platform/domain/lifecycle-inventory.md
  - docs/_product/decision-register.md
---

# Use Case: Ghi nhận phạt, thu tiền và điều chỉnh công nợ (uc-fine-payment)

> Scope: library-management-platform · Level: sea
> Screens: `fine-list`, `fine-detail`, `fine-payment`, `financial-events` · Release: split — ledger + `ASSESSMENT`/`PAYMENT` tiền mặt tối thiểu ở **R1A**; biên nhận đầy đủ/`WAIVER`/`ADJUSTMENT`/`REVERSAL`/`REFUND`/`RECONCILIATION` ở **R1B** (DEC-P2-04 — PROPOSAL). Kênh thanh toán baseline = tiền mặt tại quầy (OQ-08); thanh toán online là R3 candidate.

## Primary Actor

Thủ thư (quầy) (thu tiền mặt tại quầy — `PAYMENT`; tương đương `Nhân viên` nguồn — "Ghi nhận mất sách, thu phạt" ✓ cả hai vai trò nguồn) · Quản trị viên (`WAIVER`/`ADJUSTMENT`/`REVERSAL`/`REFUND`/`RECONCILIATION` — R1B, cần finance approver theo DEC-D3-04 — PROPOSAL, OQ-LMP-005/009) · Người đọc (xem công nợ — FR-R09/R1B; tự thanh toán chỉ khi được phép) · Hệ thống (assessment tự động khi đóng Loan, reconcile job)

## Stakeholders & Interests

| Stakeholder | Interest |
|-------------|----------|
| Bộ phận tài chính/kế toán | Ledger append-only có thể đối soát: `balance` tính lại được từ Σ events (AT-FIN-01); policy partial payment/waiver/adjustment/reversal/refund là **Open** (OQ-LMP-005/009, hard-stop DEC-D3-04/05) |
| Thủ thư trưởng | SoD: người duyệt `WAIVER`/`ADJUSTMENT` không được là người đã tạo `ASSESSMENT` thủ công cho cùng khoản (PROPOSAL — DEC-D3-04); ngưỡng cần duyệt cấp cao hơn là OQ — không tự chốt con số |
| Người đọc | Số dư minh bạch, biên nhận `receipt_no` duy nhất cho mỗi khoản đã thu (PROPOSAL — DEC-D3-08) |
| Vận hành | Reconcile ca/ngày phát hiện lệch tiền mặt vs events → `RECONCILIATION` event + alert (PROPOSAL — AT-FIN-03) |

## Trigger

- Thu phạt: Thủ thư (quầy) mở `fine-payment` để ghi nhận tiền mặt cho một `Fine` đang `UNPAID`.
- Assessment: hệ thống tự động khi đóng Loan quá hạn/hư hỏng/mất (BR-05/06/07) hoặc Quản trị viên tạo thủ công (PROPOSAL).
- Điều chỉnh: Quản trị viên có thẩm quyền tạo `WAIVER`/`ADJUSTMENT`/`REVERSAL`/`REFUND` (R1B).

## Preconditions

- Actor đã xác thực (include uc-access-control); quyền theo event type — Thủ thư (quầy) **chỉ** `PAYMENT`; Quản trị viên mới được `WAIVER`/`ADJUSTMENT`/`REVERSAL`/`REFUND`/`RECONCILIATION` (+ finance approver theo DEC-D3-04 — PROPOSAL, OQ-LMP-005/009).
- `Fine` tồn tại ở trạng thái mở (`UNPAID`) cho payment/waiver/adjustment; `REVERSAL`/`REFUND` tham chiếu event gốc đã ghi.
- Client đã phát sinh `operation_id`/idempotency key cho lần submit payment (AT-FIN-02, BR-LMP-008).
- Financial-control decision (DEC-D3-04, OQ-LMP-005/009) **Resolved + Approved** trước khi bật waiver/adjustment/partial — hard-stop, non-waivable trước GATE-GNG.

## Guarantees

- **Minimal Guarantee:** `FinancialEvent` append-only — không UPDATE/DELETE; sai sót chỉ sửa bằng `REVERSAL` trỏ event gốc (BR-LMP-007). Double-submit/retry không tạo hai `PAYMENT` cho cùng request (E-LMP-006/010). Audit fail → rollback business write (E-LMP-013, BR-LMP-013). Nghĩa vụ không bao giờ mất dấu: payment thất bại thì `Fine` giữ `UNPAID`.
- **Success Guarantee:** `PAYMENT` ghi đúng số tiền, `receipt_no` unique, Fine chuyển `PAID` khi balance = 0; mọi event nhạy cảm có `reason` + actor + audit cùng transaction; số dư đối soát được với Σ events (SC-LMP-04).

## Main Success Scenario

1. Thủ thư (quầy) mở `fine-list` của reader; hệ thống hiển thị các `Fine UNPAID` với `balance` suy từ ledger: `Σ ASSESSMENT + Σ ADJUSTMENT(+) − Σ PAYMENT − Σ WAIVER − Σ ADJUSTMENT(−) − Σ REVERSAL` (PROPOSAL — công thức; FACT nguyên tắc append-only).
2. Actor chọn một Fine, mở `fine-detail` xem breakdown events và lịch sử; chọn "Thu tiền" → `fine-payment`.
3. Actor nhập số tiền thu bằng tiền mặt (baseline OQ-08), xác nhận; client gửi kèm idempotency key.
4. Hệ thống kiểm tra: quyền `PAYMENT`, số tiền > 0 và ≤ `balance` hiện tại (CAS theo trạng thái ledger tại commit).
5. Trong **một transaction**: append `FinancialEvent{ type: PAYMENT, amount, receipt_no unique, collected_by }` → tính lại `balance` → nếu `balance = 0` thì `Fine → PAID` → ghi AuditEvent → ghi outbox NotificationEvent.
6. Hệ thống trả kết quả kèm `receipt_no` (in biên nhận đầy đủ ở R1B — FR-S08/DEC-P2-04); trạng thái delivery notify xem `notification-status`.

## Extensions

**3a. Double-submit / retry cùng idempotency key (E-LMP-006, E-LMP-010, BR-LMP-008):**
- 3a1. Server phát hiện `operation_id` đã commit → trả về kết quả + `receipt_no` gốc (query-by-operation recovery), không tạo `PAYMENT` thứ hai.
- 3a2. UI hiển thị duplicate notice trên payment event đã ghi.

**4a. Số tiền thu nhỏ hơn balance — partial payment:**
- 4a1. `PAYMENT` được ghi với amount < balance; Fine **vẫn `UNPAID`** — không có trạng thái `PARTIALLY_PAID` (PROPOSAL — chờ finance approval, DEC-D3-04 / OQ-LMP-005).
- 4a2. Chính sách cho phép partial payment hay không, giới hạn số lần, và cách áp dụng là **Open** (OQ-LMP-005); UC này không tự chốt.

**4b. Ghi payment thất bại (E-LMP-009 — critical):**
- 4b1. Rollback transaction; `Fine` giữ `UNPAID`, không mất nghĩa vụ.
- 4b2. Cho retry idempotent với cùng key; wording rõ ràng trên payment error panel.

**4c. Audit write thất bại (E-LMP-013 — critical):**
- 4c1. Toàn bộ business write rollback (fail-closed, BR-LMP-013/NFR-LMP-006); alert vận hành. Không để `PAYMENT`/`WAIVER` nào tồn tại mà không có audit.

**4d. Actor thiếu quyền tài chính/field nhạy cảm (E-LMP-016, BR-LMP-015):**
- 4d1. Thủ thư (quầy) cố tạo `WAIVER`/`ADJUSTMENT`/`REVERSAL`/`REFUND` → deny mặc định, mask/block field, audit access attempt.
- 4d2. Vi phạm SoD (người duyệt = người tạo `ASSESSMENT` thủ công cùng khoản) → từ chối + audit (PROPOSAL — DEC-D3-04).

**4e. Hai actor thu cùng một `Fine` đồng thời (`operation_id` khác nhau — không bắt được bởi idempotency):**
- 4e1. CAS trên phiên bản ledger/`Fine.version` tại commit: chỉ transaction ghi trước thắng; transaction thua nhận E-LMP-005 + hiển thị **balance mới** (sau khi khoản kia đã ghi) — không silent overwrite.
- 4e2. Rule: amount phải **≤ balance tại thời điểm commit, không chỉ tại lúc load màn** — nếu balance mới < amount đã nhập thì từ chối kèm số dư cập nhật; actor nhập lại theo balance thật.
- 4e3. Recovery: retry an toàn sau khi reload — khoản `PAYMENT` thua không tạo event mồ côi; nếu Fine đã `PAID` bởi transaction thắng → xử lý như thao tác trên Fine terminal (ext 5d).

**5a. Miễn phạt — `WAIVER` (R1B):**
- 5a1. Quản trị viên tạo `WAIVER` với `reason` bắt buộc; khi `balance → 0`, `Fine → WAIVED` (terminal).
- 5a2. Vượt ngưỡng tiền cần duyệt cấp cao hơn (Thủ thư trưởng/finance approver) — ngưỡng là OQ-LMP-005/009, **Open**, không hard-code.

**5b. Điều chỉnh — `ADJUSTMENT` ± (R1B, PROPOSAL):**
- 5b1. Quản trị viên + lý do bắt buộc; cùng SoD và ngưỡng duyệt như 5a.

**5c. Đảo/hoàn — `REVERSAL`/`REFUND` (R1B, PROPOSAL):**
- 5c1. `REVERSAL` phải tham chiếu event gốc; `REFUND` khi đã thu thừa — theo policy finance (OQ-LMP-005).
- 5c2. Reversal/refund sau khi Fine đã đóng tạo dư âm → xử lý bằng `REFUND` event + reconcile (PROPOSAL); **không reopen** Fine — nghĩa vụ mới thì mở Fine mới.

**5d. Thao tác trên Fine terminal (`PAID`/`WAIVED`) ngoài reversal/refund (E-LMP-015):**
- 5d1. Từ chối `PAYMENT`/chỉnh sửa trực tiếp; chỉ cho phép `REVERSAL`/`ADJUSTMENT`/`REFUND` có tham chiếu + audit.

**6a. Đối soát — `RECONCILIATION` (PROPOSAL — DEC-D3-08, AT-FIN-03):**
- 6a1. Job cuối ca/ngày đối chiếu tiền mặt ghi nhận vs Σ `PAYMENT` events; lệch → append `RECONCILIATION` (chiều 0) + cảnh báo vận hành.
- 6a2. Ai approve financial override khi reconcile lệch là **Open** (OQ-LMP-009).

**Nhánh tạo nghĩa vụ (assessment):** hệ thống append `ASSESSMENT` trong transaction đóng Loan — quá hạn theo BR-05 (2.000đ/ngày/cuốn, trần = giá sách), hư hỏng BR-07 (Nhẹ 0%/Vừa 30%/Nặng 100% giá), mất BR-06 (100% giá + phí xử lý) — FACT về rule, giá trị là đề xuất chờ OQ-04/OQ-LMP-010. Manual `ASSESSMENT` của Quản trị viên là PROPOSAL và chịu SoD ở 4d2.

## Related Requirements

- **FR:** FR-LMP-014 (ghi nhận tiền phạt), FR-LMP-015 (thanh toán — split R1A/R1B DEC-P2-04), FR-LMP-016 (miễn/điều chỉnh/hoàn — R1B); liên quan FR-LMP-018 (lost→found compensation), FR-LMP-019 (outbox), FR-LMP-020 (audit), FR-LMP-024 (người đọc xem công nợ — **R2** self-service portal; chốt lại khi spec reconcile).
- **BR:** BR-LMP-007 (mọi thay đổi số dư = financial event append-only), BR-LMP-008 (idempotency key), BR-LMP-013 (audit fail → fail), BR-LMP-015 (field-level deny mặc định).
- **Nguồn:** BR-05/06/07 (mức phạt), FR-S08 (thu phạt), OQ-08 (tiền mặt mặc định); lifecycle §5 (Fine/FinancialEvent ledger, SoD, ledger integrity 1–5), §7.3 (AT-FIN-01..04).
- **Errors:** E-LMP-005 (concurrent payment conflict — ext 4e), E-LMP-006 (duplicate replay), E-LMP-009 (payment failed), E-LMP-010 (payment duplicate), E-LMP-013 (audit write failed), E-LMP-015 (invalid state), E-LMP-016 (field-level access denied).
- **Open/Decision:** OQ-LMP-005 (partial payment, waiver/adjustment/refund policy — hard-stop DEC-D3-04), OQ-LMP-009 (reconcile policy + override approver — DEC-D3-05/08), OQ-LMP-010/OQ-04 (ngưỡng nợ chặn mượn BR-03, mức phạt); DEC-P2-04 (split R1A/R1B).
- **Screens:** `fine-list`, `fine-detail`, `fine-payment`, `financial-events`.
- **Nhãn tổng:** FACT = ledger append-only, event types cơ bản (ASSESSMENT/PAYMENT), fine states UNPAID/PAID/WAIVED, cash-at-desk default. PROPOSAL = SoD, receipt_no unique, partial payment, RECONCILIATION event, manual assessment, refund/reversal workflow. Open = mọi ngưỡng tiền và policy finance (OQ-LMP-005/009/010).

<sub>Tài liệu thuộc bộ AI4BA BA-Kit — bản quyền ai4ba.com</sub>
