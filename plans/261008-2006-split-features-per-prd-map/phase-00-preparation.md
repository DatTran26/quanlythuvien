---
title: "Phase 0: Chuẩn bị, đóng băng, spike công cụ"
status: pending
priority: P1
effort: "nửa ngày"
dependencies: []
---

# Phase 0: Chuẩn bị, đóng băng, spike công cụ

## Mục tiêu

Có điểm quay lại an toàn, không ai sửa song song feature gộp, và biết chắc công cụ (KG, mermaid-verify, hook) xử lý đúng cấu trúc mới trước khi đụng vào tài liệu.

## Các bước

1. **Đồng bộ nhánh.** Hỏi `develop-bao` và `develop-hoang` còn thay đổi chưa merge trong `docs/features/library-management-platform/` không. Có thì merge vào `develop-dat` trước. Xác nhận bằng `git log origin/develop-bao --not develop-dat -- docs/` rỗng (và tương tự cho `develop-hoang`).
2. **Đóng băng.** Thông báo team: không sửa `docs/features/library-management-platform/` cho tới khi xong phase 8. Thay đổi gấp ghi vào `docs/inbox/` để áp sau.
3. **Điểm quay lại.** Tạo tag `pre-split-features` trên `develop-dat`, tạo nhánh `docs/split-features`. Mọi phase sau làm trên nhánh này.
4. **Cài Chrome Headless cho mermaid-verify.** `npx puppeteer browsers install chrome-headless-shell`. Kiểm: `node .claude/scripts/mermaid-verify.mjs --file docs/features/library-management-platform/srs/library-management-platform-flows.md` exit 0. Lưu kết quả 4 file mermaid hiện tại làm baseline (lỗi có sẵn không tính cho việc tách).
5. **Spike namespace dùng chung.** KG coi `docs/_shared/` là thư mục cấp dự án, không có feature context, và bỏ qua ID dạng ngắn (`kg-build.mjs` dòng 33 `PROJECT_LEVEL_DIRS`). Thử:
   - Tạo file tạm `docs/_shared/_spike-core.md` chứa `BR-core-001` và một file feature tạm tham chiếu nó.
   - Chạy `kg-build.mjs` rồi `kg-query.mjs explore BR-core-001`.
   - Nếu KG nhận node và resolve được tham chiếu → chốt namespace `core`. Nếu không → chọn phương án thay thế và trình người dùng: (a) dùng tiền tố `shared`, (b) báo cáo hạn chế KG và chấp nhận broken ref có kiểm soát cho ID dùng chung. Không sửa code KG nếu người dùng chưa cho phép.
   - Xóa file tạm, rebuild KG.
6. **Snapshot số liệu gốc.** Lưu vào `plans/reports/split-baseline-261008-{hhmm}.md`: số FR/NFR/BR/E/SC/OQ/UC/US/AC/CHK/screen hiện có (từ `kg-query.mjs facts library-management-platform --all`), danh sách 233 broken ref, danh sách file. Đây là mốc đối chiếu "không mất nội dung" ở phase 8.
7. **Kiểm hook.** Đọc `.agents/hooks/ba-kit-run.mjs` phần stale-propagation và changelog để biết `git mv` có làm hook đánh `stale` hàng loạt không. Ghi kết luận vào report bước 6.

## Đầu ra

- Tag `pre-split-features`, nhánh `docs/split-features`.
- `plans/reports/split-baseline-*.md` (số liệu gốc + kết luận spike + kết luận hook).
- Namespace dùng chung đã chốt.

## Tiêu chí xong

- Không còn thay đổi chưa merge từ nhánh khác trong `docs/`.
- mermaid-verify chạy được.
- Namespace dùng chung được người dùng chốt.

## Rủi ro

| Rủi ro | Xử lý |
|---|---|
| Nhánh khác không merge được ngay | Hoãn phase 1, không tách song song |
| KG không hỗ trợ ID trong `_shared` | Người dùng chọn giữa sửa KG (cần cho phép) hoặc chấp nhận hạn chế |
