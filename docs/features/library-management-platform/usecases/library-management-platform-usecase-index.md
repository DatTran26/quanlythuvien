---
type: usecase-index
feature: library-management-platform
status: draft
updated: 2026-10-05
links:
  - docs/features/library-management-platform/srs/library-management-platform-spec.md
  - docs/features/library-management-platform/srs/library-management-platform-userflow.md
---

# Library Management Platform — Use Cases Index

## Use cases

| # | Slug | Level | Status | Actor primary | Covers FR | Screens | Errors (E-*) | OQ ref | Priority | Updated |
|---|------|-------|--------|---------------|-----------|---------|--------------|--------|----------|---------|
| 1 | [uc-access-control](uc-access-control.md) | sea | draft | Thủ thư/Quản trị viên/Người đọc | FR-LMP-006, FR-LMP-007 | access-login, dashboard-home, session-expired | E-LMP-002, E-LMP-016, E-LMP-017 | OQ-LMP-007 | P0 | 2026-10-05 |
| 2 | [uc-catalog-admin](uc-catalog-admin.md) | sea | draft | Thủ thư/Quản trị viên | FR-LMP-001, FR-LMP-002, FR-LMP-003 | catalog-search, bibliographic-detail, bibliographic-form, copy-inventory, copy-form | E-LMP-001, E-LMP-002, E-LMP-003, E-LMP-005, E-LMP-015 | — | P0 | 2026-10-05 |
| 3 | [uc-reader-admin](uc-reader-admin.md) | sea | draft | Thủ thư/Quản trị viên | FR-LMP-004, FR-LMP-005 | reader-list, reader-form, reader-detail | E-LMP-001, E-LMP-002, E-LMP-003, E-LMP-005, E-LMP-015, E-LMP-016 | OQ-LMP-007 | P0 | 2026-10-05 |
| 4 | [uc-checkout](uc-checkout.md) | sea | draft | Thủ thư | FR-LMP-008, FR-LMP-009, FR-LMP-026 | circulation-desk, checkout-scan, checkout-review, checkout-conflict | E-LMP-001, E-LMP-003, E-LMP-004, E-LMP-005, E-LMP-006, E-LMP-007, E-LMP-015 | OQ-LMP-010 | P0 | 2026-10-05 |
| 5 | [uc-return-renewal](uc-return-renewal.md) | sea | draft | Thủ thư/Người đọc | FR-LMP-010, FR-LMP-011, FR-LMP-014 | return-scan, return-result, renewal-result | E-LMP-004, E-LMP-005, E-LMP-007, E-LMP-015 | OQ-LMP-010 | P0 | 2026-10-05 |
| 6 | [uc-reservation](uc-reservation.md) | sea | draft | Thủ thư/Người đọc/Hệ thống | FR-LMP-012, FR-LMP-013 | reservation-search, reservation-form, reservation-queue, reservation-pickup | E-LMP-005, E-LMP-008, E-LMP-015 | OQ-LMP-003, OQ-LMP-010 | P1 · R2 (DEC-P2-05) | 2026-10-05 |
| 7 | [uc-fine-payment](uc-fine-payment.md) | sea | draft | Thủ thư/Người đọc/Quản trị viên/Hệ thống | FR-LMP-014, FR-LMP-015, FR-LMP-016 | fine-list, fine-detail, fine-payment, financial-events | E-LMP-005, E-LMP-006, E-LMP-009, E-LMP-010, E-LMP-013, E-LMP-015, E-LMP-016 | OQ-LMP-005, OQ-LMP-009 | P0/P1 | 2026-10-05 |
| 8 | [uc-damage-lost-found](uc-damage-lost-found.md) | sea | draft | Thủ thư/Quản trị viên | FR-LMP-017, FR-LMP-018, FR-LMP-025 | damage-report-form, damage-report-detail, lost-found | E-LMP-001, E-LMP-003, E-LMP-011, E-LMP-015 | OQ-LMP-005 | P0/P1 | 2026-10-05 |
| 9 | [uc-notification-audit](uc-notification-audit.md) | sea | draft | Hệ thống/Quản trị viên | FR-LMP-019, FR-LMP-020, FR-LMP-027 | notification-status, audit-log, history-timeline | E-LMP-012, E-LMP-013, E-LMP-016, E-LMP-018 | OQ-LMP-008 | P0 | 2026-10-05 |
| 10 | [uc-admin-import](uc-admin-import.md) | sea | draft | Quản trị viên | FR-LMP-021, FR-LMP-022, FR-LMP-023 | admin-config, import-upload, import-report, report-dashboard | E-LMP-001, E-LMP-002, E-LMP-005, E-LMP-006, E-LMP-014, E-LMP-016 | OQ-LMP-002, OQ-LMP-010 | P0/P1 | 2026-10-05 |

