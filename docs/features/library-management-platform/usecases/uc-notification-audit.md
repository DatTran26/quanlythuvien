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

# Use Case: Phát thông báo qua outbox và ghi/xem nhật ký kiểm toán (uc-notification-audit)

> Scope: library-management-platform · Level: sea
> Screens: `notification-status`, `audit-log`, `history-timeline` · Release: audit capture **R0** (DEC-P2-06 — PROPOSAL); notify tối thiểu in-app + email cho sự kiện quan trọng **R1A** (DEC-P2-01); trung tâm thông báo đầy đủ + audit viewer + history timeline **R1B** (FR-LMP-020/027, FR-C04/FR-L10).

## Primary Actor

Hệ thống (ghi AuditEvent cùng transaction, vận hành outbox/retry/dead-letter, cron nhắc hạn — FACT §8) · Quản trị viên (xem audit log, notification status, history timeline — R1B; FACT nguồn §9 "chỉ Thủ thư" = Quản trị viên theo mapping spec §2 — mở rộng cho Thủ thư quầy là PROPOSAL lệch ma trận)

## Stakeholders & Interests

| Stakeholder | Interest |
|-------------|----------|
| Người đọc | Nhận thông báo đúng sự kiện/thời điểm (mượn kèm hạn trả, sắp hạn −2 ngày, quá hạn ngày đầu + mỗi 3 ngày, sách đặt sẵn, hết hạn giữ, phát sinh phạt — FACT §8); không mất thông báo khi kênh ngoài lỗi |
| Bảo mật/pháp chế | Audit đầy đủ actor/action/resource/result/before-after/lý do; PII redacted trong payload (NFR-LMP-010); field-level access deny mặc định (BR-LMP-015); retention là **Open** (OQ-LMP-006) |
| Vận hành | Outbox bền không mất event khi kênh lỗi (NFR-LMP-007); dead-letter có owner xử lý; audit fail = action fail (không để sensitive action không audit — SC-LMP-06) |
| Product owner | Kênh bắt buộc cuối cùng là **Open** (OQ-LMP-008); baseline đề xuất in-app + email sự kiện quan trọng (DEC-P2-01); SMS/push/Zalo là R3 candidate — không cam kết |

## Trigger

- Một business action có phát sinh thông báo và/hoặc audit commit (checkout, trả, assess phạt, allocation reservation, báo hư hỏng, khóa tài khoản, import, đổi cấu hình…).
- Cron nghiệp vụ chạy theo lịch: quét quá hạn 00:05, nhắc sắp đến hạn 08:00, hết hạn giữ mỗi 15 phút (FACT — nguồn §8).
- Quản trị viên mở `audit-log`, `notification-status` hoặc `history-timeline` để truy vết (R1B).

## Preconditions

- Business action kích hoạt đã qua xác thực/ủy quyền riêng (audit **ghi** là nghĩa vụ hệ thống, không phụ thuộc quyền xem).
- Outbox storage và audit sink khả dụng trong transaction boundary của action.
- `PolicyConfig` có cấu hình kênh thông báo hiệu lực (FR-LMP-021); nếu chưa chốt kênh ngoài thì in-app là kênh tối thiểu luôn sẵn.
- Xem audit/notification của người khác yêu cầu quyền actor × resource × action × field × purpose (NFR-LMP-004, BR-LMP-015).

## Guarantees

- **Minimal Guarantee:** Không có sensitive action nào commit mà thiếu AuditEvent — audit write fail → business write rollback (E-LMP-013, BR-LMP-013, NFR-LMP-006, fail-closed). Notification **không bao giờ** làm fail business transaction (BR-LMP-016): business commit ghi outbox record, delivery xử lý sau.
- **Success Guarantee:** Mọi business event có `NotificationEvent` outbox tồn tại sau commit (SC-LMP-05); delivery retry có kiểm soát, trạng thái đầy đủ (pending → delivered/failed → dead-letter); mọi sensitive action có audit trace actor/action/resource/result (SC-LMP-06); người có quyền xem được timeline nhất quán của entity (FR-LMP-027).

