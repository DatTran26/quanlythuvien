---
type: srs
feature: library-management-platform
status: draft
updated: 2026-10-05
links:
  - docs/he_thong_quan_ly_thu_vien.md
  - docs/features/library-management-platform/brainstorms/product-roadmap-baseline.md
  - docs/features/library-management-platform/srs/library-management-platform-userflow.md
  - docs/features/library-management-platform/usecases/library-management-platform-usecase-index.md
  - docs/features/library-management-platform/srs/library-management-platform-flows.md
  - docs/features/library-management-platform/srs/library-management-platform-states.md
  - docs/features/library-management-platform/srs/library-management-platform-erd.md
---

# library-management-platform — Software Requirements Specification

## 0. Baseline status and approval evidence

| Item | State | Evidence / owner | Gate |
|------|-------|------------------|------|
| Baseline governance | Draft — chờ L1 | `docs/_shared/project-profile.md`, `brainstorms/product-roadmap-baseline.md`, `decision-register.md` đã tồn tại; 18 DEC entry đều `Open`; `docs/_shared/id-registry.md` chưa tạo | Owner: BA lead + stakeholder |
| PRD / release approval | Draft — chờ L1 | `docs/_product/prd.md`, `roadmap.md`, `priority-crosswalk.md`, `readiness-gates.md` đã tồn tại dạng PROPOSAL | Owner: product owner |
| Domain lifecycle inventory | PROPOSAL — chờ domain approver | `domain/lifecycle-inventory.md` đã tồn tại; Copy state machine + flow trả là reconstruction (DEC-D3-01/02 `Open`) | Owner: domain approver (Thủ thư trưởng) |
| SRS L1 content approval | Pending | Được sinh trong phiên Phase 4–8, chưa có phê duyệt người dùng | Owner: BA lead / stakeholder |
| Hard-stop identity/privacy/finance/release | Open | Xem Mục 12 Open Questions | Không coi là ready |

**Namespace ID:** `LMP` là mã rút gọn của `library-management-platform` cho FR/BR/NFR/E/CHK/TC/OQ/SC. Tên file vẫn dùng slug đầy đủ theo naming convention.

**Nhãn nguồn:**
- `Source fact`: có trong `docs/he_thong_quan_ly_thu_vien.md` hoặc roadmap baseline.
- `PROPOSAL`: suy diễn hợp lý để hoàn thiện baseline; chờ domain approval.
- `Open`: chưa đủ quyết định; không được xem là approved.

## 1. Scope

Hệ thống quản lý thư viện quản lý danh mục sách, bản sao sách, người đọc, mượn/trả/gia hạn, đặt trước, tiền phạt/thanh toán, báo cáo hư hỏng/mất/tìm thấy, thông báo, phân quyền, nhật ký kiểm toán và nhập liệu/đối soát ban đầu.

**Release boundary (PROPOSAL — đã ánh xạ lại theo `docs/_product/roadmap.md` R0–R3 theo DEC-P2-08, chờ L1 approve):**
- `R0`: nền tảng — identity/RBAC, tài khoản người đọc, catalog/bản sao/QR, import + đối soát, policy config, audit capture, backup/restore. **Chưa có giao dịch mượn–trả.**
- `R1A`: lưu thông lõi tại quầy — checkout/return nguyên tử, job quá hạn + phạt tạm tính, fine ledger + thu tiền mặt tối thiểu, damage/mất tối thiểu, notify tối thiểu, báo cáo vận hành RP-01/02/04.
- `R1B`: gia hạn, fine nâng cao (biên nhận/miễn/điều chỉnh), trung tâm thông báo đầy đủ, audit viewer, quản lý người đọc giới hạn → readiness gates → pilot go-live.
- `R2`: reservation trọn vòng (single release owner — DEC-P2-05) + báo cáo xu hướng + reader self-service.
- `R3 / candidate`: điểm danh, thanh toán online, đa chi nhánh, offline, SMS/push/Zalo, phân loại người đọc — chỉ capability envelope, không cam kết.

**Out of scope hiện tại:** cổng thanh toán thật, chính sách pháp lý cuối cùng, mô hình dữ liệu import Excel chưa có file mẫu, đề xuất AI/recommendation.

## 2. Actors & Stakeholders

