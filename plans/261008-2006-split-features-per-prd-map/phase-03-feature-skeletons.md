---
title: "Phase 3: Dựng khung 23 thư mục + nối PRD"
status: pending
priority: P1
effort: "2 giờ"
dependencies: [2]
---

# Phase 3: Dựng khung 23 thư mục + nối PRD

## Mục tiêu

Có đủ 23 thư mục feature rỗng đúng quy ước, và PRD sản phẩm trỏ tới chúng, để phase 4–7 chỉ việc lấp nội dung.

## Các bước

1. **Tạo thư mục** `docs/features/{slug}/` cho 23 slug ở `feature-allocation-draft.md` Mục 1, với các thư mục con theo bảng dưới. Chỉ tạo thư mục, không tạo file stub (tránh doc TBD rỗng — `project-profile.md` anti-pattern).

   | Thư mục con | Tạo cho |
   |---|---|
   | `brainstorms/` | 23 feature |
   | `srs/`, `usecases/`, `userstories/`, `test/checklist/` | 22 feature (trừ `expansion-candidates`) |
   | `html-wireframe/` | Feature có màn (không tạo cho `overdue-fines`, `ops-foundation`; `reader-self-service` tùy quyết định X1) |

   Thư mục rỗng không được git theo dõi; thư mục chỉ thực sự xuất hiện khi có file đầu tiên ở phase 4–7. Bước này dùng để kiểm slug và lên danh sách, không commit thư mục rỗng.

2. **Cập nhật `docs/_product/prd.md` Mục 7** qua L2: cột Slug thành wikilink tới `docs/features/{slug}/{slug}-prd.md` (sẽ có ở phase 4–7), cột "Chi tiết hóa" đặt `chưa` cho cả 23 dòng. Áp các quyết định X1–X7 đã chốt ở phase 1 (release, persona, priority).
3. **Cập nhật `docs/_product/roadmap.md` và `priority-crosswalk.md`** qua L2 nếu quyết định phase 1 đổi release/priority của feature nào.
4. **Cập nhật `docs/README.md`** (bản đồ thư mục docs) qua L2: mô tả cấu trúc 23 feature + `_shared/domain/`.

## Tiêu chí xong

- Danh sách 23 slug khớp PRD, đúng kebab-case ASCII ≤50 ký tự.
- PRD, roadmap, crosswalk không mâu thuẫn với decision-register sau phase 1.
