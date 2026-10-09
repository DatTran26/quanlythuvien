---
type: usecase
feature: ops-foundation
status: draft
updated: 2026-10-08
links:
  - docs/features/ops-foundation/usecases/ops-foundation-usecase-index.md
  - docs/features/ops-foundation/srs/ops-foundation-spec.md
---

# Use Case: Backup và khôi phục (uc-backup-restore)

> Scope: ops-foundation · Level: sea
> Screens: — · Release: R0 (FR-ops-foundation-002)

## Primary Actor

Hệ thống (backup hằng ngày). Owner vận hành (diễn tập khôi phục).

## Stakeholders & Interests

| Stakeholder | Interest |
|-------------|----------|
| Thủ thư trưởng | Không mất dữ liệu khi máy chủ hỏng; có bằng chứng GATE-OPS |

## Trigger

Lịch backup hằng ngày; lịch diễn tập trước go-live; sự cố cần khôi phục.

## Preconditions

- Đã chỉ định owner vận hành (OQ-ops-foundation-001).

## Guarantees

- **Minimal Guarantee:** Luôn còn ít nhất bản backup thành công gần nhất.
- **Success Guarantee:** 30 bản backup gần nhất được giữ; diễn tập khôi phục đạt ít nhất một lần trước go-live.

## Main Success Scenario

1. Hệ thống chạy backup toàn bộ dữ liệu nghiệp vụ hằng ngày.
2. Backup thành công: lưu bản mới, xóa bản cũ hơn bản thứ 30.
3. Trước go-live, owner vận hành khôi phục một bản vào môi trường thử, kiểm tra dữ liệu khớp, ghi biên bản cho GATE-OPS.

## Extensions

**2a. Backup lỗi:** giữ bản cũ, cảnh báo vận hành, chạy lại.

**3a. Dữ liệu khôi phục không khớp:** sửa quy trình, diễn tập lại; GATE-OPS chưa đạt.

## Related Requirements

- FR: FR-ops-foundation-002.
- Open: OQ-ops-foundation-001, OQ-ops-foundation-002.
