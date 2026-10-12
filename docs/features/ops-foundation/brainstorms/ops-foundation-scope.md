---
type: brainstorm
feature: ops-foundation
status: draft
updated: 2026-10-12
links:
  - docs/_product/prd.md
  - docs/_product/readiness-gates.md
  - docs/_shared/core-spec.md
  - docs/_shared/id-crosswalk-lmp.md
---

# Audit và backup/restore

## 1. Idea Seed

Mọi thao tác nhạy cảm ghi audit cùng giao dịch, audit lỗi thì thao tác bị hủy; dữ liệu được backup hằng ngày, giữ 30 bản, và đã diễn tập khôi phục thành công trước khi go-live.

## 2. Context

- Audit và backup phải có trước khi dữ liệu thật đi vào giao dịch (DEC-P2-06, roadmap R0).
- Màn xem audit cho Thủ thư thuộc `notification-audit-ui` (R1B); feature này chỉ ghi.
- Backup/restore chưa có FR trong SRS cũ; DEC-SF-05 bổ sung. Diễn tập restore là bằng chứng của GATE-OPS.

## 3. User Types (preliminary)

| User Type | Pain Point | Primary Need |
|-----------|-----------|--------------|
| Thủ thư | Không biết ai đã làm gì khi có sự cố | Mọi thao tác nhạy cảm có dấu vết |
| Thủ thư trưởng | Sợ mất dữ liệu khi máy chủ hỏng | Backup đều và khôi phục được |
| Hệ thống | — | Không có thao tác nhạy cảm nào thiếu audit |

## 4. Capabilities Breakdown

### P0 — must have

- Ghi audit cho mọi thao tác tạo, sửa, xóa và thao tác nhạy cảm: người làm, thời điểm, đối tượng, kết quả, giá trị trước/sau tối thiểu, lý do nếu có.
- Audit ghi cùng giao dịch; audit lỗi thì thao tác nghiệp vụ bị hủy.
- Audit chỉ thêm, không sửa, không xóa.
- Backup dữ liệu hằng ngày, giữ 30 bản gần nhất.
- Khôi phục từ backup; diễn tập ít nhất một lần thành công trước go-live.

### P1 — should have

- Không có.

### P2 — nice to have

- Không có.

## 5. Core Flows (Happy Path)

### 5.1 Ghi audit

1) Người dùng thực hiện thao tác nhạy cảm.
2) Hệ thống ghi thao tác và bản ghi audit trong cùng giao dịch.
3) Ghi audit lỗi: hủy thao tác, cảnh báo vận hành.

### 5.2 Backup và diễn tập khôi phục

1) Hệ thống chạy backup hằng ngày, giữ 30 bản gần nhất, bản cũ hơn bị xóa.
2) Trước go-live, vận hành khôi phục một bản backup vào môi trường thử, kiểm tra dữ liệu khớp.
3) Ghi kết quả diễn tập làm bằng chứng GATE-OPS.

```
Thao tác nhạy cảm ──> Ghi nghiệp vụ + audit (một giao dịch) ──> Audit ghi được? ──không──> Hủy thao tác, cảnh báo vận hành
                                                                     │ có
                                                                     ▼
                                                               Hoàn tất

Hằng ngày ──> Backup ──> Thành công? ──không──> Cảnh báo vận hành, chạy lại
                               │ có
                               ▼
                    Giữ 30 bản gần nhất
```

## 6. System Behavior Deep Dive

### 6.1 Decision Points

| ID | Flow | Khi nào | YES (nhánh đồng ý) | NO (nhánh từ chối) |
|---|---|---|---|---|
| D1 | Ghi audit | Audit ghi được? | Hoàn tất thao tác | Hủy thao tác, cảnh báo vận hành |
| D2 | Backup | Backup thành công? | Lưu, xóa bản cũ quá 30 | Cảnh báo vận hành |
| D3 | Diễn tập | Dữ liệu khôi phục khớp? | GATE-OPS có bằng chứng | Sửa quy trình, diễn tập lại |

### 6.2 Scenario Matrix

Không áp dụng.

### 6.3 State Transitions

Không áp dụng — audit chỉ thêm, backup không có vòng đời nghiệp vụ.

### 6.4 Interrupted Transactions

| Tình huống | Hệ thống còn lại gì | Resume | Cleanup |
|---|---|---|---|
| Nơi ghi audit không dùng được | Không thao tác nhạy cảm nào được ghi | Thử lại khi audit hoạt động | Cảnh báo vận hành |
| Backup lỗi giữa chừng | Bản backup trước đó | Chạy lại backup | Xóa bản lỗi |

### 6.5 Other Edge Cases

- Audit che dữ liệu nhạy cảm không cần thiết.
- Khôi phục backup trong lúc đang vận hành là quyết định của vận hành, theo runbook.

## 7. Validation, Limits & Wording

### 7.1 Validation rules

| Field | Rule |
|---|---|
| Bản ghi audit | Có người làm, thời điểm, đối tượng, kết quả |

### 7.2 Limits & Quotas (exact values)

| Tham số | Giá trị | Window | Behavior khi vượt |
|---|---|---|---|
| Tần suất backup | 1 lần/ngày | Hằng ngày | — |
| Số bản backup giữ lại | 30 | Cuốn chiếu | Xóa bản cũ nhất |
| Diễn tập khôi phục trước go-live | ≥ 1 lần đạt | Trước GATE-GNG | GATE-OPS chưa đạt |
| Thời gian lưu audit | TBD | — | Chờ chính sách lưu giữ |

### 7.3 Wording samples (exact strings)

#### Error messages

| Tình huống | Wording | Code |
|---|---|---|
| Audit lỗi, thao tác bị hủy | "Không thể hoàn tất thao tác lúc này. Vui lòng thử lại sau." (đề xuất) | E-core-007 |

#### Success messages

| Tình huống | Wording |
|---|---|
| — | — |

#### Info / neutral messages

| Tình huống | Wording |
|---|---|
| — | — |

## 8. Assumptions

- Owner vận hành cho backup và diễn tập được chỉ định trong decision register.
- Backup là toàn bộ dữ liệu nghiệp vụ, không riêng phần nào.

## 9. Risks

| Rủi ro | Khả năng | Hậu quả nghiệp vụ | Cách phòng |
|--------|----------|-------------------|-----------|
| Process: chưa có owner vận hành | thỉnh thoảng | Không ai chạy diễn tập, GATE-OPS trượt | Chỉ định owner trước R0 |
| Compliance: audit giữ dữ liệu cá nhân lâu hơn cho phép | thỉnh thoảng | Vi phạm quy định dữ liệu cá nhân | Che dữ liệu, chờ chính sách lưu giữ |

## 10. Success Criteria (preliminary)

- 100% thao tác ghi có audit.
- Ít nhất 1 lần khôi phục backup đạt trước go-live.

## 11. Open Questions

- [ ] OQ-1: Thời gian lưu audit và quy tắc che dữ liệu cá nhân trong audit? (OQ-core-003; hold — pháp chế)
- [ ] OQ-2: Owner vận hành cho backup và diễn tập? (hold — Thủ thư trưởng)
- [ ] OQ-3: Mục tiêu thời gian khôi phục và lượng dữ liệu chấp nhận mất tối đa? (hold — vận hành)

## 12. Next Steps

- `/srs ops-foundation`
