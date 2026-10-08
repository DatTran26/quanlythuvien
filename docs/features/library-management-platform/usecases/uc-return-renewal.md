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

# Use Case: Trả sách và gia hạn (uc-return-renewal)

> Scope: library-management-platform · Level: sea
> Screens: `return-scan`, `return-result`, `renewal-result` · Release: R1A (FR-LMP-010 trả, FR-LMP-014 ghi nhận phạt), R1B (FR-LMP-011 gia hạn)
> **Lưu ý nhãn/Open:** flow trả chi tiết (§2.4 lifecycle-inventory) là **PROPOSAL — DEC-D3-02**; thứ tự "đóng Loan + tính phạt trước, quyết định trạng thái Copy sau" là **FACT**; nhánh D5 phân bổ hàng chờ chỉ hoạt động từ **R2** — R1A queue luôn rỗng (DEC-P2-05); renewal limit, hold expiry, fine threshold là **PROPOSAL — OQ-LMP-010** (baseline đề xuất: gia hạn 1 lần +7 ngày — chưa chốt).

## Primary Actor

Thủ thư (trả sách tại quầy, gia hạn thay mặt). Người đọc — gia hạn tự phục vụ phụ thuộc cổng FR-LMP-024 (R2); trong R1B gia hạn tại quầy.

## Stakeholders & Interests

| Stakeholder | Interest |
|-------------|----------|
| Người đọc | Được thông báo rõ phạt tạm tính và trạng thái sau trả; gia hạn bị từ chối có lý do cụ thể |
| Quản trị viên (disposition owner) | Copy hư hỏng không kẹt trạng thái — DamageReport PENDING có đường duyệt (DEC-P2-03) |
| Bộ phận tài chính | Mọi nghĩa vụ phạt là FinancialEvent append-only (BR-LMP-007); chính sách fine chờ OQ-LMP-005 |
| Người đọc đang chờ đặt trước (R2) | Copy trả về được phân bổ FIFO nguyên tử (BR-LMP-005) |

## Trigger

- Trả: Người đọc mang sách đến quầy; Thủ thư quét Copy trên `return-scan`.
- Gia hạn: Thủ thư/Người đọc yêu cầu gia hạn một Loan đang mở.

## Preconditions

- Actor đã xác thực và có quyền (include `uc-access-control`); người đọc tự phục vụ chỉ trên khoản mượn của chính mình.
- Trả: tồn tại Loan `ACTIVE`/`OVERDUE` gắn Copy được quét (kiểm tra ở D3). Nhận trả **không** phụ thuộc trạng thái eligibility của reader — BR-LMP-003 chỉ áp cho checkout/renewal; reader bị khóa vẫn được trả sách.
- Gia hạn (R1B): Loan `ACTIVE`; policy renewal limit đã cấu hình (giá trị — PROPOSAL OQ-LMP-010).
- R1A: không có hàng chờ Reservation — điểm quyết định D5 luôn "không có hàng chờ" (DEC-P2-05); từ R2, D5 đọc queue thật (extend `uc-reservation`).

## Guarantees

- **Minimal Guarantee:** Không đóng Loan hay đổi trạng thái Copy ngoài một transaction; trả lặp không nhân đôi side effect (fine, queue advance, notify — idempotent); audit fail → rollback toàn bộ (BR-LMP-013).
- **Success Guarantee:** Loan đóng `RETURNED` + phạt quá hạn/hư hỏng được assess như FinancialEvent (BR-LMP-007) **trước**, sau đó Copy nhận trạng thái cuối đúng nghiệp vụ (`AVAILABLE`/`ON_HOLD`/`PENDING_REVIEW`) + DamageReport nếu hư hỏng — tất cả trong một transaction (FACT thứ tự; LOAN-T04, COPY-T03/T04/T05). Gia hạn hợp lệ: `due_at` gia tăng theo policy, `renew_count++`, audit (LOAN-T03).

## Main Success Scenario

### Luồng A — Trả sách (FR-LMP-010, FR-LMP-014)

1. Thủ thư mở `return-scan`, quét QR Copy; hệ thống dùng mã chỉ để locate bản ghi (BR-LMP-011).
2. Hệ thống tìm Loan đang mở gắn Copy (D3 — baseline §6.1).
3. Thủ thư ghi nhận tình trạng trả: **Bình thường** hoặc **Hư hỏng** (severity Nhẹ/Vừa/Nặng + mô tả + ảnh 1–5 nếu báo hư hỏng — DMG-T01); nhánh "Mất" xử lý ở `uc-damage-lost-found` (COPY-T06, LOAN-T05).
4. Hệ thống trong **một transaction**, theo thứ tự bắt buộc (FACT): đóng Loan `ACTIVE/OVERDUE→RETURNED` (LOAN-T04, ghi `returned_at`, `return_condition`, `closed_by`) + assess FinancialEvent `ASSESSMENT` phạt quá hạn nếu `now > due_at` (tính theo policy — PROPOSAL OQ-LMP-010; phạt hư hỏng theo BR-07 nếu D4) → sau đó quyết định trạng thái Copy (D4/D5): hư hỏng → `PENDING_REVIEW` + DamageReport `PENDING` gắn `loan_id` (COPY-T05 + DMG-T01); bình thường, queue rỗng → `AVAILABLE` (COPY-T03); bình thường, có hàng chờ → `ON_HOLD` + Reservation đầu hàng `WAITING→READY` nguyên tử (COPY-T04 — **chỉ từ R2**, DEC-P2-05) + audit + outbox notify.
5. `return-result` hiển thị: Loan đã đóng, phạt tạm tính nếu có (chuyển tiếp `uc-fine-payment` để thu), trạng thái mới của Copy ("Đã nhận trả sách và cập nhật trạng thái bản sao." — baseline §7.3).

