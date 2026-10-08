---
type: id-crosswalk
status: draft
updated: 2026-10-08
links:
  - docs/_shared/id-registry.md
  - docs/_product/decision-register.md
  - docs/features/library-management-platform/srs/library-management-platform-spec.md
---

# Bảng đối chiếu mã LMP → mã theo feature

Mỗi dòng ánh xạ một item của feature gộp `library-management-platform` sang đúng một đích (feature hoặc phần dùng chung) và một mã mới, theo quyết định DEC-SF-01..09 trong `docs/_product/decision-register.md`. Mã `*-LMP-*` sẽ retired sau khi tách xong; bảng này là nơi duy nhất còn giữ chúng.

Cách đọc:

- **Phần**: mã LMP bị tách cho nhiều feature hoặc nhiều release thì mỗi phần một dòng (`a`, `b`…). Trống = không tách.
- **Đích `core`**: phần dùng chung, sống ở `docs/_shared/core-spec.md` (NFR/BR/E/OQ) hoặc `docs/_shared/domain/` (entity, state machine, transition).
- **Đã chuyển**: điền phase khi item đã có mặt ở file đích với mã mới. Trống = chưa chuyển.
- Nguồn ghi theo đường dẫn tương đối trong `docs/features/library-management-platform/`.

## 1. Functional Requirement

