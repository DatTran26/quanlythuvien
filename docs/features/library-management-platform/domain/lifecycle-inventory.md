---
type: domain-model
feature: library-management-platform
status: draft
updated: 2026-10-05
links:
  - docs/he_thong_quan_ly_thu_vien.md
  - docs/_shared/project-profile.md
  - docs/features/library-management-platform/brainstorms/product-roadmap-baseline.md
  - docs/features/library-management-platform/srs/library-management-platform-spec.md
  - docs/_product/decision-register.md
  - plans/reports/ba-audit-261005-0018-library-management-roadmap.md
  - plans/261004-1734-library-management-full-ba-workflow/phase-03-domain-models-and-state-recovery.md
---

# Lifecycle inventory — Hệ thống Quản lý Thư viện

Artifact bền của Phase 3 (domain model và phục hồi state). Phase 4 consume file này để sinh state diagram, flow và ERD; file này **không phải** model SRS cuối.

## 0. Quy ước nhãn và trạng thái nguồn

| Nhãn | Nghĩa |
|------|-------|
| `FACT` | Có căn cứ trực tiếp trong `docs/he_thong_quan_ly_thu_vien.md`, `project-profile.md` hoặc roadmap baseline. Ghi kèm source ref. |
| `PROPOSAL` | Suy diễn/dựng lại để khép kín lifecycle; **chờ domain approval** qua decision register. Không được xem là requirement. |
| `APPROVED` | Chỉ dùng khi có evidence phê duyệt ghi trong `decision-register.md`. Hiện tại **không có mục nào APPROVED**. |

**Cảnh báo reconstruction (bắt buộc đọc):** sơ đồ "vòng đời bản sao · 7 trạng thái" và "luồng trả sách · 3 bước, 2 quyết định" trong tài liệu nguồn chỉ còn placeholder `[embedded content]` — nội dung gốc đã mất. Toàn bộ state machine Copy (Mục 2) và flow trả chi tiết (Mục 2.4) trong file này là **PROPOSAL do BA dựng lại** từ các business rule, scenario matrix và flow text còn lại. Chúng **không phải "phục hồi từ nguồn"** và phải qua domain approval (DEC-D3-01, DEC-D3-02; liên quan OQ-LMP-004) trước khi Phase 4 khoá state diagram.

## 1. Thuật ngữ và mô hình thực thể tổng

Thuật ngữ theo `docs/_shared/project-profile.md`. Cột "SRS alias" ánh xạ sang namespace đang dùng trong `library-management-platform-spec.md` để truy vết chéo.

| Thuật ngữ (profile) | Entity / tên mã | Vai trò trong domain | SRS alias |
|---------------------|-----------------|----------------------|-----------|
| Đầu sách | `Title` | Thông tin thư mục chung; đơn vị đặt trước và hàng chờ | `BibliographicRecord` |
| Bản sao | `Copy` | Cuốn vật lý, định danh QR, sở hữu `status` 7 trạng thái | `Copy` |
| Phiếu mượn | `Loan` | Một lần mượn **một** bản sao (OQ-06 default: không có phiếu cha) | `Loan` + `LoanItem` |
| Đặt trước | `Reservation` | Yêu cầu giữ chỗ trên một đầu sách + vị trí hàng chờ FIFO | `Reservation` |
| Khoản phạt | `Fine` | Nghĩa vụ tài chính; trạng thái suy ra từ ledger | `Fine` |
| Sự kiện tài chính | `FinancialEvent` | Bút toán append-only của Fine | `FinancialEvent` |
| Báo cáo hư hỏng | `DamageReport` | Hồ sơ hư hỏng + disposition của thủ thư | `DamageReport` |
| Người đọc | `User`/`ReaderProfile` | Chủ thẻ QR, chủ Loan/Reservation/Fine | `Reader` |
| Thông báo | `NotificationEvent` | Outbox bền cho thông báo | `NotificationEvent` |
| Nhật ký | `AuditEvent` | Audit ghi cùng transaction | `AuditEvent` |
| Cấu hình | `PolicyConfig` (`Setting`) | Tham số BR-01..BR-10 | `PolicyConfig` |

| Actor (profile) | Vai trò domain |
|-----------------|----------------|
| Người đọc | Tự phục vụ: tra cứu, đặt/hủy đặt trước, gia hạn online, xem phạt |
| Nhân viên | Quầy: quét QR, mượn/trả, báo hư hỏng, ghi mất, thu phạt tiền mặt |
| Thủ thư | Quản trị: duyệt hư hỏng/thanh lý, cấu hình quy định, miễn/điều chỉnh phạt (PROPOSAL), báo cáo |
| Thủ thư trưởng | Domain approver / Product Owner cho các PROPOSAL trong file này |
| Hệ thống | Tác vụ nền: quét quá hạn, hết hạn giữ, nhắc hạn; outbox; queue advance |

### 1.1 Quyền sở hữu trạng thái (single source of truth)

