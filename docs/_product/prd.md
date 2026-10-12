---
type: prd-product
status: draft
updated: 2026-10-12
links:
  - docs/he_thong_quan_ly_thu_vien.md
  - docs/_shared/project-profile.md
  - docs/_product/product-roadmap-baseline.md
  - plans/reports/ba-audit-261005-0018-library-management-roadmap.md
  - docs/_product/roadmap.md
  - docs/_product/priority-crosswalk.md
  - docs/_product/readiness-gates.md
  - docs/_product/decision-register.md
---

# Hệ thống Quản lý Thư viện — Product Requirements Document

## 0. Trạng thái baseline và nhãn nguồn

Tài liệu này phân biệt ba mức độ tin cậy. Mọi mục không ghi nhãn được mặc định là FACT từ nguồn.

| Nhãn | Nghĩa |
|---|---|
| `FACT` | Có căn cứ trực tiếp trong `docs/he_thong_quan_ly_thu_vien.md`, `docs/_shared/project-profile.md` hoặc brainstorm baseline. |
| `PROPOSAL` | Suy diễn hợp lý để hoàn thiện baseline; chờ domain approval qua Decision gate (GATE-DEC). |
| `APPROVED` | Đã có approver, thời điểm và evidence. Hiện tại chưa có mục nào ở trạng thái này. |

| Item | Trạng thái | Ghi chú |
|---|---|---|
| Product PRD | `PROPOSAL` | Chờ L1 approval (đợt 1 — xem readiness-gates). |
| Roadmap R0–R3 | `PROPOSAL` | Chờ L1 approval (đợt 2, sau PRD). |
| Decision register | `PROPOSAL` | `docs/_product/decision-register.md` có 27 quyết định: 18 quyết định DEC-D3/DEC-P2 còn `Open`, 9 quyết định tách feature DEC-SF đã chốt ngày 2026-10-08. |
| ID registry | `draft` | `docs/_shared/id-registry.md` đã tồn tại; namespace CAP-/REL-/GATE-/DEC- vẫn là `PROPOSAL` cho tới khi được duyệt. |

## 1. One-line Pitch

Số hóa trọn vòng mượn – trả – đặt trước của một thư viện vật lý bằng định danh QR cho từng bản sao và từng người đọc, với kiểm soát quá hạn/phạt/hư hỏng và báo cáo vận hành truy vết được. (FACT — tổng hợp từ tài liệu hệ thống và project profile.)

## 2. Problem & Why Now

- **Vấn đề cốt lõi:** quầy mượn–trả thủ công dễ nhầm sách/người đọc/trạng thái; kho và công nợ phạt không minh bạch; không có baseline để ra quyết định go-live. (FACT)
- **Ai đang đau:** Nhân viên quầy (tốc độ và độ chính xác giao dịch), Thủ thư (kiểm soát kho, quy định, hư hỏng, báo cáo), Người đọc (không tự theo dõi được), Thủ thư trưởng (thiếu căn cứ go-live). (FACT — brainstorm §3)
- **Giải pháp thay thế hiện tại:** quy trình thủ công/sổ sách tại quầy. (FACT — suy từ mục tiêu số hóa)
- **Why now:** pilot tại một cơ sở với hai quầy đã là giả định vận hành; nhu cầu import và đối soát Excel đã được xác định, nhưng file đại diện vẫn là external blocker. (FACT — project profile, OQ-15)

## 3. Target Users

Thuật ngữ thống nhất với nghiệp vụ gốc và DEC-SF-01 (cập nhật 2026-10-12): **Người đọc** (`READER`), **Nhân viên** (`STAFF`, trực quầy) và **Thủ thư** (`LIBRARIAN`, quản lý nghiệp vụ).

| Nhóm người dùng | Vai trò | Job-to-be-done | Bối cảnh sử dụng |
|---|---|---|---|
| Người đọc | Primary | Tra cứu sách, xem thẻ QR, theo dõi khoản mượn/đặt trước/phạt, tự gia hạn | Web responsive, tự phục vụ |
| Nhân viên | Primary | Quét QR tạo phiếu mượn/trả, xử lý ngoại lệ (quá hạn, hư hỏng, mất, phạt), hỗ trợ người đọc | Quầy phục vụ, camera điện thoại hoặc nhập mã thủ công |
| Thủ thư | Primary | Quản lý kho, danh mục, tài khoản, quy định; duyệt hư hỏng/thanh lý; báo cáo | Web quản trị |
| Thủ thư trưởng | Stakeholder/Approver | Chốt quy định, phạm vi pilot, quyết định go-live | Cổng duyệt |
| Bảo mật/pháp chế | Stakeholder | Phê duyệt retention, quyền dữ liệu cá nhân, kiểm soát PII | Gate pháp lý trước go-live |

*Ai KHÔNG phải người dùng:* khách vãng lai không có thẻ; vai trò Admin riêng chưa được xác lập (OQ-01 — `PROPOSAL` mặc định: Thủ thư seed đầu tiên, không tự sửa vai trò lẫn nhau); độc giả ngoài cơ sở pilot.

## 4. Value Proposition & Differentiator

- **Giá trị cốt lõi (1 câu):** mọi giao dịch mượn–trả tại quầy chỉ cần quét QR và được hệ thống chặn sai ngay tại thời điểm quét. (FACT)
- **Vì sao chọn mình thay vì giải pháp cũ:** kiểm tra hạn mức/trùng đầu sách/quá hạn/công nợ tức thời (BR-01..03); trạng thái bản sao là nguồn duy nhất của số lượng khả dụng (BR-11); mọi thao tác ghi audit (NFR-04). (FACT)
- **Lợi thế khác biệt:** vòng đời 7 trạng thái của bản sao + ledger phạt + đối soát import khiến dữ liệu kho luôn truy vết được — điều sổ sách không làm được. (FACT một phần; chi tiết state machine là `PROPOSAL` chờ phục hồi — OQ trong brainstorm §11)

## 5. Goals & Non-Goals

**Mục tiêu (in-scope):**

