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

# Use Case: Đặt trước và hàng đợi giữ chỗ (uc-reservation)

> Scope: library-management-platform · Level: sea
> Screens: `reservation-search`, `reservation-form`, `reservation-queue`, `reservation-pickup` · Release: **R2** (OQ-LMP-003 resolved-as-PROPOSAL bởi DEC-P2-05 — Reservation có một release owner duy nhất là R2; R1A luồng trả luôn "không có hàng chờ" ở decision D5)

## Primary Actor

Người đọc (tự đặt/hủy — self-service R2) · Thủ thư/Quản trị viên (đặt và hủy thay mặt người đọc, xử lý nhận sách tại quầy — FACT, ma trận quyền nguồn §2 theo mapping spec §2) · Hệ thống (cron RES-T04 expiry, queue advance, notify jobs — FACT nguồn §8)

## Stakeholders & Interests

| Stakeholder | Interest |
|-------------|----------|
| Hệ thống (tác vụ nền) | Cron hết hạn giữ mỗi 15 phút (FACT — nguồn §8); queue advance nguyên tử, không để lộ trạng thái trung gian (AT-RSV-04, PROPOSAL) |
| Người đọc đứng sau trong hàng chờ | FIFO công bằng theo `created_at` hợp lệ (BR-09/BR-LMP-005 — FACT); được advance ngay khi lượt trước hết hạn/hủy |
| Thủ thư trưởng (domain approver) | Toàn bộ transition RES-T01..T06 là FACT về tên/hướng nhưng cơ chế CAS/atomic là PROPOSAL chờ duyệt (DEC-D3-01/02, OQ-LMP-004) |
| Kênh thông báo ngoài | Notify qua outbox bền; kênh cụ thể là OQ-LMP-008 (baseline in-app + email — PROPOSAL DEC-P2-01) |

## Trigger

Người đọc bấm "Đặt trước" trên đầu sách có số lượng khả dụng = 0 (BR-08 — FACT), hoặc Thủ thư/Quản trị viên tạo đặt trước thay mặt tại quầy.

## Preconditions

- Actor đã xác thực và có quyền đặt trước (include uc-access-control; người đọc chỉ trên dữ liệu của chính mình — "riêng" trong ma trận quyền nguồn).
- Đầu sách tồn tại, đang hoạt động; số lượng khả dụng = 0 (tính từ `Copy.status = AVAILABLE` + `is_loanable`, không lưu counter — BR-11/CP-AVL-01).
- Reader `active`, đủ điều kiện theo BR-LMP-003 (không bị khóa, không có sách quá hạn, nợ phạt không vượt ngưỡng — ngưỡng OQ-LMP-010, baseline đề xuất 50.000đ); số đặt trước đang mở < ngưỡng cấu hình (baseline đề xuất 3 — BR-08, giá trị thật OQ-LMP-010/OQ-04).
- Reader chưa có Reservation mở khác cho **cùng đầu sách** (PROPOSAL dedup — RES-T01).
- CAP-RESERVE đã được bật (feature flag R2 — DEC-P2-05; rollback = đóng băng hàng chờ theo roadmap §6).

## Guarantees

- **Minimal Guarantee:** Không tạo Reservation khi vi phạm BR-08/điều kiện reader; không để hai Reservation `READY` giữ cùng một Copy (AT-RSV-02 — PROPOSAL); mọi hành động ghi có audit; notify lỗi không làm mất reservation đã commit (BR-LMP-016).
- **Success Guarantee:** Reservation đi trọn vòng WAITING → READY → FULFILLED đúng FIFO; giữ chỗ đúng `hold_expires_at = now + hold_expiry policy` (baseline đề xuất 48h — **PROPOSAL**, OQ-LMP-010/OQ-04; BR-10 FACT về sự tồn tại hạn giữ + cơ chế hết hạn); hết hạn/hủy thì copy được giải phóng và queue advance **trong cùng transaction** (BR-LMP-006, AT-RSV-03/04); người kế tiếp được notify qua outbox bền.

## Main Success Scenario