| Trường trạng thái | Aggregate sở hữu | Không ai khác được |
|-------------------|------------------|---------------------|
| `Copy.status` | Copy | Reservation/Loan không tự đổi trạng thái Copy; chỉ use case được phép ghi trong cùng transaction |
| `Loan.status` | Loan | Copy return chỉ đọc Loan, đóng Loan qua transition của Loan |
| `Reservation.status`, `Reservation.held_copy_id` | Reservation | Copy chỉ giữ trạng thái Đang giữ; gắn bản sao cụ thể là quyết định của Reservation |
| `Fine.status`, `Fine.balance` | Fine (suy từ `FinancialEvent`) | Không sửa `balance` trực tiếp; chỉ append event |
| `DamageReport.status` | DamageReport | Copy không tự duyệt; disposition là quyết định của report |
| Số lượng khả dụng | **Tính toán** (BR-11) | Không lưu counter; = số Copy ở trạng thái Sẵn sàng và `is_loanable` |

**Quy tắc lưu vs tính toán:** `Copy.status` là trạng thái **lưu**. "Khả dụng" (available count), "đang quá hạn bao nhiêu ngày", "số dư phạt" là giá trị **tính toán**. Không dùng "available" như trạng thái suy diễn mơ hồ — trạng thái lưu duy nhất tương ứng là `Sẵn sàng`, và điều kiện cho mượn thực tế = `Sẵn sàng` + `is_loanable` + không bị chặn bởi rule khác.

---

## 2. Copy (Bản sao) — state machine 7 trạng thái

**Nhãn tổng: `PROPOSAL`** (DEC-D3-01). Tên trạng thái lấy từ văn bản còn lại của nguồn (FACT về tên); ma trận transition đầy đủ là PROPOSAL.

### 2.1 Danh sách trạng thái

| # | Trạng thái | Code | Ý nghĩa | Tính vào "khả dụng"? | Terminal? | Nhãn |
|---|-----------|------|---------|----------------------|-----------|------|
| 1 | Sẵn sàng | `AVAILABLE` | Trên kệ, cho mượn được nếu `is_loanable` | Có (nếu loanable) | Không | FACT (tên) |
| 2 | Đang mượn | `ON_LOAN` | Gắn với một Loan đang mở | Không | Không | FACT (tên) |
| 3 | Đang giữ | `ON_HOLD` | Gắn với một Reservation `READY`, chờ người đặt đến lấy trong BR-10 | Không | Không | FACT (tên) |
| 4 | Chờ duyệt | `PENDING_REVIEW` | Bị báo cáo hư hỏng, chặn lưu thông chờ thủ thư (OQ-11 default) | Không | Không | FACT (tên) |
| 5 | Đang sửa | `IN_REPAIR` | Thủ thư đã duyệt sửa chữa | Không | Không | FACT (tên) |
| 6 | Mất | `LOST` | Đã ghi nhận mất; có thể quay lại qua found-after-lost | Không | Không | FACT (tên) |
| 7 | Đã thanh lý | `DISPOSED` | Ra khỏi kho vĩnh viễn | Không | **Có** | FACT (tên) |

Trạng thái khởi tạo: `∅ → AVAILABLE` khi đăng ký/import bản sao (PROPOSAL — nguồn ngụ ý qua FR-L03 và import; không còn sơ đồ gốc xác nhận).

### 2.2 Transition inventory

