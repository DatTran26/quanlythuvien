---
type: usecase
feature: library-management-platform
status: draft
updated: 2026-10-05
links:
  - docs/features/library-management-platform/usecases/library-management-platform-usecase-index.md
  - docs/features/library-management-platform/srs/library-management-platform-spec.md
  - docs/_shared/domain/lifecycle-inventory.md
  - docs/_product/decision-register.md
---

# Use Case: Báo cáo hư hỏng, ghi nhận mất và tìm lại bản sao (uc-damage-lost-found)

> Scope: library-management-platform · Level: sea
> Screens: `damage-report-form`, `damage-report-detail`, `lost-found` · Release: báo cáo hư hỏng + disposition tối thiểu + ghi nhận mất ở **R1A** (DEC-P2-03, DEC-P2-07 — PROPOSAL); lost→found reconciliation ở **R1B** (FR-LMP-018 split, DEC-D3-05).

## Primary Actor

Thủ thư (quầy) (tạo báo cáo hư hỏng, ghi nhận mất — FACT §6.4/FR-S05/S07; tương đương `Nhân viên` nguồn, Quản trị viên kế thừa theo ma trận nguồn) · Quản trị viên (duyệt disposition Bác bỏ/Sửa/Thanh lý, xử lý found-after-lost — FACT FR-L08, theo mapping spec §2)

## Stakeholders & Interests

| Stakeholder | Interest |
|-------------|----------|
| Quản trị viên (reviewer) | Nhận notify ngay khi có report `PENDING` (FACT — nguồn §8); không để bản sao kẹt `PENDING_REVIEW` không rõ nguyên nhân (lý do DEC-P2-03 nâng disposition vào R1A) |
| Người đọc | Bồi thường theo BR-06/BR-07 được assess trong cùng transaction đóng Loan; khi sách mất được tìm lại, nghĩa vụ đối soát đúng — không tự xóa (DEC-D3-05) |
| Bộ phận tài chính | Compensation events (REVERSAL/ADJUSTMENT/REFUND) theo policy — giữ hay không giữ phí xử lý BR-06 là **Open** (OQ-LMP-005) |
| Người đặt trước đang giữ chỗ | Copy `ON_HOLD` bị báo hư hỏng → reservation `READY` quay `WAITING` giữ vị trí hàng chờ (PROPOSAL — DEC-D3-06) |

## Trigger

- Thủ thư (quầy) quét QR bản sao và chọn "Báo cáo hư hỏng" tại quầy (ngoài luồng trả), hoặc ghi nhận tình trạng "Hư hỏng"/"Mất" trong luồng trả (extend uc-return-renewal).
- Quản trị viên mở `damage-report-detail` để duyệt một report `PENDING`.
- Thủ thư (quầy)/Quản trị viên xác nhận một bản sao `LOST` được tìm lại (`lost-found`).

## Preconditions

- Actor đã xác thực và có quyền: báo cáo/ghi mất = Thủ thư (quầy) trở lên (tương đương `Nhân viên` nguồn ✓, Quản trị viên kế thừa); disposition (Bác bỏ/Sửa/Thanh lý) = Quản trị viên — ma trận quyền nguồn §2 theo mapping spec §2, FACT.
- Copy tồn tại và ở trạng thái hợp lệ cho báo cáo: `AVAILABLE`/`ON_HOLD` (trực tiếp) hoặc `ON_LOAN` (phát hiện lúc trả — qua flow trả); `DISPOSED` là terminal — từ chối.
- Upload ảnh đi qua trust boundary (BR-LMP-012); QR chỉ là locator — phải xác thực actor/quyền sau khi locate (BR-LMP-011).
- Tối đa một `DamageReport` `PENDING` trên một Copy tại một thời điểm (PROPOSAL — lifecycle §6).

## Guarantees

- **Minimal Guarantee:** Copy bị báo hư hỏng chuyển `PENDING_REVIEW` và bị chặn lưu thông **ngay** (mặc định OQ-11 — **Open, chưa chốt**); file ảnh rủi ro không được lưu (E-LMP-011); không có thao tác ghi nào thiếu audit; DamageReport không tự đóng — chỉ đóng khi có disposition + audit đầy đủ (BR-LMP-009).
- **Success Guarantee:** Report đi trọn vòng `PENDING` → `REPAIR`/`DISPOSE`/`REJECTED` với Copy transition tương ứng (DMG-T01..T04); Copy mất có đường kết thúc (`LOST` → reconcile → `AVAILABLE`/`ON_HOLD`); nghĩa vụ tài chính đã ghi được đối soát, không xóa (AT-FIN-04).

## Main Success Scenario