### Luồng B — Gia hạn (FR-LMP-011, R1B)

1. Thủ thư chọn Loan đang mở trên hồ sơ/quầy (hoặc Người đọc chọn khoản mượn của mình — R2 portal).
2. Hệ thống kiểm BR-LMP-004 + BR-LMP-003: Loan `ACTIVE` chưa quá hạn; `renew_count < limit` (PROPOSAL OQ-LMP-010); không có Reservation đang chờ trên cùng title — **kiểm tra vẫn chạy nhưng queue rỗng cho tới R2, rule đúng ngữ nghĩa** (DEC-P2-05); reader còn đủ điều kiện.
3. LOAN-T03: `due_at += policy renewal` (baseline đề xuất +7 ngày — PROPOSAL), `renew_count++`, audit; `renewal-result` hiển thị hạn trả mới.

## Extensions

**A2a. Không có Loan đang mở cho Copy (D3 = NO):**
- A2a1. Dừng xử lý, hiển thị "Không tìm thấy phiếu mượn đang mở cho cuốn sách này." (baseline §7.3) — action trả không hợp lệ từ trạng thái hiện tại (E-LMP-015).
- A2a2. Recovery: kiểm tra vật lý tem/QR, mở `bibliographic-detail` + lịch sử Copy để đối soát; nếu Copy `LOST` được tìm thấy → luồng found-after-lost tại `uc-damage-lost-found` (COPY-T15/T16 — PROPOSAL DEC-D3-05).

**A2b. Copy ở trạng thái không thể nhận trả (`AVAILABLE` trên kệ, `PENDING_REVIEW`, `IN_REPAIR`, `LOST`, `DISPOSED`):**
- A2b1. Hệ thống hiển thị trạng thái hiện tại + action khả dụng (E-LMP-004/E-LMP-015).
- A2b2. Recovery: quét đúng cuốn đang mượn; copy lệch trạng thái vật lý → mở hồ sơ Copy và xử lý qua UC tương ứng.

**A2c. Quét lặp Copy đã trả (Loan đã `RETURNED`):**
- A2c1. Idempotent reject: trả kết quả gốc, hiển thị phiếu đã đóng (E-LMP-015 theo invalid transitions §3 lifecycle-inventory — "double-return → idempotent reject, trả kết quả gốc"); **không** assess phạt lần hai.
- A2c2. Recovery: tiếp tục cuốn kế tiếp trong lô trả.

**A3a/A4a. Trả có hư hỏng (D4 = YES):**
- A4a1. Tạo DamageReport `PENDING` gắn `loan_id` (1–5 ảnh, severity — DMG-T01), Copy `→PENDING_REVIEW` chặn lưu thông ngay (mặc định OQ-11 — Open, chưa chốt), assess phạt hư hỏng BR-07, notify Quản trị viên — tất cả trong transaction đóng Loan (extend `uc-damage-lost-found`).
- A4a2. Recovery: nếu upload ảnh lỗi (E-LMP-011) → cho chọn file khác, không lưu file rủi ro; report chưa đủ evidence thì lưu nháp theo luồng damage (PROPOSAL).

**A4b. Trả quá hạn:**
- A4b1. Loan có thể đang `OVERDUE` (job 00:05 — LOAN-T02) hoặc quá hạn phát hiện lúc trả; hệ thống assess `ASSESSMENT` tạm tính append-only (BR-LMP-007) và cập nhật Fine `UNPAID`.
- A4b2. Recovery: `return-result` hiển thị phạt tạm tính và chuyển tiếp `uc-fine-payment`; sửa sai phạt bằng `ADJUSTMENT`/`REVERSAL` có quyền + lý do (không sửa event đã ghi — PROPOSAL OQ-LMP-005).

**A4c. Trả bình thường có hàng chờ (D5 = YES — chỉ R2):**
- A4c1. Copy `→ON_HOLD` + Reservation đầu hàng `WAITING→READY` + `held_copy_id` + `hold_expires_at` (PROPOSAL OQ-LMP-010; baseline đề xuất 48h) nguyên tử cùng transaction (COPY-T04, RES-T02, BR-LMP-005); outbox notify người đặt.
- A4c2. Recovery: notify lỗi không làm fail transaction (BR-LMP-016; retry/dead-letter — `uc-notification-audit`).