| Mã LMP | Phần | Đích | Mã mới | Nội dung phần | Release | Priority | Quyết định / ghi chú | Nguồn | Đã chuyển |
|---|---|---|---|---|---|---|---|---|---|
| FR-LMP-001 |  | `catalog-admin` | `FR-catalog-admin-001` | Quản lý danh mục sách | R0 | P0 |  | `srs/library-management-platform-spec.md:75` | SRS (2026-10-08) |
| FR-LMP-002 |  | `copy-inventory` | `FR-copy-inventory-001` | Quản lý bản sao sách | R0 | P0 |  | `srs/library-management-platform-spec.md:76` | SRS (2026-10-08) |
| FR-LMP-003 | a | `catalog-admin` | `FR-catalog-admin-002` | Tra cứu khả dụng phía Thủ thư/Quản trị viên | R0 | P0 | DEC-SF-07 | `srs/library-management-platform-spec.md:77` | SRS (2026-10-08) |
| FR-LMP-003 | b | `reader-self-service` | `FR-reader-self-service-001` | Tra cứu sách phía Người đọc (FR-R02) | R1A | P0 | DEC-SF-07 | `srs/library-management-platform-spec.md:77` | SRS (2026-10-08) |
| FR-LMP-004 | a | `reader-onboarding` | `FR-reader-onboarding-001` | Cấp mới và kích hoạt tài khoản người đọc tại quầy | R0 | P0 | DEC-SF-03 | `srs/library-management-platform-spec.md:78` | SRS (2026-10-08) |
| FR-LMP-004 | b | `account-admin` | `FR-account-admin-001` | Cập nhật, xóa mềm tài khoản người đọc (FR-L05) | R0 | P0 | DEC-SF-04 | `srs/library-management-platform-spec.md:78` | SRS (2026-10-08) |
| FR-LMP-005 |  | `account-admin` | `FR-account-admin-002` | Thủ thư sửa/khóa tạm, mở lại người đọc (FR-S10) | R1B | P1 | DEC-SF-04 | `srs/library-management-platform-spec.md:79` | SRS (2026-10-08) |
| FR-LMP-006 |  | `access-control` | `FR-access-control-001` | Đăng nhập và phân quyền | R0 | P0 |  | `srs/library-management-platform-spec.md:80` | SRS (2026-10-08) |
| FR-LMP-007 |  | `access-control` | `FR-access-control-002` | Step-up và session reset | R0 | P0 |  | `srs/library-management-platform-spec.md:81` | SRS (2026-10-08) |
| FR-LMP-008 |  | `checkout` | `FR-checkout-001` | Mượn nhiều bản sao nguyên tử | R1A | P0 |  | `srs/library-management-platform-spec.md:82` | SRS (2026-10-08) |
| FR-LMP-009 |  | `checkout` | `FR-checkout-002` | Idempotency và concurrency mượn | R1A | P0 |  | `srs/library-management-platform-spec.md:83` | SRS (2026-10-08) |
| FR-LMP-010 |  | `return-handling` | `FR-return-handling-001` | Trả sách | R1A | P0 |  | `srs/library-management-platform-spec.md:84` | SRS (2026-10-08) |
| FR-LMP-011 |  | `renewal` | `FR-renewal-001` | Gia hạn tại quầy và gia hạn online | R1B | P1 | DEC-SF-02 | `srs/library-management-platform-spec.md:85` | SRS (2026-10-08) |
| FR-LMP-012 |  | `reservation` | `FR-reservation-001` | Đặt trước và hàng đợi | R2 | P1 |  | `srs/library-management-platform-spec.md:86` | SRS (2026-10-08) |
| FR-LMP-013 |  | `reservation` | `FR-reservation-002` | Hết hạn giữ chỗ | R2 | P1 |  | `srs/library-management-platform-spec.md:87` | SRS (2026-10-08) |
| FR-LMP-014 |  | `overdue-fines` | `FR-overdue-fines-001` | Ghi nhận tiền phạt | R1A | P0 |  | `srs/library-management-platform-spec.md:88` | SRS (2026-10-08) |
| FR-LMP-015 | a | `fine-collection-basic` | `FR-fine-collection-basic-001` | Thu tiền mặt tối thiểu, idempotent | R1A | P0 | DEC-P2-04 | `srs/library-management-platform-spec.md:89` | SRS (2026-10-08) |
| FR-LMP-015 | b | `fine-collection-adv` | `FR-fine-collection-adv-001` | Biên nhận đầy đủ | R1B | P1 | DEC-P2-04 | `srs/library-management-platform-spec.md:89` | SRS (2026-10-08) |
| FR-LMP-016 |  | `fine-collection-adv` | `FR-fine-collection-adv-002` | Miễn/điều chỉnh/hoàn tiền | R1B | P1 |  | `srs/library-management-platform-spec.md:90` | SRS (2026-10-08) |
| FR-LMP-017 |  | `damage-lifecycle` | `FR-damage-lifecycle-001` | Báo cáo hư hỏng | R1A | P0 |  | `srs/library-management-platform-spec.md:91` | SRS (2026-10-08) |
| FR-LMP-018 | a | `lost-handling` | `FR-lost-handling-001` | Ghi nhận mất + nghĩa vụ bồi thường tối thiểu | R1A | P0 | DEC-SF-06 | `srs/library-management-platform-spec.md:92` | SRS (2026-10-08) |
| FR-LMP-018 | b | `lost-handling` | `FR-lost-handling-002` | Tìm lại sau khi mất + đối soát nghĩa vụ | R1B | P1 | DEC-SF-06 | `srs/library-management-platform-spec.md:92` | SRS (2026-10-08) |
| FR-LMP-019 | a | `notification-core` | `FR-notification-core-001` | Outbox bền + in-app/email sự kiện quan trọng | R1A | P0 | DEC-P2-01 | `srs/library-management-platform-spec.md:93` | SRS (2026-10-08) |
| FR-LMP-019 | b | `notification-audit-ui` | `FR-notification-audit-ui-001` | Trung tâm thông báo (FR-C04) | R1B | P1 | DEC-SF-09 | `srs/library-management-platform-spec.md:93` | SRS (2026-10-08) |
| FR-LMP-020 | a | `ops-foundation` | `FR-ops-foundation-001` | Ghi audit cùng transaction | R0 | P0 | DEC-P2-06 | `srs/library-management-platform-spec.md:94` | SRS (2026-10-08) |
| FR-LMP-020 | b | `notification-audit-ui` | `FR-notification-audit-ui-002` | Audit viewer (FR-L10) | R1B | P1 | DEC-P2-06 | `srs/library-management-platform-spec.md:94` | SRS (2026-10-08) |
| FR-LMP-021 |  | `policy-config` | `FR-policy-config-001` | Quản trị cấu hình nghiệp vụ | R0 | P0 |  | `srs/library-management-platform-spec.md:95` | SRS (2026-10-08) |
| FR-LMP-022 |  | `data-import` | `FR-data-import-001` | Import và đối soát | R0 | P0 |  | `srs/library-management-platform-spec.md:96` | SRS (2026-10-08) |
| FR-LMP-023 | a | `ops-reports` | `FR-ops-reports-001` | Báo cáo vận hành RP-01/02/04 | R1A | P0 (PRD) / P1 (SRS cũ) | Cần chốt ở phase 3 | `srs/library-management-platform-spec.md:97` | SRS (2026-10-08) |
| FR-LMP-023 | b | `trend-reports` | `FR-trend-reports-001` | Báo cáo xu hướng RP-03/05/06/07 | R2 | P1 |  | `srs/library-management-platform-spec.md:97` | SRS (2026-10-08) |
| FR-LMP-024 | a | `reader-self-service` | `FR-reader-self-service-002` | Xem khoản đang mượn (FR-R04) | R1A | P0 | DEC-SF-02 | `srs/library-management-platform-spec.md:98` | SRS (2026-10-08) |
| FR-LMP-024 | b | `reader-self-service` | `FR-reader-self-service-003` | Xem công nợ (FR-R09) | R1B | P1 | DEC-SF-02 | `srs/library-management-platform-spec.md:98` | SRS (2026-10-08) |
| FR-LMP-024 | c | `reservation` | `FR-reservation-003` | Đặt/hủy đặt trước trên cổng Người đọc (FR-R07/R08) | R2 | P1 | DEC-SF-02 | `srs/library-management-platform-spec.md:98` | SRS (2026-10-08) |
| FR-LMP-024 | d | `expansion-candidates` | `FR-expansion-candidates-001` | Thanh toán online (OQ-08 nguồn) | R3 | P2 | DEC-SF-02 | `srs/library-management-platform-spec.md:98` | SRS (2026-10-08) |
| FR-LMP-025 |  | `damage-lifecycle` | `FR-damage-lifecycle-002` | Quản lý ảnh bằng chứng | R1A | P1 |  | `srs/library-management-platform-spec.md:99` | SRS (2026-10-08) |
| FR-LMP-026 |  | `copy-inventory` | `FR-copy-inventory-002` | QR/barcode locator | R0 | P0 |  | `srs/library-management-platform-spec.md:100` | SRS (2026-10-08) |
| FR-LMP-027 |  | `notification-audit-ui` | `FR-notification-audit-ui-003` | Truy vết lịch sử nghiệp vụ | R1B | P1 |  | `srs/library-management-platform-spec.md:101` | SRS (2026-10-08) |
| FR-LMP-028 |  | `expansion-candidates` | `FR-expansion-candidates-002` | Phân tích nâng cao | R3 | P2 |  | `srs/library-management-platform-spec.md:102` | SRS (2026-10-08) |
| — (mới) |  | `reader-self-service` | `FR-reader-self-service-004` | Thẻ thư viện QR (FR-R03) | R1A | P0 | DEC-SF-02 — SRS cũ thiếu | Nguồn `he_thong_quan_ly_thu_vien.md` | SRS (2026-10-08) |
| — (mới) |  | `reader-self-service` | `FR-reader-self-service-005` | Lịch sử mượn (FR-R05) | R1A | P0 | DEC-SF-02 — SRS cũ thiếu | Nguồn `he_thong_quan_ly_thu_vien.md` | SRS (2026-10-08) |
| — (mới) |  | `account-admin` | `FR-account-admin-003` | Quản lý tài khoản Thủ thư (FR-L06) | R0 | P0 | DEC-SF-04 — SRS cũ thiếu | Nguồn `he_thong_quan_ly_thu_vien.md` | SRS (2026-10-08) |
| — (mới) |  | `ops-foundation` | `FR-ops-foundation-002` | Backup hằng ngày giữ 30 bản + diễn tập restore (NFR-07) | R0 | P0 | DEC-SF-05 — SRS cũ thiếu | Nguồn `he_thong_quan_ly_thu_vien.md` | SRS (2026-10-08) |
| — (mới) |  | `access-control` | `FR-access-control-003` | Quên và đặt lại mật khẩu | R0 | P0 | SRS Tầng 1 thêm — nguồn SRC-FR-C02 | Nguồn tài liệu hệ thống | SRS (2026-10-08) |
| — (mới) |  | `access-control` | `FR-access-control-004` | Hồ sơ cá nhân | R0 | P0 | SRS Tầng 1 thêm — nguồn SRC-FR-C03 | Nguồn tài liệu hệ thống | SRS (2026-10-08) |
| — (mới) |  | `access-control` | `FR-access-control-005` | Khóa tạm khi đăng nhập sai | R0 | P0 | SRS Tầng 1 thêm — uc-access-control ext 2b | Nguồn tài liệu hệ thống | SRS (2026-10-08) |
| — (mới) |  | `catalog-admin` | `FR-catalog-admin-003` | Quản lý danh mục | R0 | P0 | SRS Tầng 1 thêm — nguồn SRC-FR-L04 | Nguồn tài liệu hệ thống | SRS (2026-10-08) |
| — (mới) |  | `copy-inventory` | `FR-copy-inventory-003` | Sinh QR hàng loạt và in nhãn | R0 | P0 | SRS Tầng 1 thêm — nguồn SRC-FR-L03 | Nguồn tài liệu hệ thống | SRS (2026-10-08) |
| — (mới) |  | `checkout` | `FR-checkout-003` | In biên nhận mượn | R1A | P0 | SRS Tầng 1 thêm — brainstorm checkout OQ-2 | Brainstorm checkout | SRS (2026-10-08) |
| — (mới) |  | `ops-reports` | `FR-ops-reports-002` | Danh sách quá hạn cho Thủ thư | R1B | P1 | SRS Tầng 1 thêm — nguồn SRC-FR-S09 | Nguồn tài liệu hệ thống | SRS (2026-10-08) |
| — (mới) |  | `fine-collection-adv` | `FR-fine-collection-adv-003` | Đối soát thu ngân cuối ca | R1B | P1 | SRS Tầng 1 thêm — DEC-D3-08 | uc-fine-payment ext 6a (cũ) | SRS (2026-10-08) |

## 2. Non-Functional Requirement

| Mã LMP | Đích | Mã mới | Ghi chú | Nguồn | Đã chuyển |
|---|---|---|---|---|---|
| NFR-LMP-001 | `core` | `NFR-core-001` |  | `srs/library-management-platform-spec.md:108` || phase 2 |
| NFR-LMP-002 | `catalog-admin` | `NFR-catalog-admin-001` |  | `srs/library-management-platform-spec.md:109` | SRS (2026-10-08) |
| NFR-LMP-003 | `core` | `NFR-core-002` |  | `srs/library-management-platform-spec.md:110` || phase 2 |
| NFR-LMP-004 | `core` | `NFR-core-003` |  | `srs/library-management-platform-spec.md:111` || phase 2 |
| NFR-LMP-005 | `core` | `NFR-core-004` |  | `srs/library-management-platform-spec.md:112` || phase 2 |
| NFR-LMP-006 | `core` | `NFR-core-005` |  | `srs/library-management-platform-spec.md:113` || phase 2 |
| NFR-LMP-007 | `notification-core` | `NFR-notification-core-001` |  | `srs/library-management-platform-spec.md:114` | SRS (2026-10-08) |
| NFR-LMP-008 | `core` | `NFR-core-006` |  | `srs/library-management-platform-spec.md:115` || phase 2 |
| NFR-LMP-009 | `core` | `NFR-core-007` |  | `srs/library-management-platform-spec.md:116` || phase 2 |
| NFR-LMP-010 | `core` | `NFR-core-008` |  | `srs/library-management-platform-spec.md:117` || phase 2 |
| NFR-LMP-011 | `data-import` | `NFR-data-import-001` |  | `srs/library-management-platform-spec.md:118` | SRS (2026-10-08) |
| NFR-LMP-012 | `core` | `NFR-core-009` |  | `srs/library-management-platform-spec.md:119` || phase 2 |