| Actor | Loại | Mục tiêu | Trong scope? |
|-------|------|----------|--------------|
| Thủ thư | người | Xử lý mượn/trả/gia hạn/đặt trước/báo hư hỏng tại quầy | Có |
| Người đọc | người | Tra cứu, đặt trước, nhận thông báo, thanh toán khi được phép | Có (P0 qua thủ thư; P1 self-service) |
| Quản trị viên | người | Quản trị cấu hình, người dùng, quyền, import, audit | Có |
| Hệ thống | hệ thống | Áp trạng thái, hàng đợi, outbox, audit, job nhắc hạn | Có |
| Kênh thông báo ngoài | ngoài | Email/SMS/push tùy cấu hình | PROPOSAL — kênh cụ thể chưa chốt |
| Bộ phận tài chính/kế toán | stakeholder | Đối soát tiền phạt, điều chỉnh, hoàn/đảo bút toán | Có như stakeholder; policy là OQ |
| Bảo mật/pháp chế | stakeholder | Kiểm soát PII, retention, audit | Có như stakeholder; policy là OQ |

**Mapping vai trò nguồn ↔ naming SRS (PROPOSAL — trả lời một phần OQ-01 nguồn, phần còn lại ở OQ-LMP-014):**

| Vai trò trong tài liệu nguồn (§2 `he_thong_quan_ly_thu_vien.md`) | Tên dùng trong bộ SRS này | Ghi chú |
|---|---|---|
| `Người đọc` | `Người đọc` | Giữ nguyên |
| `Nhân viên` (trực quầy: mượn/trả, quét QR, báo hư hỏng, khóa tạm người đọc) | `Thủ thư` | Đổi tên — PROPOSAL |
| `Thủ thư` (kế thừa Nhân viên + quản trị dữ liệu, cấu hình, báo cáo, nhật ký) | `Quản trị viên` | Đổi tên — PROPOSAL; việc tách vai trò admin riêng chính là câu hỏi OQ-01 nguồn |
| — | `Hệ thống` | Actor kỹ thuật cho job/cron/outbox/audit |

Mọi quyền thao tác trong các UC/model phải dùng đúng naming SRS ở cột 2. Delta so với ma trận quyền nguồn phải gắn nhãn PROPOSAL kèm lý do — không ghi FACT cho quyền đã siết/mở.

## 3. Functional Requirements (FR)

