---
type: srs
scope: shared
status: draft
updated: 2026-10-12
links:
  - docs/_shared/project-profile.md
  - docs/_shared/id-crosswalk-lmp.md
  - docs/_shared/domain/library-erd.md
  - docs/_shared/domain/library-states.md
  - docs/_shared/domain/lifecycle-inventory.md
  - docs/_product/decision-register.md
  - docs/he_thong_quan_ly_thu_vien.md
---

# Đặc tả dùng chung — Hệ thống Quản lý Thư viện

## 0. Namespace và nhãn nguồn

- Mã dùng chung: `NFR-core-NNN`, `BR-core-NNN`, `E-core-NNN`, `OQ-core-NNN`, `CHK-core-NNN`. Mã của từng feature: `{TYPE}-{feature}-NNN`. Mã cũ `*-LMP-*` tra ở `docs/_shared/id-crosswalk-lmp.md`.
- Mã có tiền tố `SRC-` (vd `SRC-BR01`, `SRC-FR-L06`) là mã của tài liệu nguồn `docs/he_thong_quan_ly_thu_vien.md`.
- `Source fact`: có trong tài liệu nguồn hoặc baseline sản phẩm. `PROPOSAL`: suy diễn hợp lý, chờ domain approval. `Open`: chưa đủ quyết định, không được xem là approved.

## 2. Actors & Stakeholders

| Actor | Loại | Mục tiêu | Trong scope? |
|-------|------|----------|--------------|
| Nhân viên | người | Xử lý mượn/trả/gia hạn/đặt trước/báo hư hỏng tại quầy | Có |
| Người đọc | người | Tra cứu, đặt trước, nhận thông báo, thanh toán khi được phép | Có (P0 qua nhân viên; P1 self-service) |
| Thủ thư | người | Quản trị cấu hình, người dùng, quyền, import, audit | Có |
| Hệ thống | hệ thống | Áp trạng thái, hàng đợi, outbox, audit, job nhắc hạn | Có |
| Kênh thông báo ngoài | ngoài | Email/SMS/push tùy cấu hình | PROPOSAL — kênh cụ thể chưa chốt |
| Bộ phận tài chính/kế toán | stakeholder | Đối soát tiền phạt, điều chỉnh, hoàn/đảo bút toán | Có như stakeholder; policy là OQ |
| Bảo mật/pháp chế | stakeholder | Kiểm soát PII, retention, audit | Có như stakeholder; policy là OQ |

**Tên vai trò thống nhất với nghiệp vụ nguồn (DEC-SF-01, cập nhật 2026-10-12):**

| Vai trò trong tài liệu nguồn (§2 `he_thong_quan_ly_thu_vien.md`) | Tên dùng trong bộ SRS này | Ghi chú |
|---|---|---|
| `Người đọc` | `Người đọc` (`READER`) | Giữ nguyên |
| `Nhân viên` (trực quầy: mượn/trả, quét QR, báo hư hỏng, khóa tạm người đọc) | `Nhân viên` (`STAFF`) | Giữ nguyên tên nguồn |
| `Thủ thư` (kế thừa Nhân viên + quản trị dữ liệu, cấu hình, báo cáo, nhật ký) | `Thủ thư` (`LIBRARIAN`) | Giữ nguyên tên nguồn; vai trò Admin riêng ngoài phạm vi (OQ-01 nguồn) |
| — | `Hệ thống` | Actor kỹ thuật cho job/cron/outbox/audit |

Mọi quyền thao tác trong các UC/model phải dùng đúng naming SRS ở cột 2. Delta so với ma trận quyền nguồn phải gắn nhãn PROPOSAL kèm lý do — không ghi FACT cho quyền đã siết/mở.

Tên vai trò chốt theo DEC-SF-01 (`docs/_product/decision-register.md`).

## 4. Non-Functional Requirements dùng chung

| ID | Category | Requirement | Priority | Release | Acceptance |
|----|----------|-------------|----------|---------|------------|
| NFR-core-001 | availability | Chức năng quầy lõi phải khả dụng trong giờ vận hành thư viện; SLA cụ thể chưa chốt. | P0 | R1A | OQ-policy-config-001 định nghĩa SLA/đo uptime |
| NFR-core-002 | integrity | Mọi chuyển trạng thái Copy/Loan/Reservation phải nguyên tử và chống double-write. | P0 | R1A | Test concurrency + kiểm tra dữ liệu sau commit |
| NFR-core-003 | security | Authorization phải theo actor × resource × action × field × purpose. | P0 | R0 | Permission matrix test + security review |
| NFR-core-004 | privacy | PII người đọc được mask theo quyền; retention/deletion chưa định nghĩa cho tới khi approved. | P0 | R0 | Permission test + privacy review; policy là OQ; non-waivable trước GATE-GNG |
| NFR-core-005 | auditability | Audit write thất bại phải làm hành động nhạy cảm thất bại theo cùng transaction. | P0 | R0 | Fault injection audit + transaction rollback |
| NFR-core-006 | usability | Màn hình quầy phải hiển thị trạng thái rõ ràng trong khung Mobile 375 và vẫn thao tác được bằng bàn phím khi có bàn phím phần cứng. | P0 | R1A | Keyboard walkthrough + wireframe review |
| NFR-core-007 | accessibility | Điều khiển có label/name, focus visible, lỗi mô tả rõ; mục tiêu WCAG level chờ chốt. | P1 | R2 | A11y checklist + assistive smoke test |
| NFR-core-008 | observability | Ghi log nghiệp vụ đủ để điều tra lỗi mà không lộ secrets/PII không cần thiết. | P1 | R1B | Log inspection + redaction review |
| NFR-core-009 | compatibility | HTML wireframe canonical dùng Mobile 375; responsive desktop/tablet và device production của portal vẫn cần browser/device smoke matrix riêng. | P1 | R2 | Browser/device smoke matrix |

