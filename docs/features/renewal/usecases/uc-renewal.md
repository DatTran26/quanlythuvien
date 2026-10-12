---
type: usecase
feature: renewal
status: draft
updated: 2026-10-12
links:
  - docs/features/renewal/usecases/renewal-usecase-index.md
  - docs/features/renewal/srs/renewal-spec.md
  - docs/_shared/domain/lifecycle-inventory.md
---

# Use Case: Gia hạn (uc-renewal)

> Scope: renewal · Level: sea
> Screens: `renewal-result` · Release: R1B (FR-renewal-001 gia hạn tại quầy và online)
> **Lưu ý nhãn/Open:** flow trả chi tiết (§2.4 lifecycle-inventory) là **PROPOSAL — DEC-D3-02**; thứ tự "đóng Loan + tính phạt trước, quyết định trạng thái Copy sau" là **FACT**; nhánh D5 phân bổ hàng chờ chỉ hoạt động từ **R2** — R1A queue luôn rỗng (DEC-P2-05); renewal limit, hold expiry, fine threshold là **PROPOSAL — OQ-policy-config-001** (baseline đề xuất: gia hạn 1 lần +7 ngày — chưa chốt).

## Primary Actor

Nhân viên (gia hạn thay người đọc tại quầy). Người đọc (gia hạn online trên cổng người đọc — R1B, DEC-SF-02).

## Stakeholders & Interests

| Stakeholder | Interest |
|-------------|----------|
| Người đọc | Gia hạn được khi đủ điều kiện; bị từ chối thì biết lý do cụ thể |
| Người đọc đang chờ đặt trước (R2) | Không bị chặn lượt vì người khác gia hạn |

## Trigger

Nhân viên hoặc người đọc yêu cầu gia hạn một phiếu đang mở.

## Preconditions

- Người thao tác đã xác thực (include `uc-access-control`); người đọc chỉ gia hạn khoản của chính mình.
- Phiếu đang mở; số lần gia hạn tối đa và số ngày cộng thêm có trong `PolicyConfig` (OQ-renewal-001).
- Tới R2 chưa có hàng chờ đặt trước; quy tắc vẫn kiểm (DEC-P2-05).

## Guarantees

- **Minimal Guarantee:** Không gia hạn khi không đủ điều kiện; yêu cầu lặp không gia hạn hai lần.
- **Success Guarantee:** Hạn trả cộng thêm theo cấu hình, đếm lượt tăng, có audit và thông báo hạn mới.

## Main Success Scenario

### Luồng B — Gia hạn (FR-renewal-001, R1B)

1. Nhân viên chọn Loan đang mở trên hồ sơ/quầy (hoặc Người đọc chọn khoản mượn của mình trên cổng người đọc — R1B, DEC-SF-02).
2. Hệ thống kiểm BR-renewal-001 + BR-core-001: Loan `ACTIVE` chưa quá hạn; `renew_count < limit` (PROPOSAL OQ-policy-config-001); không có Reservation đang chờ trên cùng title — **kiểm tra vẫn chạy nhưng queue rỗng cho tới R2, rule đúng ngữ nghĩa** (DEC-P2-05); reader còn đủ điều kiện.
3. LOAN-T03: `due_at += policy renewal` (baseline đề xuất +7 ngày — PROPOSAL), `renew_count++`, audit; `renewal-result` hiển thị hạn trả mới.

## Extensions

**B2a. Gia hạn bị từ chối — Loan đã quá hạn (`OVERDUE`):**
- B2a1. Từ chối kèm lý do (BR-renewal-001; E-core-008 invalid transition — `OVERDUE→ACTIVE` không qua renew): hướng dẫn trả sách + thanh toán phạt.
- B2a2. Recovery: chuyển luồng trả (A) hoặc `uc-fine-cash-payment`.

**B2b. Gia hạn bị từ chối — reader không đủ điều kiện (bị khóa/không active):**
- B2b1. Hiển thị blocked panel lý do (E-core-006 — BR-core-001 áp cho renewal).
- B2b2. Recovery: mở khóa qua `uc-account-admin` hoặc giải quyết nghĩa vụ; sau đó renew lại nếu còn hạn.

**B2c. Gia hạn bị từ chối — vượt renewal limit hoặc title có Reservation đang chờ:**
- B2c1. Từ chối kèm lý do cụ thể (BR-renewal-001; E-core-008): đạt giới hạn gia hạn (PROPOSAL OQ-policy-config-001; baseline đề xuất 1 lần) hoặc có giữ chỗ — **lưu ý queue rỗng tới R2 nên nhánh giữ chỗ chỉ sinh hiệu lực từ R2** (DEC-P2-05).
- B2c2. Recovery: hiển thị hạn trả hiện tại; người đọc trả sách đúng hạn; gợi ý đặt trước lại sau khi trả (R2).

**B2d. Renew đua với trả/mất/double-submit:**
- B2d1. Transition đầu tiên commit thắng; transition sau nhận E-core-004/E-core-008; submit lặp cùng operation trả kết quả gốc (idempotent — PROPOSAL theo AT-RSV-03/AT-CHK-02 pattern).
- B2d2. Recovery: reload `due_at`/`renew_count` mới nhất rồi hiển thị kết quả thật.

## Related Requirements

- FR: FR-renewal-001.
- BR: BR-renewal-001; dùng chung BR-core-001, BR-core-003, BR-core-005.
- Errors: E-core-004, E-core-005, E-core-006, E-core-008.
- Open: OQ-renewal-001.
- UC liên quan: `uc-access-control` (include), `uc-return` (gia hạn từ kết quả trả), `uc-reader-self-service` (gia hạn online), `uc-reservation` (người đặt trước chặn gia hạn — từ R2).