| ID | Từ | Sang | Trigger | Actor | Precondition | Side effect | Reversible? | Nhãn | Source ref |
|----|-----|------|---------|-------|--------------|-------------|-------------|------|------------|
| COPY-T00 | ∅ | AVAILABLE | Đăng ký/import bản sao | Thủ thư / Hệ thống import | QR duy nhất, title hợp lệ | Audit; cập nhật số khả dụng (tính toán) | — | PROPOSAL | FR-L03; OQ-15 |
| COPY-T01 | AVAILABLE | ON_LOAN | Xác nhận checkout | Nhân viên / Thủ thư | Reader đủ điều kiện (BR-03); `is_loanable`; BR-01/02 thoả; CAS status=`AVAILABLE` | Tạo Loan ACTIVE; audit; outbox notify; nếu đi kèm reservation đúng lượt thì Reservation→FULFILLED | Không; sửa sai qua quy trình điều chỉnh | FACT | §6.1; BR-13 |
| COPY-T02 | ON_HOLD | ON_LOAN | Checkout nhận sách đặt trước | Nhân viên / Thủ thư | Reservation `READY` thuộc đúng reader này; `hold_expires_at` chưa qua | Loan ACTIVE; Reservation→FULFILLED; audit; notify | Không | FACT | §6.3 bước 4; §5 Reservation |
| COPY-T03 | ON_LOAN | AVAILABLE | Trả bình thường, không có hàng chờ | Nhân viên / Thủ thư | Loan mở tồn tại; condition ghi nhận OK | Loan→RETURNED; assess phạt quá hạn (BR-05) nếu có; audit; notify phạt | Không | FACT | §5; §6.2; baseline D5 |
| COPY-T04 | ON_LOAN | ON_HOLD | Trả bình thường, có hàng chờ | Nhân viên / Thủ thư | Queue title ≠ ∅ | Loan→RETURNED; Reservation đầu hàng →READY + `held_copy_id` + `hold_expires_at=+48h` (BR-10); notify người đặt | Không | FACT | §6.3 bước 3; D5 |
| COPY-T05 | ON_LOAN | PENDING_REVIEW | Trả với hư hỏng | Nhân viên / Thủ thư | Condition ≠ OK khi trả | Loan→RETURNED; DamageReport PENDING gắn `loan_id`; assess phạt hư hỏng (BR-07); notify Thủ thư | Có điều kiện (qua disposition) | FACT | §6.2; §6.4 bước 4 |
| COPY-T06 | ON_LOAN | LOST | Ghi nhận mất sách | Nhân viên / Thủ thư | Loan mở tồn tại | Loan→LOST; assess bồi thường BR-06; audit; notify | Có điều kiện (COPY-T15/16) | FACT | FR-S07; §5 Loan |
| COPY-T07 | AVAILABLE | PENDING_REVIEW | Báo cáo hư hỏng ngoài luồng trả | Nhân viên / Thủ thư | Report hợp lệ (1–5 ảnh, severity) | DamageReport PENDING; chặn lưu thông ngay (OQ-11 default); notify Thủ thư | Có (COPY-T09) | FACT | §6.4 bước 1–2 |
| COPY-T08 | ON_HOLD | PENDING_REVIEW | Báo hư hỏng trên bản đang giữ | Nhân viên / Thủ thư | Report hợp lệ | DamageReport PENDING; **Reservation `READY` liên quan quay `WAITING` và giữ vị trí hàng chờ** | Có (COPY-T09) | PROPOSAL — DEC-D3-06 | Suy diễn; edge case chưa có nguồn |
| COPY-T09 | PENDING_REVIEW | AVAILABLE | Thủ thư bác bỏ báo cáo | Thủ thư | Disposition = REJECTED | DamageReport→REJECTED; audit | — | FACT | §6.4 bước 3 |
| COPY-T10 | PENDING_REVIEW | IN_REPAIR | Thủ thư duyệt sửa | Thủ thư | Disposition = REPAIR | DamageReport→REPAIR; audit | — | FACT | §6.4 bước 3 |
| COPY-T11 | PENDING_REVIEW | DISPOSED | Thủ thư duyệt thanh lý | Thủ thư | Disposition = DISPOSE | DamageReport→DISPOSE; audit; nếu có fine DAMAGE liên quan vẫn giữ độc lập | — | FACT | §6.4 bước 3 |
| COPY-T12 | IN_REPAIR | AVAILABLE | Hoàn tất sửa, không có hàng chờ | Nhân viên / Thủ thư | Xác nhận sửa xong + condition cập nhật | Audit; khả dụng tăng | — | FACT | §5 ghi chú |
| COPY-T13 | IN_REPAIR | ON_HOLD | Hoàn tất sửa, có hàng chờ | Nhân viên / Thủ thư | Queue title ≠ ∅ | Reservation đầu hàng →READY; giữ 48h; notify | — | FACT | §5 ghi chú (explicit) |
| COPY-T14 | IN_REPAIR | DISPOSED | Sửa không thành, thanh lý | Thủ thư | Quyết định của thủ thư | DamageReport bổ sung disposition DISPOSE hoặc report mới; audit | — | PROPOSAL — DEC-D3-07 | Suy diễn |
| COPY-T15 | LOST | AVAILABLE | Found-after-lost, reconcile xong, không hàng chờ | Nhân viên / Thủ thư | Kiểm tra vật lý; **financial reconciliation đã xong** (DEC-D3-05) | Compensation events (REVERSAL/ADJUSTMENT/REFUND nếu đã thu); audit bắt buộc | — | PROPOSAL — DEC-D3-05 | Baseline "Có điều kiện nếu tìm lại" |
| COPY-T16 | LOST | ON_HOLD | Found-after-lost, reconcile xong, có hàng chờ | Nhân viên / Thủ thư | Như T15 + queue ≠ ∅ | Như T15 + Reservation đầu hàng →READY | — | PROPOSAL — DEC-D3-05 | Suy diễn |
| COPY-T17 | AVAILABLE | DISPOSED | Thanh lý trực tiếp không qua hư hỏng | Thủ thư | Lý do bắt buộc; không Loan mở, không Reservation giữ | Audit; loại khỏi khả dụng | — | PROPOSAL — DEC-D3-07 | Suy diễn (BR-12 vô hiệu hoá) |
| COPY-T18 | ON_HOLD | AVAILABLE | Giải phóng giữ chỗ (hết hạn/hủy), không còn người chờ | Hệ thống (cron) / Nhân viên | Reservation chuyển EXPIRED/CANCELLED; queue rỗng sau khi advance | Outbox notify (nếu expiry); audit | — | FACT | §6.3 bước 4; §8 cron |
| COPY-T19 | ON_HOLD | ON_HOLD (re-hold) | Giải phóng giữ chỗ, queue còn người | Hệ thống | Queue advance nguyên tử cùng transaction với EXPIRED/CANCELLED | `held_copy_id` gán người kế tiếp; `hold_expires_at` reset; notify | — | FACT | §6.3 bước 4; BR-09 |

