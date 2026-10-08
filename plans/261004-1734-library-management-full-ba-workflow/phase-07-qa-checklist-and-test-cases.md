---
title: "Phase 7: QA checklist và test cases"
status: in-progress
priority: P1
effort: "2 review cycles"
dependencies: [4, 5, 6]
---

# Phase 7: QA checklist và test cases

## Mục tiêu

Dùng `test-checklist` rồi `test-cases` để tạo baseline QA có coverage theo obligation và cardinality 1:1 từ checklist đến test case.

## Trạng thái 2026-10-08

Checklist feature đã được sinh ở trạng thái `draft`: 97 mục, `next_chk_id` 98, 12 nhóm. Coverage còn `blocked`, `tbd` và `partial` nên scope chưa đóng. Test case chưa được sinh vì checklist chưa được duyệt và story vẫn Not Ready.

## Yêu cầu

- Checklist được sinh từ SRS, UC, BR, Error, story, AC và flow đã duyệt; không sinh từ trí nhớ.
- Mỗi checklist item là một test obligation nguyên tử, có ID `CHK-*`, source ref, priority và expected observation.
- Bao phủ positive, negative, boundary, permission, state transition, concurrency, recovery và audit.
- `test-cases` chỉ chạy sau checklist approval; mỗi CHK ánh xạ đúng một TC theo schema 10 trường bắt buộc.
- Item thiếu data/precondition/expected result giữ Not Ready/TBD có owner; không bịa dữ liệu.

## File tác động

- Tạo/cập nhật `docs/features/library-management-platform/test/test-strategy.md`.
- Tạo `test/checklist/library-management-platform-checklist-index.md`, `checklist-*.md`, `preview.html`, `data.js`.
- Tạo `test/testcases/library-management-platform-testcase-index.md`, `testcases-*.md`, `preview.html`, `data.js`.
- Master checklist giữ `next_chk_id`, Coverage và Retired CHK-IDs; test data/fixture reference sống trong test strategy, không chứa secret.

## Các bước thực hiện

1. Lập source inventory và coverage obligation matrix.
2. Intake và duyệt `test-strategy.md`, gồm environment/data/device/language/NFR/thiếu dữ liệu.
3. Chạy `test-checklist` ở feature scope; dùng `next_chk_id`, grammar và partition rule của skill.
4. Review completeness/atomicity; chốt checklist approval trước khi sinh TC.
5. Nếu checklist vượt 200 item, chia theo value stream nhưng giữ một master index và ID duy nhất.
6. Chạy `test-cases` từ checklist mới nhất; tạo đúng một TC cho mỗi CHK và giữ source trace.
7. Kiểm tra schema 10 trường, data readiness, precondition, bước, expected result và cleanup.
8. Lập coverage report cho cả FR/BR/Error/NFR và Not Ready register; không che thiếu sót bằng test chung chung.

## Todo

- [x] Hoàn thiện source inventory/obligation matrix ở trạng thái draft.
- [ ] Sinh và duyệt checklist. Bản draft đã có; chưa có evidence duyệt.
- [ ] Partition nếu vượt ngưỡng quản lý.
- [ ] Sinh test case 1:1.
- [ ] Kiểm tra schema/cardinality/traceability.
- [ ] Lập Not Ready register và coverage summary.

## Verification

- Số TC bằng số CHK eligible; mỗi ID ánh xạ một-một, không trùng/thiếu.
- Mỗi AC/BR/Error/NFR P0 có checklist hoặc verification-evidence coverage; exception có rationale được duyệt.
- TC không gộp nhiều obligation độc lập.
- Test data không chứa PII thật và không phụ thuộc môi trường không được mô tả.

## Kịch bản kiểm tra tối thiểu

| Nhóm | Coverage bắt buộc |
|------|-------------------|
| State | mọi transition hợp lệ + representative invalid transition |
| Boundary | loan limit, renew limit, due/expiry boundary, fine threshold |
| Permission | role allowed/denied, least privilege, audit visibility |
| Concurrency | same-copy checkout, queue advancement, duplicate payment/action |
| Recovery | notification fail, payment fail, retry/idempotency, lost-found |
| Data/privacy | validation, masking, retention/deletion theo quyết định đã duyệt |

## Rủi ro và an toàn

- Chỉ dùng synthetic test data; tách secret/config môi trường khỏi tài liệu.
- Không đánh dấu Pass/Ready cho case còn TBD hoặc phụ thuộc decision Open.

## Tiêu chí hoàn tất

- [ ] Checklist có approval evidence.
- [ ] 100% CHK eligible có đúng một TC hợp lệ.
- [ ] P0 AC/BR/Error/NFR có coverage hoặc exception được duyệt.
- [ ] Not Ready/TBD có owner và due gate.

## Bước kế tiếp

Đóng traceability end-to-end và handoff ở Phase 8.
