---
title: "Phase 5: Rollout R0 (8 feature)"
status: pending
priority: P1
effort: "8 chuỗi tài liệu"
dependencies: [4]
---

# Phase 5: Rollout R0 (8 feature)

## Mục tiêu

Chạy `feature-recipe.md` (bản đã sửa sau pilot) cho 8 feature nền tảng R0. Làm R0 trước vì mọi feature R1A phụ thuộc chúng (cột Phụ thuộc của Feature Map).

## Thứ tự (theo phụ thuộc)

| Thứ tự | Feature | Phụ thuộc | Nội dung chuyển chính | Việc mới / lưu ý |
|---|---|---|---|---|
| 1 | `access-control` | — | FR-006/007, E-017, uc-access-control, auth-flow (5 màn), US-001/002, OQ-LMP-007 | `dashboard-home` chỉ giữ màn, nội dung điều hướng ở `navigation-map.md` |
| 2 | `ops-foundation` | access-control | FR-020 (phần ghi audit), SC-06, US-010, uc-notification-audit (phần audit capture) | **Thêm FR backup/restore** theo quyết định X4; không có màn |
| 3 | `catalog-admin` | access-control | FR-001/003, NFR-002, uc-catalog-admin (phần đầu sách), 3 màn, US-003/005 | FR-003 giữ release R1A theo X6 |
| 4 | `copy-inventory` | catalog-admin | FR-002/026, BR-011, uc-catalog-admin (phần bản sao), 2 màn, US-004 | Tách `catalog-admin-flow.html` thành 2 flow |
| 5 | `reader-onboarding` | access-control | FR-004, uc-reader-admin (phần tạo), reader-list + reader-form, US-006 | Tự đăng ký theo quyết định X2 |
| 6 | `account-admin` | access-control | FR-005, reader-detail, OQ-LMP-014 | Phạm vi theo X3; release theo quyết định |
| 7 | `policy-config` | — | FR-021, admin-config, US-007, OQ-LMP-010 | Tách `admin-import-flow.html` thành 2 flow |
| 8 | `data-import` | catalog-admin, policy-config | FR-022, NFR-011, BR-014, E-014, SC-07, import-upload + import-report, US-008/009, OQ-LMP-002/018 | Liên kết `GATE-MIG` |

## Các bước cho mỗi feature

1. Chạy 9 bước `feature-recipe.md`.
2. Đánh dấu "đã chuyển (phase 5)" trong `id-crosswalk-lmp.md` cho item của feature.
3. Kiểm "xong" theo công thức.
4. Cập nhật dòng Feature Map cột "Chi tiết hóa".

## Tiêu chí xong phase

- 8 feature đạt "xong".
- Item R0 trong crosswalk đã chuyển 100%.
- Khi cả 8 xong: chạy `/gap` cho từng feature R0 và sửa gap nội bộ.
