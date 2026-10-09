---
type: usecase
feature: reader-self-service
status: draft
updated: 2026-10-08
links:
  - docs/features/reader-self-service/usecases/reader-self-service-usecase-index.md
  - docs/features/reader-self-service/srs/reader-self-service-spec.md
---

# Use Case: Tự phục vụ người đọc (uc-reader-self-service)

> Scope: reader-self-service · Level: sea
> Screens: thiết kế ở user-flow · Release: R1A (FR-reader-self-service-001, 002, 004, 005), R1B (FR-reader-self-service-003)

## Primary Actor

Người đọc.

## Stakeholders & Interests

| Stakeholder | Interest |
|-------------|----------|
| Người đọc | Tự theo dõi được tình trạng mượn |
| Bảo mật/pháp chế | Người đọc chỉ thấy dữ liệu của chính mình |

## Trigger

Người đọc mở cổng người đọc.

## Preconditions

- Người đọc đã đăng nhập (include `uc-access-control`).

## Guarantees

- **Minimal Guarantee:** Không hiện dữ liệu của người khác.
- **Success Guarantee:** Người đọc xem được thông tin của mình đúng với trạng thái hiện tại.

## Main Success Scenario

1. Người đọc tra cứu sách theo tên, tác giả, ISBN, thể loại; xem số bản khả dụng và vị trí kệ.
2. Người đọc mở thẻ thư viện QR để Thủ thư quét.
3. Người đọc xem sách đang mượn: hạn trả, số ngày còn lại hoặc đã quá hạn.
4. Người đọc xem lịch sử mượn, lọc theo thời gian.
5. (R1B) Người đọc xem công nợ và trạng thái từng khoản.

## Extensions

**2a. Tài khoản chưa kích hoạt hoặc thẻ hết hạn (E-core-008):** không hiện mã QR dùng được, hướng dẫn liên hệ quầy.

**1a. Không có kết quả tra cứu:** hiện trạng thái trống.

**3a. Không có sách đang mượn:** hiện trạng thái trống.

**Any. Truy cập dữ liệu người khác (E-core-002):** từ chối, ghi audit.

## Related Requirements

- FR: FR-reader-self-service-001..005.
- BR dùng chung: BR-core-004.
- Errors: E-core-002, E-core-008, E-core-009.
- Open: OQ-reader-self-service-001..004.
- UC liên quan: `uc-access-control` (include), `uc-renewal` (gia hạn online — R1B), `uc-reservation` (đặt trước online — R2).
