---
title: "Phase 6: Rollout R1A (8 feature còn lại)"
status: pending
priority: P1
effort: "8 chuỗi tài liệu"
dependencies: [5]
---

# Phase 6: Rollout R1A (8 feature còn lại)

## Mục tiêu

Hoàn thiện lưu thông lõi tại quầy. `checkout` đã xong ở phase 4.

## Thứ tự (theo phụ thuộc)

| Thứ tự | Feature | Phụ thuộc | Nội dung chuyển chính | Việc mới / lưu ý |
|---|---|---|---|---|
| 1 | `notification-core` | access-control | FR-019 (phần tối thiểu), NFR-007, E-012/018, SC-05, notification-status, US-018, OQ-LMP-008 | Các feature khác phát sự kiện thông báo tham chiếu tới đây |
| 2 | `overdue-fines` | policy-config, ops-foundation | FR-014, SC-04, US-013, phần assessment của uc-fine-payment + uc-return-renewal | Không có màn; BR ledger ở `_shared` |
| 3 | `return-handling` | checkout, overdue-fines | FR-010, SC-01 (phần trả), uc-return-renewal (phần trả), return-scan + return-result, US-012 | D5 "có hàng chờ" ghi rõ luôn "không" tới R2 (DEC-P2-05) |
| 4 | `damage-lifecycle` | return-handling | FR-017/025, BR-009/012, E-011, uc-damage-lost-found (phần hư hỏng), 2 màn, US-015/016, OQ-LMP-013 | |
| 5 | `lost-handling` | return-handling | FR-018, BR-010, lost-found, US-017 | Priority theo X5 |
| 6 | `fine-collection-basic` | overdue-fines | FR-015 (phần tiền mặt), BR-008, E-009/010, fine-list + fine-detail + fine-payment, US-014 | |
| 7 | `reader-self-service` | access-control, checkout | FR-024 | **Chưa có UC, màn, story** → viết mới từ brainstorm theo quyết định X1; chạy `/user-flow` từ đầu |
| 8 | `ops-reports` | checkout, return-handling | FR-023 (RP-01/02/04), report-dashboard, OQ-LMP-017 | Chưa có UC/story → viết mới |

## Các bước cho mỗi feature

Như phase 5. Feature viết mới (`reader-self-service`, `ops-reports`) dùng brainstorm chế độ Targeted deep thay vì Confirm-only, vì ít dữ kiện có sẵn.

## Tiêu chí xong phase

- 8 feature đạt "xong"; cùng `checkout` là đủ 9 feature R1A.
- Item R1A trong crosswalk đã chuyển 100%.
- `/gap` cho từng feature R1A, sửa gap nội bộ.
