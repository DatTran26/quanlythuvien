---
title: "Phase 3: Chuẩn hóa tầng sản phẩm theo /prd → /roadmap + khung 23 thư mục"
status: pending
priority: P1
effort: "1 ngày + 2 vòng duyệt"
dependencies: [2]
---

# Phase 3: Chuẩn hóa tầng sản phẩm theo /prd → /roadmap + khung 23 thư mục

## Mục tiêu

Tầng sản phẩm (`docs/_product/`) đi đúng quy trình `/prd` → `/roadmap` và là nguồn đầu vào đáng tin cho 23 feature: mỗi feature có mô tả, phạm vi, ưu tiên, phụ thuộc và trạng thái chi tiết hóa ở cấp sản phẩm trước khi bắt đầu chuỗi tài liệu của nó. Runtime không có skill `/prd`, `/roadmap`, nên làm theo `_templates/prd-product.md` và `_templates/roadmap.md`, với approval gate L1/L2 như các skill BA.

## Hiện trạng (soát ngày 2026-10-08)

| # | Tài liệu | Thiếu so với quy trình | Bằng chứng |
|---|---|---|---|
| P1 | `prd.md` Mục 7 | Bảng Feature Map thiếu cột **Chi tiết hóa** (template có; `/brainstorm` Phase E2 và KG dựa vào cột này). Cột ưu tiên dùng P0/P1 thay vì MoSCoW | KG báo "bảng Feature Map thiếu cột detail_status"; `prd.md:119` |
| P2 | `prd.md` Mục 7 | Không có khối chi tiết từng feature **7.1…7.23** (mô tả what/why/outcome, job phục vụ, phạm vi v1, chưa làm, luồng chính, rủi ro, chỉ số, OQ riêng) — đây là cầu nối từ sản phẩm xuống từng feature | Template `prd-product.md:65-78` |
| P3 | `prd.md` Mục 3, Mục 7 | Tên vai trò cũ (Nhân viên/Thủ thư); value stream bước 2 có "Người đọc đăng ký"; dòng `reader-self-service`, `account-admin`, `lost-handling` lệch DEC-SF-01..07 | `prd.md:52-54`, `:110`, Feature Map |
| P4 | `roadmap.md` | Thiếu **Mục "Xếp hạng ưu tiên"** (RICE-lite: Reach, Impact, Confidence, Evidence, Effort, Điểm) cho từng feature; không có ở `priority-crosswalk.md` | Template `roadmap.md:21-27`; grep RICE/Reach = 0 |
| P5 | `roadmap.md` | Release liệt kê theo capability (`CAP-*`), không theo **slug feature** → KG parse ra 0 item, feature không biết mình thuộc release nào qua roadmap | KG "parseRoadmap trích được 0 item"; `roadmap.md:47`, `:62` |
| P6 | `roadmap.md` | Frontmatter thiếu `format` và `next_review`; sơ đồ phụ thuộc chỉ ở mức release, chưa có mức feature | `roadmap.md:1-10`, Mục 2 |
| P7 | `priority-crosswalk.md` | Map FR nguồn → priority/release nhưng chưa có cột **feature đích**; tên vai trò cũ | `priority-crosswalk.md` |
| P8 | Cả `_product/` | Mọi quyết định `DEC-D3`, `DEC-P2` đều `Open/PROPOSAL`; PRD Mục 12 Approval chưa có người duyệt — vướng OQ-LMP-001 (ai có quyền duyệt) | `decision-register.md`; `prd.md` Mục 12 |

## Các bước

### A. PRD sản phẩm (`docs/_product/prd.md`) — L2

1. **Tên vai trò** theo DEC-SF-01 ở Mục 3, 6, 7, 10; giữ dòng giải thích mapping tên nguồn.
2. **Value stream** Mục 7: bước 2 đổi thành "Thủ thư cấp và kích hoạt tài khoản tại quầy" (DEC-SF-03); bổ sung bước cho tự phục vụ R1A (DEC-SF-02).
3. **Bảng Feature Map** theo đúng template: thêm cột `Chi tiết hóa` (`⬜ chưa` cho 23 dòng), đổi cột ưu tiên sang MoSCoW (P0 → Must, P1 → Should, P2 → Could; giữ P0/P1 trong ngoặc để đối chiếu), giữ cột Release (bổ sung có chủ đích, ghi chú lý do ở Mục 0). Sửa release/priority các dòng theo DEC-SF-02/04/06. Cột Slug thành wikilink tới `docs/features/{slug}/{slug}-prd.md`.
4. **Khối 7.1…7.23**: viết cho từng feature theo template, rút nội dung từ ma trận phân bổ phase 1, Mục 6 Capability Themes, roadmap và SRS cũ. Chỗ chưa có nguồn ghi OQ, không bịa. `expansion-candidates` ghi rõ không cam kết build.
5. **Mục 12 Approval**: ghi trạng thái thật (chưa có approver, chặn bởi OQ-LMP-001), không đánh `approved`.
6. Bỏ link `docs/features/library-management-platform/brainstorms/…` trong frontmatter, thay bằng `docs/_product/product-roadmap-baseline.md` (đã chuyển ở phase 2).

