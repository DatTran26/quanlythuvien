---
type: srs
feature: notification-core
status: draft
updated: 2026-10-08
links:
  - docs/features/notification-core/brainstorms/notification-core-scope.md
  - docs/_product/prd.md
  - docs/_shared/core-spec.md
  - docs/_shared/domain/library-erd.md
  - docs/_shared/id-crosswalk-lmp.md
---

# notification-core — Software Requirements Specification

## 1. Scope

Mọi giao dịch phát sự kiện thông báo vào hàng đợi bền cùng giao dịch; gửi in-app cho mọi sự kiện, thêm email cho sự kiện quan trọng; thử lại, hàng lỗi, in-app luôn giữ; gửi lỗi không làm hỏng giao dịch chính.

**Release:** R1A

**Ngoài phạm vi:** Trung tâm thông báo (`notification-audit-ui`, R1B); SMS, push, Zalo (candidate R3).

## 2. Actors & Stakeholders

| Actor | Loại (người/hệ thống/ngoài) | Mục tiêu | Trong scope? |
|---|---|---|---|
| Hệ thống | hệ thống | Thực thi rule, job, audit, outbox | Có |
| Người đọc | người | Mượn, trả, theo dõi khoản mượn | Có |
| Quản trị viên | người | Quản trị, duyệt ngoại lệ | Có |

Tên vai trò và mapping với tài liệu nguồn xem `docs/_shared/core-spec.md` Mục 2.

## 3. Functional Requirements (FR)

| ID | Title | Description | Priority | Release | Verify by | Source |
|---|---|---|---|---|---|---|
| FR-notification-core-001 | Thông báo bền tối thiểu | Đưa thông báo tạo phiếu, sắp đến hạn, quá hạn, phát sinh phạt, báo cáo hư hỏng mới, khóa/mở tài khoản (và đặt trước từ R2) vào hàng đợi bền; gửi in-app và email cho sự kiện quan trọng; thử lại theo chính sách; không mất khi kênh ngoài lỗi. | P0 | R1A | test | Spec cũ (xem id-crosswalk-lmp) |

## 4. Non-Functional Requirements (NFR)

| ID | Category | Requirement | Priority | Release | Acceptance |
|---|---|---|---|---|---|
| NFR-notification-core-001 | reliability | Outbox notification phải retry có kiểm soát và có trạng thái lỗi/dead-letter để xử lý. | P0 | R1A | Retry simulation + dead-letter evidence |

NFR dùng chung (`NFR-core-001..009` — khả dụng, toàn vẹn, phân quyền, riêng tư, audit, quầy dùng được bằng bàn phím, accessibility, log, tương thích) áp dụng cho feature này; xem `docs/_shared/core-spec.md` Mục 4.

## 5. Business Rules

Rule dùng chung áp dụng: BR-core-005 (thông báo không làm fail giao dịch chính) (`docs/_shared/core-spec.md` Mục 5).

## 6. Error Matrix

| Error ID | Title | Trigger | Severity | Related FR | Screen state | Recovery |
|---|---|---|---|---|---|---|
| E-notification-core-001 | Notification delivery failed | Kênh ngoài timeout/reject | major | FR-notification-core-001 | Notification status/error | Retry theo policy; dead-letter sau ngưỡng |
| E-notification-core-002 | Notification channel unavailable | Outbox/queue lỗi hoặc channel down | major | FR-notification-core-001 | Delivery status degraded | Retry/dead-letter; business event vẫn commit |

Lỗi dùng chung áp dụng: E-core-007 (`docs/_shared/core-spec.md` Mục 6). Wording xem brainstorm Mục 7.3.

## 7. Success Criteria

| ID | Outcome nghiệp vụ | Đo bằng | Mốc đạt |
|---|---|---|---|
| SC-notification-core-01 | Thông báo không làm mất giao dịch | Outbox event tồn tại sau commit | 100% business events có outbox record |

## 8. Data Entities (tóm tắt — chi tiết ở `docs/_shared/domain/library-erd.md`)

`NotificationEvent`.

## 9. Flows (tóm tắt — chi tiết ở `srs/notification-core-flows.md`)

Phát sự kiện → gửi → thử lại → hàng lỗi.

## 10. Screens (tóm tắt — chi tiết ở `srs/notification-core-userflow.md` và `html-wireframe/`)

`notification-status`.

## 11. Constraints, Dependencies & Assumptions

__Constraints:__

| Ràng buộc | Source / Owner |
|---|---|
| Kênh baseline in-app + email | DEC-P2-01 |

__Dependencies:__

| Phụ thuộc | Owner | Blocks nếu chưa sẵn |
|---|---|---|
| Dịch vụ email | Product + technical owner | Gửi email |
| Owner xử lý hàng lỗi | Vận hành | Hàng lỗi |

__Assumptions:__

| Giả định | Invalidate nếu sai |
|---|---|
| Sự kiện quan trọng gửi email: tạo phiếu, quá hạn, phát sinh phạt, đặt trước sẵn sàng, khóa tài khoản | FR-notification-core-001 |

## 12. Open Questions

- [ ] OQ-notification-core-001 — Kênh bắt buộc: chỉ in-app + email hay thêm kênh khác? Owner: Product Owner.
- [ ] OQ-notification-core-002 — Số lần thử lại và khoảng cách thử? Owner: vận hành.
- [ ] OQ-notification-core-003 — Danh sách sự kiện quan trọng gửi email? Owner: Product Owner.
- [ ] OQ-notification-core-004 — Ai xử lý hàng lỗi, có báo Thủ thư trực quầy (DEC-D3-08)? Owner: Thủ thư trưởng.