| ID | Title | Actor | Description | Priority | Release | Verify by | Source |
|----|-------|-------|-------------|----------|---------|-----------|--------|
| FR-LMP-001 | Quản lý danh mục sách | Thủ thư/Quản trị viên | Tạo, xem, cập nhật, tìm kiếm bản ghi thư mục gồm tiêu đề, tác giả, thể loại, nhà xuất bản, năm, ISBN và mô tả khi có. | P0 | R0 | demo/test | Source fact |
| FR-LMP-002 | Quản lý bản sao sách | Thủ thư/Quản trị viên | Đăng ký bản sao vật lý với mã định danh, vị trí, tình trạng ban đầu và trạng thái khả dụng. | P0 | R0 | demo/test | Source fact |
| FR-LMP-003 | Tra cứu khả dụng | Thủ thư/Người đọc | Tra cứu đầu sách và xem số bản sao khả dụng, đang giữ, đang mượn hoặc không khả dụng. | P0 | R1A | test | Source fact |
| FR-LMP-004 | Quản lý người đọc | Thủ thư/Quản trị viên | Tạo/cập nhật hồ sơ người đọc, trạng thái hoạt động, thông tin liên hệ và hạn thẻ nếu có. | P0 | R0 | demo/test | Source fact |
| FR-LMP-005 | Khóa/mở người đọc | Thủ thư/Quản trị viên | Cho phép tạm ngưng hoặc khôi phục quyền mượn của người đọc với lý do bắt buộc và audit; quyền theo ma trận nguồn (Nhân viên + Thủ thư đều khóa được). | P1 | R1B | test | Source fact (quyền) + PROPOSAL (lý do bắt buộc, FR-S10) |
| FR-LMP-006 | Đăng nhập và phân quyền | Thủ thư/Người đọc/Quản trị viên | Chỉ actor hợp lệ được truy cập chức năng theo vai trò và phạm vi dữ liệu được cấp; Hệ thống là bên thực thi kiểm tra. | P0 | R0 | test | Source fact + PROPOSAL |
| FR-LMP-007 | Step-up và session reset | Thủ thư/Người đọc/Quản trị viên | Tác vụ nhạy cảm yêu cầu xác thực lại; hết phiên phải quay về trạng thái an toàn không mất dữ liệu đã lưu; Hệ thống thực thi. | P0 | R0 | test | PROPOSAL |
| FR-LMP-008 | Mượn nhiều bản sao nguyên tử | Thủ thư | Một phiếu mượn có nhiều bản sao chỉ thành công khi toàn bộ điều kiện hợp lệ; một bản sao lỗi làm cả giao dịch rollback. | P0 | R1A | test | Source fact + plan red-team |
| FR-LMP-009 | Idempotency và concurrency mượn | Hệ thống | Lặp submit/checkout cùng request không tạo phiếu trùng; hai giao dịch tranh cùng bản sao chỉ một giao dịch thắng. | P0 | R1A | test/concurrency | Plan red-team |
| FR-LMP-010 | Trả sách | Thủ thư | Ghi nhận trả một hoặc nhiều bản sao, cập nhật trạng thái bản sao và phiếu mượn, phát hiện quá hạn/hư hỏng để tạo nghĩa vụ tiếp theo. | P0 | R1A | demo/test | Source fact |
| FR-LMP-011 | Gia hạn | Thủ thư/Người đọc | Gia hạn khoản mượn đủ điều kiện theo policy; từ chối khi đã quá hạn, có giữ chỗ hoặc vượt giới hạn gia hạn. | P1 | R1B | test | Source fact; ngưỡng là PROPOSAL; roadmap CAP-RENEW |
| FR-LMP-012 | Đặt trước và hàng đợi | Thủ thư/Người đọc | Tạo/hủy đặt trước, duy trì thứ tự hàng đợi, chuyển bản sao phù hợp sang giữ chỗ khi đến lượt. | P1 | R2 | test | Source fact; release owner R2 — DEC-P2-05 |
| FR-LMP-013 | Hết hạn giữ chỗ | Hệ thống | Khi hết thời hạn nhận, hệ thống hủy lượt giữ và đẩy người kế tiếp lên đầu hàng đợi một cách nguyên tử. | P1 | R2 | test | Source fact + PROPOSAL; DEC-P2-05 |
| FR-LMP-014 | Ghi nhận tiền phạt | Hệ thống/Thủ thư | Tạo nghĩa vụ tiền phạt khi quá hạn/hư hỏng/mất theo policy; mọi thay đổi số dư là sự kiện tài chính append-only. | P0 | R1A | test | Source fact + plan red-team |
| FR-LMP-015 | Thanh toán tiền phạt | Thủ thư/Người đọc | Ghi nhận thanh toán tiền mặt tối thiểu, hỗ trợ idempotency, cập nhật số dư và không cho xóa/sửa bút toán đã ghi; biên nhận đầy đủ ở R1B. | P0 | R1A | test | Source fact; split DEC-P2-04 |
| FR-LMP-016 | Miễn/điều chỉnh/hoàn tiền | Quản trị viên | Cho phép waiver, adjustment, reversal/refund có lý do, quyền và audit; partial-payment policy chờ duyệt. | P1 | R1B | test | PROPOSAL; policy OQ-LMP-005; hard-stop DEC-D3-04 |
| FR-LMP-017 | Báo cáo hư hỏng | Thủ thư | Tạo báo cáo hư hỏng gắn bản sao/phiếu mượn, mức độ, mô tả, bằng chứng ảnh 1–5 và trạng thái xử lý; disposition tối thiểu Bác bỏ/Sửa/Thanh lý. | P0 | R1A | demo/test | Source fact; DEC-P2-03 |
| FR-LMP-018 | Mất và tìm lại | Thủ thư/Quản trị viên | Đánh dấu bản sao mất, ghi nhận nghĩa vụ bồi thường (tối thiểu R1A — DEC-P2-07); khi tìm lại cho phép phục hồi trạng thái và đối soát nghĩa vụ liên quan (R1B — DEC-D3-05). | P1 | R1A/R1B | test | Source fact; lifecycle PROPOSAL |
| FR-LMP-019 | Thông báo bền | Hệ thống | Đưa thông báo sắp đến hạn/quá hạn/giữ sẵn/phạt vào outbox bền, retry theo chính sách và không mất khi kênh ngoài lỗi; in-app + email sự kiện quan trọng ở R1A, trung tâm thông báo đầy đủ R1B. | P0 | R1A | test | Source fact + plan red-team; DEC-P2-01 |
| FR-LMP-020 | Audit log giao dịch | Hệ thống/Quản trị viên | Ghi audit cùng transaction với hành động nhạy cảm, bao gồm actor, thời điểm, resource, trước/sau tối thiểu và lý do khi có; audit viewer ở R1B. | P0 | R0 | test | Source fact + plan red-team; DEC-P2-06 |
| FR-LMP-021 | Quản trị cấu hình nghiệp vụ | Quản trị viên | Quản lý tham số hạn mượn, số lần gia hạn, hạn giữ chỗ, vai trò và kênh thông báo. Giá trị mặc định là OQ. | P0 | R0 | demo/test | Source fact + PROPOSAL |
| FR-LMP-022 | Import và đối soát | Quản trị viên | Nhập dữ liệu ban đầu qua file đại diện, validate staging, báo lỗi theo dòng, dry-run trước commit và reconciliation sau import. | P0 | R0 | test | Source fact; file mẫu OQ-LMP-002; DEC-P2-09 |
| FR-LMP-023 | Báo cáo vận hành | Quản trị viên/Thủ thư | Xem báo cáo sách quá hạn, đang mượn, hàng đợi, tiền phạt và bản sao hư hỏng/mất (RP-01/02/04 ở R1A); báo cáo xu hướng RP-03/05/06/07 ở R2. | P1 | R1A/R2 | demo/test | Source fact |
| FR-LMP-024 | Cổng tự phục vụ người đọc | Người đọc | Cổng self-service (R2): xem khoản mượn, đặt/hủy đặt trước, thanh toán nếu được phép. Riêng "người đọc xem công nợ" (FR-R09) thuộc R1B theo roadmap. | P1 | R2 (portal); R1B (xem công nợ) | test | PROPOSAL; phụ thuộc identity/portal; chưa có UC owner — xem usecase index |
| FR-LMP-025 | Quản lý ảnh bằng chứng | Thủ thư | Upload ảnh cho báo cáo hư hỏng/mất qua trust boundary: kiểm tra loại, kích thước, quét nội dung, không tin metadata gốc. | P1 | R1A | test | PROPOSAL; ảnh 1–5 thuộc CAP-DAMAGE R1A |
| FR-LMP-026 | QR/barcode locator | Thủ thư | Quét mã bản sao/phiếu chỉ để định vị bản ghi; mã không được dùng như bằng chứng uỷ quyền. | P0 | R0 | test/security | Plan red-team |
| FR-LMP-027 | Truy vết lịch sử nghiệp vụ | Thủ thư/Quản trị viên | Xem lịch sử trạng thái và sự kiện liên quan của bản sao, phiếu mượn, đặt trước, tiền phạt và báo cáo hư hỏng. | P1 | R1B | demo/test | PROPOSAL; audit viewer FR-L10 |
| FR-LMP-028 | Phân tích nâng cao | Quản trị viên | Phân tích xu hướng mượn và đề xuất mua sắm; chỉ capability envelope, chưa phải yêu cầu build. | P2 | R3-candidate | phân tích | Roadmap baseline / PROPOSAL |

