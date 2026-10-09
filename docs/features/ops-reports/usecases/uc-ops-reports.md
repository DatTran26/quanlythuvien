---
type: usecase
feature: ops-reports
status: draft
updated: 2026-10-08
links:
  - docs/features/ops-reports/usecases/ops-reports-usecase-index.md
  - docs/features/ops-reports/srs/ops-reports-spec.md
---

# Use Case: Xem báo cáo vận hành (uc-ops-reports)

> Scope: ops-reports · Level: sea
> Screens: `report-dashboard` · Release: R1A (FR-ops-reports-001), R1B (FR-ops-reports-002)

## Primary Actor

Quản trị viên. Thủ thư (danh sách quá hạn, R1B).

## Stakeholders & Interests

| Stakeholder | Interest |
|-------------|----------|
| Quản trị viên | Số liệu kho và quá hạn hằng ngày |
| Bảo mật/pháp chế | File xuất không lộ dữ liệu ngoài quyền |

## Trigger

Quản trị viên hoặc Thủ thư mở dashboard báo cáo.

## Preconditions

- Người dùng đã đăng nhập và có quyền xem báo cáo (include `uc-access-control`).

## Guarantees

- **Minimal Guarantee:** Không hiện báo cáo ngoài quyền; dữ liệu cá nhân che theo quyền.
- **Success Guarantee:** Báo cáo đúng khoảng thời gian, xuất được Excel/PDF.

## Main Success Scenario

1. Người dùng mở `report-dashboard`, chọn RP-01, RP-02 hoặc RP-04.
2. Chọn khoảng thời gian; hệ thống hiện số liệu.
3. Xuất Excel hoặc PDF.

## Extensions

**1a. Không có quyền (E-core-002):** từ chối, quay về dashboard.

**2a. Không có dữ liệu:** hiện trạng thái trống.

**Nhánh Q (R1B):** Thủ thư mở danh sách quá hạn để nhắc người đọc.

## Related Requirements

- FR: FR-ops-reports-001, FR-ops-reports-002.
- BR dùng chung: BR-core-004.
- Errors: E-core-002, E-core-009.
- Open: OQ-ops-reports-001, OQ-ops-reports-002.
