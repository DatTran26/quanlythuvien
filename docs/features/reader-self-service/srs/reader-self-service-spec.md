---
type: srs
feature: reader-self-service
status: draft
updated: 2026-10-12
links:
  - docs/features/reader-self-service/brainstorms/reader-self-service-scope.md
  - docs/_product/prd.md
  - docs/_shared/core-spec.md
  - docs/_shared/domain/library-erd.md
  - docs/_shared/id-crosswalk-lmp.md
---

# reader-self-service — Software Requirements Specification

## 1. Scope

Người đọc tự tra cứu sách, xem thẻ QR, sách đang mượn và lịch sử mượn (R1A); xem công nợ (R1B). Chỉ xem dữ liệu của chính mình.

**Release:** R1A; R1B (công nợ)

**Ngoài phạm vi:** Đặt trước online (`reservation`), gia hạn online (`renewal`), thanh toán online (candidate R3).

## 2. Actors & Stakeholders

| Actor | Loại (người/hệ thống/ngoài) | Mục tiêu | Trong scope? |
|---|---|---|---|
| Người đọc | người | Mượn, trả, theo dõi khoản mượn | Có |
| Hệ thống | hệ thống | Thực thi rule, job, audit, outbox | Có |

Tên vai trò và mapping với tài liệu nguồn xem `docs/_shared/core-spec.md` Mục 2.

## 3. Functional Requirements (FR)

| ID | Title | Description | Priority | Release | Verify by | Source |
|---|---|---|---|---|---|---|
| FR-reader-self-service-001 | Tra cứu sách phía người đọc | Người đọc tra cứu sách theo tên, tác giả, ISBN, thể loại; lọc còn/hết; xem số lượng khả dụng và vị trí kệ. | P0 | R1A | test | Spec cũ (xem id-crosswalk-lmp) |
| FR-reader-self-service-002 | Sách đang mượn | Người đọc xem danh sách phiếu đang mở của mình: tên sách, hạn trả, số ngày còn lại hoặc đã quá hạn. | P0 | R1A | test | Spec cũ (xem id-crosswalk-lmp) |
| FR-reader-self-service-003 | Xem công nợ | Người đọc xem các khoản phạt quá hạn, hư hỏng, mất của mình và trạng thái đã hoặc chưa thanh toán. | P1 | R1B | test | Spec cũ (xem id-crosswalk-lmp) |
| FR-reader-self-service-004 | Thẻ thư viện QR | Người đọc mở mã QR cá nhân để Nhân viên quét khi mượn, trả; chỉ hiện khi tài khoản đã kích hoạt và thẻ còn hạn. | P0 | R1A | test | DEC-SF-02 — SRS cũ thiếu |
| FR-reader-self-service-005 | Lịch sử mượn | Người đọc xem các phiếu đã đóng của mình, lọc theo khoảng thời gian. | P0 | R1A | test | DEC-SF-02 — SRS cũ thiếu |

## 4. Non-Functional Requirements (NFR)

NFR dùng chung (`NFR-core-001..009` — khả dụng, toàn vẹn, phân quyền, riêng tư, audit, quầy dùng được bằng bàn phím, accessibility, log, tương thích) áp dụng cho feature này; xem `docs/_shared/core-spec.md` Mục 4.

## 5. Business Rules

Rule dùng chung áp dụng: BR-core-004 (người đọc chỉ xem dữ liệu của chính mình) (`docs/_shared/core-spec.md` Mục 5).

## 6. Error Matrix

Lỗi dùng chung áp dụng: E-core-002, E-core-008, E-core-009 (`docs/_shared/core-spec.md` Mục 6). Wording xem brainstorm Mục 7.3.

## 7. Success Criteria

Chưa có tiêu chí đo được — bổ sung khi có số liệu nghiệp vụ.

## 8. Data Entities (tóm tắt — chi tiết ở `docs/_shared/domain/library-erd.md`)

`Reader`, `Loan`, `LoanItem`, `BibliographicRecord`, `Copy` (số khả dụng), `Fine`.

## 9. Flows (tóm tắt — chi tiết ở `srs/reader-self-service-flows.md`)

Tra cứu; mở thẻ QR; xem đang mượn, lịch sử; xem công nợ (R1B).

## 10. Screens (tóm tắt — chi tiết ở `srs/reader-self-service-userflow.md` và `html-wireframe/`)

Màn tự phục vụ chưa có trong userflow cũ — thiết kế mới ở user-flow.

## 11. Constraints, Dependencies & Assumptions

__Constraints:__

| Ràng buộc | Source / Owner |
|---|---|
| R1A gồm tra cứu, thẻ QR, đang mượn, lịch sử; R1B gồm công nợ | DEC-SF-02 |

__Dependencies:__

| Phụ thuộc | Owner | Blocks nếu chưa sẵn |
|---|---|---|
| Đăng nhập người đọc | `access-control` | Mọi màn |
| Kích hoạt thẻ | `reader-onboarding` | Thẻ QR |

__Assumptions:__

| Giả định | Invalidate nếu sai |
|---|---|
| Cổng web responsive, khung Mobile 375 | Wireframe |
| Người đọc bị khóa vẫn xem được dữ liệu của mình | FR-reader-self-service-* |

## 12. Open Questions

- [ ] OQ-reader-self-service-001 — Thiết bị và hình thức cổng người đọc (mobile-first hay responsive)? Owner: Product Owner.
- [ ] OQ-reader-self-service-002 — Màn công nợ R1B làm tối thiểu hay chờ cổng đầy đủ? Owner: Product Owner.
- [ ] OQ-reader-self-service-003 — Người đọc bị khóa có đăng nhập cổng được không? Owner: domain approver.
- [ ] OQ-reader-self-service-004 — Ai được xem lịch sử mượn, có tự xóa sau N năm (OQ-12 nguồn)? Owner: pháp chế.
