---
title: "Phase 4: Pilot end-to-end — checkout"
status: pending
priority: P1
effort: "1 ngày"
dependencies: [3]
---

# Phase 4: Pilot end-to-end — `checkout`

## Mục tiêu

Chạy trọn `feature-recipe.md` cho một feature trước khi nhân ra 22 feature, để sửa công thức khi còn rẻ.

## Vì sao chọn `checkout`

Nội dung có sẵn dày nhất (FR-LMP-008/009, BR-LMP-001/002, E-LMP-004, uc-checkout, flow F3, 4 màn, US-011 có AC, CHK tương ứng), có tham chiếu chéo sang `copy-inventory` (QR), `reservation` (BR-002) và `_shared` (BR điều kiện người đọc, E concurrency) — thử được mọi kiểu tham chiếu.

## Nội dung chuyển vào

| Loại | Từ LMP | Ghi chú |
|---|---|---|
| FR | 008, 009 | FR-009 hệ thống thực thi |
| BR | 001, 002 | 002 sẽ được `reservation` tham chiếu |
| E | 004 | E chung (005, 006, 007) tham chiếu `core-spec.md` |
| SC | 01 (phần mượn), 02 | |
| UC | `uc-checkout` | |
| Flow | flows.md Mục 3 (F3) | |
| Màn | circulation-desk, checkout-scan, checkout-review, checkout-conflict | `html-wireframe/checkout-flow.html` làm nguồn |
| Story | US-011 → US-001 | AC giữ nguyên |
| CHK | CHK có Source FR-LMP-008/009 | Đánh lại CHK-checkout-001… |

## Các bước

1. Chạy 9 bước của `feature-recipe.md`.
2. Đo: số điểm duyệt thực tế, thời gian, số lần phải hỏi lại, số câu hỏi mở phát sinh.
3. Kiểm "xong" theo `feature-recipe.md` Mục cuối.
4. **Retro**: ghi `plans/reports/split-pilot-retro-261008-{hhmm}.md` — cái gì chạy tốt, cái gì phải sửa trong công thức, chỗ skill không hỗ trợ cấu trúc `_shared` (vd `/srs` đòi erd/states riêng, `/user-flow` không biết navigation-map). Sửa `feature-recipe.md` trước khi sang phase 5.

## Tiêu chí xong

- `checkout` đạt mọi tiêu chí "xong" của công thức.
- Người dùng duyệt retro và công thức đã sửa.

## Rollback

Pilot lỗi nặng (vd cấu trúc `_shared` không chạy được với skill) → dừng, trình người dùng xem lại quyết định D2 trước khi đi tiếp.