**A4d. Tranh chấp trạng thái (hai quầy xử lý cùng Copy; renew đua với trả/mất):**
- A4d1. Transition commit trước thắng (CAS allowed-source-state); thao tác sau nhận conflict dialog + fresh state (E-LMP-005) — "Sách vừa được cập nhật. Vui lòng quét lại để xem trạng thái mới."
- A4d2. Recovery: reload trạng thái và thao tác lại an toàn; không nhân đôi side effect.

**B2a. Gia hạn bị từ chối — Loan đã quá hạn (`OVERDUE`):**
- B2a1. Từ chối kèm lý do (BR-LMP-004; E-LMP-015 invalid transition — `OVERDUE→ACTIVE` không qua renew): hướng dẫn trả sách + thanh toán phạt.
- B2a2. Recovery: chuyển luồng trả (A) hoặc `uc-fine-payment`.

**B2b. Gia hạn bị từ chối — reader không đủ điều kiện (bị khóa/không active):**
- B2b1. Hiển thị blocked panel lý do (E-LMP-007 — BR-LMP-003 áp cho renewal).
- B2b2. Recovery: mở khóa qua `uc-reader-admin` hoặc giải quyết nghĩa vụ; sau đó renew lại nếu còn hạn.

**B2c. Gia hạn bị từ chối — vượt renewal limit hoặc title có Reservation đang chờ:**
- B2c1. Từ chối kèm lý do cụ thể (BR-LMP-004; E-LMP-015): đạt giới hạn gia hạn (PROPOSAL OQ-LMP-010; baseline đề xuất 1 lần) hoặc có giữ chỗ — **lưu ý queue rỗng tới R2 nên nhánh giữ chỗ chỉ sinh hiệu lực từ R2** (DEC-P2-05).
- B2c2. Recovery: hiển thị hạn trả hiện tại; người đọc trả sách đúng hạn; gợi ý đặt trước lại sau khi trả (R2).

**B2d. Renew đua với trả/mất/double-submit:**
- B2d1. Transition đầu tiên commit thắng; transition sau nhận E-LMP-005/E-LMP-015; submit lặp cùng operation trả kết quả gốc (idempotent — PROPOSAL theo AT-RSV-03/AT-CHK-02 pattern).
- B2d2. Recovery: reload `due_at`/`renew_count` mới nhất rồi hiển thị kết quả thật.

## Related Requirements

- FR: FR-LMP-010 (trả), FR-LMP-011 (gia hạn — R1B), FR-LMP-014 (ghi nhận tiền phạt); liên quan FR-LMP-017 (DamageReport), FR-LMP-019/020 (outbox/audit), FR-LMP-012/013 (queue — R2).
- NFR: NFR-LMP-003 (nguyên tử), NFR-LMP-006/007 (audit fail-closed, outbox retry).
- BR: BR-LMP-004 (renewal denial — ngưỡng OQ-LMP-010), BR-LMP-005 (allocation nguyên tử — R2), BR-LMP-007 (ledger append-only), BR-LMP-011/013/016.
- Transitions: LOAN-T02/T03/T04, COPY-T03/T04/T05, DMG-T01, RES-T02 (R2); flow §2.4 (FACT thứ tự đóng Loan trước; PROPOSAL chi tiết — DEC-D3-02).
- Errors covered: E-LMP-004, E-LMP-005, E-LMP-007, E-LMP-015.
- Open: **OQ-LMP-010** (renewal limit, hold expiry, due/fine threshold); OQ-LMP-005 (fine policy); DEC-P2-05 (D5/queue rỗng tới R2); DEC-D3-02 (return flow PROPOSAL).
- UC liên quan: `uc-access-control` (include), `uc-damage-lost-found` (extend — damaged/lost path), `uc-fine-payment` (extend — phạt tạm tính), `uc-reservation` (extend — queue allocation R2).
- **Nhãn tổng:** FACT = thứ tự "đóng Loan + tính phạt trước, quyết định trạng thái Copy sau" (nguồn §6.2), trả không phụ thuộc eligibility (BR-LMP-003 chỉ áp checkout/renewal — Preconditions), job quá hạn 00:05, báo hư hỏng lúc trả tạo DamageReport + assess BR-07, BR-13 concurrency. PROPOSAL = flow trả chi tiết DEC-D3-02, idempotent reject double-return, renewal policy (+7 ngày/1 lần), cơ chế CAS transition. Open = renewal limit, hold expiry, due/fine threshold (OQ-LMP-010), fine policy (OQ-LMP-005), OQ-11 chặn ngay khi báo hư hỏng (mặc định chưa chốt — xem `uc-damage-lost-found`).

<sub>Tài liệu thuộc bộ AI4BA BA-Kit — bản quyền ai4ba.com</sub>