## Main Success Scenario

1. Business action chạy trong transaction; trước khi commit, hệ thống append:
   - `AuditEvent{ actor_id, action, entity, entity_id, before, after, at, reason khi có }` — redacted, không lộ secrets/PII không cần thiết (FACT nguồn §7/NFR-04 + PROPOSAL payload tối thiểu).
   - `NotificationEvent` vào outbox bền với loại sự kiện, người nhận, kênh resolve từ `PolicyConfig` (in-app mặc định + email cho sự kiện quan trọng — PROPOSAL DEC-P2-01).
2. Transaction commit → business state, audit và outbox record cùng tồn tại (AT-CHK-04/05).
3. Job outbox đọc event `pending`, resolve kênh + địa chỉ nhận, gửi qua kênh tương ứng.
4. Kênh xác nhận → cập nhật `NotificationEvent.status = delivered` + `sent_at`; retry counter reset.
5. Người đọc xem thông báo trong app (badge/danh sách — FR-C04 trung tâm đầy đủ ở R1B; R1A chỉ đảm bảo đường phát tối thiểu).
6. Quản trị viên mở `audit-log` hoặc `history-timeline`, lọc theo actor/entity/thời gian; hệ thống hiển thị chuỗi AuditEvent + trạng thái đã truy vết của Copy/Loan/Reservation/Fine/DamageReport (FR-LMP-027 — R1B) và delivery status trên `notification-status`.

## Extensions

**1a. Audit sink không ghi được (E-LMP-013 — critical):**
- 1a1. Toàn bộ business write rollback trong cùng transaction — hành động nhạy cảm **thất bại theo**, không để sót hành động không audit (NFR-LMP-006).
- 1a2. Alert vận hành ngay; UI hiển thị blocking error cho sensitive action; retry chỉ sau khi audit sink phục hồi.

**3a. Kênh ngoài timeout/reject (E-LMP-012):**
- 3a1. Cập nhật `NotificationEvent.status = failed`, ghi lỗi; retry theo policy (số lần + backoff — ngưỡng là OQ-LMP-010, không tự chốt).
- 3a2. Vượt ngưỡng retry → `dead-letter` + cảnh báo vận hành có owner xử lý (NFR-LMP-007); business event vẫn committed.
- 3a3. Escalation cho Thủ thư trực quầy sau dead-letter là PROPOSAL (DEC-D3-08).

**3b. Outbox/queue hoặc toàn bộ channel down (E-LMP-018):**
- 3b1. `notification-status` hiển thị degraded; events tích lũy trong outbox bền, delivery tiếp tục khi kênh phục hồi — không mất thông báo (FR-LMP-019).
- 3b2. Business transaction vẫn commit bình thường (BR-LMP-016).

**3c. Kênh yêu cầu ngoài baseline (SMS/push/Zalo):**
- 3c1. `PolicyConfig` không có kênh → event vẫn đi kênh mặc định in-app (+email nếu sự kiện quan trọng); kênh mới chỉ thêm khi OQ-LMP-008 resolved và release R3 được lập riêng (CAP-MSGALT — candidate, không cam kết).

**3d. Người nhận thiếu/sai địa chỉ kênh (E-LMP-012 — failed, lý do phân biệt được):**
- 3d1. Địa chỉ kênh trống, sai định dạng, hoặc không còn hợp lệ (email bounce cứng, số điện thoại không tồn tại) → đánh `failed` với **mã lý do riêng** phân biệt được với lỗi kênh tạm thời (3a) — ví dụ `invalid-recipient` vs `channel-timeout`; **không retry vô ích** (skip hoặc fail-fast sau 1 lần), surface lên `notification-status` để vận hành/data owner sửa địa chỉ.
- 3d2. In-app luôn khả dụng nên thông báo **không mất hoàn toàn**: nội dung vẫn ghi vào hộp thư in-app của người nhận khi kênh ngoài fail (PROPOSAL — hành vi fallback kênh).
- 3d3. Recovery: khi địa chỉ được sửa (qua `uc-reader-admin`/quản trị tài khoản), event có thể được requeue thủ công hoặc để yên ở `failed` với lý do — policy requeue là PROPOSAL.