- Vận hành trọn vòng mượn–trả tại quầy với QR, chặn lỗi ngay khi quét, giao dịch nguyên tử. (FACT)
- Kho đầu sách/bản sao sạch sau import Excel + dán nhãn + đối soát vật lý. (FACT)
- Vòng đời khép kín cho Loan, Reservation, Fine, DamageReport — không trạng thái treo vô chủ. (FACT — audit blocker #2, #3)
- Audit, backup/restore và kiểm soát quyền trước khi dữ liệu thật đi vào giao dịch. (FACT — audit dependency list)
- Đặt trước trọn vòng ở release sau MVP; không phân bổ hàng chờ khi module chưa bật. (`PROPOSAL` — DEC-P2-05)

**Ngoài phạm vi (non-goals / out-of-scope):**

- Thanh toán trực tuyến, sách điện tử, nhiều chi nhánh, offline, SMS/Zalo/push, điểm danh — là candidate R3, không cam kết. (FACT — project profile baseline + brainstorm P2)
- Phân loại người đọc với bộ quy định riêng trong MVP. (FACT — project profile; OQ-04)
- KPI/SLA dài hạn — các chỉ số chưa có baseline là target pilot cần đo lại. (FACT — brainstorm §8)

## 6. Capability Themes

Namespace `CAP-*` là `PROPOSAL` chờ ID registry Phase 1. Ưu tiên là normalized priority (P0/P1/P2), xem `priority-crosswalk.md`.

| Theme | Capability ID | Mô tả | Nguồn FR/BR/NFR | Normalized | Release |
|---|---|---|---|---|---|
| Danh tính & phân quyền | CAP-IDENT | Đăng nhập/xuất, đặt lại mật khẩu, hồ sơ, RBAC 3 vai trò | FR-C01..C03, NFR-02 | P0 | R0 |
| Quản trị tài khoản | CAP-ACCT | Cấp + kích hoạt tài khoản người đọc tại quầy (DEC-SF-03); CRUD tài khoản người đọc/Nhân viên; Nhân viên sửa và khóa tạm người đọc | FR-R01, FR-L05, FR-L06, FR-S10 | P0 | R0 (CRUD), R1B (FR-S10) |
| Danh mục & kho | CAP-CATALOG | CRUD đầu sách, bản sao, danh mục, vị trí kệ; sinh/in QR; số lượng khả dụng theo BR-11 | FR-L02..L04 | P0 | R0 |
| Import & đối soát | CAP-IMPORT | Import Excel dry-run, báo lỗi theo dòng, đối soát vật lý, rollback batch | OQ-15, profile baseline | P0 | R0 |
| Quy định & state | CAP-POLICY | Cấu hình BR-01..BR-13 không sửa code; hiệu lực theo thời điểm giao dịch; lifecycle Copy/Loan/Reservation/Fine/DamageReport | FR-L07, BR-01..13 | P0 | R0 |
| Lưu thông quầy | CAP-CIRC | Quét QR thẻ + sách, tạo phiếu mượn nhiều cuốn một transaction, nhận trả | FR-S01..S04 | P0 | R1A |
| Quá hạn | CAP-OVERDUE | Job chuyển OVERDUE, nhắc hạn, danh sách quá hạn | Job 00:05/08:00, FR-S09, RP-04 | P0 | R1A |
| Phạt & công nợ | CAP-FINE | Fine ledger tự động, thu tiền mặt tối thiểu, biên nhận, miễn/điều chỉnh theo thẩm quyền, người đọc xem công nợ | FR-S08, FR-R09, BR-05..07 | P0 (ledger + thu tối thiểu), P1 (nâng cao) | R1A, R1B |
| Hư hỏng & mất | CAP-DAMAGE | Báo cáo hư hỏng có ảnh, duyệt/disposition, ghi nhận mất, thanh lý | FR-S05, FR-S07, FR-L08, BR-06/07 | P0 | R1A |
| Tự phục vụ người đọc | CAP-READER | Tra cứu, thẻ QR, đang mượn, lịch sử, gia hạn online | FR-R02..R06 | P0 (R02..R05), P1 (R06) | R1A, R1B |
| Đặt trước | CAP-RESERVE | Hàng chờ FIFO, giữ 48h, hết hạn chuyển tiếp, hủy | FR-R07, FR-R08, BR-08..10 | P1 | R2 |
| Thông báo | CAP-NOTIFY | In-app + email cho sự kiện quan trọng; trung tâm thông báo | FR-C04, mục 8, OQ-07 | P0 (tối thiểu), P1 (đầy đủ) | R1A, R1B |
| Audit & truy vết | CAP-AUDIT | Ghi audit mọi thao tác thay đổi dữ liệu; viewer tra cứu | NFR-04, FR-L10 | P0 (capture), P1 (viewer) | R0, R1B |
| Vận hành | CAP-OPS | Backup hằng ngày giữ 30 bản, restore drill, runbook, job owner | NFR-07 | P0 | R0, R1B |
| Báo cáo | CAP-REPORT | RP-01..RP-08 xuất Excel/PDF | FR-L09, mục 9 | P0 (RP-01/02/04), P1 (RP-03/05/06/07), P2 (RP-08) | R1A, R2, R3 |
| Gia hạn tại quầy | CAP-RENEW | Gia hạn thay người đọc theo BR-04 | FR-S06, BR-04 | P1 | R1B |
| Candidate mở rộng | CAP-ATTEND, CAP-PAY, CAP-BRANCH, CAP-OFFLINE, CAP-MSGALT | Điểm danh, thanh toán online, nhiều chi nhánh, offline, SMS/push/Zalo | FR-S11, OQ-02/08/09/13 | P2 (candidate) | R3 |

## 7. Feature Map

### Luồng người dùng tổng quan (value stream)

1) Import Excel → chạy thử → đối soát → dán QR → kho sẵn sàng → `data-import`, `catalog-admin`, `copy-inventory` (Thủ thư, R0)
2) Nhân viên cấp và kích hoạt tài khoản người đọc tại quầy → thẻ QR hiệu lực → `reader-onboarding` (R0, DEC-SF-03)
3) Quét thẻ → quét sách → kiểm tra BR ngay khi quét → xác nhận → Loan + audit → `checkout` (R1A)
4) Quét trả → đóng Loan → tính quá hạn/phạt → chuyển trạng thái Copy (Sẵn sàng/Chờ duyệt/Mất; Đang giữ chỉ khi đặt trước đã bật ở R2) → `return-handling`, `overdue-fines`, `damage-lifecycle`, `lost-handling` (R1A)
5) Người đọc tra cứu sách, xem thẻ QR, khoản đang mượn và lịch sử → `reader-self-service` (R1A); xem công nợ (R1B)
6) Người đọc đặt trước khi hết sách → nhận thông báo sẵn sàng → đến nhận trong 48h → `reservation`, `notification-core` (R2)
7) Thủ thư cấu hình quy định → duyệt hư hỏng → xem báo cáo/audit → `policy-config`, `damage-lifecycle`, `ops-reports`, `notification-audit-ui` (R0–R2)

