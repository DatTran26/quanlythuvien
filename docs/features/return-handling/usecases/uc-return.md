---
type: usecase
feature: return-handling
status: draft
updated: 2026-10-08
links:
  - docs/features/return-handling/usecases/return-handling-usecase-index.md
  - docs/features/return-handling/srs/return-handling-spec.md
  - docs/_shared/domain/lifecycle-inventory.md
---

# Use Case: Trả sách (uc-return)

> Scope: return-handling · Level: sea
> Screens: `return-scan`, `return-result` · Release: R1A (FR-return-handling-001 trả, FR-overdue-fines-001 ghi nhận phạt)
> **Lưu ý nhãn/Open:** flow trả chi tiết (§2.4 lifecycle-inventory) là **PROPOSAL — DEC-D3-02**; thứ tự "đóng Loan + tính phạt trước, quyết định trạng thái Copy sau" là **FACT**; nhánh D5 phân bổ hàng chờ chỉ hoạt động từ **R2** — R1A queue luôn rỗng (DEC-P2-05); renewal limit, hold expiry, fine threshold là **PROPOSAL — OQ-policy-config-001** (baseline đề xuất: gia hạn 1 lần +7 ngày — chưa chốt).

## Primary Actor

Thủ thư (trả sách tại quầy, gia hạn thay mặt). Người đọc — gia hạn tự phục vụ phụ thuộc cổng FR-reader-self-service-002 (R2); trong R1B gia hạn tại quầy.

## Stakeholders & Interests

| Stakeholder | Interest |
|-------------|----------|
| Người đọc | Được thông báo rõ phạt tạm tính và trạng thái sau trả; gia hạn bị từ chối có lý do cụ thể |
| Quản trị viên (disposition owner) | Copy hư hỏng không kẹt trạng thái — DamageReport PENDING có đường duyệt (DEC-P2-03) |
| Bộ phận tài chính | Mọi nghĩa vụ phạt là FinancialEvent append-only (BR-core-002); chính sách fine chờ OQ-fine-collection-adv-001 |
| Người đọc đang chờ đặt trước (R2) | Copy trả về được phân bổ FIFO nguyên tử (BR-reservation-001) |

## Trigger

- Trả: Người đọc mang sách đến quầy; Thủ thư quét Copy trên `return-scan`.
- Gia hạn: Thủ thư/Người đọc yêu cầu gia hạn một Loan đang mở.

## Preconditions

- Actor đã xác thực và có quyền (include `uc-access-control`); người đọc tự phục vụ chỉ trên khoản mượn của chính mình.
- Trả: tồn tại Loan `ACTIVE`/`OVERDUE` gắn Copy được quét (kiểm tra ở D3). Nhận trả **không** phụ thuộc trạng thái eligibility của reader — BR-core-001 chỉ áp cho checkout/renewal; reader bị khóa vẫn được trả sách.
- Gia hạn (R1B): Loan `ACTIVE`; policy renewal limit đã cấu hình (giá trị — PROPOSAL OQ-policy-config-001).
- R1A: không có hàng chờ Reservation — điểm quyết định D5 luôn "không có hàng chờ" (DEC-P2-05); từ R2, D5 đọc queue thật (extend `uc-reservation`).

## Guarantees

- **Minimal Guarantee:** Không đóng Loan hay đổi trạng thái Copy ngoài một transaction; trả lặp không nhân đôi side effect (fine, queue advance, notify — idempotent); audit fail → rollback toàn bộ (BR-core-003).
- **Success Guarantee:** Loan đóng `RETURNED` + phạt quá hạn/hư hỏng được assess như FinancialEvent (BR-core-002) **trước**, sau đó Copy nhận trạng thái cuối đúng nghiệp vụ (`AVAILABLE`/`ON_HOLD`/`PENDING_REVIEW`) + DamageReport nếu hư hỏng — tất cả trong một transaction (FACT thứ tự; LOAN-T04, COPY-T03/T04/T05). Gia hạn hợp lệ: `due_at` gia tăng theo policy, `renew_count++`, audit (LOAN-T03).

## Main Success Scenario

### Luồng A — Trả sách (FR-return-handling-001, FR-overdue-fines-001)

1. Thủ thư mở `return-scan`, quét QR Copy; hệ thống dùng mã chỉ để locate bản ghi (BR-copy-inventory-001).
2. Hệ thống tìm Loan đang mở gắn Copy (D3 — baseline §6.1).
3. Thủ thư ghi nhận tình trạng trả: **Bình thường** hoặc **Hư hỏng** (severity Nhẹ/Vừa/Nặng + mô tả + ảnh 1–5 nếu báo hư hỏng — DMG-T01); nhánh "Mất" xử lý ở `uc-damage-report` (COPY-T06, LOAN-T05).
4. Hệ thống trong **một transaction**, theo thứ tự bắt buộc (FACT): đóng Loan `ACTIVE/OVERDUE→RETURNED` (LOAN-T04, ghi `returned_at`, `return_condition`, `closed_by`) + assess FinancialEvent `ASSESSMENT` phạt quá hạn nếu `now > due_at` (tính theo policy — PROPOSAL OQ-policy-config-001; phạt hư hỏng theo SRC-BR07 nếu D4) → sau đó quyết định trạng thái Copy (D4/D5): hư hỏng → `PENDING_REVIEW` + DamageReport `PENDING` gắn `loan_id` (COPY-T05 + DMG-T01); bình thường, queue rỗng → `AVAILABLE` (COPY-T03); bình thường, có hàng chờ → `ON_HOLD` + Reservation đầu hàng `WAITING→READY` nguyên tử (COPY-T04 — **chỉ từ R2**, DEC-P2-05) + audit + outbox notify.
5. `return-result` hiển thị: Loan đã đóng, phạt tạm tính nếu có (chuyển tiếp `uc-fine-cash-payment` để thu), trạng thái mới của Copy ("Đã nhận trả sách và cập nhật trạng thái bản sao." — baseline §7.3).

