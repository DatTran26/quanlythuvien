---
type: srs
feature: lost-handling
status: draft
updated: 2026-10-08
links:
  - docs/features/lost-handling/brainstorms/lost-handling-scope.md
  - docs/_product/prd.md
  - docs/_shared/core-spec.md
  - docs/_shared/domain/library-erd.md
  - docs/_shared/id-crosswalk-lmp.md
---

# lost-handling — Software Requirements Specification

## 1. Scope

Ghi nhận mất sách: phiếu và bản sao chuyển Mất, ghi nghĩa vụ bồi thường (R1A). Tìm lại sau khi mất: đối soát nghĩa vụ đã ghi trước khi bản sao về kho (R1B).

**Release:** R1A (ghi nhận mất); R1B (tìm lại)

**Ngoài phạm vi:** Mất sách khỏi kệ khi không đang mượn.

## 2. Actors & Stakeholders

| Actor | Loại (người/hệ thống/ngoài) | Mục tiêu | Trong scope? |
|---|---|---|---|
| Thủ thư | người | Vận hành quầy | Có |
| Người đọc | người | Mượn, trả, theo dõi khoản mượn | Có |
| Bộ phận tài chính | stakeholder | Chính sách phạt, đối soát | Có như stakeholder |
| Hệ thống | hệ thống | Thực thi rule, job, audit, outbox | Có |

Tên vai trò và mapping với tài liệu nguồn xem `docs/_shared/core-spec.md` Mục 2.

## 3. Functional Requirements (FR)

| ID | Title | Description | Priority | Release | Verify by | Source |
|---|---|---|---|---|---|---|
| FR-lost-handling-001 | Ghi nhận mất sách | Thủ thư ghi nhận mất trên phiếu đang mở: trong một giao dịch, phiếu và bản sao chuyển Mất, ghi nghĩa vụ bồi thường, audit, thông báo người đọc; phiếu Mất không mở lại, ghi nhận lặp trả kết quả gốc. | P0 | R1A | test | Spec cũ (xem id-crosswalk-lmp) |
| FR-lost-handling-002 | Tìm lại sau khi mất | Khi tìm lại bản sao đã Mất, Thủ thư kiểm tra vật lý; nghĩa vụ đã ghi không tự xóa mà được đối soát (đảo nếu chưa thu, hoàn nếu đã thu theo chính sách) trước khi bản sao về Sẵn sàng; chưa có duyệt tài chính thì chỉ ghi 'đã tìm thấy — chờ đối soát'. | P1 | R1B | test | Spec cũ (xem id-crosswalk-lmp) |

## 4. Non-Functional Requirements (NFR)

NFR dùng chung (`NFR-core-001..009` — khả dụng, toàn vẹn, phân quyền, riêng tư, audit, quầy dùng được bằng bàn phím, accessibility, log, tương thích) áp dụng cho feature này; xem `docs/_shared/core-spec.md` Mục 4.

## 5. Business Rules

| ID | Rule | Trigger | Implements FR | Source |
|---|---|---|---|---|
| BR-lost-handling-001 | Lost copy khi tìm lại phải qua reconciliation trước khi trở `available`; không tự xóa nghĩa vụ tài chính đã ghi. | Mark found | FR-lost-handling-001 | Spec cũ (xem id-crosswalk-lmp) |

Rule dùng chung áp dụng: BR-core-002, BR-core-003 (`docs/_shared/core-spec.md` Mục 5).

## 6. Error Matrix

Lỗi dùng chung áp dụng: E-core-007, E-core-008 (`docs/_shared/core-spec.md` Mục 6). Wording xem brainstorm Mục 7.3.

## 7. Success Criteria

| ID | Outcome nghiệp vụ | Đo bằng | Mốc đạt |
|---|---|---|---|
| SC-lost-handling-01 | Phiếu sách mất luôn có đường kết thúc | Kiểm tra phiếu mở quá hạn lâu | 100% phiếu sách mất được đóng ở trạng thái Mất |

## 8. Data Entities (tóm tắt — chi tiết ở `docs/_shared/domain/library-erd.md`)

`Loan`, `Copy`, `Fine`, `FinancialEvent`, `AuditEvent`.

## 9. Flows (tóm tắt — chi tiết ở `srs/lost-handling-flows.md`)

Ghi nhận mất; tìm lại và đối soát (R1B).

## 10. Screens (tóm tắt — chi tiết ở `srs/lost-handling-userflow.md` và `html-wireframe/`)

`lost-found`.

## 11. Constraints, Dependencies & Assumptions

__Constraints:__

| Ràng buộc | Source / Owner |
|---|---|
| Ghi nhận mất tối thiểu ở R1A | DEC-P2-07, DEC-SF-06 |
| Nghĩa vụ đã ghi không tự xóa khi tìm lại | DEC-D3-05 |

__Dependencies:__

| Phụ thuộc | Owner | Blocks nếu chưa sẵn |
|---|---|---|
| Chính sách đảo/hoàn | Finance | FR-lost-handling-002 |
| Hàng đợi thông báo | `notification-core` | Thông báo cho người đọc |
| Ghi audit cùng giao dịch | `ops-foundation` | Mọi thao tác ghi |

__Assumptions:__

| Giả định | Invalidate nếu sai |
|---|---|
| Chỉ ghi nhận mất trên phiếu đang mở | Phạm vi feature |

## 12. Open Questions

- [ ] OQ-lost-handling-001 — Mức bồi thường mất và phí xử lý chính thức (mặc định nguồn 100% giá sách + phí)? Owner: Thủ thư trưởng.
- [ ] OQ-lost-handling-002 — Mất sách khỏi kệ khi không đang mượn xử lý ở đâu? Owner: domain approver.