## 4. Non-Functional Requirements (NFR)

| ID | Category | Requirement | Priority | Release | Acceptance |
|----|----------|-------------|----------|---------|------------|
| NFR-LMP-001 | availability | Chức năng quầy lõi phải khả dụng trong giờ vận hành thư viện; SLA cụ thể chưa chốt. | P0 | R1A | OQ-LMP-010 định nghĩa SLA/đo uptime |
| NFR-LMP-002 | performance | Tra cứu danh mục phổ thông phản hồi trong ngưỡng được phê duyệt; đề xuất ≤2s cho truy vấn thường dùng @50.000 bản sao. | P0 | R1A | Đo P95 môi trường test; ngưỡng là PROPOSAL |
| NFR-LMP-003 | integrity | Mọi chuyển trạng thái Copy/Loan/Reservation phải nguyên tử và chống double-write. | P0 | R1A | Test concurrency + kiểm tra dữ liệu sau commit |
| NFR-LMP-004 | security | Authorization phải theo actor × resource × action × field × purpose. | P0 | R0 | Permission matrix test + security review |
| NFR-LMP-005 | privacy | PII người đọc được mask theo quyền; retention/deletion chưa định nghĩa cho tới khi approved. | P0 | R0 | Permission test + privacy review; policy là OQ; non-waivable trước GATE-GNG |
| NFR-LMP-006 | auditability | Audit write thất bại phải làm hành động nhạy cảm thất bại theo cùng transaction. | P0 | R0 | Fault injection audit + transaction rollback |
| NFR-LMP-007 | reliability | Outbox notification phải retry có kiểm soát và có trạng thái lỗi/dead-letter để xử lý. | P0 | R1A | Retry simulation + dead-letter evidence |
| NFR-LMP-008 | usability | Màn hình quầy phải thao tác được bằng bàn phím và hiển thị trạng thái rõ ràng trên desktop 1024px. | P0 | R1A | Keyboard walkthrough + wireframe review |
| NFR-LMP-009 | accessibility | Điều khiển có label/name, focus visible, lỗi mô tả rõ; mục tiêu WCAG level chờ chốt. | P1 | R2 | A11y checklist + assistive smoke test |
| NFR-LMP-010 | observability | Ghi log nghiệp vụ đủ để điều tra lỗi mà không lộ secrets/PII không cần thiết. | P1 | R1B | Log inspection + redaction review |
| NFR-LMP-011 | data quality | Import phải có dry-run, lỗi theo dòng và số liệu đối soát trước khi commit. | P0 | R0 | Import fixture test + reconciliation report; GATE-MIG |
| NFR-LMP-012 | compatibility | Responsive cơ bản; primary device desktop 1024 cho thủ thư, mobile/tablet là P1 nếu có portal. | P1 | R2 | Browser/device smoke matrix |

