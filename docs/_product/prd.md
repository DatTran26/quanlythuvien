---
type: prd-product
status: draft
updated: 2026-10-05
links:
  - docs/he_thong_quan_ly_thu_vien.md
  - docs/_shared/project-profile.md
  - docs/features/library-management-platform/brainstorms/product-roadmap-baseline.md
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
| Decision register | `PROPOSAL` | `docs/_product/decision-register.md`; Phase 1 chưa sinh bản gốc trên filesystem tại thời điểm viết — các quyết định Phase 2 dùng namespace `DEC-P2-*`. |
| ID registry | Chưa tồn tại | `docs/_shared/id-registry.md` là output Phase 1; namespace CAP-/REL-/GATE-/DEC- trong tài liệu này là `PROPOSAL` cho tới khi registry được duyệt. |

## 1. One-line Pitch

Số hóa trọn vòng mượn – trả – đặt trước của một thư viện vật lý bằng định danh QR cho từng bản sao và từng người đọc, với kiểm soát quá hạn/phạt/hư hỏng và báo cáo vận hành truy vết được. (FACT — tổng hợp từ tài liệu hệ thống và project profile.)

## 2. Problem & Why Now

- **Vấn đề cốt lõi:** quầy mượn–trả thủ công dễ nhầm sách/người đọc/trạng thái; kho và công nợ phạt không minh bạch; không có baseline để ra quyết định go-live. (FACT)
- **Ai đang đau:** Nhân viên quầy (tốc độ và độ chính xác giao dịch), Thủ thư (kiểm soát kho, quy định, hư hỏng, báo cáo), Người đọc (không tự theo dõi được), Thủ thư trưởng (thiếu căn cứ go-live). (FACT — brainstorm §3)
- **Giải pháp thay thế hiện tại:** quy trình thủ công/sổ sách tại quầy. (FACT — suy từ mục tiêu số hóa)
- **Why now:** pilot tại một cơ sở với hai quầy đã là giả định vận hành; dữ liệu Excel sẵn có cần được import và đối soát trước pilot. (FACT — project profile, OQ-15)

## 3. Target Users

Thuật ngữ theo `docs/_shared/project-profile.md`.

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
| Quản trị tài khoản | CAP-ACCT | Đăng ký + kích hoạt người đọc; CRUD tài khoản người đọc/nhân viên; quản lý giới hạn của Nhân viên | FR-R01, FR-L05, FR-L06, FR-S10 | P0 | R0 (CRUD), R1B (FR-S10) |
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

1) Import Excel → dry-run → đối soát → dán QR → kho sẵn sàng → `CAP-IMPORT` + `CAP-CATALOG` (Nhân viên/Thủ thư, R0)
2) Người đọc đăng ký → Nhân viên kích hoạt → thẻ QR hiệu lực → `CAP-ACCT` (R0)
3) Quét thẻ → quét sách → kiểm tra BR ngay khi quét → xác nhận → Loan + audit + biên nhận → `CAP-CIRC` (R1A)
4) Quét trả → đóng Loan → tính quá hạn/phạt → chuyển trạng thái Copy (Sẵn sàng/Chờ duyệt/Mất; Đang giữ chỉ khi CAP-RESERVE đã bật ở R2) → `CAP-CIRC` + `CAP-FINE` + `CAP-DAMAGE` (R1A)
5) Người đọc tra cứu → đặt trước khi hết sách → nhận thông báo sẵn sàng → đến nhận trong 48h → `CAP-READER` + `CAP-RESERVE` + `CAP-NOTIFY` (R2)
6) Thủ thư cấu hình quy định → duyệt hư hỏng → xem báo cáo/audit → `CAP-POLICY` + `CAP-DAMAGE` + `CAP-REPORT` + `CAP-AUDIT` (R0–R2)

### Bảng Feature Map

