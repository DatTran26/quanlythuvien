---
type: usecase
feature: damage-lifecycle
status: draft
updated: 2026-10-08
links:
  - docs/features/damage-lifecycle/usecases/damage-lifecycle-usecase-index.md
  - docs/features/damage-lifecycle/srs/damage-lifecycle-spec.md
  - docs/_shared/domain/lifecycle-inventory.md
---

# Use Case: Báo cáo hư hỏng và duyệt (uc-damage-report)

> Scope: damage-lifecycle · Level: sea
> Screens: `damage-report-form`, `damage-report-detail` · Release: R1A (báo cáo hư hỏng + disposition tối thiểu — DEC-P2-03).

## Primary Actor

Thủ thư (quầy) (tạo báo cáo hư hỏng, ghi nhận mất — FACT §6.4/SRC-FR-S05/S07; tương đương `Nhân viên` nguồn, Quản trị viên kế thừa theo ma trận nguồn) · Quản trị viên (duyệt disposition Bác bỏ/Sửa/Thanh lý, xử lý found-after-lost — FACT SRC-FR-L08, theo mapping spec §2)

## Stakeholders & Interests

| Stakeholder | Interest |
|-------------|----------|
| Quản trị viên (reviewer) | Nhận notify ngay khi có report `PENDING` (FACT — nguồn §8); không để bản sao kẹt `PENDING_REVIEW` không rõ nguyên nhân (lý do DEC-P2-03 nâng disposition vào R1A) |
| Người đọc | Bồi thường theo SRC-BR06/SRC-BR07 được assess trong cùng transaction đóng Loan; khi sách mất được tìm lại, nghĩa vụ đối soát đúng — không tự xóa (DEC-D3-05) |
| Bộ phận tài chính | Compensation events (REVERSAL/ADJUSTMENT/REFUND) theo policy — giữ hay không giữ phí xử lý SRC-BR06 là **Open** (OQ-fine-collection-adv-001) |
| Người đặt trước đang giữ chỗ | Copy `ON_HOLD` bị báo hư hỏng → reservation `READY` quay `WAITING` giữ vị trí hàng chờ (PROPOSAL — DEC-D3-06) |

## Trigger

- Thủ thư (quầy) quét QR bản sao và chọn "Báo cáo hư hỏng" tại quầy (ngoài luồng trả), hoặc ghi nhận tình trạng "Hư hỏng"/"Mất" trong luồng trả (extend uc-return).
- Quản trị viên mở `damage-report-detail` để duyệt một report `PENDING`.
- Thủ thư (quầy)/Quản trị viên xác nhận một bản sao `LOST` được tìm lại (`lost-found`).

## Preconditions

- Actor đã xác thực và có quyền: báo cáo/ghi mất = Thủ thư (quầy) trở lên (tương đương `Nhân viên` nguồn ✓, Quản trị viên kế thừa); disposition (Bác bỏ/Sửa/Thanh lý) = Quản trị viên — ma trận quyền nguồn §2 theo mapping spec §2, FACT.
- Copy tồn tại và ở trạng thái hợp lệ cho báo cáo: `AVAILABLE`/`ON_HOLD` (trực tiếp) hoặc `ON_LOAN` (phát hiện lúc trả — qua flow trả); `DISPOSED` là terminal — từ chối.
- Upload ảnh đi qua trust boundary (BR-damage-lifecycle-002); QR chỉ là locator — phải xác thực actor/quyền sau khi locate (BR-copy-inventory-001).
- Tối đa một `DamageReport` `PENDING` trên một Copy tại một thời điểm (PROPOSAL — lifecycle §6).

## Guarantees

- **Minimal Guarantee:** Copy bị báo hư hỏng chuyển `PENDING_REVIEW` và bị chặn lưu thông **ngay** (mặc định OQ-11 — **Open, chưa chốt**); file ảnh rủi ro không được lưu (E-damage-lifecycle-001); không có thao tác ghi nào thiếu audit; DamageReport không tự đóng — chỉ đóng khi có disposition + audit đầy đủ (BR-damage-lifecycle-001).
- **Success Guarantee:** Report đi trọn vòng `PENDING` → `REPAIR`/`DISPOSE`/`REJECTED` với Copy transition tương ứng (DMG-T01..T04); Copy mất có đường kết thúc (`LOST` → reconcile → `AVAILABLE`/`ON_HOLD`); nghĩa vụ tài chính đã ghi được đối soát, không xóa (AT-FIN-04).

## Main Success Scenario

