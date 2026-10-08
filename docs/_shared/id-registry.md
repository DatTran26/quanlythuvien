---
type: id-registry
status: draft
updated: 2026-10-08
links:
  - docs/_shared/project-profile.md
  - docs/_product/decision-register.md
  - docs/features/library-management-platform/srs/library-management-platform-spec.md
---

# ID Registry — QuanLyThuVIen

> Mục đích: chống va chạm namespace trước khi sinh artifact hạ nguồn (Phase 4–8). Mọi ID mới phải đăng ký ở đây. ID đã phát hành trong tài liệu `approved` không được tái sử dụng — retire, không xoá.

## 1. Namespace đang dùng

| Namespace | Pattern | Phạm vi đã cấp | Owner artifact | Ghi chú |
|---|---|---|---|---|
| Open Question (nguồn gốc) | `OQ-NN` (2 chữ số) | `OQ-01`…`OQ-15` | `docs/he_thong_quan_ly_thu_vien.md`, `docs/_product/prd.md` §OQ | Giữ nguyên ngữ nghĩa gốc; không renumber |
| Open Question (brainstorm) | `OQ-BS-N` | `OQ-BS-1`, `OQ-BS-2`, `OQ-BS-3` | `brainstorms/product-roadmap-baseline.md` | Alias: văn bản cũ ghi `OQ-N` / `OQ brainstorm-N` → xem §2 |
| Open Question (SRS) | `OQ-LMP-NNN` | `OQ-LMP-001`…`OQ-LMP-018` | `srs/library-management-platform-spec.md` §12 | Sẽ retired sau phase 8 tách feature — tra mã mới ở `id-crosswalk-lmp.md` |
| Open Question (gap mới) | `GAP-OQ-NN` | chưa cấp | phase hiện hành | Dùng cho gap phát hiện sau baseline (phase-01 step 4) |
| Decision (phase 3 domain) | `DEC-D3-NN` | `DEC-D3-01`…`DEC-D3-09` | `docs/_product/decision-register.md` | Reconstruction + domain rule, chờ domain approver |
| Decision (phase 2 priority) | `DEC-P2-NN` | `DEC-P2-01`…`DEC-P2-09` | `docs/_product/decision-register.md` | Release boundary + priority crosswalk |
| Decision (tách feature) | `DEC-SF-NN` | `DEC-SF-01`…`DEC-SF-09` | `docs/_product/decision-register.md` | Giải xung đột khi tách 23 feature |
| Requirement theo feature | `{FR,NFR,BR,E}-{feature}-NNN`, `SC-{feature}-NN`, `OQ-{feature}-NNN`, `CHK-{feature}-NNN` | xem `id-crosswalk-lmp.md` | `docs/features/{feature}/` | Thay series `*-LMP-*` |
| Requirement dùng chung | `{NFR,BR,E,OQ,CHK}-core-NNN` | xem `id-crosswalk-lmp.md` | `docs/_shared/core-spec.md` | KG đã kiểm nhận được (spike 2026-10-08) |
| Decision (mới) | `DEC-<PHASE>-NN` | — | `decision-register.md` | `<PHASE>` = mã phase 2 ký tự sinh decision (D3, P2…) |
| Functional Req (nguồn) | `FR-<AREA>NN` | `FR-C01..C04`, `FR-R01..R09`, `FR-L01..L10`, `FR-S01..S11` | `docs/he_thong_quan_ly_thu_vien.md` | C=common, R=reader, L=librarian, S=staff; xem crosswalk §3 |
| Functional Req (SRS) | `FR-LMP-NNN` | `FR-LMP-001`…`FR-LMP-028` | SRS §3 | Sẽ retired sau phase 8 tách feature — tra mã mới ở `id-crosswalk-lmp.md` |
| Business Rule (nguồn) | `BR-NN` | `BR-01`…`BR-13` | `docs/he_thong_quan_ly_thu_vien.md` | Giá trị thật chờ OQ-04 |
| Business Rule (SRS) | `BR-LMP-NNN` | `BR-LMP-001`…`BR-LMP-017` | SRS §5 | Crosswalk với BR-NN ở §3. Sẽ retired sau phase 8 tách feature — tra mã mới ở `id-crosswalk-lmp.md` |
| Non-Functional Req (nguồn) | `NFR-NN` | `NFR-01`…`NFR-08` | `docs/he_thong_quan_ly_thu_vien.md`, roadmap | — |
| Non-Functional Req (SRS) | `NFR-LMP-NNN` | `NFR-LMP-001`…`NFR-LMP-012` | SRS §4 | Sẽ retired sau phase 8 tách feature — tra mã mới ở `id-crosswalk-lmp.md` |
| Error | `E-LMP-NNN` | `E-LMP-001`…`E-LMP-018` | SRS §6 | Sẽ retired sau phase 8 tách feature — tra mã mới ở `id-crosswalk-lmp.md` |
| Success Criteria | `SC-LMP-NN` | `SC-LMP-01`…`SC-LMP-07` | SRS §7 | Sẽ retired sau phase 8 tách feature — tra mã mới ở `id-crosswalk-lmp.md` |
| Capability | `CAP-<NAME>` | IDENT, ACCT, CATALOG, IMPORT, POLICY, AUDIT, OPS, CIRC, OVERDUE, FINE, DAMAGE, READER, NOTIFY, REPORT, RENEW, RESERVE; R3 candidates: ATTEND, PAY, BRANCH, OFFLINE, MSGALT | `docs/_product/roadmap.md`, `priority-crosswalk.md` | Candidate R3 không cam kết |
| Release | `R<N>` | `R0`, `R1A`, `R1B`, `R2`, `R3` | `docs/_product/roadmap.md` | Chuẩn duy nhất — DEC-P2-08; SRS cũ `R1/R2/Later` đã remap |
| Readiness Gate | `GATE-<NAME>` | DEC, MIG, UAT, OPS, TRN, PILOT, GNG | `docs/_product/readiness-gates.md` | GATE-GNG non-waivable |
| Report | `RP-NN` | `RP-01`…`RP-08` | `docs/he_thong_quan_ly_thu_vien.md` | — |
| State transition | `<AGG>-TNN` | `COPY-T00..T19`, `LOAN-T01..T05`, `RES-T01..T06`, `DMG-T01..T04` | `domain/lifecycle-inventory.md` | PROPOSAL — DEC-D3-01/02 |
| Flow decision point | `D<N>` | `D5` (return flow: có hàng chờ?) | `lifecycle-inventory.md` | Đánh số theo thứ tự xuất hiện trong flow |
| Use Case | `uc-<slug>` | `uc-access-control`…`uc-admin-import` (10) | `usecases/library-management-platform-usecase-index.md` | Slug = tên file |
| Screen | `<slug>` kebab | screen names trong UC index / SRS §10 | Phase 5 output | Chưa có registry riêng; cấp khi wireframe |