### Bảng Feature Map

| # | Tính năng | Slug | Theme | Persona | Ưu tiên (MoSCoW) | Phụ thuộc | Release | Chi tiết hóa |
|---|---|---|---|---|---|---|---|---|
| 1 | Đăng nhập & phân quyền | `access-control` | CAP-IDENT | Mọi vai trò | Must (P0) | — | R0 | ✅ 6 tầng (draft) |
| 2 | Cấp & kích hoạt tài khoản người đọc tại quầy | `reader-onboarding` | CAP-ACCT | Nhân viên | Must (P0) | access-control | R0 | ✅ 6 tầng (draft) |
| 3 | Quản trị tài khoản | `account-admin` | CAP-ACCT | Thủ thư, Nhân viên | Must (P0) R0; Should (P1) R1B | access-control | R0, R1B | ✅ 6 tầng (draft) |
| 4 | Danh mục & đầu sách | `catalog-admin` | CAP-CATALOG | Thủ thư, Nhân viên | Must (P0) | access-control | R0 | ✅ 6 tầng (draft) |
| 5 | Bản sao & nhãn QR | `copy-inventory` | CAP-CATALOG | Thủ thư | Must (P0) | catalog-admin | R0 | ✅ 6 tầng (draft) |
| 6 | Import Excel & đối soát | `data-import` | CAP-IMPORT | Thủ thư | Must (P0) | catalog-admin, policy-config, file Excel nguồn (external blocker) | R0 | ✅ 6 tầng (draft) |
| 7 | Cấu hình quy định | `policy-config` | CAP-POLICY | Thủ thư | Must (P0) | Quyết định giá trị BR (GATE-DEC) | R0 | ✅ 6 tầng (draft) |
| 8 | Audit capture & backup/restore | `ops-foundation` | CAP-AUDIT, CAP-OPS | Hệ thống | Must (P0) | access-control | R0 | ✅ 6 tầng (draft) |
| 9 | Mượn tại quầy | `checkout` | CAP-CIRC | Nhân viên | Must (P0) | access-control, catalog-admin, copy-inventory, policy-config | R1A | ✅ 6 tầng (draft) |
| 10 | Trả & ngoại lệ | `return-handling` | CAP-CIRC | Nhân viên | Must (P0) | checkout, overdue-fines, damage-lifecycle | R1A | ✅ 6 tầng (draft) |
| 11 | Job quá hạn & fine ledger | `overdue-fines` | CAP-OVERDUE, CAP-FINE | Hệ thống | Must (P0) | policy-config, ops-foundation | R1A | ✅ 6 tầng (draft) |
| 12 | Báo cáo hư hỏng & duyệt | `damage-lifecycle` | CAP-DAMAGE | Nhân viên, Thủ thư | Must (P0) | checkout | R1A | ✅ 6 tầng (draft) |
| 13 | Ghi nhận mất & tìm lại | `lost-handling` | CAP-DAMAGE | Nhân viên | Must (P0-PROPOSAL) R1A; Should (P1) R1B | return-handling, GATE-DEC (financial control) | R1A, R1B | ✅ 6 tầng (draft) |
| 14 | Thu phạt tiền mặt tối thiểu | `fine-collection-basic` | CAP-FINE | Nhân viên | Must (P0-PROPOSAL) | overdue-fines | R1A | ✅ 6 tầng (draft) |
| 15 | Tự phục vụ người đọc | `reader-self-service` | CAP-READER | Người đọc | Must (P0) R1A; Should (P1) R1B | access-control, checkout | R1A, R1B | ✅ 6 tầng (draft) |
| 16 | Thông báo tối thiểu | `notification-core` | CAP-NOTIFY | Hệ thống | Must (P0) | access-control | R1A | ✅ 6 tầng (draft) |
| 17 | Báo cáo vận hành | `ops-reports` | CAP-REPORT | Thủ thư | Must (P0) | checkout (dữ liệu thật) | R1A, R1B | ✅ 6 tầng (draft) |
| 18 | Gia hạn tại quầy & online | `renewal` | CAP-RENEW, CAP-READER | Người đọc, Nhân viên | Should (P1) | checkout; BR gia hạn kiểm hàng chờ rỗng tới R2 (DEC-P2-05) | R1B | ✅ 6 tầng (draft) |
| 19 | Thu phạt nâng cao (biên nhận, miễn/điều chỉnh) | `fine-collection-adv` | CAP-FINE | Nhân viên, Thủ thư | Should (P1) | fine-collection-basic, financial-control approval | R1B | ✅ 6 tầng (draft) |
| 20 | Trung tâm thông báo & audit viewer | `notification-audit-ui` | CAP-NOTIFY, CAP-AUDIT | Mọi vai trò, Thủ thư | Should (P1) | notification-core, ops-foundation | R1B | ✅ 6 tầng (draft) |
| 21 | Đặt trước trọn vòng | `reservation` | CAP-RESERVE | Người đọc, Nhân viên | Should (P1) | return-handling (điểm quyết định D5), notification-core, policy-config | R2 | ✅ 6 tầng (draft) |
| 22 | Báo cáo xu hướng | `trend-reports` | CAP-REPORT | Thủ thư | Should (P1) | ops-reports (dữ liệu vận hành tích lũy) | R2 | ✅ 6 tầng (draft) |
| 23 | Candidate mở rộng | `expansion-candidates` | CAP-ATTEND/PAY/BRANCH/OFFLINE/MSGALT | — | Could (P2) | Quyết định riêng từng mục | R3 (candidate) | 🔄 brainstorm only — không chi tiết hóa |