**Ghi chú COPY-T19:** trạng thái lưu không đổi (`ON_HOLD`) nhưng chủ thể giữ đổi — xem là transition nội bộ nguyên tử trong cùng boundary với `READY→EXPIRED/CANCELLED` của reservation trước và `WAITING→READY` của reservation kế tiếp.

### 2.3 Non-loanable và availability

| Rule | Nội dung | Nhãn |
|------|----------|------|
| CP-AVL-01 | "Khả dụng" = đếm Copy `status=AVAILABLE` **và** `is_loanable=true`; tính từ trạng thái, không lưu counter (BR-11). | FACT (BR-11) + PROPOSAL (phần is_loanable) |
| CP-AVL-02 | `is_loanable` là **thuộc tính**, không phải trạng thái; đặt trên Title (mặc định) và override được trên Copy. Copy non-loanable vẫn `AVAILABLE` nhưng bị từ chối ở COPY-T01/T02. | PROPOSAL — DEC-D3-09; theo default OQ-10 |
| CP-AVL-03 | Đổi `is_loanable` không phải state transition; vẫn ghi audit. | PROPOSAL |
| CP-AVL-04 | Copy `PENDING_REVIEW`/`IN_REPAIR`/`LOST`/`DISPOSED`/`ON_HOLD`/`ON_LOAN` đều không tính khả dụng và không checkout được. | FACT (suy trực tiếp từ BR-11 + §6.1) |

### 2.4 Flow trả sách (PROPOSAL — DEC-D3-02)

Nguồn chỉ còn placeholder "3 bước, 2 quyết định" + câu FACT: *"Phiếu luôn được đóng và tính phạt quá hạn trước, sau đó mới quyết định trạng thái mới của bản sao."* Reconstruction dưới đây khớp với baseline §5.3 và D3–D5:

```text
1. Quét QR bản sao → tìm Loan đang mở
      └─ D3: Có Loan mở? ──không──> Dừng, hiển thị "Không tìm thấy phiếu mượn đang mở"
2. Ghi nhận tình trạng trả: Bình thường / Hư hỏng (severity) / Mất
      └─ D4: Hư hỏng? → chuẩn bị PENDING_REVIEW + DamageReport
3. Đóng Loan (→RETURNED hoặc →LOST) + assess phạt (quá hạn BR-05, hư hỏng BR-07, mất BR-06)
      └─ D5: Copy quyết định trạng thái sau cùng:
            hư hỏng → PENDING_REVIEW | mất → LOST |
            bình thường + queue → ON_HOLD (allocate) | bình thường, queue rỗng → AVAILABLE
4. Audit trong cùng transaction; notification qua outbox; hiển thị kết quả cho nhân viên.
```

Thứ tự bắt buộc: **đóng Loan và tính phạt trước**, quyết định trạng thái Copy sau (FACT). Toàn bộ bước 3–4 trong một transaction (NFR-03).

### 2.5 Invalid transitions — Copy

| Từ → Sang | Vì sao invalid | Hành vi |
|-----------|----------------|---------|
| `DISPOSED → *` | Terminal; ra kho vĩnh viễn | API từ chối (E: invalid state transition) |
| `* → ON_LOAN` ngoài T01/T02 | Chỉ mượn từ `AVAILABLE` hoặc `ON_HOLD` đúng chủ | Từ chối + gợi ý trạng thái hiện tại |
| `ON_LOAN → ON_LOAN` | Không tự reset; gia hạn là thuộc tính Loan, không đổi Copy | Không áp dụng |
| `AVAILABLE → ON_HOLD` trực tiếp | Giữ chỗ chỉ qua allocation của Reservation (COPY-T19 hoặc T04/T13) | Từ chối |
| `PENDING_REVIEW → ON_LOAN/ON_HOLD` | Chưa có disposition | Từ chối |
| `LOST → ON_LOAN` | Loan đã đóng `LOST`; found đi qua T15/T16 + reconcile | Từ chối |
| `IN_REPAIR → ON_LOAN` | Phải về AVAILABLE/ON_HOLD trước | Từ chối |
| `ON_HOLD → PENDING_REVIEW` do người đặt hủy | Hủy reservation giải phóng qua T18/T19, không tạo DamageReport | Từ chối nghiệp vụ sai |

---

## 3. Loan (Phiếu mượn)

Trạng thái: `ACTIVE` (Đang mượn) · `OVERDUE` (Quá hạn) · `RETURNED` (Đã trả) · `LOST` (Mất) — **FACT** (§5). `RETURNED`, `LOST` là terminal.

