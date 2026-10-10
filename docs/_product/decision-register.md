---
type: decision-register
status: draft
updated: 2026-10-09
links:
  - docs/he_thong_quan_ly_thu_vien.md
  - docs/_shared/project-profile.md
  - docs/_shared/domain/lifecycle-inventory.md
---

# Decision register — Hệ thống Quản lý Thư viện

> Ghi chú quản trị: register được khởi tạo từ Phase 3 để chứa các quyết định phát sinh của domain model. Phase 1 (baseline governance) là owner chính thức của artifact này — khi Phase 1 chạy, các entry dưới đây phải được merge vào schema governance đầy đủ (severity, hard-stop class, resolution evidence). Namespace `DEC-D3-*` là tạm của Phase 3; Phase 1 có thể ánh xạ lại ID nhưng không được mất nội dung.

| ID | Chủ đề | Loại | Owner | Approver | Due gate | Hard-stop? | Status | Evidence / source |
|----|--------|------|-------|----------|----------|------------|--------|--------------------|
| DEC-D3-01 | Copy state machine 7 trạng thái — reconstruction vì sơ đồ gốc mất (`[embedded content]`); toàn bộ transition table §2.2 của lifecycle-inventory | PROPOSAL | BA lead | Thủ thư trưởng (domain approver) | Trước khi Phase 4 khoá state diagram trong SRS | Có — OQ-core-002 | Open | `docs/_shared/domain/lifecycle-inventory.md` §2 |
| DEC-D3-02 | Flow trả sách "3 bước, 2 quyết định" — reconstruction; chi tiết PROPOSAL, thứ tự "đóng Loan + tính phạt trước" là FACT | PROPOSAL | BA lead | Thủ thư trưởng | Cùng DEC-D3-01 | Có — OQ-core-002 | Open | `lifecycle-inventory.md` §2.4 |
| DEC-D3-03 | Reservation `skip`/`suspend` — nguồn không có; chỉ đưa vào baseline khi domain approved | Open | BA lead | Product owner | Trước Phase 4 | Không | Open — hiện KHÔNG nằm trong baseline | `lifecycle-inventory.md` §4 |
| DEC-D3-04 | Partial payment + quyền hạn waiver/adjustment/reversal/refund + SoD | PROPOSAL | BA lead | Finance owner + Thủ thư trưởng | Trước release có thu phạt | Có — OQ-fine-collection-adv-001/002 | Open | `lifecycle-inventory.md` §5 |
| DEC-D3-05 | Lost→found compensation: nghĩa vụ LOST đã ghi không tự xóa; REVERSAL/REFUND theo policy | PROPOSAL | BA lead | Finance owner | Trước SRS financial model | Có — OQ-fine-collection-adv-001 | Open | `lifecycle-inventory.md` §5.2, §7.3 |
| DEC-D3-06 | Copy `ON_HOLD` bị báo hư hỏng → Reservation `READY` re-queue về `WAITING` giữ vị trí | PROPOSAL | BA lead | Thủ thư trưởng | Trước SRS states | Không | Open | `lifecycle-inventory.md` COPY-T08 |
| DEC-D3-07 | Thanh lý trực tiếp `AVAILABLE→DISPOSED` và `IN_REPAIR→DISPOSED` (sửa không thành) | PROPOSAL | BA lead | Thủ thư trưởng | Trước SRS states | Không | Open | `lifecycle-inventory.md` COPY-T14/T17 |
| DEC-D3-08 | `receipt_no` unique, đối soát thu ngân cuối ca (`RECONCILIATION` event), escalation khi notify fail | PROPOSAL | BA lead | Finance + product owner | Trước release có thu phạt | Không | Open | `lifecycle-inventory.md` §5.2, §7.3 |
| DEC-D3-09 | `is_loanable` làm thuộc tính Title (mặc định) + override trên Copy; không phải trạng thái | PROPOSAL | BA lead | Thủ thư trưởng | Trước ERD | Không — theo default OQ-10 | Open | `lifecycle-inventory.md` §2.3 |

## Liên kết Open Questions hiện hữu

