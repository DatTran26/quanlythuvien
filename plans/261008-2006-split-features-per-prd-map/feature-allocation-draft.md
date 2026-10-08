# Ma trận phân bổ nháp — từ feature gộp sang 23 feature

Bản nháp đầu vào cho phase 1. Mọi dòng là **đề xuất**, phase 1 kiểm lại từng item với prose gốc và người dùng duyệt trước khi dùng. Nguồn: `docs/_product/prd.md` Mục 7, `srs/library-management-platform-spec.md`, `srs/library-management-platform-userflow.md` Mục 2–3, `usecases/`, `userstories/library-management-platform-story-index.md`.

Quy tắc phân bổ:

1. Mỗi item có **đúng một chủ**. Feature khác cần thì tham chiếu, không chép lại.
2. Item dùng bởi từ 2 feature trở lên và không có chủ tự nhiên → `docs/_shared/` (namespace tạm gọi `core`, chốt ở phase 0 bước 5).
3. Item bị chia theo release (một nửa R1A, một nửa R1B) → tách thành 2 item ở 2 feature, ghi nguồn chung trong bảng đối chiếu.
4. Mô hình miền (ERD, state machine, lifecycle) ở `docs/_shared/domain/` vì mọi entity đều được ít nhất 2 use case dùng (bảng CRUD trong `library-management-platform-usecase-index.md`).

## 1. Bảng 23 feature

