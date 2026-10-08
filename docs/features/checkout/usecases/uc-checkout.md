---
type: usecase
feature: checkout
status: draft
updated: 2026-10-08
links:
  - docs/features/checkout/usecases/checkout-usecase-index.md
  - docs/features/checkout/srs/checkout-spec.md
  - docs/_shared/domain/lifecycle-inventory.md
---

# Use Case: Mượn sách nguyên tử tại quầy (uc-checkout)

> Scope: checkout · Level: sea
> Screens: `circulation-desk`, `checkout-scan`, `checkout-review`, `checkout-conflict` · Release: R1A (FR-checkout-001, FR-checkout-002), R0 (FR-copy-inventory-002 locator)
> **Lưu ý nhãn/Open:** ngưỡng loan limit, hạn mượn là policy **PROPOSAL — OQ-policy-config-001** (baseline đề xuất: tối đa 5 bản sao đang mượn, hạn 14 ngày — chưa chốt); Copy `ON_HOLD→ON_LOAN` qua reservation đúng lượt chỉ khả dụng từ **R2** (DEC-P2-05 — luồng R1A không có hàng chờ); cơ chế `operation_id`/CAS chi tiết là PROPOSAL trong AT-CHK-01..05.

## Primary Actor

Thủ thư (vận hành quầy — đã xác thực và có quyền checkout qua `uc-access-control`; tương đương `Nhân viên` trực quầy của nguồn theo mapping spec §2).

## Stakeholders & Interests

| Stakeholder | Interest |
|-------------|----------|
| Người đọc | Mượn nhanh, đúng hạn trả; không bị ghi mượn nhầm hoặc trùng phiếu |
| Thủ thư trưởng | Không phát sinh hai Loan mở trên cùng bản sao (SC-checkout-02); mọi giao dịch có audit |
| Hệ thống | Commit nguyên tử all-or-nothing; idempotent theo operation key; chống double-write khi tranh chấp (NFR-core-002) |

## Trigger

Người đọc đến quầy mượn sách; Thủ thư bắt đầu phiên checkout trên `circulation-desk`.

## Preconditions

- Thủ thư đã đăng nhập, có quyền checkout (include `uc-access-control`); session còn hiệu lực.
- Reader tồn tại với thẻ QR còn hiệu lực; Copy đã đăng ký với QR/barcode duy nhất (uc-catalog-admin).
- `PolicyConfig` có tham số hạn mượn và loan limit (giá trị — PROPOSAL OQ-policy-config-001; cấu hình thay đổi chỉ áp dụng cho giao dịch bắt đầu sau thời điểm hiệu lực — baseline §6.5).
- Job quá hạn + fine ledger đã live trước khi chặn mượn BR-core-001 được bật (internal ordering — DEC-P2-02).

## Guarantees

- **Minimal Guarantee:** Nếu bất kỳ điều kiện nào fail (BR-checkout-002/BR-core-001, CAS, `is_loanable`) thì **không Loan nào được ghi** — rollback toàn bộ phiếu (BR-checkout-001); submit lặp/retry không tạo phiếu trùng (AT-CHK-02); tranh chấp cùng Copy chỉ một giao dịch thắng (AT-CHK-03, SC-checkout-02).
- **Success Guarantee:** Một transaction commit đồng thời: N Loan `ACTIVE` (LOAN-T01, `due_at = borrowed + hạn mượn policy`), N Copy `→ON_LOAN` (COPY-T01/T02), Reservation đúng lượt `→FULFILLED` (RES-T03, chỉ R2), audit (BR-core-003) và outbox notify kèm hạn trả (BR-core-005) — AT-CHK-01.

## Main Success Scenario

1. Thủ thư mở `circulation-desk` → vào `checkout-scan` (phiên đã qua `uc-access-control`).
2. Thủ thư quét QR thẻ người đọc; hệ thống dùng mã **chỉ để locate** Reader (BR-copy-inventory-001 — scan không phải authorization) và nạp hồ sơ + tình trạng.
3. Hệ thống kiểm tra đủ điều kiện mượn (D1 / BR-core-001) — đủ **3 điều kiện chặn** theo nguồn SRC-BR03 (FACT về tập điều kiện): (i) tài khoản Reader bị khóa/không `active`; (ii) Reader có sách quá hạn (Loan `OVERDUE` đang mở); (iii) nợ phạt vượt ngưỡng chặn mượn — ngưỡng là **PROPOSAL — OQ-policy-config-001** (baseline đề xuất 50.000đ theo SRC-BR03 nguồn, giá trị thật chờ OQ-04). Ngoài ra: số Loan đang mở + giỏ hiện tại không vượt loan limit (PROPOSAL — OQ-policy-config-001).
4. Thủ thư quét từng Copy; với mỗi cuốn hệ thống kiểm tra ngay khi thêm (D2 / BR-checkout-002): `status=AVAILABLE` và `is_loanable` (hoặc `ON_HOLD` với Reservation `READY` của đúng reader này — nhánh R2, extend `uc-reservation`), không trùng trong giỏ, không trùng đầu sách đang mượn (baseline §7.1 giỏ mượn).
5. Hệ thống hiển thị `checkout-review`: danh sách cuốn hợp lệ, hạn trả dự kiến theo policy.
6. Thủ thư xác nhận → client phát sinh `operation_id` cho lần xác nhận (AT-CHK-02); hệ thống mở **một transaction**: CAS trên `Copy.version` với allowed-source-state (`AVAILABLE` hoặc `ON_HOLD` đúng chủ) → chuyển từng Copy `→ON_LOAN`, tạo N Loan `ACTIVE` + `due_at`, đóng Reservation liên quan `→FULFILLED` (R2), ghi audit + outbox event.
7. Commit → in biên nhận mượn theo FR-checkout-003 và hiển thị: "Đã tạo phiếu mượn. Hạn trả được hiển thị trong danh sách sách đang mượn." (baseline §7.3).