| # | Tính năng | Slug | Theme | Persona | Ưu tiên | Phụ thuộc | Release |
|---|---|---|---|---|---|---|---|
| 1 | Đăng nhập & phân quyền | `access-control` | CAP-IDENT | Mọi vai trò | P0 | — | R0 |
| 2 | Đăng ký & kích hoạt người đọc | `reader-onboarding` | CAP-ACCT | Người đọc, Nhân viên | P0 | CAP-IDENT | R0 |
| 3 | Quản trị tài khoản | `account-admin` | CAP-ACCT | Thủ thư | P0 | CAP-IDENT | R0 |
| 4 | Danh mục & đầu sách | `catalog-admin` | CAP-CATALOG | Thủ thư | P0 | CAP-IDENT | R0 |
| 5 | Bản sao & nhãn QR | `copy-inventory` | CAP-CATALOG | Thủ thư | P0 | catalog-admin | R0 |
| 6 | Import Excel & đối soát | `data-import` | CAP-IMPORT | Thủ thư | P0 | catalog-admin, CAP-POLICY, file Excel nguồn (external blocker) | R0 |
| 7 | Cấu hình quy định | `policy-config` | CAP-POLICY | Thủ thư | P0 | Quyết định giá trị BR (GATE-DEC) | R0 |
| 8 | Audit capture & backup/restore | `ops-foundation` | CAP-AUDIT, CAP-OPS | Hệ thống | P0 | CAP-IDENT | R0 |
| 9 | Mượn tại quầy | `checkout` | CAP-CIRC | Nhân viên | P0 | CAP-IDENT, CAP-CATALOG, CAP-POLICY | R1A |
| 10 | Trả & ngoại lệ | `return-handling` | CAP-CIRC | Nhân viên | P0 | checkout, CAP-OVERDUE, CAP-FINE, CAP-DAMAGE | R1A |
| 11 | Job quá hạn & fine ledger | `overdue-fines` | CAP-OVERDUE, CAP-FINE | Hệ thống | P0 | CAP-POLICY, CAP-AUDIT | R1A |
| 12 | Báo cáo hư hỏng & duyệt | `damage-lifecycle` | CAP-DAMAGE | Nhân viên, Thủ thư | P0 | CAP-CIRC | R1A |
| 13 | Ghi nhận mất sách | `lost-handling` | CAP-DAMAGE | Nhân viên | P0-PROPOSAL | return-handling, GATE-DEC (financial control) | R1A |
| 14 | Thu phạt tiền mặt tối thiểu | `fine-collection-basic` | CAP-FINE | Nhân viên | P0-PROPOSAL | overdue-fines | R1A |
| 15 | Tự phục vụ người đọc | `reader-self-service` | CAP-READER | Người đọc | P0 | CAP-IDENT, CAP-CIRC | R1A |
| 16 | Thông báo tối thiểu | `notification-core` | CAP-NOTIFY | Hệ thống | P0 | CAP-IDENT | R1A |
| 17 | Báo cáo vận hành | `ops-reports` | CAP-REPORT | Thủ thư | P0 | CAP-CIRC dữ liệu thật | R1A |
| 18 | Gia hạn | `renewal` | CAP-RENEW, CAP-READER | Người đọc, Nhân viên | P1 | checkout; BR-04 check queue (queue rỗng cho tới R2 — xem DEC-P2-05) | R1B |
| 19 | Thu phạt nâng cao (biên nhận, miễn/điều chỉnh) | `fine-collection-adv` | CAP-FINE | Nhân viên, Thủ thư | P1 | fine-collection-basic, financial-control approval | R1B |
| 20 | Trung tâm thông báo & audit viewer | `notification-audit-ui` | CAP-NOTIFY, CAP-AUDIT | Mọi vai trò, Thủ thư | P1 | notification-core, ops-foundation | R1B |
| 21 | Đặt trước trọn vòng | `reservation` | CAP-RESERVE | Người đọc, Nhân viên | P1 | return-handling (điểm quyết định D5), notification-core, CAP-POLICY | R2 |
| 22 | Báo cáo xu hướng | `trend-reports` | CAP-REPORT | Thủ thư | P1 | dữ liệu vận hành tích lũy | R2 |
| 23 | Candidate mở rộng | `expansion-candidates` | CAP-ATTEND/PAY/BRANCH/OFFLINE/MSGALT | — | P2 | Quyết định riêng từng mục | R3 (candidate) |

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
- [ ] OQ-03: Luồng đăng ký/kích hoạt người đọc → mặc định đang dùng là `PROPOSAL`.
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

<!-- Phase 2 deliverable — QuanLyThuVIen BA workflow -->