| # | Slug | Release | FR nguồn (LMP) | UC nguồn | Flow (userflow) | Màn hình | US nguồn | Ghi chú |
|---|---|---|---|---|---|---|---|---|
| 1 | `access-control` | R0 | 006, 007 | uc-access-control | auth-flow | access-login, forgot-password, reset-password, dashboard-home, session-expired | US-001, US-002 | dashboard-home là điểm điều hướng chung → nội dung điều hướng sang `_shared/navigation-map.md` |
| 2 | `reader-onboarding` | R0 | 004 (phần cấp mới) | uc-reader-admin (phần tạo/kích hoạt) | reader-admin-flow (phần đầu) | reader-form | US-006 | Chỉ cấp tại quầy, không tự đăng ký online (DEC-SF-03) |
| 3 | `account-admin` | R0 + R1B | 004 (phần cập nhật/xóa mềm), 005 | uc-reader-admin (phần quản trị) | reader-admin-flow (phần sau) | reader-list, reader-detail | — | R0: Quản trị viên CRUD tài khoản người đọc + tài khoản Thủ thư (thêm FR từ FR-L05/L06); R1B: Thủ thư sửa/khóa tạm (DEC-SF-04) |
| 4 | `catalog-admin` | R0 | 001, 003 (phần tra cứu phía Thủ thư/Quản trị viên) | uc-catalog-admin (phần đầu sách) | catalog-admin-flow (phần đầu) | catalog-search, bibliographic-detail, bibliographic-form | US-003, US-005 | Tra cứu phía người đọc sang `reader-self-service` (DEC-SF-07) |
| 5 | `copy-inventory` | R0 | 002, 026 | uc-catalog-admin (phần bản sao) | catalog-admin-flow (phần sau) | copy-inventory, copy-form | US-004 | QR locator dùng lại ở checkout/return (tham chiếu) |
| 6 | `data-import` | R0 | 022 | uc-admin-import (phần import) | admin-import-flow (phần sau) | import-upload, import-report | US-008, US-009 | |
| 7 | `policy-config` | R0 | 021 | uc-admin-import (phần cấu hình) | admin-import-flow (phần đầu) | admin-config | US-007 | admin-config hiện cũng là cửa vào import → tách navigation |
| 8 | `ops-foundation` | R0 | 020 (phần ghi audit) | uc-notification-audit (phần audit capture) | — | — | US-010 | Thêm FR backup/restore: hằng ngày, giữ 30 bản, diễn tập restore cho GATE-OPS (DEC-SF-05) |
| 9 | `checkout` | R1A | 008, 009 | uc-checkout | checkout-flow | circulation-desk, checkout-scan, checkout-review, checkout-conflict | US-011 | Feature pilot (phase 4) |
| 10 | `return-handling` | R1A | 010 | uc-return-renewal (phần trả) | return-renewal-flow (phần trả) | return-scan, return-result | US-012 | Điểm quyết định D5 (có hàng chờ?) tham chiếu `reservation` |
| 11 | `overdue-fines` | R1A | 014 | uc-return-renewal (phần phạt), uc-fine-payment (assessment) | — | — | US-013 | Job hệ thống, không có màn riêng |
| 12 | `damage-lifecycle` | R1A | 017, 025 | uc-damage-lost-found (phần hư hỏng) | damage-lost-found-flow (phần đầu) | damage-report-form, damage-report-detail | US-015, US-016 | |
| 13 | `lost-handling` | R1A + R1B | 018 | uc-damage-lost-found (phần mất/tìm lại) | damage-lost-found-flow (phần sau) | lost-found | US-017 | Ghi nhận mất P0/R1A; tìm lại P1/R1B (DEC-SF-06) |
| 14 | `fine-collection-basic` | R1A | 015 (phần tiền mặt) | uc-fine-payment (phần thu) | fine-payment-flow (phần đầu) | fine-list, fine-detail, fine-payment | US-014 | |
| 15 | `reader-self-service` | R1A + R1B | 003 (phần người đọc), 024 (phần xem công nợ) | — (viết mới) | — (viết mới) | — (viết mới) | — | R1A/P0: tra cứu, thẻ QR, đang mượn, lịch sử (thêm FR từ FR-R02..R05); R1B/P1: xem công nợ (FR-R09). Portal đặt trước sang `reservation` (DEC-SF-02) |
| 16 | `notification-core` | R1A | 019 (phần tối thiểu) | uc-notification-audit (phần outbox) | notification-audit-flow (phần đầu) | notification-status | US-018 | |
| 17 | `ops-reports` | R1A | 023 (RP-01/02/04) | — | reports-flow | report-dashboard | — | OQ-LMP-017 quyền xem của Thủ thư |
| 18 | `renewal` | R1B | 011 | uc-return-renewal (phần gia hạn) | return-renewal-flow (phần gia hạn) | renewal-result | — | Gồm cả gia hạn tại quầy và gia hạn online của người đọc (DEC-SF-02); chưa có story |
| 19 | `fine-collection-adv` | R1B | 015 (phần biên nhận), 016 | uc-fine-payment (phần nâng cao) | fine-payment-flow (phần sau) | financial-events | — | Chưa có story |
| 20 | `notification-audit-ui` | R1B | 019 (trung tâm thông báo), 020 (audit viewer), 027 | uc-notification-audit (phần xem) | notification-audit-flow (phần sau) | audit-log, history-timeline, + màn trung tâm thông báo (mới) | — | Màn trung tâm thông báo theo FR-C04 (DEC-SF-09) |
| 21 | `reservation` | R2 | 012, 013, 024 (phần đặt/hủy trên portal) | uc-reservation | reservation-flow | reservation-search, reservation-form, reservation-queue, reservation-pickup | — | Gồm cả đặt trước online của người đọc (DEC-SF-02); chưa có story |
| 22 | `trend-reports` | R2 | 023 (RP-03/05/06/07) | — | reports-flow (dataset R2) | report-dashboard (trạng thái R2, chủ là `ops-reports`) | — | |
| 23 | `expansion-candidates` | R3 | 028 | — | — | — | — | Chỉ PRD envelope + brainstorm, không SRS |

## 2. Requirement khác FR

### NFR

| Nguồn | Đích |
|---|---|
| NFR-LMP-001, 003, 004, 005, 006, 008, 009, 010, 012 | `docs/_shared/core-spec.md` |
| NFR-LMP-002 (tra cứu ≤2s) | `catalog-admin` |
| NFR-LMP-007 (outbox retry) | `notification-core` |
| NFR-LMP-011 (import dry-run) | `data-import` |

