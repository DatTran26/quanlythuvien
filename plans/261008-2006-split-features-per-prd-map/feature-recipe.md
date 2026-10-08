# Công thức chạy cho một feature

Dùng ở phase 4–7. `{f}` là slug feature, `{F}` là đường dẫn `docs/features/{f}`. Nguồn nội dung cho mỗi bước là phần đã phân bổ cho `{f}` trong ma trận đã duyệt ở phase 1 (`docs/_shared/id-crosswalk-lmp.md`), cộng tầng chung ở `docs/_shared/`. **Không bịa nội dung mới**: chỗ ma trận không có nguồn thì ghi câu hỏi mở, không tự điền.

## Thứ tự 9 bước

| # | Bước | Công cụ | Output | Nguồn vào | Cổng duyệt |
|---|---|---|---|---|---|
| 1 | Brainstorm feature | `/brainstorm` (Confirm-only hoặc Targeted deep) | `{F}/brainstorms/{f}-scope.md` | `docs/_product/product-roadmap-baseline.md` + dòng Feature Map + item đã phân bổ | Dòng đề xuất chế độ + L1 |
| 2 | URD | Viết tay theo `_templates/urd.md` | `{F}/{f}-urd.md` | brainstorm bước 1, `project-profile.md` | L1 (L2 nếu đã có) |
| 3 | BRD | Viết tay theo `_templates/brd.md` | `{F}/{f}-brd.md` | URD, `roadmap.md`, `readiness-gates.md`, `decision-register.md` | L1 |
| 4 | PRD feature | Viết tay theo `_templates/prd.md` | `{F}/{f}-prd.md` | BRD; CAP từ Feature Map; cột `Done when` | L1 |
| 5 | SRS Tầng 1 | `/srs {f}` chọn tầng `4` | `{F}/srs/{f}-spec.md` | PRD feature + FR/BR/E/NFR/SC đã phân bổ (đổi sang mã mới) | L1 |
| 6 | SRS Tầng 2 | (trong `/srs`) | `{F}/usecases/uc-*.md` + `{f}-usecase-index.md`; `{F}/srs/{f}-flows.md` | UC và flow section đã phân bổ | L1 gộp Tầng 2 |
| 7 | SRS Tầng 3 | `/user-flow {f}` rồi `/wireframe-html {f}` | `{F}/srs/{f}-userflow.md` (`primary_device: mobile`); `{F}/html-wireframe/` | Flow + màn đã phân bổ, HTML cũ làm tham chiếu | HARD STOP user-flow + L1 wireframe |
| 8 | SRS Tầng 4 | `/userstory {f}` rồi `/ac {f}` | `{F}/userstories/us-NNN.md` + `{f}-story-index.md` | Story cũ đã phân bổ (đánh lại US-001…) + FR chưa có story | L1 + L2 |
| 9 | Checklist | `/test-checklist {f}` | `{F}/test/test-strategy.md`, `{F}/test/checklist/` | CHK cũ đã phân bổ + `docs/_shared/test-strategy-baseline.md` | L1 |

Sau bước 9: chạy `/srs` Phase G (review tự động) và Phase H (xử lý câu hỏi mở) cho feature. Ghi kết quả vào changelog qua hook.

## Quy tắc khi chuyển nội dung cũ

- **Chuyển, không viết lại:** prose của FR/UC/story/AC/CHK đã có giữ nguyên ý, chỉ đổi ID, tên vai trò (theo X7) và link. Thay đổi ý nghĩa phải qua L2 diff có ghi lý do.
- **ERD/states:** feature không có file `srs/{f}-erd.md` hay `srs/{f}-states.md` riêng. SRS Mục 8 liệt kê entity feature dùng và link `docs/_shared/domain/library-erd.md#{entity}`. Khi `/srs` hỏi Tầng 2, chỉ chạy use case + flows.
- **Tham chiếu chéo feature:** dùng ID đầy đủ của feature kia (vd `FR-copy-inventory-002`) và wikilink full path. Không chép requirement của feature khác vào spec của mình.
- **Câu hỏi mở:** OQ mới đánh `OQ-{f}-NNN`. OQ chuyển từ LMP giữ nội dung, ghi mã cũ trong ngoặc một lần để truy vết.
- **Story:** đánh lại `US-001` trong từng feature. AC giữ `AC-NNN` trong story.
- **Checklist:** `CHK-{f}-NNN`, `next_chk_id` bắt đầu lại từ 1 cho mỗi feature.
- **Wireframe:** HTML cũ dùng làm nguồn element. Flow cũ bị tách cho 2 feature (vd `catalog-admin-flow`) thì mỗi feature chỉ giữ màn của mình; nút điều hướng sang màn của feature khác ghi rõ đích theo `docs/_shared/navigation-map.md`.

## Mã ID theo feature

| Loại | Mẫu | Ví dụ |
|---|---|---|
| FR / NFR / BR / E | `{TYPE}-{f}-NNN` | `FR-checkout-001`, `E-checkout-001` |
| SC | `SC-{f}-NN` | `SC-checkout-01` |
| BO / CAP | `BO-{f}-NN`, CAP giữ mã sản phẩm `CAP-<NAME>` | `BO-checkout-01`, `CAP-CIRC` |
| UN (user need) | `UN-{f}-NN` | `UN-checkout-01` |
| OQ | `OQ-{f}-NNN` | `OQ-checkout-001` |
| CHK | `CHK-{f}-NNN` | `CHK-checkout-001` |
| US / AC / UC | Theo path (`US-NNN`, `AC-NNN`, `uc-{slug}`) | — |
| Dùng chung | Namespace chốt ở phase 0 bước 5 (đề xuất `core`) | `BR-core-003` |

## Gom duyệt (giảm số lần hỏi)

- Bước 2–4 (URD, BRD, PRD) trình **một L1 gộp** cho cả 3 file của một feature, vì đều là file mới và cùng nguồn.
- Bước 1 dùng chế độ Confirm-only khi ma trận đã đủ dữ kiện (đa số feature), chỉ hỏi chỗ trống.
- Feature cùng release chạy liên tiếp; câu hỏi cấp dự án đã trả lời ghi vào `project-profile.md` để không hỏi lại.
- Không gộp L1 giữa các feature khác nhau.

## Định nghĩa "xong" cho một feature

- [ ] Đủ 9 output ở bảng trên (hoặc có lý do bỏ ghi trong PRD feature).
- [ ] Mọi item ma trận phân bổ cho `{f}` xuất hiện với mã mới; cột "đã chuyển" trong `id-crosswalk-lmp.md` đánh dấu.
- [ ] `node .claude/skills/kg/engine/kg-query.mjs facts {f}` không có broken ref nội bộ feature.
- [ ] `mermaid-verify.mjs` exit 0 cho `{F}/srs/*.md`.
- [ ] Mọi FR P0 có ít nhất một story; FR P1/P2 không có story thì ghi lý do trong story index.
- [ ] Review tự động `/srs` Phase G không còn BLOCKING.
- [ ] Dòng feature trong `docs/_product/prd.md` Feature Map cột "Chi tiết hóa" cập nhật qua L2.