## Extensions

**2a. Mã thẻ không đọc được / không phân giải được / thẻ hết hạn:**
- 2a1. Hệ thống báo lỗi mã (E-core-001 validation), cho quét lại hoặc nhập mã tay.
- 2a2. Thẻ thuộc tài khoản không `active`/hết hạn → xử lý như bước 3a (reader không đủ điều kiện).
- 2a3. Mã thẻ quét/nhập **không tồn tại** trong hệ thống (không locate được Reader nào) → record not found (E-core-003): báo "Không tìm thấy người đọc với mã này", cho quét lại/nhập lại hoặc tra cứu thủ công trên `reader-list`.
- 2a4. Recovery: không vào bước quét sách cho tới khi locate được Reader hợp lệ.

**3a. Reader không đủ điều kiện (D1 = NO) — một trong 3 điều kiện SRC-BR03 nguồn hoặc vượt loan limit:**
- 3a1. Hệ thống chặn phiếu và hiển thị blocked panel nêu rõ lý do cụ thể (E-core-006): tài khoản bị khóa/không `active`; có sách quá hạn; nợ phạt vượt ngưỡng (ngưỡng PROPOSAL — OQ-policy-config-001, baseline đề xuất 50.000đ); hoặc đạt loan limit ("Người đọc đã đạt giới hạn N cuốn đang mượn." — N là PROPOSAL OQ-policy-config-001, baseline đề xuất 5). Không dùng lý do chung chung "block nghiệp vụ" — mỗi lý do hiển thị riêng để reader/Thủ thư biết cách khắc phục.
- 3a2. Recovery: hiển thị hành động khắc phục tương ứng — trả sách (→ `uc-return`), thanh toán công nợ (→ `uc-fine-cash-payment`), mở khóa (→ `uc-account-admin`); hoặc hủy phiếu/đổi reader.

**4a. Copy không hợp lệ để mượn (D2 = NO): `ON_LOAN`, `ON_HOLD` sai chủ, `PENDING_REVIEW`, `IN_REPAIR`, `LOST`, `DISPOSED`, hoặc `AVAILABLE` nhưng `is_loanable=false`:**
- 4a1. Hệ thống báo copy unavailable kèm trạng thái hiện tại (E-checkout-001); cuốn lỗi **không** được thêm vào giỏ.
- 4a2. Recovery: loại cuốn lỗi khỏi phiếu hoặc quét copy khác; giỏ các cuốn hợp lệ được giữ nguyên (baseline D2: "Không thêm, giữ các cuốn hợp lệ"). Copy `ON_HOLD` của reader khác → gợi ý kiểm tra `reservation-queue` (R2).

**4b. Quét trùng cùng một Copy trong giỏ, hoặc trùng đầu sách đang mượn bởi reader này:**
- 4b1. Hệ thống cảnh báo inline (E-core-001) và bỏ qua lần quét trùng, không nhân đôi item.
- 4b2. Recovery: quét cuốn khác; giỏ giữ nguyên.

**4c. Mã Copy quét/nhập không tồn tại trong hệ thống:**
- 4c1. Mã không locate được Copy nào → record not found (E-core-003): báo "Không tìm thấy bản sao với mã này", cuốn không được thêm vào giỏ; cho quét lại, nhập mã tay hoặc tra cứu trên `catalog-search`.
- 4c2. Recovery: giỏ các cuốn hợp lệ giữ nguyên; tiếp tục quét cuốn khác.