## 5. Business Rules dùng chung

| ID | Rule | Trigger | Implements FR | Source |
|----|------|---------|---------------|--------|
| BR-core-001 | Reader phải `active`, không có block nghiệp vụ và không vượt loan limit cấu hình. | Checkout/renewal | FR-checkout-001/FR-renewal-001 | PROPOSAL; ngưỡng OQ-policy-config-001 |
| BR-core-002 | Mọi thay đổi số dư Fine là financial event append-only: assessment, payment, waiver, adjustment, reversal/refund, reconciliation khi được duyệt. | Fine lifecycle | FR-overdue-fines-001/FR-fine-collection-basic-001/FR-fine-collection-adv-002 | Plan red-team |
| BR-core-003 | Audit phải ghi cùng transaction; nếu audit fail thì business write fail, không để sensitive action không audit. | Sensitive action | FR-ops-foundation-001 | Plan red-team |
| BR-core-004 | Quyền xem/đổi field PII và tài chính áp theo actor × resource × action × field × purpose; deny mặc định. | Access sensitive field/action | FR-access-control-001/FR-ops-foundation-001 | Plan red-team |
| BR-core-005 | Notification không làm fail business transaction chính; business commit ghi outbox event để delivery retry sau. | Business event emits notification | FR-notification-core-001 | Plan red-team |
| BR-core-006 | Xóa mềm: Reader, Nhân viên, BibliographicRecord, Copy đã có lịch sử nghiệp vụ chỉ được vô hiệu hóa/deactivate — không xóa cứng (giữ ledger append-only và audit trail). | Delete/deactivate request | FR-catalog-admin-001/FR-copy-inventory-001/FR-reader-onboarding-001 | Source fact (SRC-BR12 nguồn) |

## 6. Error dùng chung

| Error ID | Title | Trigger | Severity | Related FR | Screen state | Recovery |
|----------|-------|---------|----------|------------|--------------|----------|
| E-core-001 | Validation failed | Trường bắt buộc thiếu/sai định dạng | minor | nhiều FR | Inline error trên màn hiện tại | Giữ dữ liệu nhập, cho sửa và submit lại |
| E-core-002 | Permission denied | Actor không có quyền object/action/field | major | FR-access-control-001 | Access denied screen/banner | Quay về danh sách an toàn, audit denial |
| E-core-003 | Record not found hoặc duplicate | Mã không tồn tại hoặc trùng unique business key | major | FR-catalog-admin-001/FR-copy-inventory-001/FR-reader-onboarding-001 | Empty/error panel | Cho nhập lại mã hoặc mở bản ghi hiện có |
| E-core-004 | Concurrency conflict | Trạng thái copy/reservation đổi sau khi load | critical | FR-checkout-002/FR-reservation-001 | Conflict dialog + fresh state | Reload state và retry an toàn |
| E-core-005 | Duplicate request replay | Cùng idempotency key được submit lại | minor | FR-checkout-002/FR-fine-collection-basic-001 | Idempotent success/duplicate notice | Trả kết quả gốc, không tạo tác dụng phụ mới |
| E-core-006 | Reader ineligible | Reader bị khóa/quá limit/không active | major | FR-checkout-001/FR-renewal-001 | Checkout/renewal blocked panel | Hiển thị lý do và hành động khắc phục |
| E-core-007 | Audit write failed | Audit sink không ghi được | critical | FR-ops-foundation-001 | Blocking error cho sensitive action | Rollback business write, alert vận hành |
| E-core-008 | Invalid state transition | Action không hợp lệ từ trạng thái hiện tại | major | nhiều FR | Disabled action + explanation | Reload state, chỉ hiện action hợp lệ |
| E-core-009 | Field-level access denied | Actor thiếu quyền field nhạy cảm | major | FR-access-control-001/FR-ops-foundation-001 | Masked/blocked field | Không lộ dữ liệu; audit access attempt |

## 8. Invariant giao dịch dùng chung

Áp dụng cho mọi luồng có ghi dữ liệu; các flow section chỉ ghi chú thêm khi có ngoại lệ.