## 5. Business Rules

| ID | Rule | Trigger | Implements FR | Source |
|----|------|---------|---------------|--------|
| BR-LMP-001 | Checkout nhiều bản sao là all-or-nothing; một điều kiện fail thì không bản sao nào được ghi mượn. | Submit checkout | FR-LMP-008 | Plan red-team |
| BR-LMP-002 | Copy chỉ được mượn từ trạng thái `available`; reservation-held copy chỉ checkout được cho reservation đúng lượt. | Checkout | FR-LMP-008/012 | PROPOSAL lifecycle |
| BR-LMP-003 | Reader phải `active`, không có block nghiệp vụ và không vượt loan limit cấu hình. | Checkout/renewal | FR-LMP-008/011 | PROPOSAL; ngưỡng OQ-LMP-010 |
| BR-LMP-004 | Renewal bị từ chối khi quá hạn, có reservation đang chờ hoặc đạt renewal limit. | Renewal | FR-LMP-011 | PROPOSAL; ngưỡng OQ-LMP-010 |
| BR-LMP-005 | Reservation queue theo thứ tự tạo hợp lệ; khi copy phù hợp về kho, transition `available→held` phải nguyên tử với `queued→ready_for_pickup`. | Copy return / queue job | FR-LMP-012/013 | Plan red-team |
| BR-LMP-006 | Hold hết hạn thì reservation hiện tại `expired/cancelled`, copy quay `available`, queue advance atomically. | Expiry job | FR-LMP-013 | PROPOSAL lifecycle |
| BR-LMP-007 | Mọi thay đổi số dư Fine là financial event append-only: assessment, payment, waiver, adjustment, reversal/refund, reconciliation khi được duyệt. | Fine lifecycle | FR-LMP-014/015/016 | Plan red-team |
| BR-LMP-008 | Payment retry/double-submit phải dùng idempotency key và không ghi hai payment event cho cùng request. | Payment submit | FR-LMP-015 | Plan red-team |
| BR-LMP-009 | DamageReport chỉ đóng khi có quyết định repair/replace/no-charge/fine-linked và audit đầy đủ. | Resolve report | FR-LMP-017 | PROPOSAL lifecycle |
| BR-LMP-010 | Lost copy khi tìm lại phải qua reconciliation trước khi trở `available`; không tự xóa nghĩa vụ tài chính đã ghi. | Mark found | FR-LMP-018 | PROPOSAL |
| BR-LMP-011 | QR/barcode là locator; phải xác thực actor và quyền sau khi locate, không coi scan là authorization. | Scan lookup | FR-LMP-026 | Plan red-team |
| BR-LMP-012 | Upload bằng chứng phải qua trust boundary: MIME/sniffing, giới hạn size, quét nội dung, tên file lưu an toàn. | Upload attachment | FR-LMP-025 | Plan red-team |
| BR-LMP-013 | Audit phải ghi cùng transaction; nếu audit fail thì business write fail, không để sensitive action không audit. | Sensitive action | FR-LMP-020 | Plan red-team |
| BR-LMP-014 | Import commit chỉ sau dry-run pass hoặc override được phê duyệt; reconciliation phải đối chiếu số lượng, bản ghi lỗi và bản ghi bỏ qua. | Import run | FR-LMP-022 | Source fact + PROPOSAL |
| BR-LMP-015 | Quyền xem/đổi field PII và tài chính áp theo actor × resource × action × field × purpose; deny mặc định. | Access sensitive field/action | FR-LMP-006/020 | Plan red-team |
| BR-LMP-016 | Notification không làm fail business transaction chính; business commit ghi outbox event để delivery retry sau. | Business event emits notification | FR-LMP-019 | Plan red-team |
| BR-LMP-017 | Xóa mềm: Reader, Thủ thư, BibliographicRecord, Copy đã có lịch sử nghiệp vụ chỉ được vô hiệu hóa/deactivate — không xóa cứng (giữ ledger append-only và audit trail). | Delete/deactivate request | FR-LMP-001/002/004 | Source fact (BR-12 nguồn) |