| ID | Từ | Sang | Trigger | Actor | Precondition | Side effect | Reversible? | Nhãn | Source ref |
|----|-----|------|---------|-------|--------------|-------------|-------------|------|------------|
| LOAN-T01 | ∅ | ACTIVE | Checkout commit | Nhân viên / Thủ thư | Reader đủ điều kiện; Copy CAS thành công; BR-01/02 | Copy→ON_LOAN; `due_at=borrowed+BR-04`; outbox notify kèm hạn trả; audit | — | FACT | §6.1 |
| LOAN-T02 | ACTIVE | OVERDUE | Cron quét quá hạn 00:05 | Hệ thống | `now > due_at` và chưa trả | Cập nhật phạt tạm tính; notify quá hạn (ngày đầu + mỗi 3 ngày); BR-03 chặn mượn mới | Có (đóng bằng RETURNED/LOST) | FACT | §5; §8 cron |
| LOAN-T03 | ACTIVE | ACTIVE (renew) | Gia hạn | Người đọc / Nhân viên / Thủ thư | `renew_count < limit`; chưa quá hạn; title không có Reservation đang chờ (BR-04) | `due_at += 7 ngày`; `renew_count++`; audit | Không tự hoàn; trả sớm vẫn được | FACT | FR-R06/S06; BR-04 |
| LOAN-T04 | ACTIVE/OVERDUE | RETURNED | Trả sách | Nhân viên / Thủ thư | Loan mở của đúng Copy | `returned_at`, `return_condition`, `closed_by`; assess fine quá hạn/hư hỏng; Copy transition T03/T04/T05 | Không; sửa sai qua điều chỉnh + audit | FACT | §5; §6.2 |
| LOAN-T05 | ACTIVE/OVERDUE | LOST | Ghi nhận mất | Nhân viên / Thủ thư | Loan mở; xác nhận với người đọc | `closed_by`; assess fine LOST (BR-06); Copy→LOST | **Không reopen** — found xử lý ở Copy + Fine (DEC-D3-05) | FACT + PROPOSAL (phần không reopen) | §5; FR-S07 |

**Concurrency conflict (FACT BR-13 + NFR-03):** hai giao dịch tranh cùng Copy → chỉ ghi trước (CAS trên `Copy.version` + allowed-source-state) thành công; giao dịch sau nhận lỗi "Sách vừa được cập nhật. Vui lòng quét lại để xem trạng thái mới." Renew đua với trả/mất: transition đầu tiên commit thắng, transition sau nhận invalid-state.

**Invalid transitions — Loan:** `RETURNED/LOST → *` (terminal); `OVERDUE → ACTIVE` mà không qua renew hợp lệ; `∅ → OVERDUE/RETURNED/LOST` (phải qua ACTIVE); double-return (Loan đã `RETURNED` bị đóng lần nữa) → idempotent reject, trả kết quả gốc.

---

## 4. Reservation (Đặt trước)

Trạng thái: `WAITING` (Đang chờ) · `READY` (Sẵn sàng lấy) · `FULFILLED` (Đã nhận) · `EXPIRED` (Hết hạn) · `CANCELLED` (Đã hủy) — **FACT** (§5, FR-R08). `FULFILLED`, `EXPIRED`, `CANCELLED` là terminal.

| ID | Từ | Sang | Trigger | Actor | Precondition | Side effect | Reversible? | Nhãn | Source ref |
|----|-----|------|---------|-------|--------------|-------------|-------------|------|------------|
| RES-T01 | ∅ | WAITING | Người đọc/nhân viên tạo đặt trước | Người đọc / Nhân viên / Thủ thư | Title `khả dụng = 0` (BR-08); reader < 3 đặt trước mở; **không có reservation mở khác cho cùng title** | Vào cuối queue FIFO (BR-09); hiển thị vị trí; audit | — | FACT + PROPOSAL (dedup cùng title) | §6.3; BR-08/09 |
| RES-T02 | WAITING | READY | Allocation khi có Copy | Hệ thống | Reservation ở đầu queue của title; Copy vừa về (T04/T13/T15/T16/T19) | **Nguyên tử cùng transaction**: Copy→ON_HOLD; `held_copy_id`; `hold_expires_at=+48h`; outbox notify "đến nhận trong 48h" | Không (chỉ tiến EXPIRED/CANCELLED/FULFILLED) | FACT | §6.3 bước 3 |
| RES-T03 | READY | FULFILLED | Người đặt đến nhận, checkout | Nhân viên / Thủ thư | `hold_expires_at` chưa qua; reader đủ điều kiện mượn | Loan ACTIVE qua COPY-T02; audit; notify xác nhận | Không | FACT | §5; §6.3 bước 4 |
| RES-T04 | READY | EXPIRED | Cron hết hạn giữ (mỗi 15 phút) | Hệ thống | `now > hold_expires_at` | **Nguyên tử**: giải phóng Copy (T18/T19); advance queue; notify "đặt trước hết hạn giữ" | Không | FACT | §5; §8 cron; BR-10 |
| RES-T05 | WAITING | CANCELLED | Người đọc/nhân viên hủy | Người đọc / Nhân viên / Thủ thư | Reservation đang mở của chính reader (hoặc thay mặt) | Rời queue; audit | Không | FACT | §5; ma trận quyền |
| RES-T06 | READY | CANCELLED | Hủy khi đang giữ | Như RES-T05 | Như trên | **Nguyên tử**: giải phóng Copy → advance queue (T19) hoặc AVAILABLE (T18); audit | Không | FACT | §5 |

**Notification failure (bắt buộc — kịch bản kiểm tra Phase 3):** business transition commit trước; notify đi qua durable outbox với retry có kiểm soát và dead-letter. `READY` không tự hủy vì notify lỗi; `hold_expires_at` vẫn chạy. Escalation: sau ngưỡng retry, tạo cảnh báo vận hành cho nhân viên trực (PROPOSAL — kênh escalation cần domain duyệt, gộp DEC-D3-08).

