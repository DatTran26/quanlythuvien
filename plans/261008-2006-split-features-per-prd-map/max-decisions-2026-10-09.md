# Max — quyết định thi công tài liệu còn lại

Ngày: 2026-10-09. Người dùng ủy quyền Max tự trả lời mọi câu phỏng vấn skill / HARD STOP. Đánh 🔶 = Max tự chốt (soát lại nếu cần).

## Ủy quyền

- HARD STOP `/user-flow`, L1 `/wireframe-html`, L1 `/userstory`, L1 `/ac`, L1 `/test-checklist`: **chốt / Apply Y**.
- Không commit, không push, không PR, không xóa `docs/features/library-management-platform/` (Phase 8 phải hỏi lại). **Cập nhật:** user xác nhận xóa 2026-10-09 — Phase 8 đã chạy.
- Không bịa số nghiệp vụ chưa chốt. OQ nguồn giữ nguyên.

## Quyết định 🔶 đã chốt

| ID | Quyết định |
|---|---|
| 🔶-01 | `primary_device: mobile` (khung 375) cho mọi user flow / wireframe. |
| 🔶-02 | Vai trò: Người đọc / Thủ thư / Quản trị viên (DEC-SF-01, DEC-SF-08). |
| 🔶-03 | Hạn mức mượn: 5 cuốn / 14 ngày / nợ từ 50.000đ chặn (DEC-SF-10). |
| 🔶-04 | OQ-5 khổ giấy/máy in biên nhận: **giữ mở**. Wireframe ghi "biên nhận trên màn + in (máy/khổ OQ)". |
| 🔶-05 | Nhãn FACT/PROPOSAL chưa có DEC thay thế: **giữ**. |
| 🔶-06 | `overdue-fines`, `ops-foundation`: không user flow / wireframe. |
| 🔶-07 | `expansion-candidates`: không vẽ, không story/checklist đầy đủ — giữ brainstorm. |
| 🔶-08 | `reader-self-service`: cổng mobile-first; R1A gồm tra cứu, chi tiết đầu sách (chỉ xem), thẻ QR, đang mượn, lịch sử; R1B thêm màn công nợ tối thiểu (không chờ cổng đầy đủ). Khóa tài khoản: vẫn xem dữ liệu của mình nếu đăng nhập được — OQ-003 giữ. |
| 🔶-09 | `notification-core`: một màn `notification-status` (outbox/retry/dead-letter) cho vận hành. Trung tâm thông báo người dùng thuộc `notification-audit-ui` (DEC-SF-09). |
| 🔶-10 | `ops-reports`: dashboard RP-01/02/04 + empty/error; R1B thêm danh sách quá hạn cho Thủ thư. `trend-reports`: cùng khung dashboard, RP-03/05/06/07 (R2). |
| 🔶-11 | `lost-handling`: R1A ghi nhận mất tối thiểu; R1B tìm lại — 2 lát trên cùng flow, đánh nhãn release. |
| 🔶-12 | `renewal`: quầy + online (Người đọc) đều R1B. `reservation`: quầy + online R2. |
| 🔶-13 | `fine-collection-basic`: list/detail/thu tiền mặt. `fine-collection-adv`: sự kiện tài chính, biên nhận, miễn/điều chỉnh/refund + step-up. |
| 🔶-14 | Link sang feature chưa có wireframe: **chữ** (không href chết). Feature đã có: `../../{slug}/html-wireframe/{flow}.html#sN`. |
| 🔶-15 | Ghi file bằng Python (`pathlib.write_text`, utf-8) — không dùng Edit/StrReplace trên `docs/features/**` (tránh hook stale). |
| 🔶-16 | **Không** sửa `docs/_shared/changelog.md`, `docs/_product/prd.md`, `docs/features/library-management-platform/**`. Max ghi changelog sau. |
| 🔶-17 | Mermaid: quote phòng thủ mọi label có `≥ ≤ + / ? & ( ) :`; `<br/>` cho xuống dòng; không HTML entity. `flow_hash` = 8 ký tự hex đầu SHA-256 của nội dung Mục 1 (kể cả fence). `stage: flow-approved`, `flow_approved_at: 2026-10-09`. |
| 🔶-18 | Đánh số màn `[1]` lại theo từng feature. Đổi mã `*-LMP-*` theo `docs/_shared/id-crosswalk-lmp.md`. |
| 🔶-19 | Story: chuyển từ LMP theo crosswalk, persona DEC-SF-08; FR mới (DEC-SF) thì tách story mới từ spec, đánh OQ nếu thiếu số. AC chuyển kèm, remap ID lỗi/FR. |
| 🔶-20 | Checklist: `CHK-{feature}-NNN`; `test-strategy.md` trích `docs/_shared/test-strategy-baseline.md`. |

## Ánh xạ màn LMP → feature

| Nguồn LMP | Feature đích | Ghi chú |
|---|---|---|
| checkout-flow [14–17] | `checkout` | circulation-desk, checkout-scan, checkout-review, checkout-conflict |
| return-renewal-flow [18–19] | `return-handling` | return-scan, return-result |
| [20] renewal-result | `renewal` | |
| reservation-flow [21–24] | `reservation` | + nhánh cổng người đọc |
| fine-payment-flow [25–27] | `fine-collection-basic` | |
| [28] financial-events | `fine-collection-adv` | |
| damage-lost-found-flow [29–30] | `damage-lifecycle` | |
| [31] lost-found | `lost-handling` | |
| [32] notification-status | `notification-core` | |
| [33–34] + màn mới trung tâm TB | `notification-audit-ui` | DEC-SF-09 |
| [38] reports-flow | `ops-reports` + `trend-reports` | tách RP theo spec |
| (không có) | `reader-self-service` | vẽ mới |

## Mẫu userflow (bám R0)

Xem `docs/features/access-control/srs/access-control-userflow.md`. Frontmatter + 4 mục. Vietnamese. Open Questions copy từ spec của feature (không bịa thêm số).

## Mẫu wireframe

- CSS/cấu trúc copy `docs/features/access-control/html-wireframe/auth-flow.html` và cửa vào `*-wireframe.html` + `*-wireframe-html-index.md`.
- Nguồn element: `docs/features/library-management-platform/html-wireframe/*-flow.html`.
- Đen trắng, Mobile 375, `id="sN"` khớp số màn.

## Story LMP → feature (crosswalk)

| LMP | Feature | US mới |
|---|---|---|
| US-001, US-002 | access-control | US-001, US-002 |
| US-003, US-005 | catalog-admin | US-001, US-002 |
| US-004 | copy-inventory | US-001 |
| US-006 | reader-onboarding | US-001 (+ story account-admin cho cập nhật/xóa mềm) |
| US-007 | policy-config | US-001 |
| US-008, US-009 | data-import | US-001, US-002 |
| US-010 | ops-foundation | US-001 (+ US backup/restore từ FR-ops-foundation-002) |
| US-011 | checkout | US-001 |
| US-012 | return-handling | US-001 |
| US-013 | overdue-fines | US-001 |
| US-014 | fine-collection-basic | US-001 |
| US-015, US-016 | damage-lifecycle | US-001, US-002 |
| US-017 | lost-handling | US-001 |
| US-018 | notification-core | US-001 |

FR P0 chưa có story LMP → tạo story mới từ spec (reader-self-service, ops-reports, account-admin CRUD Thủ thư, renewal, reservation, fine-collection-adv, notification-audit-ui, trend-reports, lost-handling R1B found).

## Cấm

- Không đụng file ngoài folder feature được giao.
- Không chạy mermaid-verify (Windows). Rà quote bằng mắt.
- Không commit.
