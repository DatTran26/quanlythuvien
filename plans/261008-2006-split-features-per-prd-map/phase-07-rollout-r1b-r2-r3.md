---
title: "Phase 7: Rollout R1B, R2, R3 (6 feature)"
status: pending
priority: P2
effort: "5 chuỗi tài liệu + 1 envelope"
dependencies: [6]
---

# Phase 7: Rollout R1B, R2, R3 (6 feature)

## Mục tiêu

Hoàn tất các feature sau pilot. Nhóm này đa phần **chưa có story**, nên phần viết mới nhiều hơn phần chuyển.

## Thứ tự

| Thứ tự | Feature | Release | Nội dung chuyển chính | Việc mới / lưu ý |
|---|---|---|---|---|
| 1 | `renewal` | R1B | FR-011, BR-004, renewal-result, uc-return-renewal (phần gia hạn) | Viết story mới; BR điều kiện người đọc ở `_shared` |
| 2 | `fine-collection-adv` | R1B | FR-015 (phần biên nhận), FR-016, financial-events, OQ-LMP-005/009 | Viết story mới; nhiều quyết định tài chính còn mở → giữ PROPOSAL |
| 3 | `notification-audit-ui` | R1B | FR-019 (trung tâm), FR-020 (viewer), FR-027, audit-log + history-timeline | Thêm màn trung tâm thông báo (X9); viết story mới |
| 4 | `reservation` | R2 | FR-012/013, BR-005/006, E-008, SC-03, uc-reservation, 4 màn, OQ-LMP-003 | Viết story mới; tham chiếu BR-002 của `checkout` |
| 5 | `trend-reports` | R2 | FR-023 (RP-03/05/06/07) | Dùng màn `report-dashboard` của `ops-reports`, chỉ thêm trạng thái/dataset R2 |
| 6 | `expansion-candidates` | R3 | FR-028 | **Chỉ** brainstorm (mỗi candidate: mục tiêu, giả định, điều kiện mở). Không SRS. PRD sản phẩm 7.23 đã ghi không cam kết |

## Các bước

Như phase 5, trừ `expansion-candidates` chỉ chạy bước 1 của công thức.

## Tiêu chí xong phase

- 5 feature đạt "xong", `expansion-candidates` có brainstorm.
- Crosswalk: 100% item LMP có cột "đã chuyển".
