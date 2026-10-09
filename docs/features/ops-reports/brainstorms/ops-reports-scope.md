---
type: brainstorm
feature: ops-reports
status: draft
updated: 2026-10-08
links:
  - docs/_product/prd.md
  - docs/_shared/core-spec.md
  - docs/_shared/id-crosswalk-lmp.md
---

# Báo cáo vận hành

## 1. Idea Seed

Quản trị viên xem và xuất các báo cáo vận hành hằng ngày: tổng quan tài khoản, tình trạng kho, phiếu quá hạn; từ R1B Thủ thư có danh sách quá hạn để nhắc người đọc.

## 2. Context

- RP-01, RP-02, RP-04 thuộc R1A; RP-04 nâng P0 vì quá hạn phải theo dõi được ngay từ pilot (DEC-P2-02).
- Danh sách quá hạn cho Thủ thư (FR-S09 nguồn) ở R1B.
- Báo cáo xu hướng RP-03, RP-05, RP-06, RP-07 thuộc `trend-reports` (R2), dùng chung màn dashboard báo cáo.
- Nguồn chỉ cho vai trò quản trị xem báo cáo; Thủ thư quầy xem báo cáo hay không còn mở.

## 3. User Types (preliminary)

| User Type | Pain Point | Primary Need |
|-----------|-----------|--------------|
| Quản trị viên | Tổng hợp tay từ sổ sách | Báo cáo theo khoảng thời gian, xuất file |
| Thủ thư | Không biết ai đang quá hạn để nhắc | Danh sách quá hạn (R1B) |

## 4. Capabilities Breakdown

### P0 — must have

- RP-01 Tổng quan tài khoản: số người đọc và Thủ thư theo trạng thái, người đọc mới theo tháng.
- RP-02 Tình trạng kho: số bản sao theo trạng thái và tình trạng (mới, cũ, hư, mất, thanh lý).
- RP-04 Quá hạn: danh sách phiếu quá hạn, số ngày, người đọc.
- Lọc theo khoảng thời gian, xuất Excel và PDF.

### P1 — should have

- Danh sách quá hạn cho Thủ thư để nhắc người đọc (R1B).

### P2 — nice to have

- Không có.

## 5. Core Flows (Happy Path)

### 5.1 Xem và xuất báo cáo

1) Quản trị viên mở dashboard báo cáo, chọn báo cáo.
2) Chọn khoảng thời gian; hệ thống hiện số liệu.
3) Xuất Excel hoặc PDF.

## 6. System Behavior Deep Dive

### 6.1 Decision Points

| ID | Flow | Khi nào | YES (nhánh đồng ý) | NO (nhánh từ chối) |
|---|---|---|---|---|
| D1 | Xem báo cáo | Người xem có quyền báo cáo này? | Hiện | Từ chối, quay về dashboard |
| D2 | Xem báo cáo | Có dữ liệu trong khoảng thời gian? | Hiện số liệu | Hiện trạng thái trống |

### 6.2 Scenario Matrix

| From State | To State | Rule | Action | Result |
|------------|----------|------|--------|--------|
| Quản trị viên | RP-01, RP-02, RP-04 | Có quyền | Xem, xuất | Thực hiện |
| Thủ thư | Danh sách quá hạn (R1B) | Có quyền | Xem | Thực hiện |
| Thủ thư | RP-01, RP-02, RP-04 | Chưa xác định | Xem | Còn mở (OQ-1) |

### 6.3 State Transitions

Không áp dụng — feature chỉ đọc.

### 6.4 Interrupted Transactions

Không áp dụng — feature chỉ đọc.

### 6.5 Other Edge Cases

- Báo cáo có dữ liệu cá nhân người đọc: che theo quyền trường.

## 7. Validation, Limits & Wording

### 7.1 Validation rules

| Field | Rule |
|---|---|
| Khoảng thời gian | Ngày bắt đầu không sau ngày kết thúc |

### 7.2 Limits & Quotas (exact values)

| Tham số | Giá trị | Window | Behavior khi vượt |
|---|---|---|---|
| Định dạng xuất | Excel, PDF | — | — |

### 7.3 Wording samples (exact strings)

#### Error messages

| Tình huống | Wording | Code |
|---|---|---|
| Không có quyền | "Bạn không có quyền xem báo cáo này." (đề xuất) | E-core-002 |

#### Success messages

| Tình huống | Wording |
|---|---|
| — | — |

#### Info / neutral messages

| Tình huống | Wording |
|---|---|
| Không có dữ liệu | "Không có dữ liệu trong khoảng thời gian đã chọn." (đề xuất) |

## 8. Assumptions

- Báo cáo đọc dữ liệu thật từ R1A; trước đó chỉ có dữ liệu import.

## 9. Risks

| Rủi ro | Khả năng | Hậu quả nghiệp vụ | Cách phòng |
|--------|----------|-------------------|-----------|
| Compliance: báo cáo xuất file chứa dữ liệu cá nhân | thỉnh thoảng | Lộ dữ liệu khi chia sẻ file | Che theo quyền, ghi audit khi xuất |
| Process: priority lệch giữa PRD (P0) và SRS cũ (P1) | thỉnh thoảng | Sai phạm vi R1A | Chốt khi viết SRS |

## 10. Success Criteria (preliminary)

- Chưa có — định nghĩa khi viết SRS.

## 11. Open Questions

- [ ] OQ-1: Thủ thư quầy có quyền xem RP-01, RP-02, RP-04 không? (OQ-ops-reports-001; hold — domain approver)
- [ ] OQ-2: Priority chính thức: P0 theo PRD hay P1 theo SRS cũ? (hold)

## 12. Next Steps

- `/srs ops-reports`
