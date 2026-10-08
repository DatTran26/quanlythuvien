---
title: "Phase 9: Review chéo, traceability, bàn giao"
status: pending
priority: P1
effort: "nửa ngày"
dependencies: [8]
---

# Phase 9: Review chéo, traceability, bàn giao

## Mục tiêu

Xác nhận bộ 23 feature nhất quán với nhau và với tầng sản phẩm trước khi merge.

## Các bước

1. **Review chéo song song (read-only)**, mỗi agent trả findings theo `review-format.md`, không tự sửa file:
   - `@pm-reviewer`: phụ thuộc giữa feature khớp Feature Map và roadmap; không feature nào ở release sớm phụ thuộc feature release muộn.
   - `@senior-ba`: mỗi feature đủ chuỗi, ranh giới feature rõ, không requirement nào hai chủ.
   - `@qa-reviewer`: mỗi FR P0 có story, AC, CHK; Error Matrix feature + chung phủ đủ FR P0.
   - `@gap-analyst`: traceability chéo feature, tham chiếu sang `_shared`.
2. **Gộp findings**, sửa BLOCKING/WARNING qua L2. Quyết định nghiệp vụ mới trình người dùng, không tự chọn.
3. **Traceability**: chạy `/gap` toàn kho, cập nhật `docs/_shared/traceability.md`.
4. **Cập nhật plan cũ**: `plans/261004-1734-library-management-full-ba-workflow/plan.md` ghi phase 4–7 đã được thay bằng plan này.
5. **Commit và PR** (chỉ khi người dùng yêu cầu): commit theo từng phase với conventional commit (`docs(features): …`), không commit thư mục tool riêng (đã có trong `.gitignore`). PR từ `docs/split-features` vào `develop`, mô tả gồm bảng 23 feature và link crosswalk.
6. **Thông báo team**: gỡ đóng băng, hướng dẫn tra mã cũ qua `docs/_shared/id-crosswalk-lmp.md`.

## Tiêu chí xong

- Không còn BLOCKING.
- Người dùng duyệt PR.