## Extensions

**A2a. Không có Loan đang mở cho Copy (D3 = NO):**
- A2a1. Dừng xử lý, hiển thị "Không tìm thấy phiếu mượn đang mở cho cuốn sách này." (baseline §7.3) — action trả không hợp lệ từ trạng thái hiện tại (E-core-008).
- A2a2. Recovery: kiểm tra vật lý tem/QR, mở `bibliographic-detail` + lịch sử Copy để đối soát; nếu Copy `LOST` được tìm thấy → luồng found-after-lost tại `uc-damage-report` (COPY-T15/T16 — PROPOSAL DEC-D3-05).

**A2b. Copy ở trạng thái không thể nhận trả (`AVAILABLE` trên kệ, `PENDING_REVIEW`, `IN_REPAIR`, `LOST`, `DISPOSED`):**
- A2b1. Hệ thống hiển thị trạng thái hiện tại + action khả dụng (E-checkout-001/E-core-008).
- A2b2. Recovery: quét đúng cuốn đang mượn; copy lệch trạng thái vật lý → mở hồ sơ Copy và xử lý qua UC tương ứng.

**A2c. Quét lặp Copy đã trả (Loan đã `RETURNED`):**
- A2c1. Idempotent reject: trả kết quả gốc, hiển thị phiếu đã đóng (E-core-008 theo invalid transitions §3 lifecycle-inventory — "double-return → idempotent reject, trả kết quả gốc"); **không** assess phạt lần hai.
- A2c2. Recovery: tiếp tục cuốn kế tiếp trong lô trả.

**A3a/A4a. Trả có hư hỏng (D4 = YES):**
- A4a1. Tạo DamageReport `PENDING` gắn `loan_id` (1–5 ảnh, severity — DMG-T01), Copy `→PENDING_REVIEW` chặn lưu thông ngay (mặc định OQ-11 — Open, chưa chốt), assess phạt hư hỏng SRC-BR07, notify Quản trị viên — tất cả trong transaction đóng Loan (extend `uc-damage-report`).
- A4a2. Recovery: nếu upload ảnh lỗi (E-damage-lifecycle-001) → cho chọn file khác, không lưu file rủi ro; report chưa đủ evidence thì lưu nháp theo luồng damage (PROPOSAL).

**A4b. Trả quá hạn:**
- A4b1. Loan có thể đang `OVERDUE` (job 00:05 — LOAN-T02) hoặc quá hạn phát hiện lúc trả; hệ thống assess `ASSESSMENT` tạm tính append-only (BR-core-002) và cập nhật Fine `UNPAID`.
- A4b2. Recovery: `return-result` hiển thị phạt tạm tính và chuyển tiếp `uc-fine-cash-payment`; sửa sai phạt bằng `ADJUSTMENT`/`REVERSAL` có quyền + lý do (không sửa event đã ghi — PROPOSAL OQ-fine-collection-adv-001).

**A4c. Trả bình thường có hàng chờ (D5 = YES — chỉ R2):**
- A4c1. Copy `→ON_HOLD` + Reservation đầu hàng `WAITING→READY` + `held_copy_id` + `hold_expires_at` (PROPOSAL OQ-policy-config-001; baseline đề xuất 48h) nguyên tử cùng transaction (COPY-T04, RES-T02, BR-reservation-001); outbox notify người đặt.
- A4c2. Recovery: notify lỗi không làm fail transaction (BR-core-005; retry/dead-letter — `uc-notification-outbox`).

**A4d. Tranh chấp trạng thái (hai quầy xử lý cùng Copy; renew đua với trả/mất):**
- A4d1. Transition commit trước thắng (CAS allowed-source-state); thao tác sau nhận conflict dialog + fresh state (E-core-004) — "Sách vừa được cập nhật. Vui lòng quét lại để xem trạng thái mới."
- A4d2. Recovery: reload trạng thái và thao tác lại an toàn; không nhân đôi side effect.

## Related Requirements

- FR: FR-return-handling-001; liên quan FR-overdue-fines-001 (ghi phạt), FR-damage-lifecycle-001 (báo hư hỏng).
- BR: dùng chung BR-core-002, BR-core-003, BR-core-005.
- Errors: E-core-003, E-core-004, E-core-006, E-core-007, E-core-008.
- Open: OQ-return-handling-001, OQ-core-002.
- UC liên quan: `uc-access-control` (include), `uc-damage-report`, `uc-lost-found`, `uc-overdue-assessment`, `uc-renewal` (gia hạn từ kết quả trả).
