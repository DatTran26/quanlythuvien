---
type: srs
feature: notification-audit-ui
status: draft
updated: 2026-10-12
links:
  - docs/features/notification-audit-ui/brainstorms/notification-audit-ui-scope.md
  - docs/_product/prd.md
  - docs/_shared/core-spec.md
  - docs/_shared/domain/library-erd.md
  - docs/_shared/id-crosswalk-lmp.md
---

# notification-audit-ui — Software Requirements Specification

## 1. Scope

Trung tâm thông báo cho mọi vai trò (đã đọc, chưa đọc); nhật ký audit chỉ đọc và dòng thời gian lịch sử cho Thủ thư; che dữ liệu nhạy cảm theo quyền.

**Release:** R1B

**Ngoài phạm vi:** Ghi audit (`ops-foundation`); gửi thông báo (`notification-core`).

## 2. Actors & Stakeholders

| Actor | Loại (người/hệ thống/ngoài) | Mục tiêu | Trong scope? |
|---|---|---|---|
| Người đọc | người | Tự phục vụ | Có |
| Nhân viên | người | Vận hành quầy | Có |
| Thủ thư | người | Quản trị, duyệt ngoại lệ | Có |
| Bảo mật/pháp chế | stakeholder | Retention, quyền dữ liệu | Có như stakeholder |

Tên vai trò và mapping với tài liệu nguồn xem `docs/_shared/core-spec.md` Mục 2.

## 3. Functional Requirements (FR)

| ID | Title | Description | Priority | Release | Verify by | Source |
|---|---|---|---|---|---|---|
| FR-notification-audit-ui-001 | Trung tâm thông báo | Mọi vai trò xem danh sách thông báo của chính mình, mới nhất trước, đánh dấu đã đọc, xem số chưa đọc (SRC-FR-C04). | P1 | R1B | test | Spec cũ (xem id-crosswalk-lmp) |
| FR-notification-audit-ui-002 | Xem nhật ký audit | Thủ thư tra cứu nhật ký audit theo người làm, đối tượng, thời gian; chỉ đọc; che trường nhạy cảm theo quyền. | P1 | R1B | test | Spec cũ (xem id-crosswalk-lmp) |
| FR-notification-audit-ui-003 | Truy vết lịch sử nghiệp vụ | Xem lịch sử trạng thái và sự kiện liên quan của bản sao, phiếu mượn, đặt trước, tiền phạt và báo cáo hư hỏng. | P1 | R1B | demo/test | Spec cũ (xem id-crosswalk-lmp) |

## 4. Non-Functional Requirements (NFR)

NFR dùng chung (`NFR-core-001..009` — khả dụng, toàn vẹn, phân quyền, riêng tư, audit, quầy dùng được bằng bàn phím, accessibility, log, tương thích) áp dụng cho feature này; xem `docs/_shared/core-spec.md` Mục 4.

## 5. Business Rules

Rule dùng chung áp dụng: BR-core-004 (`docs/_shared/core-spec.md` Mục 5).

## 6. Error Matrix

Lỗi dùng chung áp dụng: E-core-002, E-core-009 (`docs/_shared/core-spec.md` Mục 6). Wording xem brainstorm Mục 7.3.

## 7. Success Criteria

Chưa có tiêu chí đo được — bổ sung khi có số liệu nghiệp vụ.

## 8. Data Entities (tóm tắt — chi tiết ở `docs/_shared/domain/library-erd.md`)

`NotificationEvent`, `AuditEvent`; lịch sử trạng thái của `Copy`, `Loan`, `Reservation`, `Fine`, `DamageReport`.

## 9. Flows (tóm tắt — chi tiết ở `srs/notification-audit-ui-flows.md`)

Mở trung tâm thông báo; tra cứu nhật ký và dòng thời gian.

## 10. Screens (tóm tắt — chi tiết ở `srs/notification-audit-ui-userflow.md` và `html-wireframe/`)

`audit-log`, `history-timeline`, màn trung tâm thông báo (mới — DEC-SF-09).

## 11. Constraints, Dependencies & Assumptions

__Constraints:__

| Ràng buộc | Source / Owner |
|---|---|
| Trung tâm thông báo ở R1B | DEC-P2-01, DEC-SF-09 |
| Audit viewer ở R1B, chỉ đọc | DEC-P2-06 |

__Dependencies:__

| Phụ thuộc | Owner | Blocks nếu chưa sẵn |
|---|---|---|
| Thông báo đã gửi | `notification-core` | Trung tâm thông báo |
| Audit đã ghi | `ops-foundation` | Nhật ký |

__Assumptions:__

| Giả định | Invalidate nếu sai |
|---|---|
| Chỉ Thủ thư xem nhật ký audit | FR-notification-audit-ui-002 |

## 12. Open Questions

- [ ] OQ-notification-audit-ui-001 — Có cho đánh dấu lại 'chưa đọc' không, giữ thông báo bao lâu? Owner: Product Owner.
