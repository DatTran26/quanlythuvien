---
type: srs
feature: reservation
status: draft
updated: 2026-10-08
links:
  - docs/features/reservation/brainstorms/reservation-scope.md
  - docs/_product/prd.md
  - docs/_shared/core-spec.md
  - docs/_shared/domain/library-erd.md
  - docs/_shared/id-crosswalk-lmp.md
---

# reservation — Software Requirements Specification

## 1. Scope

Đặt trước khi đầu sách hết bản khả dụng; hàng chờ theo thứ tự thời gian; giữ bản sao cho người đầu hàng có hạn; hết hạn chuyển người kế tiếp; hủy; nhận sách qua quầy mượn; đặt và hủy được từ cổng người đọc.

**Release:** R2

**Ngoài phạm vi:** Bỏ lượt, tạm hoãn (DEC-D3-03).

## 2. Actors & Stakeholders

| Actor | Loại (người/hệ thống/ngoài) | Mục tiêu | Trong scope? |
|---|---|---|---|
| Người đọc | người | Tự phục vụ | Có |
| Thủ thư | người | Vận hành quầy | Có |
| Hệ thống | hệ thống | Thực thi rule, job, audit, outbox | Có |

Tên vai trò và mapping với tài liệu nguồn xem `docs/_shared/core-spec.md` Mục 2.

## 3. Functional Requirements (FR)

| ID | Title | Description | Priority | Release | Verify by | Source |
|---|---|---|---|---|---|---|
| FR-reservation-001 | Đặt trước và hàng đợi | Tạo/hủy đặt trước, duy trì thứ tự hàng đợi, chuyển bản sao phù hợp sang giữ chỗ khi đến lượt. | P1 | R2 | test | Spec cũ (xem id-crosswalk-lmp) |
| FR-reservation-002 | Hết hạn giữ chỗ | Khi hết thời hạn nhận, hệ thống hủy lượt giữ và đẩy người kế tiếp lên đầu hàng đợi một cách nguyên tử. | P1 | R2 | test | Spec cũ (xem id-crosswalk-lmp) |
| FR-reservation-003 | Đặt trước trên cổng người đọc | Người đọc tạo, hủy và theo dõi đặt trước của mình trên cổng người đọc (SRC-FR-R07, SRC-FR-R08). | P1 | R2 | test | Spec cũ (xem id-crosswalk-lmp) |

## 4. Non-Functional Requirements (NFR)

NFR dùng chung (`NFR-core-001..009` — khả dụng, toàn vẹn, phân quyền, riêng tư, audit, quầy dùng được bằng bàn phím, accessibility, log, tương thích) áp dụng cho feature này; xem `docs/_shared/core-spec.md` Mục 4.

## 5. Business Rules

| ID | Rule | Trigger | Implements FR | Source |
|---|---|---|---|---|
| BR-reservation-001 | Reservation queue theo thứ tự tạo hợp lệ; khi copy phù hợp về kho, transition `available→held` phải nguyên tử với `queued→ready_for_pickup`. | Copy return / queue job | FR-reservation-001/FR-reservation-002 | Spec cũ (xem id-crosswalk-lmp) |
| BR-reservation-002 | Hold hết hạn thì reservation hiện tại `expired/cancelled`, copy quay `available`, queue advance atomically. | Expiry job | FR-reservation-002 | Spec cũ (xem id-crosswalk-lmp) |

Rule dùng chung áp dụng: BR-core-001, BR-core-003, BR-core-005 (`docs/_shared/core-spec.md` Mục 5).

## 6. Error Matrix

| Error ID | Title | Trigger | Severity | Related FR | Screen state | Recovery |
|---|---|---|---|---|---|---|
| E-reservation-001 | Reservation unavailable | Không có copy phù hợp hoặc reservation bị hủy/hết hạn | major | FR-reservation-001/FR-reservation-002 | Queue/error panel | Cho hủy, đổi edition/copy hoặc quay lại |

Lỗi dùng chung áp dụng: E-core-004, E-core-005, E-core-006, E-core-007, E-core-008 (`docs/_shared/core-spec.md` Mục 6). Wording xem brainstorm Mục 7.3.

## 7. Success Criteria

| ID | Outcome nghiệp vụ | Đo bằng | Mốc đạt |
|---|---|---|---|
| SC-reservation-01 | Đặt trước công bằng và có kiểm soát | Thứ tự queue, hold expiry, notification status | 100% P0 reservation tests pass; release boundary chờ duyệt |

## 8. Data Entities (tóm tắt — chi tiết ở `docs/_shared/domain/library-erd.md`)

`Reservation`, `Copy`, `Loan`, `NotificationEvent`, `PolicyConfig`.

## 9. Flows (tóm tắt — chi tiết ở `srs/reservation-flows.md`)

Đặt trước → hàng chờ → giữ chỗ → nhận sách hoặc hết hạn → chuyển người kế tiếp.

## 10. Screens (tóm tắt — chi tiết ở `srs/reservation-userflow.md` và `html-wireframe/`)

`reservation-search`, `reservation-form`, `reservation-queue`, `reservation-pickup`. Nhận sách chuyển sang `checkout-review` — xem `docs/_shared/navigation-map.md`.

## 11. Constraints, Dependencies & Assumptions

__Constraints:__

| Ràng buộc | Source / Owner |
|---|---|
| Một release owner duy nhất R2 | DEC-P2-05 |
| Job hết hạn giữ mỗi 15 phút | Nguồn §8 |

__Dependencies:__

| Phụ thuộc | Owner | Blocks nếu chưa sẵn |
|---|---|---|
| Luồng trả bật điểm quyết định D5 | `return-handling` | Phân bổ hàng chờ |
| Mượn sách | `checkout` | Nhận sách |
| Hàng đợi thông báo | `notification-core` | Thông báo |
| Tham số quy định | `policy-config` | Giới hạn và thời hạn |

__Assumptions:__

| Giả định | Invalidate nếu sai |
|---|---|
| Hàng chờ theo đầu sách | BR-reservation-001 |
| Không có ân hạn khi đến nhận sát hạn | FR-reservation-002 |

## 12. Open Questions

- [ ] OQ-reservation-001 — Đặt trước thuộc R2 (DEC-P2-05) cần Product Owner duyệt. Owner: Product Owner.
- [ ] OQ-reservation-002 — Giới hạn đặt trước và thời gian giữ chính thức (mặc định nguồn 3 yêu cầu / 48 giờ)? Owner: Thủ thư trưởng.
- [ ] OQ-reservation-003 — Có thời gian ân hạn khi đến nhận sát hạn? Owner: Thủ thư trưởng.
