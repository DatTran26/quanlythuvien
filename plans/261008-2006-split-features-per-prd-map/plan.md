---
title: "Tách bộ tài liệu thành 23 feature theo Feature Map"
description: "Chuyển feature gộp library-management-platform thành 23 thư mục feature theo docs/_product/prd.md Mục 7, phần dùng chung vào docs/_shared/, đánh lại ID theo feature và đi đủ quy trình brainstorm → URD → BRD → PRD → SRS → models → UX → story/AC → checklist cho từng feature."
status: in-progress
priority: P1
effort: "10 phases, khoảng 23 chuỗi tài liệu"
issue: ""
branch: "docs/split-features"
tags: [docs, ba, restructure, traceability]
blockedBy: []
blocks: []
supersedes: "plans/261004-1734-library-management-full-ba-workflow (phase 4–7 cho phần tổ chức thư mục)"
created: 2026-10-08
---

# Tách bộ tài liệu thành 23 feature theo Feature Map

## Bối cảnh

Feature Map trong `docs/_product/prd.md` Mục 7 định nghĩa 23 feature có slug riêng. Plan roadmap (`plans/261005-0018-library-management-product-roadmap/plan.md` Phase 2 bước 4 và Phase 4) yêu cầu tách feature đủ nhỏ để viết PRD/SRS độc lập. Nhưng plan thực thi (`plans/261004-1734-library-management-full-ba-workflow/phase-04-srs-core-and-models.md`) lại dồn toàn bộ vào một feature `library-management-platform`. Hệ quả: không có URD/BRD/PRD cấp feature, ID dùng namespace rút gọn `LMP` trái quy ước `FR-{feature}-NNN`, KG báo 233 tham chiếu gãy, và một SRS 28 FR khó duyệt theo từng phần.

## Quyết định đã chốt (người dùng, 2026-10-08)

| # | Quyết định |
|---|---|
| D1 | Chia đúng **23 feature** theo Feature Map. `expansion-candidates` (R3) chỉ có khung + brainstorm, không viết SRS. |
| D2 | Phần dùng chung (ERD tổng, vòng đời trạng thái, NFR/BR/lỗi xuyên hệ thống) chuyển vào **`docs/_shared/`**. Thư mục `docs/features/library-management-platform/` bị xóa sau khi chuyển xong. |
| D3 | **Đánh mã ID mới theo feature** (`FR-checkout-001`…). Mã `*-LMP-*` chuyển sang retired, có bảng đối chiếu. |
| D4 | Mỗi feature đi quy trình: brainstorm → SRS → models → UX → story/AC → checklist. **Không viết URD, BRD, PRD cấp feature** (người dùng bỏ ngày 2026-10-08): PRD sản phẩm Mục 7.x là mô tả cấp sản phẩm của từng feature. |

## Kết quả mong muốn

- `docs/features/` có 23 thư mục, mỗi thư mục tự đứng được và truy vết `UN/BO → CAP → FR → UC → screen → US → AC → CHK`.
- `docs/_shared/` chứa đúng phần xuyên feature, mỗi nội dung chỉ có một nơi sở hữu.
- Không còn ID `*-LMP-*` trong tài liệu sống; mọi ID cũ tra được mã mới qua bảng đối chiếu.
- KG build không còn broken ref do namespace; `/gap` chạy được cho từng feature.
- Không mất nội dung: mọi FR/BR/E/NFR/SC/OQ/UC/US/AC/CHK/screen hiện có đều có đích đến được ghi trong ma trận phân bổ.

## Ngoài phạm vi

- Không đổi nội dung nghiệp vụ đã có, trừ khi phát sinh từ xung đột ghi ở `feature-allocation-draft.md` Mục 4 và được người dùng duyệt.
- Không tự giải các câu hỏi mở cần stakeholder (identity, privacy, finance, phê duyệt). Chúng được chuyển đúng feature và giữ trạng thái mở.
- Không sinh test case (`/test-cases`) — vẫn là bước sau như plan cũ.

## Các phase

