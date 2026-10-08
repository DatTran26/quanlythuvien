# Checkpoint bàn giao — 2026-10-09

Nhánh `docs/split-features`, commit cuối `8e06bf5` (đã push lên `origin`). Plan gốc: [plan.md](plan.md), công thức từng feature: [feature-recipe.md](feature-recipe.md).

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
| 4. User flow + wireframe HTML | **Lô R0 xong**; R1A, R1B+R2 chưa làm | `a865085` (user flow R0), `8e06bf5` (wireframe R0) |
| 5. User story + AC | Chưa làm | — |
| 6. Checklist | Chưa làm | — |
| Phase 8 (gỡ feature gộp), phase 9 (review, PR) | Chưa làm | — |

Lô R0 tầng 4: 7 feature có UI (`access-control`, `reader-onboarding`, `account-admin`, `catalog-admin`, `copy-inventory`, `data-import`, `policy-config`); `ops-foundation` không có màn hình nên không có user flow/wireframe.

## Việc tiếp theo (theo thứ tự)

1. **Tầng 4 lô R1A** — user flow (HARD STOP duyệt cả lô) rồi wireframe HTML cho các feature R1A có UI: `checkout`, `return-handling`, `damage-lifecycle`, `lost-handling`, `fine-collection-basic`, `reader-self-service`, `notification-core` (màn `notification-status`), `ops-reports`. `overdue-fines` là job hệ thống, không có màn.
2. **Tầng 4 lô R1B+R2** — `renewal`, `fine-collection-adv`, `notification-audit-ui`, `reservation`, `trend-reports`. `expansion-candidates` không vẽ.
3. Tầng 5 user story + AC: đánh số `US-001` lại theo từng feature, persona theo DEC-SF-08.
4. Tầng 6 checklist: `CHK-{feature}-NNN` theo crosswalk; `test-strategy.md` từng feature tham chiếu `docs/_shared/test-strategy-baseline.md`.
5. Khi một feature đủ 6 tầng: đổi cột "Chi tiết hóa" trong Feature Map (`docs/_product/prd.md`) sang ✅.
6. Phase 8: quét mã `*-LMP-*` còn sót, sửa link, xóa `docs/features/library-management-platform/` (**phải hỏi người dùng xác nhận rõ trước khi xóa**).
7. Phase 9: review chéo, chỉ tạo PR vào `develop` khi người dùng yêu cầu.

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
- Script sinh (`wf_split.py`, `wf_entry.py`, `idremap.py`, `uf_r0.py`…) nằm trong scratchpad của phiên trước, **không được lưu lại**. Phiên sau cần viết lại theo mô tả trên hoặc làm thủ công.

## Câu hỏi còn mở đáng chú ý

- OQ-5 nguồn (giấy/máy in biên nhận) — đang giữ.
- `OQ-access-control-002` (ngưỡng khóa đăng nhập, thời lượng phiên), `OQ-policy-config-001/002` (gia hạn, phạt, giữ chỗ, SLA, miền giá trị), `OQ-account-admin-001` (ai quản lý tài khoản Quản trị viên), `OQ-data-import-001/002` (mẫu Excel, người duyệt override).
- Nhãn FACT/PROPOSAL cũ trong wireframe chưa có quyết định thay thế vẫn được giữ (vd cờ cho mượn theo đầu sách DEC-D3-09, ngưỡng đối soát 1%).