## 3. Business Rule

| Mã LMP | Đích | Mã mới | Ghi chú | Nguồn | Đã chuyển |
|---|---|---|---|---|---|
| BR-LMP-001 | `checkout` | `BR-checkout-001` |  | `srs/library-management-platform-spec.md:125` | SRS (2026-10-08) |
| BR-LMP-002 | `checkout` | `BR-checkout-002` |  | `srs/library-management-platform-spec.md:126` | SRS (2026-10-08) |
| BR-LMP-003 | `core` | `BR-core-001` |  | `srs/library-management-platform-spec.md:127` || phase 2 |
| BR-LMP-004 | `renewal` | `BR-renewal-001` |  | `srs/library-management-platform-spec.md:128` | SRS (2026-10-08) |
| BR-LMP-005 | `reservation` | `BR-reservation-001` |  | `srs/library-management-platform-spec.md:129` | SRS (2026-10-08) |
| BR-LMP-006 | `reservation` | `BR-reservation-002` |  | `srs/library-management-platform-spec.md:130` | SRS (2026-10-08) |
| BR-LMP-007 | `core` | `BR-core-002` |  | `srs/library-management-platform-spec.md:131` || phase 2 |
| BR-LMP-008 | `fine-collection-basic` | `BR-fine-collection-basic-001` |  | `srs/library-management-platform-spec.md:132` | SRS (2026-10-08) |
| BR-LMP-009 | `damage-lifecycle` | `BR-damage-lifecycle-001` |  | `srs/library-management-platform-spec.md:133` | SRS (2026-10-08) |
| BR-LMP-010 | `lost-handling` | `BR-lost-handling-001` |  | `srs/library-management-platform-spec.md:134` | SRS (2026-10-08) |
| BR-LMP-011 | `copy-inventory` | `BR-copy-inventory-001` |  | `srs/library-management-platform-spec.md:135` | SRS (2026-10-08) |
| BR-LMP-012 | `damage-lifecycle` | `BR-damage-lifecycle-002` |  | `srs/library-management-platform-spec.md:136` | SRS (2026-10-08) |
| BR-LMP-013 | `core` | `BR-core-003` |  | `srs/library-management-platform-spec.md:137` || phase 2 |
| BR-LMP-014 | `data-import` | `BR-data-import-001` |  | `srs/library-management-platform-spec.md:138` | SRS (2026-10-08) |
| BR-LMP-015 | `core` | `BR-core-004` |  | `srs/library-management-platform-spec.md:139` || phase 2 |
| BR-LMP-016 | `core` | `BR-core-005` |  | `srs/library-management-platform-spec.md:140` || phase 2 |
| BR-LMP-017 | `core` | `BR-core-006` |  | `srs/library-management-platform-spec.md:141` || phase 2 |

## 4. Error

| Mã LMP | Đích | Mã mới | Ghi chú | Nguồn | Đã chuyển |
|---|---|---|---|---|---|
| E-LMP-001 | `core` | `E-core-001` |  | `srs/library-management-platform-spec.md:147` || phase 2 |
| E-LMP-002 | `core` | `E-core-002` |  | `srs/library-management-platform-spec.md:148` || phase 2 |
| E-LMP-003 | `core` | `E-core-003` |  | `srs/library-management-platform-spec.md:149` || phase 2 |
| E-LMP-004 | `checkout` | `E-checkout-001` |  | `srs/library-management-platform-spec.md:150` | SRS (2026-10-08) |
| E-LMP-005 | `core` | `E-core-004` |  | `srs/library-management-platform-spec.md:151` || phase 2 |
| E-LMP-006 | `core` | `E-core-005` |  | `srs/library-management-platform-spec.md:152` || phase 2 |
| E-LMP-007 | `core` | `E-core-006` |  | `srs/library-management-platform-spec.md:153` || phase 2 |
| E-LMP-008 | `reservation` | `E-reservation-001` |  | `srs/library-management-platform-spec.md:154` | SRS (2026-10-08) |
| E-LMP-009 | `fine-collection-basic` | `E-fine-collection-basic-001` |  | `srs/library-management-platform-spec.md:155` | SRS (2026-10-08) |
| E-LMP-010 | `fine-collection-basic` | `E-fine-collection-basic-002` |  | `srs/library-management-platform-spec.md:156` | SRS (2026-10-08) |
| E-LMP-011 | `damage-lifecycle` | `E-damage-lifecycle-001` |  | `srs/library-management-platform-spec.md:157` | SRS (2026-10-08) |
| E-LMP-012 | `notification-core` | `E-notification-core-001` |  | `srs/library-management-platform-spec.md:158` | SRS (2026-10-08) |
| E-LMP-013 | `core` | `E-core-007` |  | `srs/library-management-platform-spec.md:159` || phase 2 |
| E-LMP-014 | `data-import` | `E-data-import-001` |  | `srs/library-management-platform-spec.md:160` | SRS (2026-10-08) |
| E-LMP-015 | `core` | `E-core-008` |  | `srs/library-management-platform-spec.md:161` || phase 2 |
| E-LMP-016 | `core` | `E-core-009` |  | `srs/library-management-platform-spec.md:162` || phase 2 |
| E-LMP-017 | `access-control` | `E-access-control-001` |  | `srs/library-management-platform-spec.md:163` | SRS (2026-10-08) |
| E-LMP-018 | `notification-core` | `E-notification-core-002` |  | `srs/library-management-platform-spec.md:164` | SRS (2026-10-08) |

## 5. Success Criteria

| Mã LMP | Phần | Đích | Mã mới | Nội dung phần | Nguồn | Đã chuyển |
|---|---|---|---|---|---|---|
| SC-LMP-01 | a | `checkout` | `SC-checkout-01` | Phần mượn | `srs/library-management-platform-spec.md:170` | SRS (2026-10-08) |
| SC-LMP-01 | b | `return-handling` | `SC-return-handling-01` | Phần trả | `srs/library-management-platform-spec.md:170` | SRS (2026-10-08) |
| SC-LMP-02 |  | `checkout` | `SC-checkout-02` |  | `srs/library-management-platform-spec.md:171` | SRS (2026-10-08) |
| SC-LMP-03 |  | `reservation` | `SC-reservation-01` |  | `srs/library-management-platform-spec.md:172` | SRS (2026-10-08) |
| SC-LMP-04 |  | `overdue-fines` | `SC-overdue-fines-01` |  | `srs/library-management-platform-spec.md:173` | SRS (2026-10-08) |
| SC-LMP-05 |  | `notification-core` | `SC-notification-core-01` |  | `srs/library-management-platform-spec.md:174` | SRS (2026-10-08) |
| SC-LMP-06 |  | `ops-foundation` | `SC-ops-foundation-01` |  | `srs/library-management-platform-spec.md:175` | SRS (2026-10-08) |
| SC-LMP-07 |  | `data-import` | `SC-data-import-01` |  | `srs/library-management-platform-spec.md:176` | SRS (2026-10-08) |