| ID | Invariant | Nhãn | Source |
|----|-----------|------|--------|
| INV-01 | Business write + `AuditEvent` + `NotificationEvent` (outbox) ghi trong **một** transaction; audit fail → rollback toàn bộ (E-core-007) | FACT (BR-core-003, BR-core-005, NFR-core-005) | spec §5/§6 |
| INV-02 | Concurrency bằng CAS trên `version` + allowed-source-state; giao dịch sau nhận conflict và phải reload (E-core-004) | FACT (SRC-BR13 nguồn, NFR-core-002) | spec §4, lifecycle §3 |
| INV-03 | Mọi submit ghi (checkout, payment, pickup) mang `operation_id`/idempotency key; replay trả kết quả gốc, không nhân đôi side effect (E-core-005, E-fine-collection-basic-002) | PROPOSAL (AT-CHK-02, AT-FIN-02, BR-fine-collection-basic-001) | lifecycle §7 |
| INV-04 | Notification không bao giờ làm fail business transaction; delivery retry có kiểm soát + dead-letter + cảnh báo vận hành (E-notification-core-001, E-notification-core-002) | FACT (BR-core-005, NFR-notification-core-001); ngưỡng retry PROPOSAL | spec §5, lifecycle §4 |
| INV-05 | QR/barcode chỉ là **locator**; sau khi locate vẫn phải kiểm tra actor × resource × action (BR-copy-inventory-001, BR-core-004) | FACT | spec §5 |
| INV-06 | FinancialEvent append-only; không UPDATE/DELETE; `Fine.balance` suy từ ledger (BR-core-002) | FACT | spec §5, lifecycle §5 |

## 11. Constraints, Dependencies & Assumptions

**Constraints:**

| Ràng buộc | Source / Owner |
|-----------|----------------|
| Không viết hoặc suy đoán schema từ Excel khi chưa có representative source | Plan / Phase 1–3 owner |
| Hard-stop privacy/finance/release phải Resolved + Approved trước khi ready | Plan / stakeholder |
| QR chỉ là locator, không phải credential | Plan red-team |
| Financial ledger append-only; không update/delete bút toán | Plan red-team |
| Audit transactionally consistent với sensitive action | Plan red-team |

**Dependencies:**

| Phụ thuộc | Owner | Blocks nếu chưa sẵn |
|-----------|-------|--------------------|
| Decision register + stakeholder approval authority | Phase 1 / product owner | Mọi trạng thái approved |
| PRD và release boundary chính thức | Phase 2 / product owner | R0–R3 boundary chốt |
| Lifecycle inventory approved | Phase 3 / domain approver | States/diagrams ready |
| Representative Excel source | Data owner | Import schema/details |
| Notification channel/provider | Product + technical owner | Channel-specific requirements |
| Financial policy owner | Finance/legal | Partial payment, waiver, refund |
| Privacy/retention owner | Legal/DPO | Retention/deletion and masking final |

**Assumptions:**

| Giả định | Invalidate nếu sai |
|----------|--------------------|
| Nhân viên là actor P0 chính; người đọc tự phục vụ có thể dời R2 | FR-reader-self-service-002 và screen portal |
| Reservation trọn vòng có một release owner duy nhất là R2; luồng trả R1A không phân bổ hàng chờ (D5 = "không có hàng chờ") | FR-reservation-001/FR-reservation-002; PROPOSAL DEC-P2-05 |
| Cấu hình loan/renewal/hold/fine là policy do thủ thư quản lý | BR-core-001/BR-renewal-001/BR-reservation-001 |
| Upload ảnh cần trong damage/lost flow từ R1A (báo cáo hư hỏng có ảnh 1–5 thuộc CAP-DAMAGE R1A) | FR-damage-lifecycle-002 |
| Mobile 375 là primary device của HTML wireframe theo quyết định người dùng ngày 2026-10-07 | Userflow/wireframe device |

## 12. Open Questions dùng chung

- [ ] OQ-core-001 — Ai có quyền approve baseline/release/hard-stop? Owner: product sponsor. Gate: không artifact nào được đánh `approved`.
- [ ] OQ-core-002 — Diagram Copy/Return gốc thiếu; lifecycle hiện tại là PROPOSAL cần domain review. Owner: domain approver.
- [ ] OQ-core-003 — Retention/deletion/masking policy? Owner: legal/privacy. Gate: NFR-core-004 và privacy QA.
- [ ] OQ-core-004 — Ngữ nghĩa Loan↔LoanItem: phiếu mượn là header + dòng per-copy (hạn trả/gia hạn/trạng thái ở dòng) — xác nhận thay giả định mặc định "không phiếu cha" từ OQ-06 nguồn. Owner: domain approver. Gate: ERD + uc-checkout/return.
- [ ] OQ-core-005 — Actor/staff reference model: `*_by`/`actor_ref`/`recipient_ref` trỏ tài khoản hệ thống không nằm trong 13 entity §8 — tách entity hay giữ ref logic? Liên quan OQ-access-control-001 (identity model). Owner: security/IT. Gate: ERD + audit.