**`skip`/`suspend`:** **không đưa vào baseline.** Nguồn không có; phase contract yêu cầu chỉ thêm khi có domain approval → ghi Open tại DEC-D3-03.

**Race hủy-vs-allocate:** hủy đúng lúc allocation chạy → CAS trên `Reservation.status`: nếu allocation commit trước thì cancel đi nhánh RES-T06 (giải phóng copy); nếu cancel commit trước thì allocation bỏ qua và advance queue. Cả hai idempotent (PROPOSAL — cơ chế, FACT về yêu cầu BR-13).

**Invalid transitions — Reservation:** `WAITING → FULFILLED` (phải qua READY + pickup); `terminal → *`; `READY → WAITING` (trừ nhánh T08 của Copy — re-queue là PROPOSAL DEC-D3-06); tạo RES mới khi title còn bản khả dụng (vi phạm BR-08).

---

## 5. Fine (Khoản phạt) & FinancialEvent ledger

### 5.1 Trạng thái Fine

`UNPAID` (chưa trả) · `PAID` (đã trả) · `WAIVED` (đã miễn) — **FACT** (data model §7). `PAID`/`WAIVED` là terminal.

- `balance` **không lưu trực tiếp** — suy từ ledger: `balance = Σ ASSESSMENT + Σ ADJUSTMENT(+) − Σ PAYMENT − Σ WAIVER − Σ ADJUSTMENT(−) − Σ REVERSAL` (PROPOSAL — công thức; FACT về nguyên tắc append-only từ red-team).
- `UNPAID → PAID` khi balance về 0 do PAYMENT; `→ WAIVED` khi balance về 0 do WAIVER (hoặc hỗn hợp, event cuối quyết định nhãn — PROPOSAL).
- Không có trạng thái `PARTIALLY_PAID`: thanh toán một phần là PAYMENT event < balance, Fine vẫn `UNPAID`. **Partial payment là PROPOSAL** chờ finance approval (DEC-D3-04 / OQ-LMP-005).
- Sai sót sau khi đóng: **không reopen**; ghi REVERSAL/ADJUSTMENT event mới; nếu tạo nghĩa vụ mới thì mở Fine mới (PROPOSAL).

### 5.2 FinancialEvent types (append-only)

| Event | Chiều tiền | Actor được phép | Nhãn |
|-------|-----------|-----------------|------|
| `ASSESSMENT` | + nghĩa vụ | Hệ thống (đóng Loan) / Thủ thư (manual) | FACT (BR-05/06/07) + PROPOSAL (manual) |
| `PAYMENT` | − (ghi nhận thu tiền mặt) | Nhân viên / Thủ thư (FR-S08) | FACT |
| `WAIVER` | − (miễn) | **Thủ thư** trở lên + lý do bắt buộc | PROPOSAL — DEC-D3-04 |
| `ADJUSTMENT` | ± (điều chỉnh) | **Thủ thư** + lý do; ngưỡng cần duyệt cao hơn là OQ | PROPOSAL — OQ-LMP-005 |
| `REVERSAL` | đảo một event sai | **Thủ thư** + tham chiếu event gốc | PROPOSAL — OQ-LMP-009 |
| `REFUND` | − tiền ra (đã thu thừa) | **Thủ thư**; theo policy finance | PROPOSAL — OQ-LMP-005 |
| `RECONCILIATION` | 0 (đối soát ca/kỳ) | Thủ thư (đối soát thu ngân cuối ca) | PROPOSAL — DEC-D3-08 |

**Quyền hạn & SoD (PROPOSAL — DEC-D3-04):**
- Nhân viên: chỉ `PAYMENT`. Không được WAIVE/ADJUST/REVERSE/REFUND.
- Thủ thư: toàn bộ event; người duyệt `WAIVER/ADJUSTMENT` **không được là người đã tạo `ASSESSMENT` thủ công** cho cùng khoản (segregation of duties, PROPOSAL).
- Ngưỡng tiền cần phê duyệt cấp cao hơn (Thủ thư trưởng/finance): OQ-LMP-005/009 — không tự chốt con số.
- Mọi event nhạy cảm yêu cầu `reason` + audit cùng transaction; `PAYMENT` phát hành `receipt_no` **duy nhất** (PROPOSAL — DEC-D3-08).

**Đường hoàn tất Fine:** `ASSESSMENT` mở nghĩa vụ → PAYMENT/WAIVER/ADJUSTMENT đưa balance về 0 → `PAID`/`WAIVED` đóng. Reversal/refund sau đóng tạo dư âm → xử lý bằng `REFUND` event + reconcile (PROPOSAL).

**Ledger integrity requirements:**
1. `FinancialEvent` append-only: không UPDATE/DELETE; sửa sai bằng `REVERSAL` trỏ event gốc.
2. Mọi event ghi cùng transaction với business action tạo ra nó; audit fail → rollback.
3. Payment idempotent theo operation key (xem §7): double-submit không tạo hai PAYMENT.
4. `Fine.balance` tính lại được từ ledger; reconcile job đối chiếu `balance` vs Σ events → lệch thì `RECONCILIATION` + cảnh báo (PROPOSAL).
5. **Lost→found compensation (DEC-D3-05):** khi Copy `LOST` được tìm thấy (COPY-T15/T16), nghĩa vụ LOST đã assess không tự xóa. Nếu chưa thu → `REVERSAL`/`ADJUSTMENT` về 0. Nếu đã thu → `REFUND` theo policy finance. Có thể giữ phần phí xử lý BR-06 — **OQ-LMP-005, không tự quyết**.

