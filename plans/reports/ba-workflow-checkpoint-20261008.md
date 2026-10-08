# Checkpoint quy trình BA — 2026-10-08

## Mục đích

Ghi lại trạng thái kiểm chứng trước khi tiếp tục hoàn thiện toàn bộ quy trình BA và chạy lại `ak-ship`.

> Mốc mới nhất là mục **Checkpoint 15:43**. Các mục phía trên là snapshot trong ngày và có chỗ đã lỗi thời.

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

## Checkpoint 15:43 — tài liệu chưa đủ để khóa baseline

Kết luận: bộ tài liệu đủ để review tiếp Phase 6. Chưa đủ để khóa baseline, viết test, hoặc giao dev làm toàn bộ phạm vi.

### Đã có

- Phase 3 completed. Phase 5 completed: user flow đã duyệt, wireframe HTML Mobile 375, 11 luồng / 38 màn hình.
- Phase 4 SRS còn `status: draft`, plan ghi `In-review`. PRD/roadmap còn chờ L1 approval. Phase 1 còn in-progress.
- 18 user story đã có trong `docs/features/library-management-platform/userstories/`. Tất cả vẫn `draft`.
- Acceptance Criteria đã ghi cho US-013 (4 AC) và US-014 (6 AC). Hai story vẫn BLOCKING DoR vì OQ-LMP-005, OQ-LMP-009 và OQ-LMP-010 chưa chốt công thức phạt, thu một phần, đối soát và thẩm quyền tài chính.
- Use case thu tiền gán E-LMP-005 cho hai khoản thu đồng thời. Error Matrix vẫn mô tả mã này cho xung đột bản sao hoặc đặt chỗ, gắn FR-LMP-009 và FR-LMP-012.

### Chưa đủ

- 16 story US-001 đến US-012 và US-015 đến US-018 vẫn chỉ có placeholder Acceptance Criteria.
- Phase 7 chưa có test strategy, checklist hay test case.
- Phase 8 chưa có traceability, quality review hay handoff bàn giao.
- OQ-LMP-001 đến OQ-LMP-018 vẫn mở. OQ-LMP-001 chặn việc đánh artifact là `approved`.
- Plan tổng vẫn `in-progress`. Phase 6, 7 và 8 trong plan index vẫn `Pending`.

### Git

- Nhánh `develop-dat`, HEAD `0525d55` (`docs: add BA skill guide for library docs`).
- Local đang ahead `origin/develop-dat` 7 commit. Chưa push, chưa mở PR. PR đích khi push là `develop`, không phải `main`.
- Năm commit tài liệu trong phiên này: `fd2a44f`, `f7b8d02`, `45b71ca`, `5bc69d4`, `0525d55`.
- Chưa commit: sửa skill BA-Kit, `docs/_shared/kg/`, `.1devtool/tasks/`, file `nul`.

### Bước kế tiếp

1. Chạy `/ac` cho 16 story còn placeholder. Story dính OQ mở giữ Not Ready, không bịa ngưỡng.
2. Nếu muốn E-LMP-005 thành contract của thu tiền, sửa Error Matrix trước khi coi AC-004 của US-014 là đã chốt mã lỗi.
3. Sau khi AC đủ cho phạm vi đem đi test, mới chạy Phase 7 rồi Phase 8.
4. Push và PR vào `develop` do người dùng thực hiện.

## Checkpoint 15:50 — đã sinh AC cho 18 story, chưa sang Phase 7

- Đã ghi Acceptance Criteria cho US-001 đến US-012 và US-015 đến US-018. Cùng US-013 và US-014, cả 18 story đều có AC có ID.
- Mọi story vẫn `draft`. Mỗi story có BLOCKING DoR cho quyết định chưa chốt. Không bịa ngưỡng, công thức phạt, mapping Excel, mô hình danh tính hay số lần gửi lại.
- US-015 không khẳng định cách ly bản sao ngay khi báo hư hỏng, vì quyết định này vẫn mở.
- Phase 6 trong plan index vẫn `Pending` vì AC chưa được duyệt và chưa đạt Definition of Ready.
- Phase 7 và Phase 8 chưa chạy. Checklist và test case chưa được sinh, vì story Not Ready không được đưa vào bộ test hoàn chỉnh.
- Các AC và checkpoint này nằm trên `develop-dat`. Chưa push. PR đích là `develop`.