## 6. Open Question

OQ trong spec là canonical. OQ trùng ở userflow gộp về cùng mã mới. OQ ghi trong user story là tham chiếu tới OQ spec hoặc ghi chú riêng của story, đi theo story (Mục 9). `OQ-BS-1..3` của brainstorm sản phẩm giữ nguyên mã, chuyển cùng file sang `docs/_product/product-roadmap-baseline.md`. `OQ-NN` của tài liệu nguồn giữ nguyên; `OQ-03` đã được trả lời bởi DEC-SF-03.

| Mã LMP | Đích | Mã mới | Ghi chú | Nguồn | Đã chuyển |
|---|---|---|---|---|---|
| OQ-LMP-001 | `core` | `OQ-core-001` | Cấp sản phẩm — ghi kèm decision-register | `srs/library-management-platform-spec.md:245` || phase 2 |
| OQ-LMP-002 | `data-import` | `OQ-data-import-001` |  | `srs/library-management-platform-spec.md:246` | SRS (2026-10-08) |
| OQ-LMP-003 | `reservation` | `OQ-reservation-001` |  | `srs/library-management-platform-spec.md:247` | SRS (2026-10-08) |
| OQ-LMP-004 | `core` | `OQ-core-002` | Tương đương OQ-BS-3 | `srs/library-management-platform-spec.md:248` || phase 2 |
| OQ-LMP-005 | `fine-collection-adv` | `OQ-fine-collection-adv-001` |  | `srs/library-management-platform-spec.md:249` | SRS (2026-10-08) |
| OQ-LMP-006 | `core` | `OQ-core-003` | Tương đương OQ-BS-1 | `srs/library-management-platform-spec.md:250` || phase 2 |
| OQ-LMP-007 | `access-control` | `OQ-access-control-001` |  | `srs/library-management-platform-spec.md:251` | SRS (2026-10-08) |
| OQ-LMP-008 | `notification-core` | `OQ-notification-core-001` |  | `srs/library-management-platform-spec.md:252` | SRS (2026-10-08) |
| OQ-LMP-009 | `fine-collection-adv` | `OQ-fine-collection-adv-002` |  | `srs/library-management-platform-spec.md:253` | SRS (2026-10-08) |
| OQ-LMP-010 | `policy-config` | `OQ-policy-config-001` |  | `srs/library-management-platform-spec.md:254` | SRS (2026-10-08) |
| OQ-LMP-011 | `core` | `OQ-core-004` |  | `srs/library-management-platform-spec.md:255` || phase 2 |
| OQ-LMP-012 | `core` | `OQ-core-005` |  | `srs/library-management-platform-spec.md:256` || phase 2 |
| OQ-LMP-013 | `damage-lifecycle` | `OQ-damage-lifecycle-001` |  | `srs/library-management-platform-spec.md:257` | SRS (2026-10-08) |
| OQ-LMP-014 | `account-admin` | `OQ-account-admin-001` |  | `srs/library-management-platform-spec.md:258` | SRS (2026-10-08) |
| OQ-LMP-015 | `reader-self-service` | `OQ-reader-self-service-001` | Trùng userflow OQ-a1 — gộp | `srs/library-management-platform-spec.md:259` | SRS (2026-10-08) |
| OQ-LMP-016 | `reader-self-service` | `OQ-reader-self-service-002` | Trùng userflow OQ-a2 — gộp | `srs/library-management-platform-spec.md:260` | SRS (2026-10-08) |
| OQ-LMP-017 | `ops-reports` | `OQ-ops-reports-001` | Trùng userflow OQ-a3 — gộp | `srs/library-management-platform-spec.md:261` | SRS (2026-10-08) |
| OQ-LMP-018 | `data-import` | `OQ-data-import-002` | Trùng userflow OQ-a4 — gộp | `srs/library-management-platform-spec.md:262` | SRS (2026-10-08) |

## 7. Use case

Slug use case mới là đề xuất; chốt khi chạy `/srs` Tầng 2 của từng feature.

| UC cũ | Đích | UC mới (đề xuất) | Phần nội dung | Đã chuyển |
|---|---|---|---|---|
| `uc-access-control` | `access-control` | `uc-access-control` | Toàn bộ |  |
| `uc-catalog-admin` | `catalog-admin` | `uc-catalog-admin` | Đầu sách, tra cứu |  |
| `uc-catalog-admin` | `copy-inventory` | `uc-copy-inventory` | Bản sao, QR |  |
| `uc-reader-admin` | `reader-onboarding` | `uc-reader-onboarding` | Cấp mới, kích hoạt tại quầy |  |
| `uc-reader-admin` | `account-admin` | `uc-account-admin` | Cập nhật, xóa mềm, khóa/mở, tài khoản Thủ thư |  |
| `uc-checkout` | `checkout` | `uc-checkout` | Toàn bộ |  |
| `uc-return-renewal` | `return-handling` | `uc-return` | Trả |  |
| `uc-return-renewal` | `renewal` | `uc-renewal` | Gia hạn |  |
| `uc-return-renewal` | `overdue-fines` | `uc-overdue-assessment` | Tính phạt khi trả quá hạn |  |
| `uc-reservation` | `reservation` | `uc-reservation` | Toàn bộ + đặt/hủy trên cổng Người đọc |  |
| `uc-fine-payment` | `overdue-fines` | `uc-overdue-assessment` | Assessment (gộp với phần từ uc-return-renewal) |  |
| `uc-fine-payment` | `fine-collection-basic` | `uc-fine-cash-payment` | Thu tiền mặt |  |
| `uc-fine-payment` | `fine-collection-adv` | `uc-fine-adjustment` | Biên nhận, miễn/điều chỉnh/hoàn |  |
| `uc-damage-lost-found` | `damage-lifecycle` | `uc-damage-report` | Hư hỏng, ảnh, disposition |  |
| `uc-damage-lost-found` | `lost-handling` | `uc-lost-found` | Mất, tìm lại |  |
| `uc-notification-audit` | `ops-foundation` | `uc-audit-capture` | Ghi audit |  |
| `uc-notification-audit` | `notification-core` | `uc-notification-outbox` | Outbox, retry, dead-letter |  |
| `uc-notification-audit` | `notification-audit-ui` | `uc-notification-audit-view` | Trung tâm thông báo, audit viewer, lịch sử |  |
| `uc-admin-import` | `policy-config` | `uc-policy-config` | Cấu hình |  |
| `uc-admin-import` | `data-import` | `uc-data-import` | Import, dry-run, commit, đối soát |  |
| — (mới) | `reader-self-service` | `uc-reader-self-service` | Viết mới (DEC-SF-02) | SRS (2026-10-08) |
| — (mới) | `ops-reports` | `uc-ops-reports` | Viết mới | SRS (2026-10-08) |
| — (mới) | `trend-reports` | `uc-trend-reports` | Viết mới | SRS (2026-10-08) |

## 8. Flow, màn hình

### 8.1 Flow trong userflow và wireframe HTML (`html-wireframe/{flow}.html`)

| Flow cũ | Đích | Đã chuyển |
|---|---|---|
| `auth-flow` | access-control |  |
| `catalog-admin-flow` | catalog-admin + copy-inventory |  |
| `reader-admin-flow` | reader-onboarding + account-admin |  |
| `checkout-flow` | checkout |  |
| `return-renewal-flow` | return-handling + renewal |  |
| `reservation-flow` | reservation |  |
| `fine-payment-flow` | fine-collection-basic + fine-collection-adv |  |
| `damage-lost-found-flow` | damage-lifecycle + lost-handling |  |
| `notification-audit-flow` | notification-core + notification-audit-ui |  |
| `admin-import-flow` | policy-config + data-import |  |
| `reports-flow` | ops-reports (+ trạng thái R2 của trend-reports) |  |