Các decision trên gắn với `OQ-reservation-001`, `OQ-core-002`, `OQ-fine-collection-adv-001/002`, `OQ-policy-config-001` (bảng đối chiếu mã gộp cũ ở `docs/_shared/id-crosswalk-lmp.md`) và `OQ-10/OQ-11` trong `docs/he_thong_quan_ly_thu_vien.md` §11. Khi OQ được resolve, entry tương ứng phải cập nhật status + evidence.

## Quyết định Phase 2 — Product PRD & Roadmap (namespace `DEC-P2-*`, tạm)

> Các entry dưới đây được thêm bởi Phase 2 (product PRD + roadmap) để resolve 6 mâu thuẫn priority trong `plans/reports/ba-audit-261005-0018-library-management-roadmap.md` và các scope split phát sinh. Giống `DEC-D3-*`, namespace `DEC-P2-*` là tạm; Phase 1 (owner chính thức của register) có thể ánh xạ lại ID khi merge, không được mất nội dung. Evidence chi tiết: `docs/_product/priority-crosswalk.md` và `docs/_product/roadmap.md`.

| ID | Chủ đề | Loại | Owner | Approver | Due gate | Hard-stop? | Status | Evidence / source |
|----|--------|------|-------|----------|----------|------------|--------|--------------------|
| DEC-P2-01 | Kênh thông báo baseline = in-app + email cho sự kiện quan trọng; thông báo tối thiểu vào P0/R1A, trung tâm thông báo FR-C04 ở P1/R1B; SMS/push/Zalo → R3 candidate | PROPOSAL | BA lead | Thủ thư trưởng | Trước L1 roadmap + trước build R1A | Không | Open | Audit "Mâu thuẫn" #1; OQ-07; `priority-crosswalk.md` §2 |
| DEC-P2-02 | Job OVERDUE + phạt tạm tính + RP-04 nâng vào P0/R1A; BR-03 chặn mượn chỉ bật sau khi job + ledger live | PROPOSAL | BA lead | Thủ thư trưởng | Trước L1 roadmap | Không | Open | Audit "Mâu thuẫn" #2; `roadmap.md` §4 |
| DEC-P2-03 | Damage disposition tối thiểu (Bác bỏ/Sửa/Thanh lý, FR-L08) nâng vào P0/R1A để bản sao không kẹt Chờ duyệt | PROPOSAL | BA lead | Thủ thư trưởng | Trước L1 roadmap | Không | Open | Audit "Mâu thuẫn" #3; `priority-crosswalk.md` §2 |
| DEC-P2-04 | Fine ledger + ghi nhận thu tiền mặt tối thiểu vào P0/R1A; biên nhận/miễn/điều chỉnh → P1/R1B; thẩm quyền miễn/điều chỉnh gộp với DEC-D3-04 (hard-stop financial) | PROPOSAL | BA lead | Finance owner + Thủ thư trưởng | Trước L1 roadmap (split); trước GATE-GNG (financial control) | Có — phần waiver/adjustment (DEC-D3-04) | Open | Audit "Mâu thuẫn" #4; `roadmap.md` §4–5 |
| DEC-P2-05 | Release boundary Reservation: R1A luồng trả KHÔNG phân bổ hàng chờ (D5 luôn "không có hàng chờ"); Reservation trọn vòng một release owner duy nhất = R2; BR-04 check queue rỗng tới R2 không phải dependency đảo | PROPOSAL | BA lead | Thủ thư trưởng | Trước L1 roadmap | Có — quyết định release boundary duy nhất | Open | Audit "Mâu thuẫn" #5; Phase 1 step 8; `roadmap.md` §5–6 |
| DEC-P2-06 | Audit capture vào P0/R0 (trước giao dịch dữ liệu thật); audit viewer FR-L10 → P1/R1B | PROPOSAL | BA lead | Thủ thư trưởng | Trước L1 roadmap | Không | Open | Audit "Mâu thuẫn" #6; NFR-04 |
| DEC-P2-07 | Ghi nhận mất sách tối thiểu (đóng Loan LOST + tạo khoản bồi thường, FR-S07) nâng vào P0/R1A để Loan có đường kết thúc; lost→found xử lý theo DEC-D3-05 | PROPOSAL | BA lead | Thủ thư trưởng + Finance owner | Trước L1 roadmap | Không (scope); financial reversal vẫn hard-stop qua DEC-D3-05 | Open | Brainstorm P0 "trả … và mất sách"; `priority-crosswalk.md` §4 |
| DEC-P2-08 | Release naming chuẩn = R0/R1A/R1B/R2/R3; SRS gộp cũ (đã tách, xem `id-crosswalk-lmp.md`) dùng R1/P0–R2/P1–Later/P2 và gắn Reservation `P0-PROPOSAL` — cần ánh xạ lại sau khi roadmap approved (drift risk, Reservation theo DEC-P2-05 là R2 không phải P0) | PROPOSAL | BA lead | Thủ thư trưởng | Trước Phase 4 khóa SRS | Không — nhưng bắt buộc reconcile trước khi SRS approved | Open | `roadmap.md` §2 vs SRS §1 |
| DEC-P2-09 | Import Excel + đối soát là capability P0/R0 trong roadmap readiness (audit blocker #6); external blocker file Excel đại diện — owner Thủ thư trưởng, due gate GATE-MIG | PROPOSAL | BA lead | Thủ thư trưởng | Trước L1 roadmap | Có — external blocker không có evidence thì GATE-MIG fail | Open | Audit blocker #6; `readiness-gates.md` GATE-MIG |

## Quyết định tách feature (namespace `DEC-SF-*`)

> Giải 9 xung đột phân bổ khi tách feature gộp thành 23 feature theo `docs/_product/prd.md` Mục 7. Nguồn: `plans/261008-2006-split-features-per-prd-map/feature-allocation-draft.md` Mục 4.

| ID | Chủ đề | Loại | Owner | Approver | Due gate | Hard-stop? | Status | Evidence / source |
|----|--------|------|-------|----------|----------|------------|--------|--------------------|
| DEC-SF-01 | Tên vai trò: Người đọc / Thủ thư (trực quầy) / Quản trị viên (dữ liệu, cấu hình, báo cáo, nhật ký). "Nhân viên" nguồn → Thủ thư; "Thủ thư" nguồn → Quản trị viên; Thủ thư trưởng giữ nguyên là approver nghiệp vụ. PRD, roadmap, priority-crosswalk, project-profile đổi theo | Decision | BA lead | Thủ thư trưởng | Trước khi viết URD feature đầu tiên | Không | Chốt (người dùng 2026-10-08) | Nguồn §2; spec Mục 2 mapping |
| DEC-SF-02 | `reader-self-service` theo roadmap: R1A/P0 tra cứu, thẻ QR, đang mượn, lịch sử (FR-R02..R05, bổ sung FR SRS còn thiếu); R1B/P1 xem công nợ (FR-R09). Gia hạn online thuộc `renewal`, đặt trước online thuộc `reservation` (R2). Tách theo `FR-reader-self-service-002/003`, `FR-reservation-003`, `FR-expansion-candidates-001` | Decision | BA lead | Product owner | Phase 1 tách feature | Không | Chốt (người dùng 2026-10-08) | `roadmap.md` R1A Scope; `priority-crosswalk.md` FR-R02..R09 |
| DEC-SF-03 | Tài khoản người đọc chỉ cấp tại quầy (Thủ thư/Quản trị viên tạo + kích hoạt); không tự đăng ký online. Trả lời OQ-03, khác mặc định nguồn; sửa value stream bước 2 của PRD | Decision | BA lead | Thủ thư trưởng | Phase 1 tách feature | Không | Chốt (người dùng 2026-10-08) | Nguồn FR-R01, OQ-03 |
| DEC-SF-04 | `account-admin`: Quản trị viên CRUD + xóa mềm tài khoản người đọc (FR-L05) và tài khoản Thủ thư (FR-L06) ở R0; Thủ thư sửa/khóa tạm người đọc (FR-S10) ở R1B. Quản lý tài khoản Quản trị viên vẫn mở | Decision | BA lead | Thủ thư trưởng + security/IT | Phase 1 tách feature | Có — OQ-account-admin-001 | Chốt (người dùng 2026-10-08) | Nguồn FR-L05/L06/S10; `priority-crosswalk.md` |
| DEC-SF-05 | Thêm FR backup/restore vào `ops-foundation` (R0): backup hằng ngày, giữ 30 bản; diễn tập restore là bằng chứng GATE-OPS | Decision | BA lead | Thủ thư trưởng + technical owner | SRS `ops-foundation` | Không | Chốt (người dùng 2026-10-08) | Nguồn NFR-07; `priority-crosswalk.md` dòng backup/restore |
| DEC-SF-06 | `lost-handling` 2 lát: ghi nhận mất tối thiểu P0/R1A (DEC-P2-07); tìm lại sau khi mất P1/R1B (DEC-D3-05) | Decision | BA lead | Thủ thư trưởng + Finance owner | SRS `lost-handling` | Không | Chốt (người dùng 2026-10-08) | DEC-P2-07, DEC-D3-05 |
| DEC-SF-07 | Tra cứu tách 2: phía Thủ thư/Quản trị viên ở `catalog-admin` (R0, phục vụ quản trị); phía Người đọc (FR-R02) ở `reader-self-service` (R1A) | Decision | BA lead | Product owner | Phase 1 tách feature | Không | Chốt (người dùng 2026-10-08) | FR-catalog-admin-002 / FR-reader-self-service-001; `priority-crosswalk.md` FR-R02 |
| DEC-SF-08 | Persona trong user story đổi theo bộ tên DEC-SF-01 khi chuyển sang feature | Decision | BA lead | — | Rollout từng feature | Không | Chốt (người dùng 2026-10-08) | story index |
| DEC-SF-09 | Thêm màn trung tâm thông báo (FR-C04) cho `notification-audit-ui`, R1B theo DEC-P2-01 | Decision | BA lead | Product owner | User-flow `notification-audit-ui` | Không | Chốt (người dùng 2026-10-08) | Nguồn FR-C04; DEC-P2-01 |
| DEC-SF-10 | Giá trị quy định mượn: tối đa 5 cuốn đang mượn, thời hạn mượn 14 ngày, nợ phạt từ 50.000đ trở lên thì chặn mượn. Trả lời một phần OQ-04 nguồn / `OQ-policy-config-001`; các giá trị gia hạn, phạt, giữ chỗ, SLA vẫn mở | Decision | BA lead | Thủ thư trưởng | Trước khi khóa SRS `checkout` | Không | Chốt (người dùng 2026-10-08) | Nguồn BR-01/03/04; `checkout-scope.md` OQ-1 |

## Feature bị ảnh hưởng

| Decision | Feature |
|---|---|
| DEC-D3-01 | copy-inventory, checkout, return-handling, damage-lifecycle, lost-handling, reservation |
| DEC-D3-02 | return-handling |
| DEC-D3-03 | reservation |
| DEC-D3-04 | fine-collection-basic, fine-collection-adv |
| DEC-D3-05 | lost-handling, fine-collection-adv |
| DEC-D3-06 | damage-lifecycle, reservation |
| DEC-D3-07 | damage-lifecycle, copy-inventory |
| DEC-D3-08 | fine-collection-adv, notification-core |
| DEC-D3-09 | catalog-admin, copy-inventory, checkout |
| DEC-P2-01 | notification-core, notification-audit-ui |
| DEC-P2-02 | overdue-fines, ops-reports, checkout |
| DEC-P2-03 | damage-lifecycle |
| DEC-P2-04 | fine-collection-basic, fine-collection-adv |
| DEC-P2-05 | reservation, return-handling, renewal |
| DEC-P2-06 | ops-foundation, notification-audit-ui |
| DEC-P2-07 | lost-handling |
| DEC-P2-08 | Mọi feature |
| DEC-P2-09 | data-import |
| DEC-SF-01 | Mọi feature |
| DEC-SF-02 | reader-self-service, renewal, reservation, expansion-candidates |
| DEC-SF-03 | reader-onboarding |
| DEC-SF-04 | account-admin |
| DEC-SF-05 | ops-foundation |
| DEC-SF-06 | lost-handling |
| DEC-SF-07 | catalog-admin, reader-self-service |
| DEC-SF-08 | Mọi feature có user story |
| DEC-SF-09 | notification-audit-ui |
| DEC-SF-10 | checkout, policy-config, return-handling, overdue-fines |
