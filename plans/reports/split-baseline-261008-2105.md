# Số liệu gốc trước khi tách feature

Mốc đối chiếu cho phase 8 ("không mất nội dung") của `plans/261008-2006-split-features-per-prd-map/`. Chụp trên nhánh `docs/split-features` tại tag `pre-split-features` (commit `d385997`), ngày 2026-10-08.

## 1. Item trong feature gộp `library-management-platform`

| Loại | Số lượng | Nguồn đếm |
|---|---|---|
| FR | 28 | Bảng spec Mục 3 (`FR-LMP-001..028`) |
| NFR | 12 | Bảng spec Mục 4 |
| BR | 17 | Bảng spec Mục 5 |
| Error | 18 | Bảng spec Mục 6 |
| Success Criteria | 7 | Bảng spec Mục 7 |
| OQ trong spec | 18 | Spec Mục 12 |
| OQ toàn feature (KG) | 61 | `kg-query facts --all`, gồm OQ ở brainstorm, userflow, ERD, flows, states, use case, story |
| Use case | 10 | `usecases/uc-*.md` |
| User story | 18 | `userstories/us-001..018.md` |
| Acceptance criteria | 72 | Heading `AC-NNN` trong story (khớp KG) |
| CHK | 97 | `CHK-LMP-*` trong `checklist-feature.md` (khớp KG; `next_chk_id: 98`) |
| Flow (userflow) | 11 | `### Flow:` trong userflow |
| Màn hình | 38 | Bảng userflow Mục 2. KG đếm 46 vì tính thêm 8 slug màn tham chiếu từ use case không có trong userflow (vd `checkout`, `catalog-admin`) — 8 slug này là tên nhóm, không phải màn thật; phase 1 xác nhận lại |
| Entity | 14 | ERD + KG |
| State transition | 35 | `COPY/LOAN/RES/DMG-Tnn` trong `domain/lifecycle-inventory.md` |
| Flow kỹ thuật (flows.md) | 8 | Mục 1–8 (F1..F8) + Mục 0 invariant chung |
| State machine | 5 | Copy, Loan, Reservation, Fine, DamageReport |

## 2. File

55 file được git theo dõi: brainstorms 1, domain 1, html-wireframe 13 (11 flow + cửa vào + index), srs 5, test 5 (strategy + checklist index + checklist + `data.js` + `preview.html`), usecases 11, userstories 19. Thư mục `test/testcases/` trống, chưa có file.

## 3. KG

- Build: 497 node, 2137 edge, 48/51 doc parse được, **233 tham chiếu không giải được**.
- 233 tham chiếu gãy: 172 `BR-library-management-platform-*` + 18 `NFR-library-management-platform-*` (KG mở rộng ID dạng ngắn `BR-01`, `NFR-01` của tài liệu nguồn thành ID feature), 43 `CHK-library-management-platform-*`. Mục tiêu sau phase 8: 0.
- Doc phải Read tay (ngoài graph): `prd.md` (thiếu cột `detail_status` ở Feature Map), `roadmap.md`, `…-wireframe-html-index.md`, `…-flows.md`, `…-states.md` (parse ra 0 item), `he_thong_quan_ly_thu_vien.md`, `docs/README.md`, `references/COMMIT.md`.

## 4. Kết luận spike namespace dùng chung

Đã thử `BR-core-001` trong file tạm `docs/_shared/_spike-core.md`, tham chiếu từ một spec feature tạm. KG tạo node `requirement (BR)` với `Feature: —` và nối cạnh `REFERENCES` từ FR của feature. **Namespace `core` dùng được** cho NFR/BR/E dùng chung. File tạm đã xóa, KG đã build lại về đúng số liệu ở Mục 3.

## 5. Kết luận về hook

Quan sát thực tế trong phiên 2026-10-08:
- Sửa một doc qua công cụ Write/Edit làm hook `ba-kit-run.mjs` chuyển mọi doc có `links:` trỏ tới doc đó từ `draft` sang `stale` và ghi thêm dòng vào `docs/_shared/staleness.md`. Sửa `decision-register.md` đã kéo theo 20 doc.
- Thao tác qua shell (`git mv`, `sed`, script) không kích hoạt hook.
- Hệ quả cho các phase sau: di chuyển file dùng `git mv`; sau mỗi lượt sửa tài liệu tầng trên phải kiểm `grep -rl '^status: stale' docs/` và dọn nếu stale là giả.

## 6. Công cụ

- Chrome Headless Shell đã cài tại `~/.cache/puppeteer/chrome-headless-shell/win64-155.0.8059.39/`.
- **`mermaid-verify.mjs` vẫn không chạy được trên Windows**: hàm `findChrome()` (`.claude/scripts/mermaid-verify.mjs:50-61`) chỉ dò `~/.puppeteer-cache/chrome` với layout macOS và Linux, và không đọc biến môi trường `PUPPETEER_EXECUTABLE_PATH`. Cần người dùng cho phép sửa script, hoặc chạy kiểm sơ đồ trên máy macOS/Linux. Chưa có baseline kết quả kiểm 4 file mermaid.