Ưu tiên ghi theo MoSCoW kèm normalized priority trong ngoặc (`priority-crosswalk.md`). Cột Release là bổ sung so với template, giữ vì release gắn với readiness gate.
### 7.1 Đăng nhập & phân quyền — `access-control`

Mọi vai trò đăng nhập, đặt lại mật khẩu, quản lý hồ sơ của mình và chỉ thấy chức năng, dữ liệu theo vai trò; tác vụ nhạy cảm yêu cầu xác thực lại.

__Phục vụ job:__ Mọi vai trò vào đúng không gian làm việc an toàn.

__Phạm vi v1:__ Đăng nhập/đăng xuất, quên và đặt lại mật khẩu, hồ sơ cá nhân, phân quyền 3 vai trò, xác thực lại, xử lý hết phiên (R0).
__Chưa làm:__ SSO/IdP ngoài; vai trò Admin riêng.

__Luồng chính:__
1) Đăng nhập
2) Dashboard theo vai trò
3) Tác vụ nhạy cảm thì xác thực lại rồi quay về màn đang làm

__Rủi ro chính:__ Identity model chưa chốt · __Đo thành công:__ 100% truy cập ngoài quyền bị từ chối và có audit
__OQ riêng:__ OQ-access-control-001; OQ-01 nguồn

### 7.2 Cấp & kích hoạt tài khoản người đọc tại quầy — `reader-onboarding`

Nhân viên cấp tài khoản người đọc tại quầy và kích hoạt để thẻ QR có hiệu lực (DEC-SF-03).

__Phục vụ job:__ Người đọc có thẻ hợp lệ để mượn sách.

__Phạm vi v1:__ Tạo hồ sơ, kiểm trùng định danh, kích hoạt, cấp thẻ QR (R0).
__Chưa làm:__ Tự đăng ký online (DEC-SF-03).

__Luồng chính:__
1) Nhân viên nhập hồ sơ người đọc
2) Hệ thống kiểm trùng định danh
3) Kích hoạt, thẻ QR có hiệu lực

__Rủi ro chính:__ Dữ liệu cá nhân và thời hạn lưu giữ chưa được duyệt · __Đo thành công:__ 0 hồ sơ trùng định danh
__OQ riêng:__ OQ-core-003; OQ-05 nguồn (hạn thẻ)

### 7.3 Quản trị tài khoản — `account-admin`

Thủ thư quản lý vòng đời tài khoản người đọc và tài khoản Nhân viên; Nhân viên sửa thông tin và khóa tạm người đọc (DEC-SF-04).

__Phục vụ job:__ Tài khoản luôn đúng người, đúng quyền, có dấu vết thay đổi.

__Phạm vi v1:__ R0: tạo, sửa, khóa, xóa mềm tài khoản người đọc và tài khoản Nhân viên. R1B: Nhân viên sửa thông tin, khóa tạm và mở lại người đọc.
__Chưa làm:__ Quản lý tài khoản Thủ thư (còn mở).

__Luồng chính:__
1) Tra cứu tài khoản
2) Xem chi tiết
3) Sửa, khóa hoặc xóa mềm có lý do và audit

__Rủi ro chính:__ Tự nâng quyền hoặc khóa nhầm lẫn nhau · __Đo thành công:__ 100% thay đổi tài khoản có audit
__OQ riêng:__ OQ-account-admin-001; OQ-01 nguồn

### 7.4 Danh mục & đầu sách — `catalog-admin`

Thủ thư quản lý đầu sách và danh mục (thể loại, tác giả, NXB, vị trí kệ); Nhân viên và Thủ thư tra cứu đầu sách, số bản khả dụng.

__Phục vụ job:__ Kho có dữ liệu đầu sách chuẩn và tra cứu được ngay.

__Phạm vi v1:__ Tạo, sửa, ẩn đầu sách; quản lý danh mục; tra cứu phía Nhân viên/Thủ thư (DEC-SF-07).
__Chưa làm:__ Tra cứu phía người đọc (thuộc `reader-self-service`).

__Luồng chính:__
1) Tra cứu đầu sách
2) Xem chi tiết
3) Tạo, sửa hoặc vô hiệu hóa

__Rủi ro chính:__ Bộ trường bắt buộc và quy tắc ISBN chưa được duyệt · __Đo thành công:__ Tra cứu dưới 2 giây ở 50.000 bản sao (NFR-01 nguồn)
__OQ riêng:__ —

### 7.5 Bản sao & nhãn QR — `copy-inventory`

Đăng ký bản sao vật lý, sinh và in nhãn QR; QR chỉ dùng để định vị bản ghi, không phải bằng chứng ủy quyền.

__Phục vụ job:__ Mỗi cuốn sách thật có một mã QR duy nhất trong hệ thống.

__Phạm vi v1:__ Nhập N bản cho một đầu sách, sinh QR hàng loạt, xuất file in nhãn, trạng thái ban đầu của bản sao (R0).
__Chưa làm:__ —

__Luồng chính:__
1) Chọn đầu sách
2) Nhập số bản
3) Sinh QR và in nhãn
4) Dán nhãn lên sách

__Rủi ro chính:__ Trạng thái khởi tạo và cờ cho mượn chờ DEC-D3-01/09 · __Đo thành công:__ 0 mã QR trùng
__OQ riêng:__ DEC-D3-01; DEC-D3-09

### 7.6 Import Excel & đối soát — `data-import`