### Business Rule

| Nguồn | Đích | Lý do |
|---|---|---|
| BR-LMP-001, 002 | `checkout` | 002 được `reservation` tham chiếu |
| BR-LMP-003 (điều kiện người đọc) | `_shared` | Dùng bởi `checkout` + `renewal` |
| BR-LMP-004 | `renewal` | |
| BR-LMP-005, 006 | `reservation` | |
| BR-LMP-007 (ledger append-only) | `_shared` | Dùng bởi 4 feature tài chính |
| BR-LMP-008 | `fine-collection-basic` | |
| BR-LMP-009, 012 | `damage-lifecycle` | |
| BR-LMP-010 | `lost-handling` | |
| BR-LMP-011 | `copy-inventory` | |
| BR-LMP-013, 015, 016, 017 | `_shared` | Audit, quyền field, notification không chặn giao dịch, xóa mềm — xuyên hệ thống |
| BR-LMP-014 | `data-import` | |

### Error

| Nguồn | Đích |
|---|---|
| E-LMP-001, 002, 003, 005, 006, 007, 013, 015, 016 | `_shared` (lỗi chung) |
| E-LMP-004 | `checkout` |
| E-LMP-008 | `reservation` |
| E-LMP-009, 010 | `fine-collection-basic` |
| E-LMP-011 | `damage-lifecycle` |
| E-LMP-012, 018 | `notification-core` |
| E-LMP-014 | `data-import` |
| E-LMP-017 | `access-control` |

### Success Criteria

| Nguồn | Đích |
|---|---|
| SC-LMP-01 | Tách: `checkout` (mượn) + `return-handling` (trả) |
| SC-LMP-02 | `checkout` |
| SC-LMP-03 | `reservation` |
| SC-LMP-04 | `overdue-fines` |
| SC-LMP-05 | `notification-core` |
| SC-LMP-06 | `ops-foundation` |
| SC-LMP-07 | `data-import` |

### Open Question (spec)

| Nguồn | Đích |
|---|---|
| OQ-LMP-001 (ai phê duyệt) | `docs/_product/decision-register.md` (cấp sản phẩm) |
| OQ-LMP-002, 018 | `data-import` |
| OQ-LMP-003 | `reservation` |
| OQ-LMP-004, 006, 011, 012 | `_shared` |
| OQ-LMP-005, 009 | `fine-collection-adv` |
| OQ-LMP-007 | `access-control` |
| OQ-LMP-008 | `notification-core` |
| OQ-LMP-010 | `policy-config` |
| OQ-LMP-013 | `damage-lifecycle` |
| OQ-LMP-014 | `account-admin` |
| OQ-LMP-015, 016 | `reader-self-service` |
| OQ-LMP-017 | `ops-reports` |

OQ của userflow, ERD, flows, states, use case và story đi theo chủ của section chứa chúng. Câu trùng nhau (vd OQ-LMP-015 ở cả spec và userflow) gộp về một chủ.

## 3. Artifact dùng chung chuyển vào `docs/_shared/`

| Nguồn | Đích | Ghi chú |
|---|---|---|
| `srs/library-management-platform-erd.md` | `docs/_shared/domain/library-erd.md` | 14 entity, canonical |
| `srs/library-management-platform-states.md` | `docs/_shared/domain/library-states.md` | Copy, Loan, Reservation, Fine, DamageReport |
| `domain/lifecycle-inventory.md` | `docs/_shared/domain/lifecycle-inventory.md` | Giữ nguyên ID transition `COPY-T00..` |
| `srs/…-spec.md` Mục 0, 2, NFR/BR/E chung, Mục 11 | `docs/_shared/core-spec.md` | Actors + mapping vai trò, ràng buộc, phụ thuộc, giả định chung |
| `srs/…-flows.md` Mục 0 (invariant) | `docs/_shared/core-spec.md` | |
| `srs/…-userflow.md` Mục 3.5 phần chuyển màn giữa feature | `docs/_shared/navigation-map.md` | Chuyển màn trong cùng feature ở lại feature |
| `test/test-strategy.md` phần bền (môi trường, dữ liệu, thiết bị) | `docs/_shared/test-strategy-baseline.md` | Phần per-run sang từng feature |
| `brainstorms/product-roadmap-baseline.md` | `docs/_product/product-roadmap-baseline.md` | Đây là brainstorm cấp sản phẩm, không phải của feature nào |