1. Actor quét QR bản sao tại `damage-report-form`; hệ thống locate Copy và hiển thị trạng thái/tình trạng hiện tại.
2. Actor chọn mức độ (Nhẹ / Vừa / Nặng — BR-07), nhập ghi chú, upload **1–5 ảnh** bằng chứng (FACT — §6.4; mỗi ảnh sau nén ≤ 500 KB, NFR-05).
3. Hệ thống kiểm tra từng ảnh qua trust boundary: kiểm loại/MIME sniffing, giới hạn kích thước, quét nội dung, tên file lưu an toàn, không tin metadata gốc (BR-LMP-012, FR-LMP-025).
4. Trong **một transaction**: tạo `DamageReport` `PENDING` (gắn `loan_id` nếu phát hiện lúc trả), Copy `→PENDING_REVIEW` chặn lưu thông ngay (DMG-T01, mặc định OQ-11 — Open, chưa chốt), ghi AuditEvent + outbox notify Quản trị viên.
5. Quản trị viên mở `damage-report-detail`, xem ảnh/mô tả/liên kết phiếu mượn; hệ thống chỉ hiển thị disposition hợp lệ.
6. Quản trị viên chọn disposition tối thiểu (DEC-P2-03 — FACT nguồn FR-L08):
   - **Bác bỏ** → report `REJECTED`; Copy về `AVAILABLE` hoặc trạng thái lưu trước report nếu vẫn hợp lệ (ví dụ `ON_HOLD` khi giữ chỗ còn hiệu lực — PROPOSAL, DMG-T04).
   - **Sửa** → report `REPAIR`; Copy `→IN_REPAIR` (DMG-T02); theo dõi hoàn tất sửa ở bước 7.
   - **Thanh lý** → report `DISPOSE`; Copy `→DISPOSED` terminal (DMG-T03); fine `DAMAGE` gắn Loan (nếu có) giữ độc lập, không bị xóa theo.
   - Trong cùng transaction: ghi audit + outbox notify.
7. Khi sửa xong, actor xác nhận + cập nhật `Copy.condition`: queue rỗng → Copy `IN_REPAIR→AVAILABLE` (COPY-T12); đầu sách có hàng chờ → `IN_REPAIR→ON_HOLD` + Reservation đầu queue `READY` + `hold_expires_at = now + hold_expiry policy` (baseline đề xuất 48h — PROPOSAL, OQ-LMP-010/OQ-04) + notify (COPY-T13 — FACT §5 ghi chú; áp dụng từ R2 khi CAP-RESERVE live).

## Extensions

**2a. Thiếu/sai trường bắt buộc (E-LMP-001):**
- 2a1. Không có ảnh nào, thiếu severity hoặc note bắt buộc → inline error, giữ dữ liệu nhập, cho sửa và submit lại. Không tạo report.

**2b. Mã không tồn tại hoặc Copy đã có report `PENDING` (E-LMP-003):**
- 2b1. QR/mã không trỏ Copy hợp lệ → error panel, cho nhập lại mã.
- 2b2. Copy đã có report `PENDING` → báo cáo lặp được gộp vào report đang mở hoặc bị từ chối idempotent (PROPOSAL — lifecycle §6); hiển thị report hiện có.

**3a. Upload bị từ chối (E-LMP-011):**
- 3a1. File sai loại, vượt 500 KB sau nén, hoặc nội dung rủi ro → attachment error, cho chọn file khác; **không lưu file rủi ro** (BR-LMP-012). Quá 5 ảnh → từ chối phần vượt (validation baseline §7.1).

**4a. Báo hư hỏng phát hiện trong luồng trả (COPY-T05 — FACT):**
- 4a1. Loan đóng `RETURNED` + assess phạt hư hỏng BR-07 gắn Loan đó (`ASSESSMENT` append-only) **trước**, sau đó Copy `ON_LOAN→PENDING_REVIEW` + `DamageReport PENDING` — thứ tự "đóng Loan + tính phạt trước" là FACT; toàn bộ một transaction. Xem uc-return-renewal.

**4b. Báo hư hỏng trên Copy đang `ON_HOLD` (COPY-T08 — PROPOSAL DEC-D3-06):**
- 4b1. Copy `→PENDING_REVIEW`; Reservation `READY` liên quan quay `WAITING` và **giữ vị trí** hàng chờ; notify người đặt. Chỉ áp dụng từ R2.

**6a. Disposition trên report không còn `PENDING` (E-LMP-015):**
- 6a1. Report đã có quyết định (terminal) → từ chối action, reload state, chỉ hiện action hợp lệ. Report không reopen.

**6b. Sửa không thành / thanh lý trực tiếp (COPY-T14/T17 — PROPOSAL DEC-D3-07):**
- 6b1. `IN_REPAIR→DISPOSED` khi Quản trị viên quyết định sửa không thành (bổ sung disposition `DISPOSE` hoặc report mới + audit).
- 6b2. `AVAILABLE→DISPOSED` thanh lý trực tiếp không qua hư hỏng: lý do bắt buộc, không Loan mở, không Reservation giữ; audit.