Import Excel đầu sách và bản sao: kiểm dữ liệu ở vùng tạm, báo lỗi theo dòng, chạy thử trước khi ghi, đối soát sau import.

__Phục vụ job:__ Kho có dữ liệu thật sạch trước khi mở quầy.

__Phạm vi v1:__ Tải file, chạy thử, ghi nguyên lô, báo cáo đối soát (R0).
__Chưa làm:__ Bảng ánh xạ cột chính thức (chờ file mẫu).

__Luồng chính:__
1) Tải file
2) Chạy thử và xem lỗi theo dòng
3) Sửa file, ghi nguyên lô
4) Đối soát với kiểm kê vật lý

__Rủi ro chính:__ File thật kém chất lượng hoặc chưa có (external blocker) · __Đo thành công:__ 100% bản ghi lỗi được chỉ rõ trước khi ghi; sai lệch kho ≤ 1%
__OQ riêng:__ OQ-data-import-001; OQ-data-import-002; OQ-15 nguồn

### 7.7 Cấu hình quy định — `policy-config`

Thủ thư cấu hình tham số mượn, gia hạn, giữ chỗ, phạt, kênh thông báo, có hiệu lực theo thời điểm, không cần sửa code.

__Phục vụ job:__ Thay đổi quy định không phải chờ phát triển phần mềm.

__Phạm vi v1:__ Danh sách tham số, hiệu lực theo thời điểm, audit thay đổi (R0).
__Chưa làm:__ Bộ quy định theo loại người đọc (candidate R3).

__Luồng chính:__
1) Mở cấu hình
2) Sửa tham số
3) Chọn thời điểm hiệu lực
4) Lưu, hệ thống ghi audit

__Rủi ro chính:__ Giá trị quy định chốt muộn · __Đo thành công:__ Chưa có — giá trị chờ GATE-DEC
__OQ riêng:__ OQ-policy-config-001; OQ-04 nguồn

### 7.8 Audit capture & backup/restore — `ops-foundation`

Ghi audit cùng giao dịch cho mọi thao tác nhạy cảm; backup hằng ngày giữ 30 bản và diễn tập khôi phục (DEC-SF-05).

__Phục vụ job:__ Dữ liệu thật luôn truy vết và khôi phục được.

__Phạm vi v1:__ Audit capture, job backup, diễn tập restore (R0).
__Chưa làm:__ Màn xem audit (thuộc `notification-audit-ui`).

__Luồng chính:__
1) Thao tác nhạy cảm ghi audit cùng giao dịch, audit lỗi thì hủy thao tác
2) Backup hằng ngày
3) Diễn tập restore trước go-live

__Rủi ro chính:__ Chưa có owner vận hành · __Đo thành công:__ 100% thao tác ghi có audit; ít nhất 1 lần restore đạt
__OQ riêng:__ OQ-core-003; OQ-core-005

### 7.9 Mượn tại quầy — `checkout`

Nhân viên quét thẻ và nhiều sách; hệ thống kiểm điều kiện ngay khi quét và ghi phiếu mượn nguyên tử, chống trùng và tranh chấp.

__Phục vụ job:__ Mượn sách nhanh, đúng, không hai người cùng giữ một bản sao.

__Phạm vi v1:__ Quét thẻ, quét sách, rà soát, xác nhận, xử lý xung đột, in biên nhận mượn (R1A).
__Chưa làm:__ Nhận sách đặt trước (thuộc `reservation`, R2).

__Luồng chính:__
1) Quét thẻ người đọc
2) Quét sách
3) Rà soát
4) Xác nhận, hệ thống ghi phiếu và audit

__Rủi ro chính:__ Hai quầy tranh cùng một bản sao · __Đo thành công:__ 0 phiếu mở trùng một bản sao
__OQ riêng:__ OQ-policy-config-001; OQ-core-004

### 7.10 Trả & ngoại lệ — `return-handling`

Nhân viên quét sách trả; hệ thống đóng phiếu, phát hiện quá hạn hoặc hư hỏng và chuyển trạng thái bản sao.

__Phục vụ job:__ Trả sách xong là trạng thái kho và công nợ đúng ngay.

__Phạm vi v1:__ Quét trả, ghi tình trạng, đóng phiếu, tạo nghĩa vụ phạt, chuyển bản sao về Sẵn sàng hoặc Chờ duyệt (R1A).
__Chưa làm:__ Phân bổ cho hàng chờ đặt trước (R2, DEC-P2-05).

__Luồng chính:__
1) Quét bản sao
2) Ghi tình trạng
3) Đóng phiếu, tính phạt nếu quá hạn
4) Bản sao về kho hoặc chờ duyệt

__Rủi ro chính:__ Luồng trả là bản dựng lại, chờ duyệt (DEC-D3-02) · __Đo thành công:__ Trả quá hạn/hư hỏng/mất đều đóng phiếu và tạo đúng nghĩa vụ
__OQ riêng:__ OQ-core-002; DEC-D3-02

### 7.11 Job quá hạn & fine ledger — `overdue-fines`

Job hằng ngày chuyển phiếu quá hạn, nhắc hạn và ghi nghĩa vụ phạt dạng sổ chỉ thêm, không sửa xóa.

__Phục vụ job:__ Công nợ phạt luôn đúng và truy vết được.

__Phạm vi v1:__ Job quá hạn, nhắc hạn, ghi nghĩa vụ phạt (R1A).
__Chưa làm:__ Miễn, điều chỉnh, hoàn (thuộc `fine-collection-adv`).

__Luồng chính:__
1) Job quét phiếu đến hạn
2) Chuyển quá hạn
3) Ghi nghĩa vụ phạt
4) Gửi thông báo

__Rủi ro chính:__ Công thức và ngưỡng phạt chưa chốt · __Đo thành công:__ 100% sự kiện tài chính chỉ thêm, không sửa xóa
__OQ riêng:__ OQ-policy-config-001

### 7.12 Báo cáo hư hỏng & duyệt — `damage-lifecycle`

Nhân viên báo hư hỏng kèm 1–5 ảnh, bản sao chuyển Chờ duyệt ngay; Thủ thư quyết định Bác bỏ, Sửa hoặc Thanh lý.

