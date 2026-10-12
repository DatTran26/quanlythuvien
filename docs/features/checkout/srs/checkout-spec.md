---
type: srs
feature: checkout
status: draft
updated: 2026-10-12
links:
  - docs/features/checkout/brainstorms/checkout-scope.md
  - docs/_product/prd.md
  - docs/_shared/core-spec.md
  - docs/_shared/domain/library-erd.md
  - docs/_shared/id-crosswalk-lmp.md
---

# checkout — Software Requirements Specification

## 1. Scope

Nhân viên quét thẻ và nhiều sách; hệ thống kiểm điều kiện người đọc và từng cuốn ngay khi quét, ghi cả giỏ trong một giao dịch (tất cả hoặc không cuốn nào), chống ghi trùng và tranh chấp giữa hai quầy, rồi in biên nhận mượn.

**Release:** R1A

**Ngoài phạm vi:** Nhận sách đặt trước (bật ở R2 cùng `reservation`); cho mượn ngoại lệ khi người đọc không đủ điều kiện.

## 2. Actors & Stakeholders

| Actor | Loại (người/hệ thống/ngoài) | Mục tiêu | Trong scope? |
|---|---|---|---|
| Nhân viên | người | Vận hành quầy | Có |
| Người đọc | người | Mượn, trả, theo dõi khoản mượn | Có |
| Hệ thống | hệ thống | Thực thi rule, job, audit, outbox | Có |
| Thủ thư trưởng | stakeholder | Duyệt quy định và go-live | Có như stakeholder |

Tên vai trò và mapping với tài liệu nguồn xem `docs/_shared/core-spec.md` Mục 2.

## 3. Functional Requirements (FR)

| ID | Title | Description | Priority | Release | Verify by | Source |
|---|---|---|---|---|---|---|
| FR-checkout-001 | Mượn nhiều bản sao nguyên tử | Một phiếu mượn có nhiều bản sao chỉ thành công khi toàn bộ điều kiện hợp lệ; một bản sao lỗi làm cả giao dịch rollback. | P0 | R1A | test | Spec cũ (xem id-crosswalk-lmp) |
| FR-checkout-002 | Idempotency và concurrency mượn | Lặp submit/checkout cùng request không tạo phiếu trùng; hai giao dịch tranh cùng bản sao chỉ một giao dịch thắng. | P0 | R1A | test/concurrency | Spec cũ (xem id-crosswalk-lmp) |
| FR-checkout-003 | In biên nhận mượn | Sau khi ghi phiếu thành công, hệ thống in biên nhận gộp các cuốn theo thời điểm tạo, gồm: tên thư viện, mã phiếu, ngày giờ mượn, tên và mã thẻ người đọc, danh sách cuốn (tên sách, mã bản sao) kèm hạn trả từng cuốn, Nhân viên thực hiện. | P0 | R1A | demo/test | Brainstorm checkout OQ-2 (2026-10-08) |

## 4. Non-Functional Requirements (NFR)

NFR dùng chung (`NFR-core-001..009` — khả dụng, toàn vẹn, phân quyền, riêng tư, audit, quầy dùng được bằng bàn phím, accessibility, log, tương thích) áp dụng cho feature này; xem `docs/_shared/core-spec.md` Mục 4.

## 5. Business Rules

| ID | Rule | Trigger | Implements FR | Source |
|---|---|---|---|---|
| BR-checkout-001 | Checkout nhiều bản sao là all-or-nothing; một điều kiện fail thì không bản sao nào được ghi mượn. | Submit checkout | FR-checkout-001 | Spec cũ (xem id-crosswalk-lmp) |
| BR-checkout-002 | Copy chỉ được mượn từ trạng thái `available`; reservation-held copy chỉ checkout được cho reservation đúng lượt. | Checkout | FR-checkout-001/FR-reservation-001 | Spec cũ (xem id-crosswalk-lmp) |