## 6. Error Matrix

| Error ID | Title | Trigger | Severity | Related FR | Screen state | Recovery |
|----------|-------|---------|----------|------------|--------------|----------|
| E-LMP-001 | Validation failed | Trường bắt buộc thiếu/sai định dạng | minor | nhiều FR | Inline error trên màn hiện tại | Giữ dữ liệu nhập, cho sửa và submit lại |
| E-LMP-002 | Permission denied | Actor không có quyền object/action/field | major | FR-LMP-006 | Access denied screen/banner | Quay về danh sách an toàn, audit denial |
| E-LMP-003 | Record not found hoặc duplicate | Mã không tồn tại hoặc trùng unique business key | major | FR-LMP-001/002/004 | Empty/error panel | Cho nhập lại mã hoặc mở bản ghi hiện có |
| E-LMP-004 | Copy unavailable | Copy không ở trạng thái hợp lệ để mượn | major | FR-LMP-008/012 | Checkout review error | Loại item khỏi phiếu hoặc chọn copy khác |
| E-LMP-005 | Concurrency conflict | Trạng thái copy/reservation đổi sau khi load | critical | FR-LMP-009/012 | Conflict dialog + fresh state | Reload state và retry an toàn |
| E-LMP-006 | Duplicate request replay | Cùng idempotency key được submit lại | minor | FR-LMP-009/015 | Idempotent success/duplicate notice | Trả kết quả gốc, không tạo tác dụng phụ mới |
| E-LMP-007 | Reader ineligible | Reader bị khóa/quá limit/không active | major | FR-LMP-008/011 | Checkout/renewal blocked panel | Hiển thị lý do và hành động khắc phục |
| E-LMP-008 | Reservation unavailable | Không có copy phù hợp hoặc reservation bị hủy/hết hạn | major | FR-LMP-012/013 | Queue/error panel | Cho hủy, đổi edition/copy hoặc quay lại |
| E-LMP-009 | Payment failed | Kênh thanh toán hoặc ghi payment thất bại | critical | FR-LMP-015 | Payment error | Giữ nghĩa vụ, cho retry idempotent |
| E-LMP-010 | Payment duplicate detected | Submit/click payment lặp | minor | FR-LMP-015 | Duplicate notice | Hiển thị payment event đã ghi |
| E-LMP-011 | Upload rejected | File sai loại/size/nội dung | major | FR-LMP-025 | Attachment error | Cho chọn file khác, không lưu file rủi ro |
| E-LMP-012 | Notification delivery failed | Kênh ngoài timeout/reject | major | FR-LMP-019 | Notification status/error | Retry theo policy; dead-letter sau ngưỡng |
| E-LMP-013 | Audit write failed | Audit sink không ghi được | critical | FR-LMP-020 | Blocking error cho sensitive action | Rollback business write, alert vận hành |
| E-LMP-014 | Import invalid hoặc mismatch | File sai format/dòng lỗi/reconcile lệch | major | FR-LMP-022 | Import report error | Cho tải file sửa hoặc dry-run lại; không commit nếu chưa pass |
| E-LMP-015 | Invalid state transition | Action không hợp lệ từ trạng thái hiện tại | major | nhiều FR | Disabled action + explanation | Reload state, chỉ hiện action hợp lệ |
| E-LMP-016 | Field-level access denied | Actor thiếu quyền field nhạy cảm | major | FR-LMP-006/020 | Masked/blocked field | Không lộ dữ liệu; audit access attempt |
| E-LMP-017 | Session expired / step-up required | Phiên hết hạn hoặc tác vụ nhạy cảm cần xác thực lại | major | FR-LMP-007 | Re-auth dialog/route | Sau xác thực quay lại trạng thái an toàn |
| E-LMP-018 | Notification channel unavailable | Outbox/queue lỗi hoặc channel down | major | FR-LMP-019 | Delivery status degraded | Retry/dead-letter; business event vẫn commit |