__Phục vụ job:__ Sách hỏng được xử lý dứt điểm, không kẹt trạng thái.

__Phạm vi v1:__ Báo cáo hư hỏng có ảnh, duyệt hướng xử lý tối thiểu (R1A).
__Chưa làm:__ —

__Luồng chính:__
1) Báo cáo kèm ảnh
2) Bản sao chuyển Chờ duyệt
3) Thủ thư chọn hướng xử lý
4) Bản sao chuyển trạng thái theo quyết định

__Rủi ro chính:__ Bản sao kẹt Chờ duyệt · __Đo thành công:__ 0 bản sao kẹt trạng thái tạm không có owner
__OQ riêng:__ OQ-damage-lifecycle-001; DEC-D3-06; DEC-D3-07

### 7.13 Ghi nhận mất & tìm lại — `lost-handling`

Ghi nhận mất sách (đóng phiếu Mất và tạo nghĩa vụ bồi thường) ở R1A; tìm lại sau khi mất và đối soát nghĩa vụ ở R1B (DEC-SF-06).

__Phục vụ job:__ Phiếu mượn luôn có đường kết thúc kể cả khi mất sách.

__Phạm vi v1:__ R1A: ghi nhận mất tối thiểu. R1B: tìm lại và đối soát.
__Chưa làm:__ Hoàn tiền tự động.

__Luồng chính:__
1) Ghi nhận mất
2) Bản sao chuyển Mất, tạo nghĩa vụ bồi thường
3) (R1B) Tìm lại, kiểm tra, đối soát rồi đưa bản sao về kho

__Rủi ro chính:__ Chính sách bồi thường và hoàn tiền chưa duyệt · __Đo thành công:__ Không nghĩa vụ nào bị xóa khi tìm lại sách
__OQ riêng:__ DEC-D3-05; OQ-fine-collection-adv-001

### 7.14 Thu phạt tiền mặt tối thiểu — `fine-collection-basic`

Nhân viên ghi nhận thu tiền mặt tại quầy, chống ghi trùng, không sửa xóa bút toán đã ghi.

__Phục vụ job:__ Người đọc trả được tiền phạt ngay trong pilot.

__Phạm vi v1:__ Tra công nợ, thu tiền mặt, cập nhật số dư (R1A).
__Chưa làm:__ Biên nhận đầy đủ, miễn và điều chỉnh (R1B).

__Luồng chính:__
1) Tra công nợ
2) Chọn khoản
3) Thu tiền mặt
4) Hệ thống ghi khoản thu và cập nhật số dư

__Rủi ro chính:__ Ghi trùng khoản thu · __Đo thành công:__ 0 khoản thu bị ghi hai lần cho một yêu cầu
__OQ riêng:__ OQ-fine-collection-adv-001; OQ-fine-collection-adv-002

### 7.15 Tự phục vụ người đọc — `reader-self-service`

Người đọc tự tra cứu sách, xem thẻ QR, khoản đang mượn và lịch sử ở R1A; xem công nợ ở R1B (DEC-SF-02).

__Phục vụ job:__ Người đọc tự theo dõi được tình trạng mượn của mình.

__Phạm vi v1:__ R1A: tra cứu, thẻ QR, đang mượn, lịch sử. R1B: xem công nợ.
__Chưa làm:__ Đặt trước (thuộc `reservation`), gia hạn online (thuộc `renewal`), thanh toán online (candidate R3).

__Luồng chính:__
1) Đăng nhập
2) Tra cứu sách hoặc mở thẻ QR
3) Xem khoản đang mượn và lịch sử

__Rủi ro chính:__ Thiết bị và hình thức cổng người đọc chưa chốt · __Đo thành công:__ Chưa có — định nghĩa trong PRD feature
__OQ riêng:__ OQ-reader-self-service-001; OQ-reader-self-service-002

### 7.16 Thông báo tối thiểu — `notification-core`

Mọi giao dịch phát sự kiện thông báo vào hàng đợi bền; gửi in-app và email cho sự kiện quan trọng, có thử lại và hàng lỗi.

__Phục vụ job:__ Không giao dịch nào mất chỉ vì gửi thông báo lỗi.

__Phạm vi v1:__ Hàng đợi thông báo, in-app + email sự kiện quan trọng, thử lại, hàng lỗi (R1A).
__Chưa làm:__ Trung tâm thông báo (thuộc `notification-audit-ui`); SMS, push, Zalo (candidate R3).

__Luồng chính:__
1) Giao dịch hoàn tất
2) Sự kiện vào hàng đợi
3) Gửi, lỗi thì thử lại rồi chuyển hàng lỗi

__Rủi ro chính:__ Kênh bắt buộc chưa chốt · __Đo thành công:__ 100% giao dịch nghiệp vụ có sự kiện thông báo
__OQ riêng:__ OQ-notification-core-001; OQ-07 nguồn

### 7.17 Báo cáo vận hành — `ops-reports`

Báo cáo vận hành RP-01, RP-02, RP-04 ở R1A và danh sách quá hạn cho Nhân viên (FR-S09 nguồn) ở R1B.

__Phục vụ job:__ Thủ thư nắm tình hình kho và quá hạn hằng ngày.

__Phạm vi v1:__ RP-01, RP-02, RP-04, xuất file (R1A); danh sách quá hạn (R1B).
__Chưa làm:__ Báo cáo xu hướng (thuộc `trend-reports`, R2).

__Luồng chính:__
1) Mở dashboard báo cáo
2) Chọn báo cáo và bộ lọc
3) Xem hoặc xuất file

__Rủi ro chính:__ Priority lệch: PRD Must (P0), SRS cũ P1 — chốt khi viết PRD feature · __Đo thành công:__ Chưa có — định nghĩa trong PRD feature
__OQ riêng:__ OQ-ops-reports-001

### 7.18 Gia hạn tại quầy & online — `renewal`