1. Actor quét QR bản sao tại `damage-report-form`; hệ thống locate Copy và hiển thị trạng thái/tình trạng hiện tại.
2. Actor chọn mức độ (Nhẹ / Vừa / Nặng — SRC-BR07), nhập ghi chú, upload **1–5 ảnh** bằng chứng (FACT — §6.4; mỗi ảnh sau nén ≤ 500 KB, SRC-NFR05).
3. Hệ thống kiểm tra từng ảnh qua trust boundary: kiểm loại/MIME sniffing, giới hạn kích thước, quét nội dung, tên file lưu an toàn, không tin metadata gốc (BR-damage-lifecycle-002, FR-damage-lifecycle-002).
4. Trong **một transaction**: tạo `DamageReport` `PENDING` (gắn `loan_id` nếu phát hiện lúc trả), Copy `→PENDING_REVIEW` chặn lưu thông ngay (DMG-T01, mặc định OQ-11 — Open, chưa chốt), ghi AuditEvent + outbox notify Quản trị viên.
5. Quản trị viên mở `damage-report-detail`, xem ảnh/mô tả/liên kết phiếu mượn; hệ thống chỉ hiển thị disposition hợp lệ.
6. Quản trị viên chọn disposition tối thiểu (DEC-P2-03 — FACT nguồn SRC-FR-L08):
   - **Bác bỏ** → report `REJECTED`; Copy về `AVAILABLE` hoặc trạng thái lưu trước report nếu vẫn hợp lệ (ví dụ `ON_HOLD` khi giữ chỗ còn hiệu lực — PROPOSAL, DMG-T04).
   - **Sửa** → report `REPAIR`; Copy `→IN_REPAIR` (DMG-T02); theo dõi hoàn tất sửa ở bước 7.
   - **Thanh lý** → report `DISPOSE`; Copy `→DISPOSED` terminal (DMG-T03); fine `DAMAGE` gắn Loan (nếu có) giữ độc lập, không bị xóa theo.
   - Trong cùng transaction: ghi audit + outbox notify.
7. Khi sửa xong, actor xác nhận + cập nhật `Copy.condition`: queue rỗng → Copy `IN_REPAIR→AVAILABLE` (COPY-T12); đầu sách có hàng chờ → `IN_REPAIR→ON_HOLD` + Reservation đầu queue `READY` + `hold_expires_at = now + hold_expiry policy` (baseline đề xuất 48h — PROPOSAL, OQ-policy-config-001/OQ-04) + notify (COPY-T13 — FACT §5 ghi chú; áp dụng từ R2 khi CAP-RESERVE live).

## Extensions

**2a. Thiếu/sai trường bắt buộc (E-core-001):**
- 2a1. Không có ảnh nào, thiếu severity hoặc note bắt buộc → inline error, giữ dữ liệu nhập, cho sửa và submit lại. Không tạo report.

**2b. Mã không tồn tại hoặc Copy đã có report `PENDING` (E-core-003):**
- 2b1. QR/mã không trỏ Copy hợp lệ → error panel, cho nhập lại mã.
- 2b2. Copy đã có report `PENDING` → báo cáo lặp được gộp vào report đang mở hoặc bị từ chối idempotent (PROPOSAL — lifecycle §6); hiển thị report hiện có.

**3a. Upload bị từ chối (E-damage-lifecycle-001):**
- 3a1. File sai loại, vượt 500 KB sau nén, hoặc nội dung rủi ro → attachment error, cho chọn file khác; **không lưu file rủi ro** (BR-damage-lifecycle-002). Quá 5 ảnh → từ chối phần vượt (validation baseline §7.1).

**4a. Báo hư hỏng phát hiện trong luồng trả (COPY-T05 — FACT):**
- 4a1. Loan đóng `RETURNED` + assess phạt hư hỏng SRC-BR07 gắn Loan đó (`ASSESSMENT` append-only) **trước**, sau đó Copy `ON_LOAN→PENDING_REVIEW` + `DamageReport PENDING` — thứ tự "đóng Loan + tính phạt trước" là FACT; toàn bộ một transaction. Xem uc-return.

**4b. Báo hư hỏng trên Copy đang `ON_HOLD` (COPY-T08 — PROPOSAL DEC-D3-06):**
- 4b1. Copy `→PENDING_REVIEW`; Reservation `READY` liên quan quay `WAITING` và **giữ vị trí** hàng chờ; notify người đặt. Chỉ áp dụng từ R2.

**6a. Disposition trên report không còn `PENDING` (E-core-008):**
- 6a1. Report đã có quyết định (terminal) → từ chối action, reload state, chỉ hiện action hợp lệ. Report không reopen.

**6b. Sửa không thành / thanh lý trực tiếp (COPY-T14/T17 — PROPOSAL DEC-D3-07):**
- 6b1. `IN_REPAIR→DISPOSED` khi Quản trị viên quyết định sửa không thành (bổ sung disposition `DISPOSE` hoặc report mới + audit).
- 6b2. `AVAILABLE→DISPOSED` thanh lý trực tiếp không qua hư hỏng: lý do bắt buộc, không Loan mở, không Reservation giữ; audit.

## Related Requirements

- FR: FR-damage-lifecycle-001, FR-damage-lifecycle-002.
- BR: BR-damage-lifecycle-001, BR-damage-lifecycle-002; dùng chung BR-core-002, BR-core-003, BR-core-005.
- Errors: E-damage-lifecycle-001; dùng chung E-core-001, E-core-002, E-core-003, E-core-004, E-core-007, E-core-008.
- Open: OQ-damage-lifecycle-001, OQ-damage-lifecycle-002.
- UC liên quan: `uc-access-control` (include), `uc-return` (báo hư hỏng lúc trả), `uc-reservation` (bản giữ bị hỏng, từ R2).
