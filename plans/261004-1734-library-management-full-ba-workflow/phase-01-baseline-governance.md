---
title: "Phase 1: Baseline và governance"
status: in-progress
priority: P1
effort: "1 approval cycle"
dependencies: []
---

# Phase 1: Baseline và governance

## Mục tiêu

Hoàn tất đầu ra `brainstorm`, tách fact/proposal/approved và đưa toàn bộ OQ-01…OQ-15 vào cơ chế quyết định có trách nhiệm rõ ràng.

## Bối cảnh và nguồn

- `docs/he_thong_quan_ly_thu_vien.md`: tài liệu khám phá gốc.
- `docs/_shared/project-profile.md`: fact và quy ước dùng chung.
- `docs/features/library-management-platform/brainstorms/product-roadmap-baseline.md`: baseline đang đề xuất.
- `plans/reports/ba-audit-261005-0018-library-management-roadmap.md`: audit khoảng trống.

## Nhận định chính

- Các giá trị mặc định hiện là đề xuất, chưa phải quyết định được duyệt.
- Reservation đang có mâu thuẫn giữa MVP và R2.
- Copy lifecycle, privacy retention và Fine adjustment còn thiếu điều kiện khoá.

## Yêu cầu

- Mỗi quyết định có ID không va chạm, status, owner, approver, due gate và evidence.
- OQ ảnh hưởng schema/state/release, privileged identity, privacy hoặc financial control phải `Resolved + Approved` trước phase sở hữu; owner + due gate không đủ để vượt hard stop.
- Không tự suy đoán câu hỏi pháp lý/chính sách.
- Mọi scope P0/P1/P2 mới phải ghi là proposal cho tới khi được duyệt.
- Tài liệu brainstorm phải đủ outcome, constraint, non-goal, assumption, risk và acceptance signal.

## File tác động

- Sửa `docs/_shared/project-profile.md`.
- Sửa `docs/features/library-management-platform/brainstorms/product-roadmap-baseline.md`.
- Tạo `docs/_product/decision-register.md`.
- Tạo `docs/_shared/id-registry.md` cho Outcome/Capability/Release/Decision/FR/NFR/BR/Error/UC/Flow/Screen/US/AC/CHK/TC.
- Sửa `plans/reports/ba-audit-261005-0018-library-management-roadmap.md` nếu kết luận audit thay đổi.

## Các bước thực hiện

1. Tiếp tục workflow `brainstorm` trên artifact hiện có; không tạo brainstorm song song.
2. Sửa các finding L2: chuyển mọi giả định chưa duyệt thành proposal/assumption.
3. Tìm bản gốc hai sơ đồ Copy/return. Nếu không có, dựng lại dưới nhãn Proposal qua workshop và domain approval; không trình bày như evidence nguồn.
4. Giữ nguyên ngữ nghĩa OQ-01…OQ-15 của tài liệu gốc; các câu hỏi mới dùng OQ-16 trở đi hoặc `GAP-OQ-*`, kèm bảng alias/migration và semantic title check.
5. Tạo decision register; thêm severity, impact, owner, approver, target gate, hard-stop class và resolution evidence.
6. Thu thập Excel đại diện; tạo source profile, mapping, dedup/reconciliation rule và rollback expectation. Nếu chưa có file, ghi external blocker thay vì đoán schema.
7. Tạo ID registry với namespace, version, alias và retirement rule trước khi sinh artifact hạ nguồn.
8. Giải quyết mâu thuẫn Reservation MVP/R2 bằng release boundary duy nhất.
9. Chạy quality gate của `brainstorm`; chỉ chuyển Phase 2 khi hard-stop đã `Resolved + Approved`, các non-blocker còn lại có owner + due gate.

## Todo

- [x] Đối chiếu mọi claim với tài liệu nguồn.
- [x] Chuẩn hoá fact/proposal/approved.
- [x] Tạo và điền decision register.
- [x] Tạo ID registry và chống va chạm OQ.
- [ ] Thu thập/đánh giá Excel và sơ đồ nguồn hoặc có reconstruction approval.
- [ ] Chốt blocker scope Reservation, Copy, Fine và privacy.
- [ ] Ghi approval evidence vào artifact.

## Verification

- Tìm mọi từ khoá `approved`, `default`, `assume`, `TBD`, `OQ-`; không còn “approved” thiếu bằng chứng.
- Mỗi OQ xuất hiện đúng một lần theo semantic title; không có va chạm OQ-01/OQ-1 và được tham chiếu từ artifact bị ảnh hưởng.
- Review độc lập xác nhận không còn contradiction mức blocker.

## Kịch bản kiểm tra

| Tình huống | Kỳ vọng |
|------------|---------|
| Reservation được xếp cả MVP và R2 | Chỉ còn một release owner; release khác ghi rõ dependency/non-goal |
| Chính sách retention chưa có ý kiến pháp lý | Giữ trạng thái Open, có approver và due gate; không tự đặt thời hạn |
| Một default chưa được duyệt | Gắn nhãn Proposed và liên kết decision ID |

## Rủi ro và an toàn

- Không đưa PII thật vào tài liệu BA; ví dụ dữ liệu phải synthetic.
- Không khoá chính sách pháp lý bằng suy luận của BA.
- Nếu tài liệu nguồn mâu thuẫn, giữ cả evidence và chuyển thành decision thay vì âm thầm chọn một bên.

## Tiêu chí hoàn tất

- [ ] Baseline vượt quality gate của `brainstorm`.
- [ ] OQ gốc và gap OQ có namespace không va chạm, governance đầy đủ.
- [ ] Hard-stop decision đã Resolved + Approved; external blocker có acceptance evidence hoặc reconstruction approval.
- [ ] Không còn quyết định giả được trình bày như fact.
- [ ] Phase 2 có input đã được duyệt hoặc blocker được quản lý rõ.

## Bước kế tiếp

Chuyển baseline đã kiểm soát sang Product PRD và roadmap ở Phase 2.
