# Checkpoint quy trình BA — 2026-10-08

## Mục đích

Ghi lại trạng thái kiểm chứng trước khi tiếp tục hoàn thiện toàn bộ quy trình BA và chạy lại `ak-ship`.

## Đã hoàn thành và kiểm chứng

- Phase 5: user flow và HTML wireframe đã hoàn tất.
- Bộ wireframe gồm 11 flow, 38 màn hình, khung Mobile 375.
- Script `node scripts/verify-library-wireframes.mjs` đã PASS với canonical flow hash `c4d1b86d`.
- Entry page, breadcrumb, deep link, screen label, bảng mô tả, palette và local link đã được kiểm tra tự động.
- Prototype comment layer của Claude, Codex/shared agents và Cursor đã chuyển sang `localStorage`-only; không còn credential phía client hoặc URL chia sẻ chứa khóa.
- Marker license có email/order cá nhân đã được thay bằng thông báo license chung; bằng chứng license gốc giữ ngoài version control.
- Phase 5 trong plan index đã được đồng bộ thành `Completed`.

## Chưa hoàn thành

- Phase 1 còn thiếu Excel/sơ đồ nguồn hoặc reconstruction approval, hard-stop decisions và approval evidence.
- Phase 2 còn thiếu L1 approval evidence cho PRD/roadmap.
- Phase 4 còn thiếu L1/L2 approval evidence, domain approval và lần kiểm tra orphan reference cuối.
- Phase 6 chưa có story map, user stories và acceptance criteria.
- Phase 7 chưa có test strategy, checklist và test cases 1:1.
- Phase 8 chưa có traceability matrix, final quality review, operational-readiness evidence và handoff.

Các approval thuộc stakeholder/domain/security/legal không được tự giả lập. Artifact liên quan phải giữ trạng thái Open/Blocked/Not Ready cùng owner và gate cho đến khi có bằng chứng thật.

## Trạng thái ship

`ak-ship` đã tạm dừng trước commit/push/PR để tránh xuất bản một baseline bị hiểu nhầm là đã hoàn thành toàn bộ 8 phase. Issue theo dõi hiện tại: `#2`.

Các đường dẫn không thuộc phạm vi ship:

- `.1devtool/tasks/`
- `plans/handoffs/`
- `nul`
- `docs/_shared/kg/graph.json` (generated artifact từ KG baseline còn lỗi upstream)

## Trình tự tiếp tục

1. Audit Phase 1, 2 và 4; phân biệt phần có thể hoàn thiện bằng evidence trong repo với approval bên ngoài còn thiếu.
2. Hoàn thiện Phase 6 bằng `userstory` rồi `ac`.
3. Hoàn thiện Phase 7 bằng `test-checklist` rồi `test-cases`.
4. Hoàn thiện Phase 8: traceability, static checks, review độc lập và handoff.
5. Chạy lại toàn bộ test/review gate, sau đó tiếp tục `ak-ship` beta vào `develop`.

## Điều kiện kết thúc checkpoint

- Mọi artifact có trạng thái phản ánh đúng evidence, không giả approval.
- P0 có traceability end-to-end hoặc được ghi rõ blocker/Not Ready.
- Không có secret/PII thật, broken link, duplicate ID hay claim hoàn thành không có bằng chứng.
- Overall plan chỉ chuyển `completed` khi toàn bộ tiêu chí có thể hoàn thành đã PASS và các external gate được mô tả trung thực.

## Checkpoint tiếp tục Phase 6

- Đã sửa các claim nền bị stale và đồng bộ trạng thái Phase 4 thành `In-review`.
- Đã tạo story index cùng 18 user story draft, bao phủ 17/17 FR P0.
- Mọi story giữ trạng thái `draft`, có ghi chú được xây từ SRS draft và chưa đạt Definition of Ready.
- Acceptance Criteria chưa được sinh; bước kế tiếp là chạy `ac` với L1/L2 riêng, không tự chốt các OQ về identity, ngưỡng nghiệp vụ, Excel, tài chính, privacy hoặc notification.
