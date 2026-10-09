# Checkpoint bàn giao — 2026-10-09

Nhánh `docs/split-features` (sau đó merge `develop-dat`). Plan gốc: [plan.md](plan.md), công thức: [feature-recipe.md](feature-recipe.md), quyết định Max: [max-decisions-2026-10-09.md](max-decisions-2026-10-09.md).

## Cách đang làm

- Plan gốc chạy theo từng feature (phase 4 pilot `checkout`, phase 5–7 rollout). Thực tế đã chuyển sang **chạy theo tầng, duyệt theo lô release** (R0 → R1A → R1B+R2+R3). Mỗi tầng xong cả 23 feature mới sang tầng sau.
- Quy trình 6 tầng (D4 — bỏ URD/BRD/PRD cấp feature): brainstorm → SRS spec → use case + flows → user flow + wireframe HTML → user story + AC → checklist.
- Người dùng duyệt theo lô. Claude tự trả lời câu hỏi phỏng vấn của skill, **không bịa số nghiệp vụ** (để ở dạng câu hỏi mở), liệt kê các quyết định tự đưa ra (đánh dấu 🔶) trong L1 để người dùng soát.
- Ghi file bằng script (python/bash) thay vì Edit để tránh hook đánh `stale` dây chuyền; vì vậy **dòng nhật ký `docs/_shared/changelog.md` phải tự thêm** theo mẫu `| ngày | /skill | @dattran26 | \`path\` | ghi chú |`.
- Không commit tooling riêng (`.claude/`, `.agents/`, `scripts/`, `_templates/`, `CLAUDE.md`…); `docs/_shared/kg/` và `docs/_shared/.status-state/` đã gitignore.
- Sơ đồ mermaid không kiểm bằng máy (mermaid-verify không chạy trên Windows) — kiểm bằng mắt.

## Tiến độ theo tầng

| Tầng | Trạng thái | Commit |
|---|---|---|
| Phase 0–3 (chuẩn bị, crosswalk ID, `_shared/`, tầng sản phẩm + RICE) | Xong | trước `5936b8f` |
| 1. Brainstorm — 23/23 feature | Xong | `5936b8f`, `7385dc2`, `826e2d4` |
| 2. SRS spec — 22/22 (trừ `expansion-candidates`) | Xong | `7d5150a`, `3ab41ea`, `30e8d28` |
| 3. Use case + flows — 22/22 | Xong | `95b6b44`, `189aa72`, `a7117bc` (+ `a8b4fe1` đổi ký hiệu `SRC-BRnn`) |
| 4. User flow + wireframe HTML | **R0 + R1A + R1B+R2 xong** (22 feature; `ops-foundation`/`overdue-fines` không có màn; `expansion-candidates` không vẽ) | R0: `a865085`/`8e06bf5`; còn lại: Max 2026-10-09 |
| 5. User story + AC | **22/22 xong** (draft, chuyển từ LMP + FR mới) | Max 2026-10-09 |
| 6. Checklist | **22/22 xong** (draft, `CHK-{feature}-NNN`) | Max 2026-10-09 |
| Phase 8 (gỡ feature gộp) | Chưa xóa LMP — **cần xác nhận user** | — |
| Phase 9 (PR vào `develop`) | Đang làm khi user yêu cầu merge `develop-dat` | — |

Lô R0 tầng 4: 7 feature có UI (`access-control`, `reader-onboarding`, `account-admin`, `catalog-admin`, `copy-inventory`, `data-import`, `policy-config`); `ops-foundation` không có màn hình nên không có user flow/wireframe.

## Việc tiếp theo (theo thứ tự)

1. Soát 🔶 trong [max-decisions-2026-10-09.md](max-decisions-2026-10-09.md) và lô user flow/wireframe (Max đã tự chốt HARD STOP).
2. Phase 8: quét mã `*-LMP-*` còn sót trong feature gộp, sửa link, xóa `docs/features/library-management-platform/` (**phải hỏi người dùng xác nhận rõ trước khi xóa**).
3. Review chéo /srs Phase G nếu cần; Feature Map đã đánh ✅ 6 tầng (draft) trừ `expansion-candidates`.

## Cách làm wireframe (để lô sau làm giống R0)

- Nguồn màn cũ: `docs/features/library-management-platform/html-wireframe/*-flow.html`. Bảng phân màn cũ → feature mới:
  - `checkout-flow` [14–17] → `checkout`
  - `return-renewal-flow` [18–19] → `return-handling`; [20] `renewal-result` → `renewal`
  - `reservation-flow` [21–24] → `reservation`
  - `fine-payment-flow` [25–27] → `fine-collection-basic`; [28] `financial-events` → `fine-collection-adv`
  - `damage-lost-found-flow` [29–30] → `damage-lifecycle`; [31] → `lost-handling`
  - `notification-audit-flow` [32] `notification-status` → `notification-core`; [33–34] → `notification-audit-ui`
  - `reports-flow` [38] → `ops-reports` (dùng chung với `trend-reports`)
- Màn mới phải vẽ thêm: các màn cổng người đọc (`reader-self-service`) và trung tâm thông báo (`notification-audit-ui`, DEC-SF-09).
- Mỗi feature sinh 3 file trong `docs/features/{feature}/html-wireframe/`: `{flow-slug}.html`, `{feature}-wireframe.html` (cửa vào), `{feature}-wireframe-html-index.md`. Khung Mobile 375, đen trắng, đánh số màn lại từ [1] theo user flow của feature; link sang feature khác dùng `../../{feature}/html-wireframe/{flow}.html#sN`; link tới feature chưa có wireframe thì để dạng chữ.
- Sau khi tách: đổi mã cũ `*-LMP-*` theo `docs/_shared/id-crosswalk-lmp.md`, rồi sửa các ghi chú cũ trái với quyết định DEC-SF (vai trò, cấp tài khoản tại quầy, giá trị 5 cuốn/14 ngày/50.000đ…). Kiểm link bằng script và chụp màn hình bằng Chrome headless (`C:/Program Files/Google/Chrome/Application/chrome.exe --headless=new --screenshot`).
- Script sinh đã chép vào `scripts/split-features/` trên máy của @dattran26 (thư mục `scripts/` bị gitignore, **không có trên remote**). Chính: `idremap.py` (đổi mã `*-LMP-*` theo crosswalk), `uf_r0.py` (sinh user flow), `wf_split.py` + `wf_r0.py` + `wf_r0_fix.py` (tách wireframe cũ, vẽ màn mới, sửa ghi chú theo DEC-SF), `wf_entry.py` (sinh cửa vào + index). Chạy bằng `python -I <script> <thư-mục-nháp>` rồi chép kết quả vào `docs/`. Một số script tầng trước còn trỏ đường dẫn scratchpad cũ — sửa đường dẫn trước khi dùng lại. Máy khác thì viết lại theo mô tả trên.

## Câu hỏi còn mở đáng chú ý

- OQ-5 nguồn (giấy/máy in biên nhận) — đang giữ.
- `OQ-access-control-002` (ngưỡng khóa đăng nhập, thời lượng phiên), `OQ-policy-config-001/002` (gia hạn, phạt, giữ chỗ, SLA, miền giá trị), `OQ-account-admin-001` (ai quản lý tài khoản Quản trị viên), `OQ-data-import-001/002` (mẫu Excel, người duyệt override).
- Nhãn FACT/PROPOSAL cũ trong wireframe chưa có quyết định thay thế vẫn được giữ (vd cờ cho mượn theo đầu sách DEC-D3-09, ngưỡng đối soát 1%).