1. Actor mở `reservation-search`, tra cứu đầu sách; hệ thống hiển thị số lượng khả dụng tính từ trạng thái Copy (BR-11 — FACT).
2. Actor chọn "Đặt trước" trên đầu sách có khả dụng = 0; hệ thống kiểm tra preconditions (reader hợp lệ, dưới ngưỡng 3 đặt trước mở, chưa có reservation mở cùng title).
3. Hệ thống tạo Reservation `WAITING` ở cuối hàng chờ FIFO theo `created_at` (RES-T01, BR-09 — FACT), hiển thị vị trí trong hàng chờ trên `reservation-queue`; ghi AuditEvent trong cùng transaction (BR-LMP-013).
4. Khi một Copy của đầu sách về kho (trả bình thường COPY-T04, sửa xong T13, found T16, hoặc re-hold T19): Hệ thống chọn Reservation đầu queue hợp lệ tại thời điểm commit (AT-RSV-05 — FACT).
5. Trong **một transaction nguyên tử** (AT-RSV-01 — PROPOSAL): Copy `→ON_HOLD`, gán `held_copy_id`, đặt `hold_expires_at = now + hold_expiry policy` (baseline đề xuất 48h — PROPOSAL, OQ-LMP-010/OQ-04; BR-10 FACT về cơ chế), Reservation `WAITING→READY` (RES-T02), ghi outbox NotificationEvent + AuditEvent.
6. Outbox phát thông báo "Sách đã sẵn sàng. Vui lòng đến nhận trong hạn giữ." (FACT — nguồn §8 sự kiện notify; wording baseline §7.3 ghi 48 giờ — giá trị theo hold_expiry policy, PROPOSAL); trạng thái delivery xem trên `notification-status`.
7. Người đọc đến quầy trong hạn giữ; Thủ thư mở `reservation-pickup`, xác nhận reservation `READY` thuộc đúng reader và `hold_expires_at` chưa qua.
8. Thủ thư checkout (COPY-T02, extend uc-checkout): trong một transaction — Loan `ACTIVE` tạo, Copy `ON_HOLD→ON_LOAN`, Reservation `READY→FULFILLED` (RES-T03), audit + outbox notify xác nhận.

## Extensions

**2a. Đầu sách vẫn còn bản sao khả dụng (vi phạm BR-08):**
- 2a1. Hệ thống từ chối tạo đặt trước, hiển thị số bản khả dụng và điều hướng sang luồng mượn trực tiếp — lỗi E-LMP-008 (Reservation unavailable).
- 2a2. Use case kết thúc; không ghi Reservation, không audit nhạy cảm ngoài access log.

**2b. Reader vượt ngưỡng hoặc không đủ điều kiện:**
- 2b1. Đã có ≥ ngưỡng đặt trước mở (baseline 3 — OQ-LMP-010), hoặc đã có Reservation mở cho cùng đầu sách (PROPOSAL), hoặc reader bị khóa/không active (BR-LMP-003): hệ thống từ chối, nêu lý do trên `reservation-form` — E-LMP-008.
- 2b2. Use case kết thúc.

**4a. Race giữa hai allocation hoặc hủy-vs-allocate (E-LMP-005):**
- 4a1. CAS trên `Reservation.status` và `Copy.version` + allowed-source-state (AT-CHK-03/AT-RSV-01 — FACT BR-13): chỉ một transaction commit thắng.
- 4a2. Transaction thua nhận E-LMP-005 "Sách vừa được cập nhật…", reload fresh state và retry an toàn; không tạo double-hold (AT-RSV-02).
- 4a3. Nếu cancel commit trước allocate → allocate bỏ qua reservation đó và advance xuống người kế tiếp; nếu allocate commit trước → cancel đi nhánh RES-T06 (giải phóng copy) — cả hai idempotent (PROPOSAL — lifecycle §4).

**5a. Notify thất bại sau khi READY đã commit:**
- 5a1. Business transition đã commit; `READY` **không** tự hủy vì notify lỗi, `hold_expires_at` vẫn chạy (FACT — lifecycle §4 kịch bản bắt buộc).
- 5a2. Outbox retry theo policy, sau ngưỡng → dead-letter + cảnh báo vận hành (E-LMP-012/E-LMP-018, NFR-LMP-007 — chi tiết tại uc-notification-audit).
- 5a3. Escalation cho Thủ thư trực quầy sau ngưỡng retry là PROPOSAL (DEC-D3-08 — kênh escalation chưa duyệt).

**7a. Người đọc không đến nhận trong hạn giữ (RES-T04 — FACT; giá trị hạn = PROPOSAL):**
- 7a1. Cron "Hết hạn giữ đặt trước" (mỗi 15 phút — FACT nguồn §8) CAS `READY→EXPIRED` khi `now > hold_expires_at`; giá trị `hold_expires_at` = now + hold_expiry policy (baseline đề xuất 48h — PROPOSAL, OQ-LMP-010/OQ-04).
- 7a2. Trong **cùng transaction** (BR-LMP-006, AT-RSV-04): giải phóng Copy — nếu queue còn người thì COPY-T19 re-hold nguyên tử (`held_copy_id` gán đầu queue mới, `hold_expires_at` reset theo hold_expiry policy — baseline 48h PROPOSAL, notify người mới); nếu queue rỗng thì COPY-T18 `ON_HOLD→AVAILABLE`.
- 7a3. Outbox notify "đặt trước hết hạn giữ" cho người bị hết hạn; audit. Không tồn tại trạng thái trung gian "copy free chưa ai giữ" lộ ra ngoài (AT-RSV-04 — PROPOSAL).