**Ghi chú coverage:** FR-LMP-024 (cổng self-service người đọc, R2/R1B) và CAP-IDENT/CAP-ACCT phần "đặt lại mật khẩu / đăng ký + kích hoạt người đọc" (R0) chưa có UC owner — sẽ bổ sung UC `uc-reader-self-service` + mở rộng uc-access-control/uc-reader-admin khi portal scope được approve (xem spec §3 FR-LMP-024, OQ-LMP-007/014).

## CRUD matrix

| UC \ Entity | BibliographicRecord | Copy | Reader | Loan | LoanItem | Reservation | Fine | FinancialEvent | DamageReport | NotificationEvent | AuditEvent | PolicyConfig | ImportBatch |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| [uc-access-control](uc-access-control.md) | R | R | R | R | R | R | R | R | R | R | R | R | — |
| [uc-catalog-admin](uc-catalog-admin.md) | CRUD | CRUD | R | R | R | R | — | — | — | — | C | — | — |
| [uc-reader-admin](uc-reader-admin.md) | — | — | CRUD | R | R | R | R | R | — | — | C | — | — |
| [uc-checkout](uc-checkout.md) | R | U | R | C | C | U | R | — | — | C | C | R | — |
| [uc-return-renewal](uc-return-renewal.md) | R | U | R | U | U | U | C | C | C | C | C | R | — |
| [uc-reservation](uc-reservation.md) | R | U | R | R | — | CRUD | — | — | — | C | C | R | — |
| [uc-fine-payment](uc-fine-payment.md) | — | R | R | R | R | — | RU | C | R | C | C | R | — |
| [uc-damage-lost-found](uc-damage-lost-found.md) | R | U | R | U | R | U | C | C | CRUD | C | C | — | — |
| [uc-notification-audit](uc-notification-audit.md) | R | R | R | R | R | R | R | R | R | RU | CR | — | — |
| [uc-admin-import](uc-admin-import.md) | RU | RU | RU | RU | RU | RU | RU | RU | RU | RU | R | CRUD | CRUD |

**Quy ước:** `D` trong ma trận = vô hiệu hóa/soft-delete (BR-LMP-017 / BR-12 nguồn — FACT) — không xóa cứng entity đã có lịch sử nghiệp vụ.

## Actors

| Actor | Loại | Mô tả | Nguồn |
|---|---|---|---|
| Thủ thư | primary | Người vận hành quầy, xử lý mượn/trả/gia hạn/đặt trước/báo cáo — **tương đương `Nhân viên` của tài liệu nguồn §2** | `docs/he_thong_quan_ly_thu_vien.md`; mapping spec §2 — PROPOSAL |
| Người đọc | primary/secondary | Người sử dụng dịch vụ thư viện; self-service đầy đủ là P1 | Source + PROPOSAL |
| Quản trị viên | primary | Cấu hình, phân quyền, import, audit, duyệt ngoại lệ — **tương đương `Thủ thư` của tài liệu nguồn §2** | Source + PROPOSAL; mapping spec §2 |
| Hệ thống | system | Job trạng thái, queue advancement, outbox, audit | PROPOSAL |
| Kênh thông báo ngoài | secondary | Email/SMS/push sau outbox | OQ-LMP-008 |
| Bộ phận tài chính | stakeholder | Phê duyệt và đối soát financial events | OQ-LMP-005/009 |

> Actor naming tuân theo bảng mapping nguồn↔SRS ở `spec.md` §2. Cấm dùng "Nhân viên" trần trong UC/model.

## Diagram

Use-case diagram chưa được render trong phase này vì artifact `.puml/.svg` là output của `/usecase-diagram`, không phải điều kiện bắt buộc của Phase 4. Ma trận trên là nguồn truy vết UC↔FR↔Screen↔Error↔OQ.

## Relationships

| Type | From | To | Rationale |
|---|---|---|---|
| include | uc-checkout | uc-access-control | Mọi thao tác quầy cần actor đã xác thực và có quyền checkout |
| include | uc-return-renewal | uc-access-control | Return/renewal cần actor hợp lệ |
| include | uc-fine-payment | uc-access-control | Thanh toán/điều chỉnh cần actor hợp lệ và audit |
| extend | uc-checkout | uc-reservation | Khi copy đang held, checkout chỉ hợp lệ nếu reservation đúng lượt |
| extend | uc-return-renewal | uc-damage-lost-found | Return có thể phát sinh báo cáo hư hỏng hoặc lost/found |
| extend | uc-return-renewal | uc-fine-payment | Return quá hạn/hư hỏng có thể tạo fine event |
| extend | uc-admin-import | uc-notification-audit | Import và action nhạy cảm phải ghi audit |

## Nguồn dữ liệu

- FR + Error Matrix: [[docs/features/library-management-platform/srs/library-management-platform-spec.md|SRS spec]]
- Screens: [[docs/features/library-management-platform/srs/library-management-platform-userflow.md|User flow]]
- Open Questions canonical: `library-management-platform-spec.md` Mục 12