---

## 6. DamageReport (Báo cáo hư hỏng)

Trạng thái: `PENDING` (Chờ duyệt) · `REPAIR` (Sửa chữa) · `DISPOSE` (Thanh lý) · `REJECTED` (Bác bỏ) — **FACT** (data model §7, §6.4). `REPAIR`, `DISPOSE`, `REJECTED` là terminal cho report (Copy đi tiếp theo disposition).

| ID | Từ | Sang | Trigger | Actor | Precondition | Side effect | Reversible? | Nhãn | Source ref |
|----|-----|------|---------|-------|--------------|-------------|-------------|------|------------|
| DMG-T01 | ∅ | PENDING | Báo cáo hư hỏng (quầy hoặc khi trả) | Nhân viên / Thủ thư | 1–5 ảnh, severity Nhẹ/Vừa/Nặng, note; Copy đang AVAILABLE/ON_HOLD/ON_LOAN(qua trả) | Copy→PENDING_REVIEW (OQ-11 default chặn ngay); notify Thủ thư; link `loan_id` nếu phát hiện lúc trả; audit | — | FACT | §6.4; FR-S05 |
| DMG-T02 | PENDING | REPAIR | Thủ thư duyệt sửa | Thủ thư | Review đủ evidence | Copy→IN_REPAIR; audit | Không (terminal report) | FACT | §6.4 bước 3; FR-L08 |
| DMG-T03 | PENDING | DISPOSE | Thủ thư duyệt thanh lý | Thủ thư | Review đủ evidence | Copy→DISPOSED; audit; fine DAMAGE (nếu gắn loan) giữ độc lập | Không | FACT | §6.4 bước 3 |
| DMG-T04 | PENDING | REJECTED | Thủ thư bác bỏ | Thủ thư | Xác định không hư hỏng | Copy→AVAILABLE **hoặc trạng thái lưu trước report nếu vẫn hợp lệ** (ON_HOLD nếu giữ chỗ còn hiệu lực); audit | Không | FACT + PROPOSAL (phần khôi phục trạng thái trước) | §6.4 bước 3 |

**Liên kết:** `DamageReport.loan_id` (nullable) liên kết return phát hiện hư hỏng → phạt BR-07 gắn Loan đó (FACT §6.4 bước 4). Disposition `REPAIR` → theo dõi Copy qua IN_REPAIR; hoàn tất sửa cập nhật `Copy.condition`.

**Quy tắc bổ sung (PROPOSAL):** một Copy chỉ có **một** DamageReport `PENDING` tại một thời điểm; báo cáo lặp trên cùng Copy gộp vào report đang mở hoặc bị từ chối idempotent. Report không tự đóng — chỉ đóng khi có disposition + audit (khớp BR-LMP-009).

---

## 7. Atomicity & idempotency requirements

### 7.1 Checkout (mượn nhiều bản sao)

| Req | Nội dung | Nhãn |
|-----|----------|------|
| AT-CHK-01 | **All-or-nothing commit set:** một lần xác nhận tạo N Loan + N transition Copy→ON_LOAN + đóng Reservation liên quan + audit + outbox, trong **một transaction**. Bất kỳ điều kiện nào fail (BR-01/02/03, CAS, `is_loanable`) → rollback toàn bộ, không Loan nào được ghi. | FACT (NFR-03; baseline §5.2) + PROPOSAL (chi tiết cơ chế) |
| AT-CHK-02 | **Operation key:** client phát sinh `operation_id` cho mỗi lần xác nhận; server có unique constraint trên `operation_id`. Submit lặp/mất mạng sau confirm → trả về kết quả gốc (**query-by-operation recovery**), không tạo Loan thứ hai. | PROPOSAL (khớp baseline §6.4) |
| AT-CHK-03 | **Concurrency:** CAS theo `Copy.version` + allowed-source-state (`AVAILABLE` hoặc `ON_HOLD` đúng chủ). Thao tác sau nhận E conflict "Sách vừa được cập nhật". | FACT (BR-13, NFR-03) |
| AT-CHK-04 | Audit write nằm **trong** transaction; audit fail → business write fail. | FACT (NFR-04) + PROPOSAL (fail-closed) |
| AT-CHK-05 | Notification không làm fail transaction chính; ghi outbox event trong transaction, delivery retry sau. | PROPOSAL (khớp BR-LMP-016) |

### 7.2 Reservation allocation & hold