### 8.2 Section trong `srs/library-management-platform-flows.md`

| Section | Đích | Đã chuyển |
|---|---|---|
| Mục 0 — Quy ước và invariant dùng chung | `_shared/core-spec.md` |  |
| Mục 1 — F1 catalog/copy | catalog-admin + copy-inventory |  |
| Mục 2 — F2 reader administration | reader-onboarding + account-admin |  |
| Mục 3 — F3 checkout | checkout |  |
| Mục 4 — F4 trả, gia hạn, follow-up | return-handling + renewal + overdue-fines |  |
| Mục 5 — F5 reservation | reservation |  |
| Mục 6 — F6 thanh toán phạt | fine-collection-basic + fine-collection-adv |  |
| Mục 7 — F7 hư hỏng/mất/tìm lại | damage-lifecycle + lost-handling |  |
| Mục 8 — F8 notification + audit + import | notification-core + ops-foundation + data-import |  |
| Mục 9–11 — phủ interrupted tx, Error Matrix, gap | Chia theo item được nhắc tới |  |

### 8.3 Màn hình (userflow Mục 2)

| Màn | Đích | Đã chuyển |
|---|---|---|
| `access-login` | access-control |  |
| `forgot-password` | access-control |  |
| `reset-password` | access-control |  |
| `dashboard-home` | access-control (điều hướng ở `_shared/navigation-map.md`) |  |
| `session-expired` | access-control |  |
| `catalog-search` | catalog-admin |  |
| `bibliographic-detail` | catalog-admin |  |
| `bibliographic-form` | catalog-admin |  |
| `copy-inventory` | copy-inventory |  |
| `copy-form` | copy-inventory |  |
| `reader-list` | account-admin |  |
| `reader-form` | reader-onboarding |  |
| `reader-detail` | account-admin |  |
| `circulation-desk` | checkout |  |
| `checkout-scan` | checkout |  |
| `checkout-review` | checkout |  |
| `checkout-conflict` | checkout |  |
| `return-scan` | return-handling |  |
| `return-result` | return-handling |  |
| `renewal-result` | renewal |  |
| `reservation-search` | reservation |  |
| `reservation-form` | reservation |  |
| `reservation-queue` | reservation |  |
| `reservation-pickup` | reservation |  |
| `fine-list` | fine-collection-basic |  |
| `fine-detail` | fine-collection-basic |  |
| `fine-payment` | fine-collection-basic |  |
| `financial-events` | fine-collection-adv |  |
| `damage-report-form` | damage-lifecycle |  |
| `damage-report-detail` | damage-lifecycle |  |
| `lost-found` | lost-handling |  |
| `notification-status` | notification-core |  |
| `audit-log` | notification-audit-ui |  |
| `history-timeline` | notification-audit-ui |  |
| `admin-config` | policy-config |  |
| `import-upload` | data-import |  |
| `import-report` | data-import |  |
| `report-dashboard` | ops-reports |  |
| notification-center | `notification-audit-ui` | Mới — DEC-SF-09 |
| Màn tự phục vụ (tra cứu, thẻ QR, đang mượn, lịch sử, công nợ) | `reader-self-service` | Mới — DEC-SF-02 — thiết kế ở user-flow |

## 9. User story và acceptance criteria

Story đánh lại `US-NNN` trong từng feature. AC giữ nguyên `AC-NNN` trong story. Persona đổi theo DEC-SF-01 (DEC-SF-08).

| US cũ | Đích | US mới | Số AC | Ghi chú | Đã chuyển |
|---|---|---|---|---|---|
| US-001 | `access-control` | US-001 | 3 |  |  |
| US-002 | `access-control` | US-002 | 2 |  |  |
| US-003 | `catalog-admin` | US-001 | 5 |  |  |
| US-004 | `copy-inventory` | US-001 | 4 |  |  |
| US-005 | `catalog-admin` | US-002 | 2 | Persona 'Người tra cứu' đổi theo DEC-SF-01; phần Người đọc chuyển `reader-self-service` |  |
| US-006 | `reader-onboarding` | US-001 | 5 | Phần cập nhật/xóa mềm hồ sơ chuyển `account-admin` (DEC-SF-04) khi viết story |  |
| US-007 | `policy-config` | US-001 | 4 |  |  |
| US-008 | `data-import` | US-001 | 2 |  |  |
| US-009 | `data-import` | US-002 | 5 | Cũng phủ FR ghi audit (`ops-foundation`) và QR (`copy-inventory`) — tham chiếu, không chép |  |
| US-010 | `ops-foundation` | US-001 | 3 |  |  |
| US-011 | `checkout` | US-001 | 7 |  |  |
| US-012 | `return-handling` | US-001 | 5 |  |  |
| US-013 | `overdue-fines` | US-001 | 4 |  |  |
| US-014 | `fine-collection-basic` | US-001 | 6 |  |  |
| US-015 | `damage-lifecycle` | US-001 | 4 |  |  |
| US-016 | `damage-lifecycle` | US-002 | 5 |  |  |
| US-017 | `lost-handling` | US-001 | 4 |  |  |
| US-018 | `notification-core` | US-001 | 2 |  |  |

## 10. Checklist

Chủ của CHK = chủ của FR đầu tiên trong cột Nguồn của CHK (FR bị tách thì theo phần mà nội dung CHK kiểm). CHK không có FR theo chủ của item đầu tiên. Mã mới `CHK-{feature}-NNN`, `next_chk_id` bắt đầu lại cho mỗi feature.