Rule dùng chung áp dụng: BR-core-001 (điều kiện người đọc: tối đa 5 cuốn, nợ từ 50.000đ chặn — DEC-SF-10), BR-core-003, BR-core-005 (`docs/_shared/core-spec.md` Mục 5).

## 6. Error Matrix

| Error ID | Title | Trigger | Severity | Related FR | Screen state | Recovery |
|---|---|---|---|---|---|---|
| E-checkout-001 | Copy unavailable | Copy không ở trạng thái hợp lệ để mượn | major | FR-checkout-001/FR-reservation-001 | Checkout review error | Loại item khỏi phiếu hoặc chọn copy khác |

Lỗi dùng chung áp dụng: E-core-001, E-core-003, E-core-004, E-core-005, E-core-006, E-core-007, E-core-008 (`docs/_shared/core-spec.md` Mục 6). Wording xem brainstorm Mục 7.3.

## 7. Success Criteria

| ID | Outcome nghiệp vụ | Đo bằng | Mốc đạt |
|---|---|---|---|
| SC-checkout-01 | Hoàn tất mượn/trả tại quầy nhanh và chính xác — phần mượn | Thời gian trung bình/giao dịch, tỷ lệ lỗi state | Ngưỡng cuối cùng OQ-policy-config-001; proposal: ≤2 phút/giao dịch |
| SC-checkout-02 | Không mất/trùng quyền sở hữu bản sao khi concurrency | Kiểm thử đồng thời và audit reconcile | 100% P0 concurrency tests pass |

## 8. Data Entities (tóm tắt — chi tiết ở `docs/_shared/domain/library-erd.md`)

`Loan`, `LoanItem`, `Copy`, `Reader`, `AuditEvent`, `NotificationEvent`. Quan hệ phiếu cha/dòng còn mở (`OQ-core-004`).

## 9. Flows (tóm tắt — chi tiết ở `srs/checkout-flows.md`)

Mượn tại quầy: quét thẻ (D1) → quét từng cuốn (D2) → rà soát → xác nhận một giao dịch (D3 trùng, D4 tranh chấp, D5 audit) → in biên nhận.

## 10. Screens (tóm tắt — chi tiết ở `srs/checkout-userflow.md` và `html-wireframe/`)

`circulation-desk`, `checkout-scan`, `checkout-review`, `checkout-conflict`. Nhận sách đặt trước đến từ `reservation-pickup` (R2) — xem `docs/_shared/navigation-map.md`.

## 11. Constraints, Dependencies & Assumptions

__Constraints:__

| Ràng buộc | Source / Owner |
|---|---|
| Không cho mượn ngoại lệ | Brainstorm checkout (2026-10-08) |
| Hạn mức 5 cuốn, hạn mượn 14 ngày, ngưỡng nợ 50.000đ | DEC-SF-10 |
| Chặn mượn vì nợ chỉ bật khi job quá hạn và sổ phạt đã chạy | DEC-P2-02 |

__Dependencies:__

| Phụ thuộc | Owner | Blocks nếu chưa sẵn |
|---|---|---|
| Bản sao có QR | `copy-inventory` | Quét sách |
| Tài khoản kích hoạt | `reader-onboarding` | Quét thẻ |
| Tham số quy định | `policy-config` | Hạn mức, hạn mượn, mức phạt |
| Sổ phạt | `overdue-fines` | Điều kiện nợ |
| Ghi audit cùng giao dịch | `ops-foundation` | Mọi thao tác ghi |
| Hàng đợi thông báo | `notification-core` | Thông báo cho người đọc |

__Assumptions:__

| Giả định | Invalidate nếu sai |
|---|---|
| Mỗi cuốn một phiếu, in gộp theo thời điểm tạo (OQ-06 nguồn) | FR-checkout-003, ERD Loan/LoanItem |

## 12. Open Questions

- [ ] OQ-checkout-001 — Khổ giấy và loại máy in biên nhận tại quầy? Owner: vận hành.
