---
title: "Phase 3: Domain model và phục hồi state"
status: in-progress
priority: P1
effort: "1 review cycle"
dependencies: [1, 2]
---

# Phase 3: Domain model và phục hồi state

## Mục tiêu

Khôi phục đầy đủ lifecycle, transition và rule cho Copy, Loan, Reservation, Fine và DamageReport trước khi kỹ thuật hoá thành SRS.

## Yêu cầu

- Mỗi transition có current state, trigger, actor, precondition, next state, side effect, reversibility và invalid transition.
- Copy có rule rõ cho non-loanable, maintenance, lost, damaged và found-after-lost.
- Loan bao phủ checkout, renew, overdue, return, lost và concurrency conflict.
- Reservation bao phủ queue, expiry, pickup, cancel và notification failure; `skip/suspend` là proposal/OQ, chỉ thêm nếu có domain approval.
- Financial control phải dùng append-only event model; partial payment là proposal/OQ. Mô hình cuối phải phủ các event được duyệt như assessment, payment, waiver, adjustment, reversal/refund và reconciliation.
- DamageReport liên kết với return, Copy condition và repair disposition.

## File tác động

- Sửa `docs/features/library-management-platform/brainstorms/product-roadmap-baseline.md`.
- Sửa `docs/_product/decision-register.md`.
- Tạo `docs/features/library-management-platform/domain/lifecycle-inventory.md` làm artifact bền với state/transition ID, source ref, proposal flag và approval status.
- Không tạo model SRS cuối ở phase này; state/flow/ERD chính thức thuộc Phase 4 và consume lifecycle inventory này.

## Các bước thực hiện

1. Lập transition inventory cho 5 aggregate từ PRD, roadmap và tài liệu nguồn.
2. Đối chiếu mỗi transition với actor, business rule và release owner.
3. Bổ sung error/edge: concurrent checkout, damaged return, repair + reservation queue, fine adjustment, lost-found.
4. Đặc tả transaction/idempotency: multi-copy checkout commit set all-or-nothing; operation key và query-by-operation recovery; audit trong transaction, notification qua durable outbox/retry.
5. Đặc tả atomic boundary cho Reservation + held Copy + queue head bằng allowed-source-state/CAS, unique active hold và idempotent cancel/expire/fulfill.
6. Đặc tả ledger, balance formula, receipt uniqueness, approval/SoD, cashier reconciliation và compensation khi lost→found.
7. Đánh dấu transition chưa quyết định và tạo/cập nhật decision ID thay vì tự chốt.
8. Review chéo tính toàn vẹn: không có orphan state, dead end hoặc side effect không có owner.

## Todo

- [x] Hoàn thiện 5 lifecycle table.
- [x] Chốt rule non-loanable và availability.
- [x] Phân tích transition bất hợp lệ và phục hồi.
- [x] Khoá atomicity/idempotency cho checkout và reservation queue.
- [x] Khoá append-only financial ledger và lost-found compensation.
- [x] Liên kết open rule với decision register.
- [x] Review consistency giữa các aggregate.

## Verification

- Với mỗi state, xác định được đường vào, đường ra hoặc lý do terminal.
- Mọi side effect (fine, notification, audit, queue advancement) có trigger và failure behavior.
- Không có hai aggregate sở hữu cùng một quyết định trạng thái mà không có source of truth.

## Kịch bản kiểm tra tối thiểu

| Kịch bản | Điểm cần chứng minh |
|---------|---------------------|
| Hai thủ thư checkout cùng một Copy | Chỉ một Loan thành công; giao dịch còn lại nhận conflict rõ |
| Trả sách bị hỏng khi có queue | Copy không được pickup cho tới disposition hợp lệ |
| Fine được điều chỉnh sau thanh toán một phần | Balance và audit trail vẫn nhất quán |
| Copy báo mất rồi được tìm thấy | Có transition phục hồi và xử lý fine/availability |
| Notification pickup thất bại | Reservation không tự mất; có retry/escalation rule |

## Rủi ro và an toàn

- Transition tài chính/phân quyền cần audit trail bất biến.
- Không dùng “available” như trạng thái suy diễn mơ hồ; ghi rõ trạng thái lưu và trạng thái tính toán.

## Tiêu chí hoàn tất

- [x] Năm lifecycle table đầy đủ và nhất quán.
- [x] Không còn orphan/dead-end state ngoài terminal hợp lệ.
- [x] Open rule có owner, approver và due gate.
- [x] Phase 4 có input đủ để sinh state diagram, flow và ERD.

## Bước kế tiếp

Kỹ thuật hoá baseline, rules và lifecycle thành SRS Core + Models ở Phase 4.