## 7. Success Criteria

| ID | Outcome nghiệp vụ | Đo bằng | Mốc đạt |
|----|-------------------|---------|---------|
| SC-LMP-01 | Hoàn tất mượn/trả tại quầy nhanh và chính xác | Thời gian trung bình/giao dịch, tỷ lệ lỗi state | Ngưỡng cuối cùng OQ-LMP-010; proposal: ≤2 phút/giao dịch |
| SC-LMP-02 | Không mất/trùng quyền sở hữu bản sao khi concurrency | Kiểm thử đồng thời và audit reconcile | 100% P0 concurrency tests pass |
| SC-LMP-03 | Đặt trước công bằng và có kiểm soát | Thứ tự queue, hold expiry, notification status | 100% P0 reservation tests pass; release boundary chờ duyệt |
| SC-LMP-04 | Tài chính có thể đối soát | Event ledger đầy đủ, số dư khớp sum events | 100% financial events append-only |
| SC-LMP-05 | Thông báo không làm mất giao dịch | Outbox event tồn tại sau commit | 100% business events có outbox record |
| SC-LMP-06 | Audit phủ hành động nhạy cảm | Trace actor/action/resource/result | 100% sensitive actions audited |
| SC-LMP-07 | Import có kiểm soát | Dry-run và reconcile report | Chỉ commit khi pass hoặc override approved |

## 8. Data Entities (tóm tắt — chi tiết ở erd.md)

- `BibliographicRecord`: đầu sách / thông tin thư mục.
- `Copy`: bản sao vật lý với barcode/QR locator, trạng thái, vị trí, tình trạng.
- `Reader`: người đọc, liên hệ tối thiểu, trạng thái tài khoản.
- `Loan`: phiếu mượn/khoản mượn, hạn trả, lần gia hạn.
- `LoanItem`: bản sao trong phiếu mượn và trạng thái return.
- `Reservation`: yêu cầu giữ trước và vị trí hàng đợi.
- `Fine`: nghĩa vụ tài chính, trạng thái và số dư suy từ events.
- `FinancialEvent`: assessment/payment/waiver/adjustment/reversal/refund/reconciliation append-only.
- `DamageReport`: báo cáo hư hỏng/mất và quyết định xử lý.
- `NotificationEvent`: outbox notification và delivery status.
- `AuditEvent`: actor/action/resource/result/timestamp/redacted payload.
- `PolicyConfig`: cấu hình nghiệp vụ được quản trị.
- `ImportBatch` / `ImportIssue`: batch import, dry-run, lỗi và reconcile.

## 9. Flows (tóm tắt — chi tiết ở flows.md)

- Luồng catalog/copy administration.
- Luồng reader administration.
- Luồng checkout nguyên tử và xử lý conflict/idempotency.
- Luồng return/renewal và tạo fine/damage follow-up.
- Luồng reservation queue/hold/expiry/pickup.
- Luồng fine payment và financial events.
- Luồng damage report/lost/found.
- Luồng notification outbox, audit và admin import/reconcile.

## 10. Screens (tóm tắt — chi tiết ở userflow + html-wireframe)