## 2. Alias / migration table

| Cách ghi cũ / mơ hồ | Canonical | Nơi sửa / ghi chú |
|---|---|---|
| `OQ-1`, `OQ-2`, `OQ-3` (trong `product-roadmap-baseline.md`) | `OQ-BS-1`, `OQ-BS-2`, `OQ-BS-3` | Đã chú thích canonical tại chỗ; KHÔNG trùng `OQ-01..OQ-03` của tài liệu gốc |
| `OQ brainstorm-1`, `OQ brainstorm-3` (trong `prd.md`) | `OQ-BS-1`, `OQ-BS-3` | Alias văn xuôi của cùng câu hỏi |
| `R1`, `R2`, `Later` (SRS cũ) | `R0`, `R1A`, `R1B`, `R2`, `R3` | DEC-P2-08 — SRS đã remap; artifact mới chỉ dùng R0–R3 |
| `FR-Cnn/Rnn/Lnn/Snn` | Giữ nguyên (series nguồn) | Map sang `FR-LMP-nnn` trong traceability Phase 6/8 — một FR-LMP có thể cover nhiều FR nguồn |
| `P0-PROPOSAL` (release của Reservation) | `R2` | DEC-P2-05: single release owner |

## 3. Crosswalk quy tắc nguồn → SRS

- `FR-<AREA>NN` (nguồn) ↔ `FR-LMP-NNN` (SRS): không phải 1:1. Bảng ánh xạ chính thức sinh ở Phase 6/8 traceability; tạm thời tham chiếu qua cột "Covers FR" của UC index.
- `BR-NN` (nguồn) ↔ `BR-LMP-NNN`: khác thứ tự — `BR-LMP` là rule đã chuẩn hoá, `BR-NN` trỏ tham số cấu hình (OQ-04).
- `NFR-NN` (nguồn, 01–08) ↔ `NFR-LMP-NNN` (SRS, 001–012): ánh xạ ghi trong cột Source/Acceptance của SRS §4 khi cần.

## 4. Quy tắc cấp và retire

1. ID mới lấy số tiếp theo trong series của owner artifact; ghi vào registry trước khi dùng.
2. ID đã xuất hiện trong artifact `approved` là immutable: sai thì tạo ID mới + ghi `retired → <ID mới>` vào alias table, không xoá dòng.
3. Không cấp ID cho nội dung chưa qua gate của phase sở hữu (hard-stop: identity/privacy/finance/release boundary).
4. Mọi OQ mới sau baseline dùng `GAP-OQ-NN` hoặc `OQ-LMP-NNN` tiếp theo — tuyệt đối không dùng `OQ-NN` trần (va chạm series nguồn).
5. Slug `uc-*`, screen, plan folder (`YYMMDD-HHMM-<slug>`) là immutable sau khi file được commit.