**Nhánh A — Ghi nhận mất (R1A, DEC-P2-07; LOAN-T05/COPY-T06 — FACT):**
- A1. Actor xác nhận với người đọc và ghi nhận mất trên `lost-found`: trong một transaction — Loan `→LOST` (`closed_by`), Copy `→LOST`, `ASSESSMENT` bồi thường BR-06 (100% giá sách + phí xử lý — giá trị đề xuất OQ-04), audit + outbox notify.
- A2. Loan `LOST` là terminal — **không reopen**; nếu sau này tìm lại thì xử lý ở Copy + Fine (nhánh B), không mở lại phiếu.
- A3. Ghi nhận mất lặp trên Loan đã `LOST` → idempotent reject, trả kết quả gốc (double-return rule, lifecycle §3).

**Nhánh B — Found after lost (R1B; COPY-T15/T16 — PROPOSAL DEC-D3-05, BR-LMP-010):**
- B1. Actor kiểm tra vật lý bản sao tìm lại, xác nhận trên `lost-found`.
- B2. **Financial reconciliation phải xong trước khi Copy quay lại lưu thông:** nghĩa vụ `LOST` đã assess **không tự xóa**. Chưa thu → `REVERSAL`/`ADJUSTMENT` về 0; đã thu → `REFUND` theo policy finance; có thể giữ phần phí xử lý BR-06 — **Open** (OQ-LMP-005), không tự quyết.
- B3. Trong **một transaction** (AT-FIN-04): compensation events + Copy `LOST→AVAILABLE` (queue rỗng, T15) hoặc `LOST→ON_HOLD` (có hàng chờ, T16 — advance như RES-T02) + audit bắt buộc.
- B4. Chưa có financial approval thì nhánh B2–B3 bị chặn: hệ thống chỉ cho ghi nhận "đã tìm thấy — chờ đối soát" (PROPOSAL), giữ Copy `LOST` cho tới khi reconcile xong.

## Related Requirements

- **FR:** FR-LMP-017 (báo cáo hư hỏng + disposition tối thiểu), FR-LMP-018 (mất/tìm lại — split R1A/R1B), FR-LMP-025 (upload ảnh qua trust boundary); liên quan FR-LMP-010 (trả phát hiện hư hỏng), FR-LMP-012 (re-queue khi copy held hư hỏng), FR-LMP-014/016 (assessment/compensation), FR-LMP-019/020.
- **BR:** BR-LMP-009 (report chỉ đóng khi có quyết định + audit), BR-LMP-010 (lost→found qua reconcile, không tự xóa nghĩa vụ), BR-LMP-011 (QR chỉ là locator), BR-LMP-012 (upload trust boundary), BR-LMP-013 (audit cùng transaction).
- **Nguồn:** §5 Copy states, §6.4 (báo cáo hư hỏng 4 bước), BR-06/07 (bồi thường), OQ-11 (chặn ngay khi báo hư hỏng), NFR-05 (ảnh ≤500KB); lifecycle §2 (COPY-T05..T17), §6 (DMG-T01..T04), §7.3 (AT-FIN-04).
- **Errors:** E-LMP-001 (validation), E-LMP-003 (not found/duplicate report), E-LMP-011 (upload rejected), E-LMP-015 (invalid state transition — terminal Copy/Report/Loan); audit fail E-LMP-013 handled chung.
- **Open/Decision:** OQ-LMP-005 (policy compensation, giữ phí xử lý — hard-stop DEC-D3-05); DEC-D3-06 (re-queue reservation khi held copy hư hỏng); DEC-D3-07 (disposal trực tiếp / sửa-không-thành); DEC-P2-03 (disposition tối thiểu Bác bỏ/Sửa/Thanh lý ở R1A); DEC-P2-07 (ghi nhận mất tối thiểu R1A); OQ-LMP-004 (Copy state machine PROPOSAL chờ domain approver).
- **Screens:** `damage-report-form`, `damage-report-detail`, `lost-found`.
- **Nhãn tổng:** FACT = tên trạng thái/disposition, ảnh 1–5 ≤500KB, assess BR-06/07 khi trả, "đóng Loan + tính phạt trước", báo cáo/ghi mất = Thủ thư quầy + disposition = Quản trị viên (ma trận nguồn §2 — theo mapping spec §2). PROPOSAL = ma trận transition Copy đầy đủ, khôi phục trạng thái sau REJECTED, re-queue reservation, đường found-after-lost, một-report-PENDING-mỗi-copy. Open = chặn lưu thông ngay khi báo hư hỏng (mặc định OQ-11 — chưa chốt), chính sách tiền trong compensation (OQ-LMP-005).

<sub>Tài liệu thuộc bộ AI4BA BA-Kit — bản quyền ai4ba.com</sub>
