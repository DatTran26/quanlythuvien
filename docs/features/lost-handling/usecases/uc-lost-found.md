---
type: usecase
feature: lost-handling
status: draft
updated: 2026-10-08
links:
  - docs/features/lost-handling/usecases/lost-handling-usecase-index.md
  - docs/features/lost-handling/srs/lost-handling-spec.md
  - docs/_shared/domain/lifecycle-inventory.md
---

# Use Case: Ghi nhận mất và tìm lại (uc-lost-found)

> Scope: lost-handling · Level: sea
> Screens: `lost-found` · Release: R1A (FR-lost-handling-001), R1B (FR-lost-handling-002)

## Primary Actor

Thủ thư.

## Stakeholders & Interests

| Stakeholder | Interest |
|-------------|----------|
| Người đọc | Không bị ghi nợ sai khi tìm lại sách |
| Bộ phận tài chính | Nghĩa vụ đã ghi không tự xóa, đối soát có duyệt |

## Trigger

Người đọc báo mất sách đang mượn; hoặc bản sao đã báo mất được tìm thấy.

## Preconditions

- Thủ thư đã xác thực (include `uc-access-control`).
- Ghi nhận mất: phiếu mượn đang mở hoặc quá hạn.

## Guarantees

- **Minimal Guarantee:** Phiếu Mất không mở lại; nghĩa vụ đã ghi không bị xóa khi tìm lại.
- **Success Guarantee:** Ghi nhận mất: phiếu và bản sao Mất, có nghĩa vụ bồi thường, audit, thông báo. Tìm lại: nghĩa vụ đã đối soát, bản sao về kho, audit.

## Main Success Scenario

### Luồng A — Ghi nhận mất (R1A)

1. Thủ thư xác nhận với người đọc, mở phiếu đang mượn, chọn ghi nhận mất.
2. Trong một giao dịch: phiếu sang Mất (LOAN-T05), bản sao sang Mất (COPY-T06), ghi nghĩa vụ bồi thường, audit, thông báo.

### Luồng B — Tìm lại sau khi mất (R1B)

1. Thủ thư kiểm tra vật lý bản sao tìm lại, xác nhận trên `lost-found`.
2. Có duyệt tài chính: trong một giao dịch, đối soát nghĩa vụ (đảo về 0 nếu chưa thu, hoàn nếu đã thu theo chính sách), bản sao sang Sẵn sàng (COPY-T15) hoặc Đang giữ nếu có hàng chờ từ R2 (COPY-T16), ghi audit.

## Extensions

**A1a. Phiếu đã ở trạng thái Mất (ghi nhận lặp):** trả kết quả gốc, không ghi nghĩa vụ lần hai.

**A2a. Audit lỗi (E-core-007):** hủy giao dịch.

**B1a. Kiểm tra vật lý không đạt:** giữ bản sao Mất.

**B2a. Chưa có duyệt tài chính:** chỉ ghi "đã tìm thấy — chờ đối soát", bản sao giữ trạng thái Mất.

**Any. Thao tác không hợp lệ với trạng thái hiện tại (E-core-008):** giải thích, chỉ hiện thao tác hợp lệ.

## Related Requirements

- FR: FR-lost-handling-001, FR-lost-handling-002.
- BR: BR-lost-handling-001; dùng chung BR-core-002, BR-core-003.
- Errors: E-core-007, E-core-008.
- Transitions: LOAN-T05, COPY-T06, COPY-T15, COPY-T16.
- Open: OQ-lost-handling-001, OQ-lost-handling-002; DEC-D3-05.
- UC liên quan: `uc-access-control` (include), `uc-overdue-assessment` (ghi bồi thường), `uc-fine-adjustment` (đảo, hoàn — R1B).