| Req | Nội dung | Nhãn |
|-----|----------|------|
| AT-RSV-01 | **Atomic boundary:** `WAITING→READY` của đầu queue + `Copy→ON_HOLD` + `held_copy_id` + `hold_expires_at` + outbox notify là một transaction; enforce bằng allowed-source-state CAS trên cả hai aggregate. | PROPOSAL (khớp BR-LMP-005) |
| AT-RSV-02 | **Unique active hold:** một Copy tối đa một Reservation `READY` giữ; một reader tối đa một Reservation mở cho cùng title (constraint DB). | PROPOSAL |
| AT-RSV-03 | **Idempotent expire/cancel/fulfill:** cron expiry, cancel, pickup đều CAS theo trạng thái hiện tại; chạy lặp trả kết quả gốc, không nhân đôi side effect (queue advance, notify, fine). | PROPOSAL (khớp baseline §6.4) |
| AT-RSV-04 | **Queue advance nguyên tử:** khi `READY→EXPIRED/CANCELLED`, giải phóng Copy và gán người kế tiếp (COPY-T19) hoặc về AVAILABLE (T18) trong cùng transaction — không có trạng thái trung gian "copy vừa free chưa ai giữ" lộ ra ngoài. | PROPOSAL |
| AT-RSV-05 | FIFO = thứ tự `created_at` hợp lệ; allocation luôn chọn đầu queue tại thời điểm commit (BR-09). | FACT |

### 7.3 Tài chính

| Req | Nội dung |
|-----|----------|
| AT-FIN-01 | `FinancialEvent` append-only; `Fine.status`/`balance` suy từ events hoặc lưu cache đối soát được. |
| AT-FIN-02 | Payment dùng operation key + `receipt_no` unique; replay trả biên nhận gốc. |
| AT-FIN-03 | Reconcile: job ca/ngày đối chiếu tiền mặt ghi nhận vs events; lệch → `RECONCILIATION` + alert (PROPOSAL — DEC-D3-08). |
| AT-FIN-04 | Lost→found: compensation events + Copy transition trong một transaction; không xóa event đã ghi (DEC-D3-05). |

---

## 8. Review tính toàn vẹn chéo aggregate

| Kiểm tra | Kết quả |
|----------|---------|
| Mọi state có đường vào | Đạt — ∅→AVAILABLE (T00), ∅→ACTIVE, ∅→WAITING, ∅→UNPAID, ∅→PENDING đều có trigger |
| Terminal hợp lệ | `DISPOSED`, `RETURNED`/`LOST` (Loan), `FULFILLED`/`EXPIRED`/`CANCELLED`, `PAID`/`WAIVED`, `REPAIR`/`DISPOSE`/`REJECTED` — tất cả có lý do terminal |
| Không orphan state | `PENDING_REVIEW` có 3 đường ra (T09/10/11); `IN_REPAIR` có 3 (T12/13/14); `LOST` có 2 (T15/16 — PROPOSAL); `ON_HOLD` có 3 (T02/T18/T19/T08) |
| Side effect có owner | Fine→System/Thủ thư; notify→outbox; audit→cùng transaction; queue advance→Hệ thống trong transaction allocation |
| Hai aggregate cùng sở hữu một quyết định | Không — xem bảng §1.1; Copy↔Reservation cập nhật chéo chỉ qua use case trong một transaction |
| Trạng thái suy diễn mơ hồ | "Khả dụng"/"balance"/vị trí queue đều ghi là tính toán (§1.1, §2.3, §5.1) |
| Kịch bản kiểm tra Phase 3 | Đủ phủ: double-checkout (AT-CHK-03), damaged return + queue (T05 + DEC-D3-06), adjust sau partial pay (§5, DEC-D3-04), lost→found (T15/16 + §7.3), notify fail (§4 + AT-RSV-03) |

## 9. Open items → decision register

| Decision | Nội dung | Approver đề xuất | Gate |
|----------|----------|------------------|------|
| DEC-D3-01 | Copy state machine 7 trạng thái (toàn bộ §2) | Thủ thư trưởng (domain) | Trước khi Phase 4 khoá state diagram |
| DEC-D3-02 | Return flow §2.4 | Thủ thư trưởng | Cùng DEC-D3-01 |
| DEC-D3-03 | Reservation `skip`/`suspend` | Product owner | Chỉ thêm khi approved; hiện **không** có trong baseline |
| DEC-D3-04 | Partial payment, waiver/adjustment authority, SoD | Finance owner + Thủ thư trưởng | OQ-LMP-005/009 |
| DEC-D3-05 | Lost→found compensation & giữ/phần phí xử lý | Finance owner | OQ-LMP-005 |
| DEC-D3-06 | Copy `ON_HOLD` bị báo hư hỏng → reservation re-queue | Thủ thư trưởng | Trước SRS states |
| DEC-D3-07 | Disposal trực tiếp / sửa-không-thành thanh lý | Thủ thư trưởng | Trước SRS states |
| DEC-D3-08 | Receipt numbering, cashier reconciliation, escalation notify | Finance + product owner | Trước release có thu phạt |
| DEC-D3-09 | `is_loanable` Title/Copy model | Thủ thư trưởng | OQ-10 default đang dùng |

Liên quan OQ hiện hữu: OQ-LMP-003 (release boundary Reservation), OQ-LMP-004 (sơ đồ gốc mất), OQ-LMP-005/009 (financial policy), OQ-LMP-010 (ngưỡng BR).
