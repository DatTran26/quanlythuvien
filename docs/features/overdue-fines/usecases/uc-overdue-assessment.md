---
type: usecase
feature: overdue-fines
status: draft
updated: 2026-10-08
links:
  - docs/features/overdue-fines/usecases/overdue-fines-usecase-index.md
  - docs/features/overdue-fines/srs/overdue-fines-spec.md
---

# Use Case: Ghi phạt và job quá hạn (uc-overdue-assessment)

> Scope: overdue-fines · Level: subfunction
> Screens: — · Release: R1A (FR-overdue-fines-001)

## Primary Actor

Hệ thống.

## Stakeholders & Interests

| Stakeholder | Interest |
|-------------|----------|
| Người đọc | Được nhắc trước hạn và khi quá hạn |
| Bộ phận tài chính | Sổ phạt chỉ thêm, số dư khớp |

## Trigger

Job hằng ngày 00:05 (quá hạn) và 08:00 (nhắc hạn); hoặc phiếu được đóng khi trả trễ, trả hư hỏng, ghi nhận mất.

## Preconditions

- Tham số phạt có trong `PolicyConfig`.

## Guarantees

- **Minimal Guarantee:** Không ghi phạt hay thông báo hai lần cho cùng kỳ; không sửa, xóa sự kiện đã ghi.
- **Success Guarantee:** Phiếu quá hạn được đánh dấu, nghĩa vụ được ghi vào sổ, người đọc được nhắc đúng lịch.

## Main Success Scenario

1. 00:05 hệ thống quét phiếu đang mở đã quá hạn, chuyển sang Quá hạn (LOAN-T02).
2. Cập nhật phạt tạm tính vào sổ (theo ngày, tới trần), ghi audit.
3. Phát thông báo quá hạn ngày đầu, sau đó mỗi 3 ngày.
4. 08:00 hệ thống phát nhắc cho phiếu đến hạn trong 2 ngày tới.

## Extensions

**1a. Job chạy lại trong cùng kỳ:** bỏ qua phiếu đã xử lý (BR-overdue-fines-001).

**2a. Phạt chạm trần:** không cộng thêm.

**2b. Nghĩa vụ từ trả hư hỏng hoặc mất:** ghi vào sổ khi đóng phiếu, theo mức của `PolicyConfig`.

**2c. Audit lỗi (E-core-007):** hủy ghi cho phiếu đó, cảnh báo vận hành.

## Related Requirements

- FR: FR-overdue-fines-001.
- BR: BR-overdue-fines-001; dùng chung BR-core-002, BR-core-003, BR-core-005.
- Errors: E-core-007.
- Transitions: LOAN-T02.
- Open: OQ-overdue-fines-001, OQ-overdue-fines-002.
- UC liên quan: `uc-return`, `uc-damage-report`, `uc-lost-found`, `uc-notification-outbox`.