**5a. Cron emit thông báo theo lịch (FACT §8 — PROPOSAL cơ chế):**
- 5a1. Job 00:05 chuyển Loan `OVERDUE` + cập nhật phạt tạm tính + emit notify quá hạn (ngày đầu, lặp mỗi 3 ngày); job 08:00 emit nhắc "sắp đến hạn" cho Loan có hạn trong 2 ngày; job 15 phút emit "hết hạn giữ".
- 5a2. Mọi job chạy idempotent theo kỳ — chạy lại không nhân đôi NotificationEvent (baseline §6.4 "tác vụ nền chạy lại").

**6a. Actor thiếu quyền xem audit/timeline (E-LMP-016, E-LMP-002 related):**
- 6a1. Deny mặc định + mask field nhạy cảm; ghi audit access attempt (BR-LMP-015). Người đọc chỉ xem dữ liệu của chính mình ("riêng" — ma trận quyền nguồn); audit log chỉ đọc (FR-L10).

**6b. Truy vết lịch sử entity (FR-LMP-027 — R1B, PROPOSAL):**
- 6b1. `history-timeline` hiển thị lịch sử trạng thái + sự kiện liên quan của Copy/Loan/Reservation/Fine/DamageReport: state transitions, financial events, damage reports, notification outcomes.
- 6b2. Dữ liệu tài chính/PII trong timeline tuân field-level masking như 6a.

## Related Requirements

- **FR:** FR-LMP-019 (thông báo bền — outbox + retry + dead-letter), FR-LMP-020 (audit cùng transaction), FR-LMP-027 (truy vết lịch sử — R1B); emitters: FR-LMP-008/010/012/013/014/017/018/021/022 (mọi UC ghi đều include audit + outbox).
- **BR:** BR-LMP-013 (audit cùng transaction, fail → fail), BR-LMP-015 (field-level deny mặc định), BR-LMP-016 (notify không fail business; outbox trong transaction, delivery retry sau).
- **NFR:** NFR-LMP-006 (audit fail → action fail), NFR-LMP-007 (retry có kiểm soát + dead-letter), NFR-LMP-010 (log đủ điều tra, không lộ secrets/PII).
- **Nguồn:** §8 bảng sự kiện thông báo + cron (00:05 quá hạn, 08:00 nhắc hạn, 15 phút hết hạn giữ, hằng ngày hết hạn thẻ); FR-C04, FR-L10; NFR-04; OQ-07 (kênh → OQ-LMP-008).
- **Errors:** E-LMP-012 (delivery failed → retry/dead-letter), E-LMP-013 (audit write failed → rollback + alert), E-LMP-016 (field-level access denied), E-LMP-018 (channel unavailable → degraded, business vẫn commit).
- **Open/Decision:** OQ-LMP-008 (kênh bắt buộc — Open); DEC-P2-01 (baseline in-app + email, trung tâm R1B, SMS/push/Zalo → R3); DEC-P2-06 (audit capture R0, viewer R1B); DEC-D3-08 (escalation khi notify fail — PROPOSAL); OQ-LMP-006 (retention audit — Open, non-waivable trước GATE-GNG).
- **Screens:** `notification-status`, `audit-log`, `history-timeline`.
- **Nhãn tổng:** FACT = bảng sự kiện/thời điểm thông báo, cron schedule, audit ghi mọi thao tác tạo/sửa/xóa, audit-log chỉ đọc. PROPOSAL = cấu trúc outbox/dead-letter, escalation, cấu trúc AuditEvent tối thiểu, timeline viewer. Open = kênh cuối (OQ-LMP-008), ngưỡng retry (OQ-LMP-010), retention (OQ-LMP-006).

<sub>Tài liệu thuộc bộ AI4BA BA-Kit — bản quyền ai4ba.com</sub>
