---
title: "Phase 8: Gỡ feature gộp, sửa link, retire ID"
status: completed
priority: P1
effort: "nửa ngày"
dependencies: [7]
---

# Phase 8: Gỡ feature gộp, sửa link, retire ID

## Mục tiêu

Xóa `docs/features/library-management-platform/` khi chắc chắn không mất nội dung, và để kho tài liệu không còn tham chiếu nào tới nó.

## Các bước

1. **Kiểm "không mất nội dung"** bằng script đối chiếu: mọi dòng `id-crosswalk-lmp.md` có "đã chuyển"; mọi mã mới tồn tại trong đúng file đích; tổng số item theo loại ≥ snapshot phase 0 (phần chênh = item tách, phải giải thích được).
2. **Kiểm file còn sót**: liệt kê mọi file trong feature gộp, mỗi file phải có đích đã ghi (đã chuyển ở phase 2 hoặc đã thay bằng file per-feature). Gồm cả file phụ: `test/checklist/data.js`, `test/checklist/preview.html`, `html-wireframe/library-management-platform-wireframe.html` (cửa vào cũ).
3. **Quét tham chiếu**: `grep -rn "library-management-platform" docs/ plans/*.md` (trừ crosswalk và plan này) và `grep -rnE "(FR|NFR|BR|E|SC|OQ|CHK)-LMP-" docs/` (trừ crosswalk). Sửa từng chỗ qua L2 theo crosswalk. Riêng `plans/261004-1734-…` và `plans/261005-0018-…`: không sửa nội dung lịch sử, chỉ thêm dòng `superseded_by` trong frontmatter.
4. **Xóa feature gộp** bằng `git rm -r docs/features/library-management-platform/` (thao tác xóa — xác nhận riêng với người dùng trước khi chạy).
5. **Dọn stale**: hook có thể đã đánh `stale` hàng loạt trong quá trình chuyển. Liệt kê mọi doc `stale` sinh ra trong nhánh này, trình một lượt duyệt gỡ (theo `status-lifecycle.md`, thoát stale qua review).
6. **Retire ID**: `id-registry.md` đánh `*-LMP-*` là retired, trỏ crosswalk. Không tái sử dụng.
7. **Rebuild KG** (`kg-build.mjs`), kiểm: 0 broken ref do namespace, `Độ phủ` gần 100%, mục "Phải Read tay" không còn short-form ID. Chạy `facts` cho từng feature, đối chiếu đếm với crosswalk.
8. **Sơ đồ mermaid**: không kiểm bằng máy trên Windows (người dùng bỏ qua 2026-10-08); rà bằng mắt các sơ đồ trong `docs/features/*/srs/` và `docs/_shared/domain/` theo `diagram-selection.md` Mục "Mermaid syntax safety".

## Tiêu chí xong

- Thư mục feature gộp không còn.
- 0 tham chiếu `library-management-platform` hay `*-LMP-*` ngoài crosswalk và plan lịch sử.
- KG sạch; sơ đồ đã rà bằng mắt.

## Rollback

Thiếu nội dung phát hiện sau khi xóa → khôi phục file từ tag `pre-split-features` (`git checkout pre-split-features -- <path>`) và bổ sung vào feature đích.