**7b. Hủy đặt trước:**
- 7b1. Đang `WAITING`: người đọc (chính mình) hoặc Thủ thư/Quản trị viên (thay mặt) hủy → `CANCELLED`, rời queue (RES-T05 — FACT); audit.
- 7b2. Đang `READY`: hủy → `CANCELLED` (RES-T06) + giải phóng copy/advance queue nguyên tử như 7a2.
- 7b3. Hủy trên reservation terminal (`FULFILLED`/`EXPIRED`/`CANCELLED`) → E-LMP-015 invalid state transition; chỉ hiển thị action hợp lệ.

**7c. Copy đang giữ bị báo hư hỏng (COPY-T08 — PROPOSAL DEC-D3-06):**
- 7c1. Copy `ON_HOLD→PENDING_REVIEW`; Reservation `READY` liên quan quay `WAITING` và **giữ vị trí hàng chờ**; notify người đặt. Xem uc-damage-lost-found.

**7d. Đến nhận nhưng reservation đã EXPIRED/CANCELLED:**
- 7d1. Hệ thống hiển thị E-LMP-008 (reservation bị hủy/hết hạn), cho hủy yêu cầu, đặt lại cuối queue nếu còn nhu cầu hoặc quay lại tra cứu.

**8a. `hold_expires_at` đi qua giữa lúc xác nhận pickup (cron vs pickup race):**
- 8a1. Reader đến quầy ngay sát hạn; trong lúc Thủ thư xác nhận, cron RES-T04 (hoặc check `now > hold_expires_at` tại commit) làm reservation `READY→EXPIRED` → CAS `READY→FULFILLED` thất bại → transaction pickup nhận E-LMP-005 + hiển thị trạng thái mới (`EXPIRED`), **không** tạo Loan.
- 8a2. Recovery: reload `reservation-pickup` ở trạng thái mới; copy đã advance cho người kế tiếp hoặc về `AVAILABLE` theo 7a2 — nếu vẫn `AVAILABLE` và reader còn nhu cầu thì checkout trực tiếp qua `uc-checkout` (copy không còn gắn hold), hoặc đặt lại cuối queue.
- 8a3. Grace period tại quầy (cho phép pickup vài phút sau hạn khi reader đã có mặt) là **Open — OQ-LMP-010**: không tự quyết; nếu chốt thì cấu hình trong hold_expiry policy và áp thống nhất cho cả cron RES-T04.

**Ngoài baseline:** `skip`/`suspend` reservation **không** có trong nguồn và không đưa vào — ghi Open tại DEC-D3-03, chỉ thêm khi domain approved.

## Related Requirements

- **FR:** FR-LMP-012 (đặt trước + hàng đợi, R2), FR-LMP-013 (hết hạn giữ chỗ, R2); liên quan FR-LMP-008/009 (checkout nguyên tử khi pickup), FR-LMP-019 (outbox notify).
- **BR:** BR-LMP-002 (copy `ON_HOLD` chỉ checkout cho đúng lượt), BR-LMP-005 (queue FIFO + transition nguyên tử), BR-LMP-006 (expiry advance atomically), BR-LMP-013 (audit cùng transaction), BR-LMP-016 (notify không fail business).
- **Nguồn:** BR-08/09/10, FR-R07/R08, §5 Reservation states, §6.3, §8 cron; AT-RSV-01..05 (lifecycle §7.2).
- **Errors:** E-LMP-005 (concurrency conflict), E-LMP-008 (reservation unavailable), E-LMP-015 (invalid state transition); delivery failure E-LMP-012/018 handled trong uc-notification-audit.
- **Open/Decision:** OQ-LMP-003 → resolved-as-PROPOSAL DEC-P2-05 (single release owner R2; R1A D5 luôn "không có hàng chờ"); OQ-LMP-010 (ngưỡng số đặt trước mở, hold expiry, SLA job); DEC-D3-03 (skip/suspend — Open, không baseline); DEC-D3-06 (re-queue khi copy held bị báo hư hỏng); DEC-D3-08 (escalation notify).
- **Release note:** toàn bộ UC này thuộc R2 (PROPOSAL — chờ L1 approve roadmap). Mọi transition/projection trong UC mang nhãn FACT (tên trạng thái, FIFO, sự tồn tại hold-expiry + cron 15 phút) hoặc PROPOSAL (giá trị hold_expiry — baseline 48h, cơ chế CAS/atomic/dedup/escalation).

<sub>Tài liệu thuộc bộ AI4BA BA-Kit — bản quyền ai4ba.com</sub>
