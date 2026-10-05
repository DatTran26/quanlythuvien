---
title: "Phase 8: Traceability, review và handoff"
status: pending
priority: P1
effort: "1 final review cycle"
dependencies: [1, 2, 3, 4, 5, 6, 7]
---

# Phase 8: Traceability, review và handoff

## Mục tiêu

Chứng minh chuỗi BA end-to-end hoàn chỉnh, xử lý gap còn lại và bàn giao một baseline có thể dùng cho estimate, implementation và QA mà không cần đoán lại nghiệp vụ.

## Yêu cầu

- Traceability tối thiểu: Product outcome → capability/release → FR/BR/Error/NFR/UC → flow/screen → story/AC hoặc verification contract → CHK → TC/evidence.
- Metadata tuân theo contract của skill sở hữu: full/slim/zero frontmatter; file parser-ready zero-frontmatter được quản trị qua master index, không bị ép thêm frontmatter.
- Không còn marker rỗng/TBD không có owner/gate, broken link, orphan ID hoặc approval giả.
- Final review phải độc lập với tác giả chính và phân loại blocker/major/minor.
- Handoff ghi rõ approved scope, deferred scope, open risks, decision debt và execution order.

## File tác động

- Tạo `docs/_shared/traceability.md` làm ma trận truy vết chính.
- Tạo `plans/reports/ba-final-quality-review.md`.
- Tạo `plans/reports/ba-delivery-handoff.md`.
- Tạo `plans/reports/operational-readiness-evidence.md` liên kết Migration/UAT/SOP-Training/Restore/Pilot/Go-No-Go evidence; thiếu evidence phải giữ gate Blocked.
- Cập nhật `docs/_product/decision-register.md` và các index liên quan khi phát hiện gap.

## Các bước thực hiện

1. Thu thập toàn bộ artifact manifest và ID index; xác định artifact owner/source of truth.
2. Sinh traceability matrix theo P0 trước, sau đó P1/P2; đánh dấu coverage, deferred và exception.
3. Chạy link/metadata-contract/marker scan, Mermaid parse, HTML entry/navigation và CHK↔TC cardinality check.
4. Thực hiện review độc lập theo bốn góc: BA completeness, domain/state, UX consistency, QA/traceability.
5. Sửa blocker/major; minor được sửa hoặc ghi debt có owner/gate.
6. Kiểm tra stale propagation: revision upstream thay đổi phải mark stale, enumerate affected IDs và re-approve; stale count phải bằng 0 hoặc có deferred approval.
7. Lập handoff: scope/release, decision log, artifact map, readiness, estimate assumptions, test readiness, rollback/change-control.
8. Tạo operational readiness evidence manifest. BA plan có thể ready cho estimation/implementation/QA, nhưng không được tuyên bố go-live ready cho tới khi Migration/UAT/SOP-Training/Restore/Pilot/Go-No-Go evidence được ký duyệt.
9. Chạy `ak plan validate` và đối chiếu toàn bộ success criteria của kế hoạch trước khi chuyển status complete.

## Todo

- [ ] Tạo artifact manifest và traceability matrix.
- [ ] Chạy toàn bộ static/structural checks.
- [ ] Hoàn thành review độc lập.
- [ ] Xử lý blocker/major và ghi debt hợp lệ.
- [ ] Tạo final quality report và handoff.
- [ ] Xác nhận stale count và operational readiness gate status.
- [ ] Validate plan và cập nhật trạng thái.

## Verification

- Truy vấn ngẫu nhiên từ TC ngược về outcome và từ outcome xuôi về TC đều có đường dẫn đầy đủ cho P0.
- Không có link hỏng, duplicate ID, orphan ref hoặc Mermaid lỗi.
- Entry HTML mở được và điều hướng tới mọi flow được index.
- Tổng CHK eligible khớp tổng TC; các ngoại lệ có approval evidence.
- Decision Open còn lại không phải blocker cho estimation/implementation scope được bàn giao; go-live blocker luôn giữ gate Blocked, không waive bằng due date.

## Kịch bản kiểm tra bàn giao

| Người nhận | Phải trả lời được từ artifact |
|------------|-------------------------------|
| PO/PM | Vì sao feature ở release này, metric và exit gate là gì? |
| Developer | Rule, state, error, data và dependency cần triển khai là gì? |
| Designer | Actor, flow, screen, field/action và error/recovery nào đã duyệt? |
| QA | Obligation, data, expected result và trace nguồn nằm ở đâu? |
| Security/Legal | Decision privacy/access/audit nào đã duyệt, còn nợ gì? |

## Rủi ro và an toàn

- Báo cáo handoff không sao chép secret/PII; chỉ dẫn tới nguồn được quản lý.
- Không tuyên bố “ready” khi còn blocker; trạng thái phải phản ánh evidence.
- Mọi thay đổi sau baseline đi qua change-control và cập nhật traceability hạ nguồn.

## Tiêu chí hoàn tất

- [ ] P0 có traceability end-to-end 100%; P1/P2 có coverage hoặc deferred rationale.
- [ ] Không còn blocker/major chưa xử lý.
- [ ] Final review và handoff được duyệt bởi vai trò phù hợp.
- [ ] Operational-readiness evidence đầy đủ hoặc handoff ghi rõ `Not Go-Live Ready` cùng blocker/owner.
- [ ] `ak plan validate` thành công.
- [ ] Plan và phase status phản ánh đúng trạng thái thực tế.

## Kết quả bàn giao

Một BA baseline kiểm chứng được, sẵn sàng cho estimation/implementation/QA theo release và không phụ thuộc vào kiến thức ngầm của người viết.