Nhóm màn hình chính: đăng nhập/access, dashboard, danh mục, chi tiết đầu sách, form đầu sách, copy inventory, reader list/detail/form, quầy lưu thông, checkout scan/review/conflict, return scan/result, renewal result, reservation search/form/queue/pickup, fine list/detail/payment, damage/lost-found, admin config, import, audit log, reports, notification status.

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
| Thủ thư là actor P0 chính; người đọc tự phục vụ có thể dời R2 | FR-LMP-024 và screen portal |
| Reservation trọn vòng có một release owner duy nhất là R2; luồng trả R1A không phân bổ hàng chờ (D5 = "không có hàng chờ") | FR-LMP-012/013; PROPOSAL DEC-P2-05 |
| Cấu hình loan/renewal/hold/fine là policy do quản trị viên quản lý | BR-LMP-003/004/005 |
| Upload ảnh cần trong damage/lost flow từ R1A (báo cáo hư hỏng có ảnh 1–5 thuộc CAP-DAMAGE R1A) | FR-LMP-025 |
| Desktop 1024 là primary device | Userflow/wireframe device |

## 12. Open Questions

- [ ] OQ-LMP-001 — Ai có quyền approve baseline/release/hard-stop? Owner: product sponsor. Gate: không artifact nào được đánh `approved`.
- [ ] OQ-LMP-002 — Representative Excel source và mapping schema là gì? Owner: data owner. Gate: FR-LMP-022 chỉ proposal cho đến khi có file mẫu.
- [ ] OQ-LMP-003 — Reservation thuộc MVP hay R2? Resolved-as-PROPOSAL bởi DEC-P2-05: single release owner = R2. Owner: product owner. Gate: chờ approve trước khi SRS lock.
- [ ] OQ-LMP-004 — Diagram Copy/Return gốc thiếu; lifecycle hiện tại là PROPOSAL cần domain review. Owner: domain approver.
- [ ] OQ-LMP-005 — Fine partial payment, waiver, adjustment, reversal/refund và reconciliation policy? Owner: finance owner. Gate: FR-LMP-016/018.
- [ ] OQ-LMP-006 — Retention/deletion/masking policy? Owner: legal/privacy. Gate: NFR-LMP-005 và privacy QA.
- [ ] OQ-LMP-007 — Identity model: local account, SSO hay external IdP? Owner: security/IT. Gate: FR-LMP-006/007.
- [ ] OQ-LMP-008 — Kênh notification bắt buộc là email/SMS/push hay trong-app? Owner: product owner. Gate: FR-LMP-019.
- [ ] OQ-LMP-009 — Chính sách reconcile tài chính và ai approve financial override? Owner: finance owner. Gate: BR-LMP-007/008.
- [ ] OQ-LMP-010 — Ngưỡng loan limit, renewal limit, hold expiry, due/fine threshold và SLA? Owner: domain/product owner. Gate: các BR/SC liên quan.
- [ ] OQ-LMP-011 — Ngữ nghĩa Loan↔LoanItem: phiếu mượn là header + dòng per-copy (hạn trả/gia hạn/trạng thái ở dòng) — xác nhận thay giả định mặc định "không phiếu cha" từ OQ-06 nguồn. Owner: domain approver. Gate: ERD + uc-checkout/return.
- [ ] OQ-LMP-012 — Actor/staff reference model: `*_by`/`actor_ref`/`recipient_ref` trỏ tài khoản hệ thống không nằm trong 13 entity §8 — tách entity hay giữ ref logic? Liên quan OQ-LMP-007 (identity model). Owner: security/IT. Gate: ERD + audit.
- [ ] OQ-LMP-013 — `DamageReport.photo_refs`: list nhúng hay entity Attachment riêng? Liên quan OQ-LMP-006 (retention). Owner: domain/tech. Gate: ERD + uc-damage-lost-found.
- [ ] OQ-LMP-014 — Kế thừa OQ-01 nguồn: sau khi tách `Quản trị viên` khỏi `Thủ thư` nguồn (mapping §2 — PROPOSAL), ai quản lý tài khoản Quản trị viên và cơ chế chống tự nâng quyền? Owner: security/IT. Gate: FR-LMP-006/007 + ma trận RBAC.

## 13. Approval register

| Artifact layer | Required approver | Current evidence | State |
|----------------|-------------------|------------------|-------|
| Core spec | BA lead + product owner | Chưa có approval event | draft / pending |
| Lifecycle states | Domain approver | `domain/lifecycle-inventory.md` đã tồn tại — reconstruction DEC-D3-01/02 `Open` | PROPOSAL |
| Security/privacy/finance | Security, legal, finance owners | OQ mở | blocked for approval |
| Release boundary | Product owner | `docs/_product/roadmap.md` R0–R3 draft — chờ L1; remap SRS theo DEC-P2-08 | pending |

