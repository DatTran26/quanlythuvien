---
title: "Phase 5: UX flow và HTML wireframe"
status: pending
priority: P1
effort: "2 approval cycles"
dependencies: [4]
---

# Phase 5: UX flow và HTML wireframe

## Mục tiêu

Dùng `user-flow` và `wireframe-html` để biến use case đã duyệt thành luồng tổng và prototype đen trắng kiểm tra được, phủ happy/error/empty/permission/recovery.

## Yêu cầu

- `user-flow` chạy ở main thread, có HARD STOP và UX reviewer đúng quy định skill.
- Flow phải chỉ ra actor, entry, decision, validation, system response, error recovery và terminal outcome.
- Xác nhận thiết bị trước khi dựng wireframe; đề xuất mặc định responsive desktop-first vì nghiệp vụ vận hành, nhưng không tự coi là đã duyệt.
- Wireframe chỉ dùng field/action có nguồn; field chưa xác minh phải đánh dấu OQ, không tự bịa.
- Mỗi màn hình và transition truy vết về UC/FR/BR/Error tương ứng.

## File tác động

- Tạo `docs/features/library-management-platform/srs/library-management-platform-userflow.md`.
- Tạo `docs/features/library-management-platform/html-wireframe/library-management-platform-wireframe-html-index.md`.
- Tạo entry bắt buộc `docs/features/library-management-platform/html-wireframe/library-management-platform-wireframe.html`.
- Tạo các `{flow-slug}.html` trực tiếp dưới `docs/features/library-management-platform/html-wireframe/`.

## Các bước thực hiện

1. Chạy `user-flow` từ SRS/use cases đã duyệt; lập flow coverage matrix theo value stream.
2. Review flow với UX reviewer; sửa severity blocker/major và lưu approval evidence.
3. Chốt thiết bị/layout constraint tại approval gate của flow.
4. Chạy `wireframe-html` chỉ sau khi flow-approved; dựng entry page và từng flow độc lập.
5. Tạo screen inventory, transition table và mapping source field/action.
6. Mở entry HTML, đi qua toàn bộ link/action chính; kiểm tra responsive, keyboard focus và trạng thái lỗi/empty.

## Todo

- [ ] Hoàn thiện master user flow.
- [ ] Phê duyệt UX flow và thiết bị mục tiêu.
- [ ] Hoàn thiện screen inventory/transition table.
- [ ] Tạo entry page và flow wireframes.
- [ ] Kiểm tra navigation, accessibility cơ bản và source fidelity.

## Verification

- Mermaid flow parse thành công và không có node cụt ngoài terminal hợp lệ.
- Mọi transition trong flow có màn hình/feedback tương ứng hoặc lý do không cần UI.
- `library-management-platform-wireframe.html` mở được; mỗi flow có breadcrumb về entry và không có link nội bộ hỏng.
- Wireframe đen trắng, không masquerade thành visual design hoàn chỉnh.

## Kịch bản kiểm tra tối thiểu

| Luồng | Trạng thái bắt buộc |
|-------|---------------------|
| Checkout | eligible, blocked member, non-loanable, concurrent conflict, success |
| Return | normal, overdue, damaged, lost, fine created, receipt/error |
| Reservation | join queue, ineligible, pickup ready, expiry, cancel, notify failure |
| Catalog/Copy | create/edit, duplicate validation, condition/state restriction |
| Administration | permission denied, audit view, policy update validation |

## Rủi ro và an toàn

- Không hiển thị PII không cần thiết trên màn hình vận hành.
- Error state không tiết lộ thông tin nhạy cảm hoặc quyền của người dùng khác.

## Tiêu chí hoàn tất

- [ ] User flow có approval evidence.
- [ ] Device/layout target được xác nhận.
- [ ] Entry HTML và toàn bộ flow chính hoạt động.
- [ ] Screen/transition/source mapping nhất quán với SRS.

## Bước kế tiếp

Dùng SRS và UX artifact làm đầu vào sinh backlog ở Phase 6.