## 4. Xung đột — đã quyết (2026-10-08)

Quyết định ghi tại `docs/_product/decision-register.md` mục "Quyết định tách feature". Bảng Mục 1 đã cập nhật theo.

| # | Xung đột | Quyết định | DEC |
|---|---|---|---|
| X1 | `reader-self-service` lệch release giữa PRD và SRS | Theo roadmap: R1A/P0 tra cứu, thẻ QR, đang mượn, lịch sử; R1B/P1 xem công nợ; gia hạn online thuộc `renewal`, đặt trước online thuộc `reservation` | DEC-SF-02 |
| X2 | Tự đăng ký online có hay không | Không. Tài khoản người đọc chỉ cấp tại quầy (khác mặc định OQ-03 của nguồn); PRD value stream bước 2 sửa ở phase 3 | DEC-SF-03 |
| X3 | Phạm vi `account-admin` | R0: Quản trị viên CRUD + xóa mềm tài khoản người đọc và tài khoản Thủ thư; R1B: Thủ thư sửa/khóa tạm người đọc. Quản lý tài khoản Quản trị viên vẫn mở (OQ-LMP-014) | DEC-SF-04 |
| X4 | Backup/restore không có FR | Thêm FR vào `ops-foundation` R0: hằng ngày, giữ 30 bản, diễn tập restore cho GATE-OPS | DEC-SF-05 |
| X5 | Priority `lost-handling` | 2 lát: ghi nhận mất P0/R1A, tìm lại P1/R1B | DEC-SF-06 |
| X6 | Release của tra cứu | Tra cứu phía Thủ thư/Quản trị viên ở `catalog-admin` R0; phía Người đọc ở `reader-self-service` R1A | DEC-SF-07 |
| X7 | Bộ tên vai trò | **Theo SRS**: Người đọc / Thủ thư (trực quầy, nguồn gọi "Nhân viên") / Quản trị viên (nguồn gọi "Thủ thư"); Thủ thư trưởng giữ nguyên. `project-profile.md` đã cập nhật; PRD, roadmap, priority-crosswalk đổi ở phase 3 | DEC-SF-01 |
| X8 | Persona trong story | Đổi theo DEC-SF-01 khi chuyển story | DEC-SF-08 |
| X9 | Thiếu màn trung tâm thông báo | Thêm cho `notification-audit-ui`, R1B | DEC-SF-09 |

### Hệ quả cần làm ở các phase sau

- Phase 3: sửa PRD (cột Persona, value stream bước 2, release/priority dòng `reader-self-service`, `account-admin`, `lost-handling`), roadmap và priority-crosswalk theo DEC-SF-01..07. Lưu ý trong tài liệu nguồn `he_thong_quan_ly_thu_vien.md` "Thủ thư" mang nghĩa Quản trị viên — khi trích nguồn phải ghi theo mapping DEC-SF-01.
- Phase 5: `account-admin` thêm FR cho tài khoản Thủ thư (từ FR-L06); `ops-foundation` thêm FR backup/restore; `reader-onboarding` bỏ luồng tự đăng ký.
- Phase 6: `reader-self-service` thêm FR thẻ QR, đang mượn, lịch sử (từ FR-R03..R05) — SRS hiện chưa có các FR này.
- Phase 7: `notification-audit-ui` thêm màn trung tâm thông báo.