**6a. Xác nhận khi ≥1 item đổi trạng thái sau khi load giỏ (ví dụ vừa bị quầy khác xử lý, vừa chuyển `PENDING_REVIEW`):**
- 6a1. CAS trên `Copy.version` + allowed-source-state thất bại cho item đó → theo BR-checkout-001 **rollback toàn bộ**, không Loan nào được ghi; hiển thị `checkout-conflict` dialog + fresh state (E-core-004): "Sách vừa được cập nhật. Vui lòng quét lại để xem trạng thái mới."
- 6a2. Recovery: reload giỏ ở trạng thái mới, loại/thay item conflict, xác nhận lại; retry an toàn vì chưa có side effect nào commit.

**6b. Hai quầy tranh chấp cùng một Copy:**
- 6b1. Chỉ giao dịch ghi trước (CAS thắng) commit; giao dịch sau nhận E-core-004 conflict dialog + trạng thái mới (baseline §6.4: "Chỉ thao tác hợp lệ đầu tiên thành công").
- 6b2. Recovery: quầy thua reload trạng thái mới và chọn copy khác; **không** phát sinh double-loan (SC-checkout-02, NFR-core-002).

**6c. Double-submit / mất mạng sau khi đã xác nhận (client không nhận được phản hồi):**
- 6c1. Server có unique constraint trên `operation_id`; submit lặp nhận lại **kết quả gốc** (query-by-operation recovery — AT-CHK-02) và hiển thị duplicate notice (E-core-005), không tạo Loan thứ hai.
- 6c2. Recovery: client hiển thị trạng thái đã ghi; giao dịch chưa nhận phản hồi được đối soát (baseline §6.4).

**6d. Action từ trạng thái không hợp lệ (ví dụ re-confirm phiếu đã đóng, submit giỏ rỗng, copy vừa `DISPOSED`):**
- 6d1. Hệ thống disable/từ chối action kèm giải thích trạng thái hiện tại (E-core-008).
- 6d2. Recovery: reload trạng thái, chỉ hiển thị action hợp lệ.

**6e. Audit write thất bại trong commit:**
- 6e1. Business write fail theo cùng transaction — fail-closed (BR-core-003, NFR-core-005); không Loan nào được ghi (chi tiết E-core-007 xử lý tại `uc-notification-outbox`).
- 6e2. Recovery: cảnh báo vận hành, thử lại sau khi audit sink hoạt động.

**6f. Notification/outbox lỗi sau khi ghi outbox event:**
- 6f1. Business commit **vẫn thành công** — notify đi qua durable outbox, retry/dead-letter theo policy (BR-core-005, NFR-notification-core-001; E-notification-core-001/E-notification-core-002 xử lý tại `uc-notification-outbox`).

## Related Requirements

- FR: FR-checkout-001 (mượn nhiều bản sao nguyên tử), FR-checkout-002 (idempotency & concurrency), FR-copy-inventory-002 (QR locator — R0); liên quan FR-ops-foundation-001 (audit), FR-notification-core-001 (outbox).
- NFR: NFR-core-002 (nguyên tử, chống double-write), NFR-core-005, NFR-notification-core-001, NFR-core-006 (quầy thao tác bàn phím).
- BR: BR-checkout-001 (all-or-nothing), BR-checkout-002 (chỉ mượn từ `AVAILABLE`/`ON_HOLD` đúng chủ), BR-core-001 (reader eligibility — ngưỡng OQ-policy-config-001), BR-copy-inventory-001, BR-core-003, BR-core-005.
- Atomicity spec: AT-CHK-01..05 (`docs/_shared/domain/lifecycle-inventory.md` §7.1); transitions COPY-T01/T02, LOAN-T01, RES-T03.
- Errors covered: E-core-001, E-core-003, E-checkout-001, E-core-004, E-core-005, E-core-006, E-core-008.
- Open: **OQ-policy-config-001** (loan limit, hạn mượn, ngưỡng nợ chặn mượn); DEC-P2-05 (nhánh reservation đúng lượt chỉ từ R2).
- UC liên quan: `uc-access-control` (include), `uc-reservation` (extend — R2), `uc-fine-cash-payment`, `uc-account-admin` (khắc phục eligibility).
- **Nhãn tổng:** FACT = tập 3 điều kiện chặn mượn SRC-BR03 nguồn (khóa/quá hạn/nợ vượt ngưỡng — MSS b3, ext 3a), kiểm tra SRC-BR01/SRC-BR02 ngay khi quét, "chỉ thao tác hợp lệ đầu tiên thành công" (SRC-BR13), quét QR/tra cứu thủ công, mỗi cuốn một Loan trong một transaction. PROPOSAL = cơ chế `operation_id`/CAS chi tiết (AT-CHK-01..05), `checkout-conflict` dialog, wording biên nhận baseline. Open = loan limit, hạn mượn, ngưỡng nợ chặn mượn (OQ-policy-config-001/OQ-04 — baseline đề xuất 5 cuốn/14 ngày/50.000đ chưa chốt).