### B. Roadmap (`docs/_product/roadmap.md`) — L2

7. **Giữ cấu trúc theo release R0–R3** (DEC-P2-08, phù hợp vì release gắn readiness gate) và ánh xạ sang horizon của template: Now = R0 + R1A, Next = R1B, Later = R2 + R3. Frontmatter thêm `format: now-next-later` kèm ghi chú ánh xạ, và `next_review`.
8. **Thêm Mục "Xếp hạng ưu tiên"** RICE-lite cho 23 feature theo bảng template. Reach/Impact/Effort là đề xuất của BA có ghi Evidence; Confidence phản ánh mức PROPOSAL (thường 0.5–0.8). Trình người dùng duyệt điểm, không tự chốt.
9. **Mỗi release liệt kê feature theo slug** (`* **Tên** (\`slug\`) — đóng góp vào outcome`) bên cạnh capability hiện có, để KG parse được và feature tra được release.
10. **Sơ đồ phụ thuộc mức feature** (mermaid `graph LR`) từ cột Phụ thuộc của Feature Map, đặt dưới sơ đồ release hiện có.

### C. Tài liệu sản phẩm bổ trợ — L2

11. `priority-crosswalk.md`: thêm cột `Feature đích` cho mỗi FR nguồn (theo phase 1), đổi tên vai trò theo DEC-SF-01.
12. `readiness-gates.md`: gắn feature vào từng gate (vd GATE-MIG ← `data-import`, `copy-inventory`; GATE-OPS ← `ops-foundation`), đổi tên vai trò.
13. `decision-register.md`: thêm cột hoặc ghi chú "feature bị ảnh hưởng" cho các DEC-D3/P2 để khi rollout từng feature biết quyết định nào còn chặn mình.

### D. Khung 23 thư mục

14. Xác nhận 23 slug khớp Feature Map, đúng kebab-case ASCII ≤50 ký tự. Danh sách thư mục con cần tạo cho từng feature (thư mục thật chỉ xuất hiện khi có file đầu tiên ở phase 4–7, không commit thư mục rỗng hay file stub):

    | Thư mục con | Feature |
    |---|---|
    | `brainstorms/` | 23 feature |
    | `srs/`, `usecases/`, `userstories/`, `test/checklist/` | 22 feature (trừ `expansion-candidates`) |
    | `html-wireframe/` | Feature có màn (không có cho `overdue-fines`, `ops-foundation`) |

15. Viết lại `docs/README.md` thành bản đồ tài liệu: tầng sản phẩm (`_product/`), tầng dùng chung (`_shared/`), 23 feature theo release, thứ tự đọc. Cột trạng thái lấy từ cột Chi tiết hóa của Feature Map.

## Kiểm sau mỗi lượt sửa

- `grep -rl '^status: stale' docs/` — hook stale-propagation sẽ đánh `stale` các doc có `links:` trỏ tới `prd.md`/`roadmap.md`. Stale giả (nội dung không bị ảnh hưởng) trả về trạng thái cũ, ghi lại số lượng.
- KG build: `prd.md` và `roadmap.md` không còn trong mục "Phải Read tay".

## Tiêu chí xong

- PRD có Feature Map đủ cột theo template và 23 khối 7.x.
- Roadmap có bảng xếp hạng ưu tiên đã được người dùng duyệt, mỗi release liệt kê feature theo slug, có sơ đồ phụ thuộc mức feature.
- PRD, roadmap, crosswalk, readiness-gates, decision-register không mâu thuẫn nhau và không mâu thuẫn DEC-SF-01..09.
- `docs/README.md` là bản đồ tài liệu.

## Rủi ro

| Rủi ro | Xử lý |
|---|---|
| Điểm RICE dễ bị coi là số đo thật | Ghi rõ là xếp hạng tương đối, có cột Evidence và Confidence |
| Khối 7.x trùng nội dung với PRD feature viết ở phase 4–7 | 7.x chỉ là tóm tắt cấp sản phẩm (5–8 dòng); chi tiết sống ở `{slug}-prd.md`, 7.x link xuống |
| Sửa PRD kéo stale hàng loạt | Kiểm và dọn sau mỗi lượt như mục trên |