| Mã LMP | Đích | Mã mới | Căn cứ | Nguồn của CHK | Vị trí | Đã chuyển |
|---|---|---|---|---|---|---|
| CHK-LMP-001 | `access-control` | `CHK-access-control-001` | FR-LMP-006 | FR-LMP-006, BR-LMP-015 | `test/checklist/checklist-feature.md:5` |  |
| CHK-LMP-002 | `access-control` | `CHK-access-control-002` | FR-LMP-006 | FR-LMP-006, E-LMP-002 | `test/checklist/checklist-feature.md:6` |  |
| CHK-LMP-003 | `access-control` | `CHK-access-control-003` | FR-LMP-006 | FR-LMP-006, E-LMP-002 | `test/checklist/checklist-feature.md:7` |  |
| CHK-LMP-004 | `access-control` | `CHK-access-control-004` | FR-LMP-006 | FR-LMP-006, E-LMP-016, BR-LMP-015 | `test/checklist/checklist-feature.md:8` |  |
| CHK-LMP-005 | `access-control` | `CHK-access-control-005` | FR-LMP-007 | FR-LMP-007, E-LMP-017 | `test/checklist/checklist-feature.md:12` |  |
| CHK-LMP-006 | `access-control` | `CHK-access-control-006` | FR-LMP-007 | FR-LMP-007, E-LMP-017 | `test/checklist/checklist-feature.md:13` |  |
| CHK-LMP-007 | `access-control` | `CHK-access-control-007` | FR-LMP-007 | FR-LMP-007, E-LMP-017 | `test/checklist/checklist-feature.md:14` |  |
| CHK-LMP-008 | `catalog-admin` | `CHK-catalog-admin-001` | FR-LMP-001 | FR-LMP-001 | `test/checklist/checklist-feature.md:20` |  |
| CHK-LMP-009 | `catalog-admin` | `CHK-catalog-admin-002` | FR-LMP-001 | FR-LMP-001, E-LMP-001 | `test/checklist/checklist-feature.md:21` |  |
| CHK-LMP-010 | `catalog-admin` | `CHK-catalog-admin-003` | FR-LMP-001 | FR-LMP-001, E-LMP-001 | `test/checklist/checklist-feature.md:22` |  |
| CHK-LMP-011 | `catalog-admin` | `CHK-catalog-admin-004` | FR-LMP-001 | FR-LMP-001, E-LMP-003 | `test/checklist/checklist-feature.md:23` |  |
| CHK-LMP-012 | `catalog-admin` | `CHK-catalog-admin-005` | FR-LMP-001 | FR-LMP-001, BR-LMP-017, E-LMP-015 | `test/checklist/checklist-feature.md:24` |  |
| CHK-LMP-013 | `catalog-admin` | `CHK-catalog-admin-006` | FR-LMP-001 | FR-LMP-001, E-LMP-002 | `test/checklist/checklist-feature.md:25` |  |
| CHK-LMP-014 | `copy-inventory` | `CHK-copy-inventory-001` | FR-LMP-002 | FR-LMP-002, FR-LMP-026 | `test/checklist/checklist-feature.md:29` |  |
| CHK-LMP-015 | `copy-inventory` | `CHK-copy-inventory-002` | FR-LMP-026 | FR-LMP-026, BR-LMP-011 | `test/checklist/checklist-feature.md:30` |  |
| CHK-LMP-016 | `copy-inventory` | `CHK-copy-inventory-003` | FR-LMP-026 | FR-LMP-026, BR-LMP-011 | `test/checklist/checklist-feature.md:31` |  |
| CHK-LMP-017 | `copy-inventory` | `CHK-copy-inventory-004` | FR-LMP-002 | FR-LMP-002, E-LMP-003 | `test/checklist/checklist-feature.md:32` |  |
| CHK-LMP-018 | `copy-inventory` | `CHK-copy-inventory-005` | FR-LMP-002 | FR-LMP-002, BR-LMP-017, E-LMP-015 | `test/checklist/checklist-feature.md:33` |  |
| CHK-LMP-019 | `catalog-admin` | `CHK-catalog-admin-007` | FR-LMP-003a | FR-LMP-003 | `test/checklist/checklist-feature.md:37` |  |
| CHK-LMP-020 | `catalog-admin` | `CHK-catalog-admin-008` | FR-LMP-003a | FR-LMP-003, E-LMP-003 | `test/checklist/checklist-feature.md:38` |  |
| CHK-LMP-021 | `reader-onboarding` | `CHK-reader-onboarding-001` | FR-LMP-004a | FR-LMP-004 | `test/checklist/checklist-feature.md:44` |  |
| CHK-LMP-022 | `reader-onboarding` | `CHK-reader-onboarding-002` | FR-LMP-004a | FR-LMP-004 | `test/checklist/checklist-feature.md:45` |  |
| CHK-LMP-023 | `reader-onboarding` | `CHK-reader-onboarding-003` | FR-LMP-004a | FR-LMP-004, E-LMP-001 | `test/checklist/checklist-feature.md:46` |  |
| CHK-LMP-024 | `reader-onboarding` | `CHK-reader-onboarding-004` | FR-LMP-004a | FR-LMP-004, E-LMP-003 | `test/checklist/checklist-feature.md:47` |  |
| CHK-LMP-025 | `account-admin` | `CHK-account-admin-001` | FR-LMP-004b | FR-LMP-004, E-LMP-016, BR-LMP-015 | `test/checklist/checklist-feature.md:48` |  |
| CHK-LMP-026 | `account-admin` | `CHK-account-admin-002` | FR-LMP-004b | FR-LMP-004, BR-LMP-017 | `test/checklist/checklist-feature.md:49` |  |
| CHK-LMP-027 | `policy-config` | `CHK-policy-config-001` | FR-LMP-021 | FR-LMP-021 | `test/checklist/checklist-feature.md:55` |  |
| CHK-LMP-028 | `policy-config` | `CHK-policy-config-002` | FR-LMP-021 | FR-LMP-021 | `test/checklist/checklist-feature.md:56` |  |
| CHK-LMP-029 | `policy-config` | `CHK-policy-config-003` | FR-LMP-021 | FR-LMP-021, E-LMP-002 | `test/checklist/checklist-feature.md:57` |  |
| CHK-LMP-030 | `policy-config` | `CHK-policy-config-004` | FR-LMP-021 | FR-LMP-021, E-LMP-001 | `test/checklist/checklist-feature.md:58` |  |
| CHK-LMP-031 | `data-import` | `CHK-data-import-001` | FR-LMP-022 | FR-LMP-022, BR-LMP-014 | `test/checklist/checklist-feature.md:64` |  |
| CHK-LMP-032 | `data-import` | `CHK-data-import-002` | FR-LMP-022 | FR-LMP-022, BR-LMP-014 | `test/checklist/checklist-feature.md:65` |  |
| CHK-LMP-033 | `data-import` | `CHK-data-import-003` | FR-LMP-022 | FR-LMP-022, E-LMP-014 | `test/checklist/checklist-feature.md:66` |  |
| CHK-LMP-034 | `data-import` | `CHK-data-import-004` | FR-LMP-022 | FR-LMP-022, BR-LMP-014 | `test/checklist/checklist-feature.md:70` |  |
| CHK-LMP-035 | `data-import` | `CHK-data-import-005` | FR-LMP-022 | FR-LMP-022, FR-LMP-026 | `test/checklist/checklist-feature.md:71` |  |
| CHK-LMP-036 | `data-import` | `CHK-data-import-006` | FR-LMP-022 | FR-LMP-022, BR-LMP-014 | `test/checklist/checklist-feature.md:72` |  |
| CHK-LMP-037 | `data-import` | `CHK-data-import-007` | FR-LMP-022 | FR-LMP-022, BR-LMP-014, E-LMP-014 | `test/checklist/checklist-feature.md:73` |  |
| CHK-LMP-038 | `data-import` | `CHK-data-import-008` | FR-LMP-022 | FR-LMP-022, E-LMP-014 | `test/checklist/checklist-feature.md:74` |  |
| CHK-LMP-039 | `data-import` | `CHK-data-import-009` | FR-LMP-022 | FR-LMP-022, E-LMP-006 | `test/checklist/checklist-feature.md:75` |  |
| CHK-LMP-040 | `ops-foundation` | `CHK-ops-foundation-001` | FR-LMP-020a | FR-LMP-020, BR-LMP-013, E-LMP-013 | `test/checklist/checklist-feature.md:76` |  |
| CHK-LMP-041 | `notification-audit-ui` | `CHK-notification-audit-ui-001` | FR-LMP-020b | FR-LMP-020 | `test/checklist/checklist-feature.md:82` |  |
| CHK-LMP-042 | `ops-foundation` | `CHK-ops-foundation-002` | FR-LMP-020a | FR-LMP-020 | `test/checklist/checklist-feature.md:83` |  |
| CHK-LMP-043 | `ops-foundation` | `CHK-ops-foundation-003` | FR-LMP-020a | FR-LMP-020, BR-LMP-013, E-LMP-013 | `test/checklist/checklist-feature.md:84` |  |
| CHK-LMP-044 | `notification-audit-ui` | `CHK-notification-audit-ui-002` | FR-LMP-020b | FR-LMP-020, E-LMP-002, E-LMP-016 | `test/checklist/checklist-feature.md:85` |  |
| CHK-LMP-045 | `checkout` | `CHK-checkout-001` | FR-LMP-008 | FR-LMP-008, BR-LMP-001 | `test/checklist/checklist-feature.md:91` |  |
| CHK-LMP-046 | `checkout` | `CHK-checkout-002` | FR-LMP-008 | FR-LMP-008, BR-LMP-001 | `test/checklist/checklist-feature.md:92` |  |
| CHK-LMP-047 | `checkout` | `CHK-checkout-003` | FR-LMP-008 | FR-LMP-008, BR-LMP-001, BR-LMP-002, E-LMP-004 | `test/checklist/checklist-feature.md:93` |  |
| CHK-LMP-048 | `checkout` | `CHK-checkout-004` | FR-LMP-008 | FR-LMP-008, BR-LMP-003, E-LMP-007 | `test/checklist/checklist-feature.md:94` |  |
| CHK-LMP-049 | `checkout` | `CHK-checkout-005` | FR-LMP-008 | FR-LMP-008, E-LMP-007 | `test/checklist/checklist-feature.md:95` |  |
| CHK-LMP-050 | `checkout` | `CHK-checkout-006` | FR-LMP-009 | FR-LMP-009, E-LMP-006 | `test/checklist/checklist-feature.md:96` |  |
| CHK-LMP-051 | `checkout` | `CHK-checkout-007` | FR-LMP-009 | FR-LMP-009, E-LMP-005 | `test/checklist/checklist-feature.md:97` |  |
| CHK-LMP-052 | `checkout` | `CHK-checkout-008` | FR-LMP-008 | FR-LMP-008, BR-LMP-013, E-LMP-013 | `test/checklist/checklist-feature.md:98` |  |
| CHK-LMP-053 | `copy-inventory` | `CHK-copy-inventory-006` | FR-LMP-026 | FR-LMP-026, BR-LMP-011 | `test/checklist/checklist-feature.md:99` |  |
| CHK-LMP-054 | `return-handling` | `CHK-return-handling-001` | FR-LMP-010 | FR-LMP-010 | `test/checklist/checklist-feature.md:105` |  |
| CHK-LMP-055 | `return-handling` | `CHK-return-handling-002` | FR-LMP-010 | FR-LMP-010 | `test/checklist/checklist-feature.md:106` |  |
| CHK-LMP-056 | `return-handling` | `CHK-return-handling-003` | FR-LMP-010 | FR-LMP-010, E-LMP-015 | `test/checklist/checklist-feature.md:107` |  |
| CHK-LMP-057 | `return-handling` | `CHK-return-handling-004` | FR-LMP-010 | FR-LMP-010, E-LMP-005 | `test/checklist/checklist-feature.md:108` |  |
| CHK-LMP-058 | `return-handling` | `CHK-return-handling-005` | FR-LMP-010 | FR-LMP-010, BR-LMP-013, E-LMP-013 | `test/checklist/checklist-feature.md:109` |  |
| CHK-LMP-059 | `overdue-fines` | `CHK-overdue-fines-001` | FR-LMP-014 | FR-LMP-014, BR-LMP-007 | `test/checklist/checklist-feature.md:115` |  |
| CHK-LMP-060 | `overdue-fines` | `CHK-overdue-fines-002` | FR-LMP-014 | FR-LMP-014, BR-LMP-007 | `test/checklist/checklist-feature.md:116` |  |
| CHK-LMP-061 | `overdue-fines` | `CHK-overdue-fines-003` | FR-LMP-014 | FR-LMP-014, BR-LMP-007 | `test/checklist/checklist-feature.md:117` |  |
| CHK-LMP-062 | `overdue-fines` | `CHK-overdue-fines-004` | FR-LMP-014 | FR-LMP-014, E-LMP-015 | `test/checklist/checklist-feature.md:118` |  |
| CHK-LMP-063 | `overdue-fines` | `CHK-overdue-fines-005` | FR-LMP-014 | FR-LMP-014, BR-LMP-013, E-LMP-013 | `test/checklist/checklist-feature.md:119` |  |
| CHK-LMP-064 | `fine-collection-basic` | `CHK-fine-collection-basic-001` | FR-LMP-015a | FR-LMP-015, BR-LMP-007, BR-LMP-008 | `test/checklist/checklist-feature.md:123` |  |
| CHK-LMP-065 | `fine-collection-basic` | `CHK-fine-collection-basic-002` | FR-LMP-015a | FR-LMP-015 | `test/checklist/checklist-feature.md:124` |  |
| CHK-LMP-066 | `fine-collection-basic` | `CHK-fine-collection-basic-003` | FR-LMP-015a | FR-LMP-015, BR-LMP-008, E-LMP-006, E-LMP-010 | `test/checklist/checklist-feature.md:125` |  |
| CHK-LMP-067 | `fine-collection-basic` | `CHK-fine-collection-basic-004` | FR-LMP-015a | FR-LMP-015, E-LMP-009 | `test/checklist/checklist-feature.md:126` |  |
| CHK-LMP-068 | `fine-collection-basic` | `CHK-fine-collection-basic-005` | FR-LMP-015a | FR-LMP-015, E-LMP-005 | `test/checklist/checklist-feature.md:127` |  |
| CHK-LMP-069 | `fine-collection-basic` | `CHK-fine-collection-basic-006` | FR-LMP-015a | FR-LMP-015, BR-LMP-013, E-LMP-013 | `test/checklist/checklist-feature.md:128` |  |
| CHK-LMP-070 | `fine-collection-basic` | `CHK-fine-collection-basic-007` | FR-LMP-015a | FR-LMP-015, E-LMP-016 | `test/checklist/checklist-feature.md:129` |  |
| CHK-LMP-071 | `damage-lifecycle` | `CHK-damage-lifecycle-001` | FR-LMP-017 | FR-LMP-017 | `test/checklist/checklist-feature.md:135` |  |
| CHK-LMP-072 | `damage-lifecycle` | `CHK-damage-lifecycle-002` | FR-LMP-017 | FR-LMP-017, BR-LMP-009 | `test/checklist/checklist-feature.md:136` |  |
| CHK-LMP-073 | `damage-lifecycle` | `CHK-damage-lifecycle-003` | FR-LMP-017 | FR-LMP-017, BR-LMP-012, E-LMP-011 | `test/checklist/checklist-feature.md:137` |  |
| CHK-LMP-074 | `damage-lifecycle` | `CHK-damage-lifecycle-004` | FR-LMP-017 | FR-LMP-017, BR-LMP-013, E-LMP-013 | `test/checklist/checklist-feature.md:138` |  |
| CHK-LMP-075 | `damage-lifecycle` | `CHK-damage-lifecycle-005` | FR-LMP-017 | FR-LMP-017, BR-LMP-009 | `test/checklist/checklist-feature.md:139` |  |
| CHK-LMP-076 | `damage-lifecycle` | `CHK-damage-lifecycle-006` | FR-LMP-017 | FR-LMP-017, BR-LMP-009 | `test/checklist/checklist-feature.md:140` |  |
| CHK-LMP-077 | `damage-lifecycle` | `CHK-damage-lifecycle-007` | FR-LMP-017 | FR-LMP-017, BR-LMP-009 | `test/checklist/checklist-feature.md:141` |  |
| CHK-LMP-078 | `damage-lifecycle` | `CHK-damage-lifecycle-008` | FR-LMP-017 | FR-LMP-017, E-LMP-002 | `test/checklist/checklist-feature.md:142` |  |
| CHK-LMP-079 | `damage-lifecycle` | `CHK-damage-lifecycle-009` | FR-LMP-017 | FR-LMP-017, E-LMP-015 | `test/checklist/checklist-feature.md:143` |  |
| CHK-LMP-080 | `damage-lifecycle` | `CHK-damage-lifecycle-010` | FR-LMP-017 | FR-LMP-017, E-LMP-005 | `test/checklist/checklist-feature.md:144` |  |
| CHK-LMP-081 | `damage-lifecycle` | `CHK-damage-lifecycle-011` | FR-LMP-017 | FR-LMP-017, BR-LMP-013, E-LMP-013 | `test/checklist/checklist-feature.md:145` |  |
| CHK-LMP-082 | `lost-handling` | `CHK-lost-handling-001` | FR-LMP-018a | FR-LMP-018, FR-LMP-014, BR-LMP-007 | `test/checklist/checklist-feature.md:149` |  |
| CHK-LMP-083 | `lost-handling` | `CHK-lost-handling-002` | FR-LMP-018a | FR-LMP-018 | `test/checklist/checklist-feature.md:150` |  |
| CHK-LMP-084 | `lost-handling` | `CHK-lost-handling-003` | FR-LMP-018a | FR-LMP-018, E-LMP-015 | `test/checklist/checklist-feature.md:151` |  |
| CHK-LMP-085 | `lost-handling` | `CHK-lost-handling-004` | FR-LMP-018b | FR-LMP-018, BR-LMP-010 | `test/checklist/checklist-feature.md:152` |  |
| CHK-LMP-086 | `lost-handling` | `CHK-lost-handling-005` | FR-LMP-018a | FR-LMP-018, BR-LMP-013, E-LMP-013 | `test/checklist/checklist-feature.md:153` |  |
| CHK-LMP-087 | `notification-core` | `CHK-notification-core-001` | FR-LMP-019a | FR-LMP-019, BR-LMP-016 | `test/checklist/checklist-feature.md:159` |  |
| CHK-LMP-088 | `notification-core` | `CHK-notification-core-002` | FR-LMP-019a | FR-LMP-019, BR-LMP-016 | `test/checklist/checklist-feature.md:160` |  |
| CHK-LMP-089 | `notification-core` | `CHK-notification-core-003` | FR-LMP-019a | FR-LMP-019, E-LMP-012, E-LMP-018 | `test/checklist/checklist-feature.md:161` |  |
| CHK-LMP-090 | `notification-core` | `CHK-notification-core-004` | FR-LMP-019a | FR-LMP-019, BR-LMP-016, E-LMP-018 | `test/checklist/checklist-feature.md:162` |  |
| CHK-LMP-091 | `core` | `CHK-core-001` | NFR-LMP-008 | NFR-LMP-008 | `test/checklist/checklist-feature.md:168` || phase 2 |
| CHK-LMP-092 | `core` | `CHK-core-002` | NFR-LMP-008 | NFR-LMP-008, NFR-LMP-009 | `test/checklist/checklist-feature.md:172` || phase 2 |
| CHK-LMP-093 | `core` | `CHK-core-003` | NFR-LMP-009 | NFR-LMP-009 | `test/checklist/checklist-feature.md:173` || phase 2 |
| CHK-LMP-094 | `core` | `CHK-core-004` | NFR-LMP-012 | NFR-LMP-012 | `test/checklist/checklist-feature.md:177` || phase 2 |
| CHK-LMP-095 | `checkout` | `CHK-checkout-009` | FR-LMP-008 | FR-LMP-008 | `test/checklist/checklist-feature.md:181` |  |
| CHK-LMP-096 | `checkout` | `CHK-checkout-010` | FR-LMP-008 | FR-LMP-008, NFR-LMP-003 | `test/checklist/checklist-feature.md:182` |  |
| CHK-LMP-097 | `access-control` | `CHK-access-control-008` | FR-LMP-006 | FR-LMP-006, E-LMP-017 | `test/checklist/checklist-feature.md:183` |  |