Gia hạn tại quầy (Nhân viên làm thay người đọc) và gia hạn online (người đọc tự làm); từ chối khi đã quá hạn, có người đặt trước hoặc hết lượt.

__Phục vụ job:__ Người đọc giữ sách lâu hơn mà không phải trả rồi mượn lại.

__Phạm vi v1:__ Gia hạn tại quầy và online, lý do từ chối rõ ràng (R1B).
__Chưa làm:__ —

__Luồng chính:__
1) Chọn khoản mượn
2) Hệ thống kiểm điều kiện gia hạn
3) Gia hạn hoặc từ chối có lý do

__Rủi ro chính:__ Hàng chờ đặt trước rỗng tới R2 (DEC-P2-05) · __Đo thành công:__ Chưa có — định nghĩa trong PRD feature
__OQ riêng:__ OQ-policy-config-001

### 7.19 Thu phạt nâng cao (biên nhận, miễn/điều chỉnh) — `fine-collection-adv`

Biên nhận, miễn, điều chỉnh, đảo và hoàn tiền phạt có lý do, thẩm quyền và audit; đối soát thu ngân cuối ca.

__Phục vụ job:__ Xử lý ngoại lệ tài chính có kiểm soát.

__Phạm vi v1:__ Biên nhận, miễn/điều chỉnh/đảo/hoàn, đối soát cuối ca (R1B).
__Chưa làm:__ Thu một phần (chờ chính sách).

__Luồng chính:__
1) Mở sổ sự kiện tài chính
2) Chọn thao tác
3) Xác thực lại
4) Ghi sự kiện và audit

__Rủi ro chính:__ Kiểm soát tài chính chưa duyệt (hard-stop) · __Đo thành công:__ Số dư khớp tổng sự kiện tài chính
__OQ riêng:__ OQ-fine-collection-adv-001; OQ-fine-collection-adv-002; DEC-D3-04; DEC-D3-08

### 7.20 Trung tâm thông báo & audit viewer — `notification-audit-ui`

Trung tâm thông báo cho mọi vai trò (DEC-SF-09); màn xem audit và dòng thời gian lịch sử cho Thủ thư.

__Phục vụ job:__ Người dùng xem lại được thông báo; Thủ thư tra được ai làm gì.

__Phạm vi v1:__ Trung tâm thông báo, đánh dấu đã đọc, nhật ký audit, dòng thời gian lịch sử (R1B).
__Chưa làm:__ —

__Luồng chính:__
1) Mở trung tâm thông báo hoặc nhật ký
2) Lọc
3) Xem chi tiết đã che dữ liệu nhạy cảm

__Rủi ro chính:__ Lộ dữ liệu cá nhân trong nhật ký · __Đo thành công:__ Chưa có — định nghĩa trong PRD feature
__OQ riêng:__ OQ-core-003

### 7.21 Đặt trước trọn vòng — `reservation`

Người đọc hoặc Nhân viên đặt trước khi hết bản; hàng chờ theo thứ tự, giữ 48 giờ, hết hạn chuyển người kế tiếp, nhận sách qua quầy mượn.

__Phục vụ job:__ Người đọc chắc chắn có lượt khi sách được trả.

__Phạm vi v1:__ Đặt, hủy, theo dõi hàng chờ, giữ chỗ, hết hạn, nhận sách (R2).
__Chưa làm:__ Bỏ lượt, tạm hoãn (DEC-D3-03).

__Luồng chính:__
1) Tìm sách hết bản
2) Đặt trước
3) Nhận thông báo sẵn sàng
4) Nhận sách trong 48 giờ hoặc hết hạn

__Rủi ro chính:__ Bật điểm quyết định D5 làm thay đổi luồng trả đang chạy · __Đo thành công:__ Tỷ lệ đặt trước được phục vụ trong 48 giờ (roadmap R2)
__OQ riêng:__ OQ-reservation-001

### 7.22 Báo cáo xu hướng — `trend-reports`

Báo cáo xu hướng RP-03, RP-05, RP-06, RP-07 trên dữ liệu vận hành tích lũy.

__Phục vụ job:__ Thủ thư quyết định mua, sửa, thanh lý dựa trên số liệu.

__Phạm vi v1:__ RP-03, RP-05, RP-06, RP-07, xuất file (R2).
__Chưa làm:__ RP-08 (candidate R3).

__Luồng chính:__
1) Mở dashboard báo cáo
2) Chọn báo cáo và khoảng thời gian
3) Xem hoặc xuất file

__Rủi ro chính:__ Dữ liệu pilot chưa đủ dài · __Đo thành công:__ Chưa có — định nghĩa trong PRD feature
__OQ riêng:__ —

### 7.23 Candidate mở rộng — `expansion-candidates`

Danh mục candidate không cam kết: điểm danh, thanh toán online, nhiều chi nhánh, offline, SMS/push/Zalo, phân loại người đọc, phân tích nâng cao.

__Phục vụ job:__ Giữ ý tưởng mở rộng ngoài các release đã cam kết.

__Phạm vi v1:__ Không có — chỉ lập release sau quyết định riêng từng mục.
__Chưa làm:__ Toàn bộ.

__Luồng chính:__
1) Đánh giá từng candidate khi có business case

__Rủi ro chính:__ Scope creep chen vào release cam kết · __Đo thành công:__ Không áp dụng
__OQ riêng:__ OQ-02, OQ-08, OQ-09, OQ-13 nguồn

## 8. Success Metrics

Không bịa baseline: mọi chỉ số chưa có số liệu lịch sử ghi rõ phương pháp đo và owner thiết lập baseline.