| # | Phase | File | Phụ thuộc | Cổng duyệt |
|---|---|---|---|---|
| 0 | Chuẩn bị, đóng băng, spike công cụ — **xong 2026-10-08** (bỏ qua mermaid-verify theo người dùng) | [phase-00-preparation.md](phase-00-preparation.md) | — | Team đồng ý đóng băng |
| 1 | Ma trận phân bổ và bảng đối chiếu ID — **xong 2026-10-08** (`docs/_shared/id-crosswalk-lmp.md`, DEC-SF-01..09) | [phase-01-allocation-matrix.md](phase-01-allocation-matrix.md) | 0 | Duyệt ma trận |
| 2 | Dựng tầng dùng chung `docs/_shared/` — **xong 2026-10-08** | [phase-02-shared-layer.md](phase-02-shared-layer.md) | 1 | L1/L2 từng file |
| 3 | Chuẩn hóa tầng sản phẩm theo /prd → /roadmap + khung 23 thư mục — **xong 2026-10-08** (điểm RICE đã duyệt) | [phase-03-product-layer-and-skeletons.md](phase-03-product-layer-and-skeletons.md) | 2 | L2 PRD, L2 roadmap (duyệt điểm RICE) |
| 4 | Pilot end-to-end: `checkout` | [phase-04-pilot-checkout.md](phase-04-pilot-checkout.md) | 3 | Retro pilot, chốt công thức |
| 5 | Rollout R0 (8 feature) | [phase-05-rollout-r0.md](phase-05-rollout-r0.md) | 4 | Duyệt từng feature |
| 6 | Rollout R1A (8 feature còn lại) | [phase-06-rollout-r1a.md](phase-06-rollout-r1a.md) | 5 | Duyệt từng feature |
| 7 | Rollout R1B, R2, R3 (6 feature) | [phase-07-rollout-r1b-r2-r3.md](phase-07-rollout-r1b-r2-r3.md) | 6 | Duyệt từng feature |
| 8 | Gỡ feature gộp, sửa link, retire ID | [phase-08-retire-umbrella.md](phase-08-retire-umbrella.md) | 7 | Kiểm 0 link gãy |
| 9 | Review chéo, traceability, bàn giao | [phase-09-review-handoff.md](phase-09-review-handoff.md) | 8 | Người dùng duyệt PR |

Tiến độ hiện tại và việc tiếp theo: [checkpoint-2026-10-09.md](checkpoint-2026-10-09.md) (phase 4–7 đang chạy theo tầng, duyệt theo lô release).

Công thức chạy cho một feature (dùng ở phase 4–7): [feature-recipe.md](feature-recipe.md).
Ma trận phân bổ nháp (đầu vào phase 1): [feature-allocation-draft.md](feature-allocation-draft.md).

## Ước lượng khối lượng

- 22 feature chạy đủ chuỗi + 1 feature chỉ có envelope. Mỗi feature khoảng 9–12 điểm duyệt (L1/L2/HARD STOP user-flow); rollout gom duyệt theo lô (xem `feature-recipe.md` Mục "Gom duyệt").
- Runtime không có skill `/urd`, `/brd`, `/prd-epic`, và quy trình không dùng các bước này (D4).

## Tiêu chí hoàn thành

- [ ] 23 thư mục feature tồn tại, frontmatter đúng `feature: {slug}`.
- [ ] 22 feature có đủ: brainstorm, `srs/{feature}-spec.md`, use case, userflow (`stage: flow-approved`), wireframe HTML, user story có AC, checklist. Feature thiếu artifact phải ghi lý do trong PRD feature.
- [ ] `expansion-candidates` có brainstorm, ghi rõ không build.
- [ ] `grep -rE '(FR|NFR|BR|E|SC|OQ|CHK)-LMP-' docs/` chỉ còn trong bảng đối chiếu.
- [ ] `docs/features/library-management-platform/` không còn tồn tại.
- [ ] KG build: 0 broken ref do namespace; mục "Phải Read tay" không còn short-form ID.
- [ ] Sơ đồ mermaid: **không kiểm bằng máy** trên môi trường này (`mermaid-verify.mjs` không hỗ trợ Windows, người dùng chọn bỏ qua 2026-10-08) — kiểm bằng mắt khi review.
- [ ] Tầng sản phẩm: PRD có Feature Map đủ cột + 23 khối 7.x; roadmap có xếp hạng ưu tiên, feature theo slug, sơ đồ phụ thuộc mức feature.
- [ ] Ma trận phân bổ: 100% item nguồn có đích, 0 item mồ côi, 0 item hai chủ.
- [ ] Review chéo (senior-ba, qa-reviewer, pm-reviewer) không còn BLOCKING.

## Rủi ro chính

| Rủi ro | Kiểm soát |
|---|---|
| Thành viên khác đang sửa `library-management-platform` trên `develop-bao`/`develop-hoang` → conflict lớn | Phase 0 đóng băng + merge các nhánh vào trước khi tách |
| Đánh lại ID sai làm gãy truy vết | Bảng đối chiếu sinh bằng script, kiểm đối xứng 2 chiều ở phase 8 |
| KG không hiểu ID trong `docs/_shared/` (thư mục project-level, không có feature context) | Spike ở phase 0 trước khi chốt namespace dùng chung |
| Mệt duyệt với ~300 điểm duyệt | Pilot trước, gom duyệt theo lô, chế độ Confirm-only cho brainstorm khi đã đủ dữ kiện |
| Hook stale-propagation đánh `stale` hàng loạt khi di chuyển file | Ghi nhận, dọn ở phase 8 bằng một lượt duyệt, không xử lý từng file |

## Rollback

Phase 0 tạo tag `pre-split-features` trên `develop-dat`. Mọi phase làm trên nhánh `docs/split-features`; chưa merge thì bỏ nhánh là quay về nguyên trạng.

## Câu hỏi còn mở

Xem `feature-allocation-draft.md` Mục 4 (xung đột phân bổ cần người dùng quyết) và phase 0 bước 5 (namespace ID cho phần dùng chung).