## 11. Phần dùng chung giữ nguyên mã

| Item | Số lượng | Đích | Ghi chú |
|---|---|---|---|
| Entity | 14 | `docs/_shared/domain/library-erd.md` | Giữ tên entity |
| State machine | 5 | `docs/_shared/domain/library-states.md` | Copy, Loan, Reservation, Fine, DamageReport |
| State transition `COPY/LOAN/RES/DMG-Tnn` | 35 | `docs/_shared/domain/lifecycle-inventory.md` | Giữ mã |
| ID dạng ngắn của tài liệu nguồn (`BR-01`, `NFR-01`, `FR-C01`…) | — | Giữ trong tài liệu nguồn | Trong tài liệu dẫn xuất ghi tiền tố `SRC-` (vd `SRC-BR01`) để KG không hiểu nhầm là mã feature |

## 12. Tổng hợp theo đích

| Đích | FR | NFR | BR | E | SC | OQ | US | AC | CHK |
|---|---|---|---|---|---|---|---|---|---|
| `access-control` | 2 | — | — | 1 | — | 1 | 2 | 5 | 8 |
| `reader-onboarding` | 1 | — | — | — | — | — | 1 | 5 | 4 |
| `account-admin` | 3 | — | — | — | — | 1 | — | — | 2 |
| `catalog-admin` | 2 | 1 | — | — | — | — | 2 | 7 | 8 |
| `copy-inventory` | 2 | — | 1 | — | — | — | 1 | 4 | 6 |
| `data-import` | 1 | 1 | 1 | 1 | 1 | 2 | 2 | 7 | 9 |
| `policy-config` | 1 | — | — | — | — | 1 | 1 | 4 | 4 |
| `ops-foundation` | 2 | — | — | — | 1 | — | 1 | 3 | 3 |
| `checkout` | 2 | — | 2 | 1 | 2 | — | 1 | 7 | 10 |
| `return-handling` | 1 | — | — | — | 1 | — | 1 | 5 | 5 |
| `overdue-fines` | 1 | — | — | — | 1 | — | 1 | 4 | 5 |
| `damage-lifecycle` | 2 | — | 2 | 1 | — | 1 | 2 | 9 | 11 |
| `lost-handling` | 2 | — | 1 | — | — | — | 1 | 4 | 5 |
| `fine-collection-basic` | 1 | — | 1 | 2 | — | — | 1 | 6 | 7 |
| `reader-self-service` | 5 | — | — | — | — | 2 | — | — | — |
| `notification-core` | 1 | 1 | — | 2 | 1 | 1 | 1 | 2 | 4 |
| `ops-reports` | 1 | — | — | — | — | 1 | — | — | — |
| `renewal` | 1 | — | 1 | — | — | — | — | — | — |
| `fine-collection-adv` | 2 | — | — | — | — | 2 | — | — | — |
| `notification-audit-ui` | 3 | — | — | — | — | — | — | — | 2 |
| `reservation` | 3 | — | 2 | 1 | 1 | 1 | — | — | — |
| `trend-reports` | 1 | — | — | — | — | — | — | — | — |
| `expansion-candidates` | 2 | — | — | — | — | — | — | — | — |
| `core` | — | 9 | 6 | 9 | — | 5 | — | — | 4 |
| **Tổng** | 42 | 12 | 17 | 18 | 8 | 18 | 18 | 72 | 97 |

## 13. Đối chiếu với số liệu gốc

Mốc: `plans/reports/split-baseline-261008-2105.md`.

| Loại | Gốc | Sau phân bổ | Chênh | Giải thích |
|---|---|---|---|---|
| FR | 28 | 42 | +14 | 10 dòng do tách phần, 4 FR mới theo DEC-SF-02/04/05 |
| NFR | 12 | 12 | +0 | — |
| BR | 17 | 17 | +0 | — |
| E | 18 | 18 | +0 | — |
| OQ | 18 | 18 | +0 | — |
| US | 18 | 18 | +0 | — |
| AC | 72 | 72 | +0 | — |
| CHK | 97 | 97 | +0 | — |
| SC | 7 | 8 | +1 | SC-LMP-01 tách mượn/trả |

Item còn phải xác nhận khi chuyển: FR-LMP-023 phần `ops-reports` lệch priority (PRD P0, SRS cũ P1) — chốt ở phase 3.
