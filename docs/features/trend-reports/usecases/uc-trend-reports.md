---
type: usecase
feature: trend-reports
status: draft
updated: 2026-10-08
links:
  - docs/features/trend-reports/usecases/trend-reports-usecase-index.md
  - docs/features/trend-reports/srs/trend-reports-spec.md
---

# Use Case: Xem báo cáo xu hướng (uc-trend-reports)

> Scope: trend-reports · Level: sea
> Screens: `report-dashboard` (chủ: `ops-reports`) · Release: R2 (FR-trend-reports-001)

## Primary Actor

Quản trị viên.

## Stakeholders & Interests

| Stakeholder | Interest |
|-------------|----------|
| Quản trị viên | Quyết định mua, sửa, thanh lý dựa trên số liệu |

## Trigger

Quản trị viên cần số liệu xu hướng.

## Preconditions

- Quản trị viên đã đăng nhập (include `uc-access-control`); có dữ liệu vận hành tích lũy.

## Guarantees

- **Minimal Guarantee:** Không hiện báo cáo ngoài quyền.
- **Success Guarantee:** Báo cáo đúng khoảng thời gian, xuất được Excel/PDF; ghi rõ khoảng dữ liệu thực có.

## Main Success Scenario

1. Quản trị viên mở `report-dashboard`, chọn RP-03, RP-05, RP-06 hoặc RP-07.
2. Chọn khoảng thời gian; hệ thống hiện số liệu.
3. Xuất Excel hoặc PDF.

## Extensions

**1a. Không có quyền (E-core-002):** từ chối.

**2a. Dữ liệu chưa đủ 12 tháng cho RP-06:** ghi rõ khoảng dữ liệu thực có.

**2b. Không có dữ liệu:** hiện trạng thái trống.

## Related Requirements

- FR: FR-trend-reports-001.
- BR dùng chung: BR-core-004.
- Errors: E-core-002, E-core-009.
- Open: OQ-trend-reports-001.
- UC liên quan: `uc-ops-reports` (dùng chung dashboard).
