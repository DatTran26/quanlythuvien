---
title: "Phase 1: Ma trận phân bổ và bảng đối chiếu ID"
status: pending
priority: P1
effort: "1 ngày + 1 vòng duyệt"
dependencies: [0]
---

# Phase 1: Ma trận phân bổ và bảng đối chiếu ID

## Mục tiêu

Mọi item hiện có trong feature gộp được gán **đúng một** đích (feature hoặc `_shared`) và **một mã mới**, trước khi di chuyển bất kỳ nội dung nào. Đây là xương sống của toàn plan: phase 2–8 chỉ thực thi ma trận này.

## Đầu vào

- `feature-allocation-draft.md` (bản nháp).
- `plans/reports/split-baseline-*.md` (danh sách item từ phase 0).
- Prose gốc: spec, userflow, flows, states, erd, use case, story, AC, checklist.

## Các bước

1. **Liệt kê đầy đủ item** bằng KG (`kg-query.mjs facts library-management-platform --all`, `trace … --all`) rồi bổ sung bằng grep cho item KG không parse: AC trong story, CHK trong checklist, OQ trong userflow/erd/flows/states/use case, screen, flow section, decision point, transition ID. Mục tiêu: con số khớp snapshot phase 0.
2. **Đọc prose từng item** và kiểm đề xuất trong bản nháp. Item có từ hai chủ trở lên → hoặc đẩy lên `_shared`, hoặc tách (ghi rõ phần nào sang đâu). Kết luận dựa trên prose, không dựa KG (`kg-usage.md`).
3. **Tách item bị chia release:** FR-LMP-015 (tiền mặt R1A / biên nhận R1B), FR-LMP-019 (tối thiểu R1A / trung tâm R1B), FR-LMP-020 (ghi audit R0 / viewer R1B), FR-LMP-023 (RP-01/02/04 R1A / RP-03/05/06/07 R2), SC-LMP-01 (mượn / trả), FR-LMP-024 (xem công nợ R1B / portal R2). Mỗi phần thành một item riêng có mã mới.
4. **Cấp mã mới** theo `feature-recipe.md` Mục "Mã ID theo feature". Thứ tự đánh số trong mỗi feature giữ thứ tự LMP gốc để dễ đối chiếu. Sinh bằng script trong scratchpad, không gõ tay.
5. **Trình các xung đột X1–X9** (`feature-allocation-draft.md` Mục 4) cho người dùng quyết, mỗi xung đột kèm bằng chứng và phương án. Ghi quyết định vào `docs/_product/decision-register.md` với mã `DEC-SF-NN` (đăng ký namespace `SF` trong `id-registry.md`).
6. **Chốt bộ tên vai trò (X7)** và đề xuất cập nhật `docs/_shared/project-profile.md` mục "Người dùng & thuật ngữ" qua L2.
7. **Ghi ma trận chính thức** vào `docs/_shared/id-crosswalk-lmp.md`:
   - Cột: `Mã LMP | Loại | Đích (feature/_shared) | Mã mới | Tách từ | File nguồn:dòng | Đã chuyển (phase) | Ghi chú`.
   - Một dòng cho mỗi item, kể cả item tách (nhiều dòng cùng mã LMP).
   - Mục cuối: tổng số theo loại, đối chiếu với snapshot phase 0.
8. **Cập nhật `docs/_shared/id-registry.md`** qua L2: thêm namespace theo feature, namespace dùng chung, `DEC-SF`, đánh dấu các series `*-LMP-*` là "retired sau phase 8", link sang `id-crosswalk-lmp.md`.

## File tác động

- Tạo `docs/_shared/id-crosswalk-lmp.md`.
- Sửa `docs/_shared/id-registry.md`, `docs/_product/decision-register.md`, `docs/_shared/project-profile.md`.

## Kiểm tra

- Script kiểm: mỗi mã LMP có ít nhất 1 dòng; mỗi mã mới xuất hiện đúng 1 lần; không có item không có đích.
- Tổng số item theo loại khớp snapshot (cộng thêm số item phát sinh do tách, liệt kê rõ).

## Tiêu chí xong

- Người dùng duyệt ma trận và quyết X1–X9.
- 0 item mồ côi, 0 item hai chủ.

## Rủi ro

| Rủi ro | Xử lý |
|---|---|
| Ma trận quá lớn để duyệt một lần | Trình theo nhóm release (R0, R1A, R1B+R2+R3, `_shared`), mỗi nhóm một lần duyệt |
| Xung đột chưa quyết được (cần stakeholder ngoài) | Ghi `Open` trong decision-register, chọn phương án tạm có nhãn PROPOSAL, đi tiếp |