| Vai trò | Chỉ số | Baseline | Target | Cách đo / Owner |
|---|---|---|---|---|
| North Star | Thời gian hoàn tất một giao dịch mượn/trả tại quầy | Chưa đo — đo thủ công quy trình hiện tại trong UAT | Giảm so với baseline đo được; QR→hiển thị < 1 giây (NFR-01) | Đo thời gian UAT + telemetry; Owner: Thủ thư trưởng |
| Input | Quét QR → hiển thị < 1s; tra cứu < 2s ở 50.000 bản sao | — | NFR-01 | Kiểm thử hiệu năng với dataset import; Owner: đội kỹ thuật |
| Input | Sai lệch kho vật lý vs hệ thống sau đối soát pilot | — | ≤ 1% | Đối soát kiểm kê; Owner: Thủ thư |
| Input | % bản ghi import lỗi/trùng được chỉ rõ trước ghi chính thức | — | 100% | Báo cáo dry-run; Owner: Thủ thư |
| Guardrail | Số Loan mở trùng một bản sao | — | 0 | Query kiểm chứng định kỳ; Owner: đội kỹ thuật |
| Guardrail | % thao tác thay đổi dữ liệu có audit actor/thời điểm/đối tượng | — | 100% | Kiểm tra AuditLog; Owner: đội kỹ thuật |
| Guardrail | Khôi phục backup thành công trước go-live | — | ≥ 1 lần diễn tập đạt | GATE-OPS evidence; Owner: vận hành |
| Guardrail | Bản sao kẹt trạng thái tạm (Chờ duyệt/Đang giữ) không có owner | — | 0 | Báo cáo tuổi trạng thái; Owner: Thủ thư |

Chỉ số KPI **không thu thập PII quá mức cần thiết** (ràng buộc an toàn từ plan).

## 9. Constraints

- **Kênh/nền tảng:** web responsive là nền tảng duy nhất của baseline; nhân viên quét bằng camera điện thoại hoặc nhập mã thủ công (NFR-06, OQ-14 default — `PROPOSAL` đến khi duyệt). (FACT/PROPOSAL)
- **Ngôn ngữ & định dạng:** tiếng Việt, VND, dd/mm/yyyy, UTC+7 (NFR-08). (FACT)
- **Pháp lý/compliance:** retention, quyền xem/sửa/xóa dữ liệu cá nhân, dữ liệu người chưa thành niên phải được pháp lý/quản trị dữ liệu phê duyệt trước go-live — gate non-waivable. (FACT — project profile Compliance)
- **Vận hành:** một cơ sở, hai quầy pilot; thu phạt tiền mặt tại quầy; không offline. (FACT — project profile)
- **Ngoại lệ bên ngoài:** file Excel đại diện chưa được cung cấp — external blocker có owner trong decision register. (FACT — plan.md blockedBy)

## 10. Risks & Assumptions

| Rủi ro / Giả định | Loại | Nhãn | Khả năng | Hậu quả | Cách phòng |
|---|---|---|---|---|---|
| File Excel thật sai/trùng QR | feasibility | FACT | thường | Không vận hành được quầy | Dry-run, lỗi theo dòng, đối soát vật lý (GATE-MIG) |
| Quy định mượn/phạt chốt muộn | viability | FACT | thỉnh thoảng | Viết lại luồng, trễ pilot | GATE-DEC chốt giá trị BR trước SRS |
| Bản sao kẹt trạng thái Chờ duyệt | usability | FACT | thỉnh thoảng | Giảm sách khả dụng | Disposition tối thiểu trong R1A |
| Nhân viên chưa quen quy trình | usability | FACT | thường | Giao dịch chậm, sửa tay | SOP, diễn tập (GATE-TRN) |
| Quyền riêng tư chưa duyệt | viability | FACT | thỉnh thoảng | Trì hoãn/thu hẹp go-live | GATE-DEC + GATE-GNG non-waivable |
| Scope creep chen vào MVP | viability | FACT | thỉnh thoảng | Trễ critical path | Candidate giữ ngoài release cam kết |
| Sơ đồ Copy 7 trạng thái & flow trả gốc không phục hồi được | feasibility | FACT | chưa rõ | SRS khóa trên giả định | Reconstruct-as-proposal + domain approval (Phase 3) |
| Reservation kích hoạt R2 đổi hành vi trả | feasibility | PROPOSAL | thấp | Hành vi D5 thay đổi giữa release | Contract D5 ghi rõ "không phân bổ khi module chưa bật" (DEC-P2-05) |

## 11. Open Questions

Kế thừa OQ-01..OQ-15 từ tài liệu hệ thống (giữ nguyên semantics; governance tại decision register). Các OQ ảnh hưởng trực tiếp release/gate:

- [ ] OQ-01: Ai quản lý tài khoản Thủ thư? Có cần Admin riêng? → ảnh hưởng privileged identity, GATE-DEC trước R0.
- [x] OQ-03: Luồng đăng ký/kích hoạt người đọc → Resolved: chỉ cấp tại quầy, không tự đăng ký online (DEC-SF-03, 2026-10-08).
- [ ] OQ-04: Giá trị thật BR-01..BR-10; có phân loại người đọc không → GATE-DEC trước khi khóa policy.
- [ ] OQ-07: Kênh thông báo → xử lý theo DEC-P2-01 (in-app + email sự kiện quan trọng).
- [ ] OQ-08: Thu phạt tiền mặt hay online → mặc định tiền mặt; online là R3 candidate.
- [ ] OQ-12: Quyền xem/xóa lịch sử mượn, retention → gate pháp lý, non-waivable trước go-live.
- [ ] OQ-15: File Excel thật, trạng thái mã cũ → external blocker của GATE-MIG.
- [ ] OQ-BS-1: Chính sách retention được pháp lý duyệt nào → chờ approver.
- [ ] OQ-BS-3: Nguồn phục hồi state machine Copy và flow trả → Phase 3 reconstruct-as-proposal.

## 12. Approval

| Gate | Đối tượng | Approver | Trạng thái | Evidence |
|---|---|---|---|---|
| L1-PRD | Tài liệu này | Thủ thư trưởng (Product Owner) | Pending | — |
| L1-Roadmap | `docs/_product/roadmap.md` | Thủ thư trưởng | Pending — chỉ xin sau khi PRD approved | — |

Quyền phê duyệt baseline chưa được xác lập chính thức (`OQ-core-001` trong `docs/_shared/core-spec.md`); chưa mục nào được đánh `approved`.

<!-- Phase 2 deliverable — QuanLyThuVIen BA workflow -->
