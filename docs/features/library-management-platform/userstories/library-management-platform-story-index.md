---
type: userstory-index
feature: library-management-platform
status: draft
updated: 2026-10-08
links:
  - docs/features/library-management-platform/srs/library-management-platform-spec.md
  - docs/features/library-management-platform/srs/library-management-platform-userflow.md
  - docs/features/library-management-platform/usecases/library-management-platform-usecase-index.md
---

# Hệ thống Quản lý Thư viện — User Stories Index

> Bộ backlog draft được xây từ SRS đang ở trạng thái `draft`. Mọi story cần refinement và Acceptance Criteria được duyệt trước khi đạt Definition of Ready.

## User Stories

| # | ID | Title | Persona | Covers FR | UC | Screens | Priority | Status | Jira | Updated |
|---|----|-------|---------|-----------|----|---------|----------|--------|------|---------|
| 1 | [US-001](us-001.md) | Truy cập đúng không gian làm việc theo vai trò | Người dùng hệ thống | FR-LMP-006 | [[docs/features/library-management-platform/usecases/uc-access-control.md|access-control]] | access-login, dashboard-home | P0 | draft | — | 2026-10-08 |
| 2 | [US-002](us-002.md) | Xác thực lại và tiếp tục an toàn khi phiên hết hạn | Người dùng đã đăng nhập | FR-LMP-007 | [[docs/features/library-management-platform/usecases/uc-access-control.md|access-control]] | session-expired, dashboard-home | P0 | draft | — | 2026-10-08 |
| 3 | [US-003](us-003.md) | Duy trì hồ sơ thư mục sách để kho có dữ liệu chuẩn | Quản trị viên | FR-LMP-001 | [[docs/features/library-management-platform/usecases/uc-catalog-admin.md|catalog-admin]] | catalog-search, bibliographic-detail, bibliographic-form | P0 | draft | — | 2026-10-08 |
| 4 | [US-004](us-004.md) | Đăng ký bản sao và cấp mã QR định vị duy nhất | Quản trị viên | FR-LMP-002, FR-LMP-026 | [[docs/features/library-management-platform/usecases/uc-catalog-admin.md|catalog-admin]] | bibliographic-detail, copy-inventory, copy-form | P0 | draft | — | 2026-10-08 |
| 5 | [US-005](us-005.md) | Tra cứu đầu sách và khả dụng thực tế | Người tra cứu | FR-LMP-003 | [[docs/features/library-management-platform/usecases/uc-catalog-admin.md|catalog-admin]] | catalog-search, bibliographic-detail | P0 | draft | — | 2026-10-08 |
| 6 | [US-006](us-006.md) | Tạo, kích hoạt và cập nhật hồ sơ người đọc | Nhân viên quản lý người đọc | FR-LMP-004 | [[docs/features/library-management-platform/usecases/uc-reader-admin.md|reader-admin]] | reader-list, reader-form, reader-detail | P0 | draft | — | 2026-10-08 |
| 7 | [US-007](us-007.md) | Cấu hình quy định có hiệu lực theo thời điểm | Quản trị viên | FR-LMP-021 | [[docs/features/library-management-platform/usecases/uc-admin-import.md|admin-import]] | admin-config | P0 | draft | — | 2026-10-08 |
| 8 | [US-008](us-008.md) | Kiểm tra file nhập liệu bằng dry-run trước khi ghi | Quản trị viên | FR-LMP-022 | [[docs/features/library-management-platform/usecases/uc-admin-import.md|admin-import]] | import-upload, import-report | P0 | draft | — | 2026-10-08 |
| 9 | [US-009](us-009.md) | Commit và đối soát một lô import nguyên tử | Quản trị viên | FR-LMP-022, FR-LMP-020, FR-LMP-026 | [[docs/features/library-management-platform/usecases/uc-admin-import.md|admin-import]] | import-upload, import-report | P0 | draft | — | 2026-10-08 |
| 10 | [US-010](us-010.md) | Ghi audit đồng giao dịch cho hành động nhạy cảm | Người kiểm soát vận hành | FR-LMP-020 | [[docs/features/library-management-platform/usecases/uc-notification-audit.md|notification-audit]] | audit-log, history-timeline | P0 | draft | — | 2026-10-08 |
| 11 | [US-011](us-011.md) | Hoàn tất phiếu mượn nhiều bản sao nguyên tử | Thủ thư quầy | FR-LMP-008, FR-LMP-009, FR-LMP-026 | [[docs/features/library-management-platform/usecases/uc-checkout.md|checkout]] | circulation-desk, checkout-scan, checkout-review, checkout-conflict | P0 | draft | — | 2026-10-08 |
| 12 | [US-012](us-012.md) | Nhận trả và đóng nghĩa vụ mượn đúng thứ tự | Thủ thư quầy | FR-LMP-010, FR-LMP-014 | [[docs/features/library-management-platform/usecases/uc-return-renewal.md|return-renewal]] | return-scan, return-result | P0 | draft | — | 2026-10-08 |
| 13 | [US-013](us-013.md) | Ghi nhận phạt quá hạn một lần và truy vết được | Hệ thống vận hành | FR-LMP-014 | [[docs/features/library-management-platform/usecases/uc-return-renewal.md|return-renewal]] | return-result, fine-list, fine-detail | P0 | draft | — | 2026-10-08 |
| 14 | [US-014](us-014.md) | Thu tiền phạt tiền mặt không ghi trùng | Thủ thư quầy | FR-LMP-015 | [[docs/features/library-management-platform/usecases/uc-fine-payment.md|fine-payment]] | fine-list, fine-detail, fine-payment | P0 | draft | — | 2026-10-08 |
| 15 | [US-015](us-015.md) | Báo hư hỏng và cách ly bản sao khỏi lưu thông | Thủ thư quầy | FR-LMP-017 | [[docs/features/library-management-platform/usecases/uc-damage-lost-found.md|damage-lost-found]] | damage-report-form, damage-report-detail | P0 | draft | — | 2026-10-08 |
| 16 | [US-016](us-016.md) | Quyết định hướng xử lý báo cáo hư hỏng | Quản trị viên | FR-LMP-017 | [[docs/features/library-management-platform/usecases/uc-damage-lost-found.md|damage-lost-found]] | damage-report-detail | P0 | draft | — | 2026-10-08 |
| 17 | [US-017](us-017.md) | Ghi nhận mất sách và nghĩa vụ bồi thường tối thiểu | Thủ thư quầy | FR-LMP-018, FR-LMP-014 | [[docs/features/library-management-platform/usecases/uc-damage-lost-found.md|damage-lost-found]] | lost-found, fine-detail | P1 | draft | — | 2026-10-08 |
| 18 | [US-018](us-018.md) | Bảo đảm thông báo không làm mất giao dịch chính | Người vận hành hệ thống | FR-LMP-019 | [[docs/features/library-management-platform/usecases/uc-notification-audit.md|notification-audit]] | notification-status | P0 | draft | — | 2026-10-08 |

**Status values:** `draft` / `in-review` / `revisions` / `approved` / `shipped` / `stale`.

**Priority note:** US-017 giữ P1 theo FR-LMP-018; roadmap chỉ đang đề xuất minimum lost handling ở R1A/P0 và chưa được duyệt.

## Coverage P0

17/17 FR có priority P0 trong SRS được phủ bởi ít nhất một story. FR-LMP-028 không có story vì chỉ là capability envelope R3-candidate, chưa phải yêu cầu build.

## Links upstream

- [[docs/features/library-management-platform/srs/library-management-platform-spec.md|SRS spec]]
- [[docs/features/library-management-platform/srs/library-management-platform-userflow.md|User flow]]
- [[docs/features/library-management-platform/usecases/library-management-platform-usecase-index.md|Use cases index]]

<!-- Licensed BA-Kit content; license proof retained outside version control. -->

