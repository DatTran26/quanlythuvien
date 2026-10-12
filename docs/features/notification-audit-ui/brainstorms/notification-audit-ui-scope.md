---
type: brainstorm
feature: notification-audit-ui
status: draft
updated: 2026-10-12
links:
  - docs/_product/prd.md
  - docs/_product/decision-register.md
  - docs/_shared/core-spec.md
  - docs/_shared/id-crosswalk-lmp.md
---

# Trung tâm thông báo và audit viewer

## 1. Idea Seed

Mọi vai trò có trung tâm thông báo để xem lại và đánh dấu đã đọc; Thủ thư có màn tra cứu nhật ký audit và dòng thời gian lịch sử của bản sao, phiếu mượn, đặt trước, khoản phạt, báo cáo hư hỏng.

## 2. Context

- Gửi thông báo đã có ở `notification-core` (R1A); trung tâm thông báo FR-C04 ở R1B (DEC-P2-01, DEC-SF-09). Màn trung tâm thông báo chưa có trong userflow cũ.
- Ghi audit đã có ở `ops-foundation` (R0); màn xem audit FR-L10 ở R1B (DEC-P2-06). Nhật ký chỉ đọc.

## 3. User Types (preliminary)

| User Type | Pain Point | Primary Need |
|-----------|-----------|--------------|
| Mọi vai trò | Lỡ thông báo, không xem lại được | Danh sách thông báo, đã đọc / chưa đọc |
| Thủ thư | Không tra được ai làm gì khi có tranh chấp | Lọc audit theo người, đối tượng, thời gian |

## 4. Capabilities Breakdown

### P0 — must have

- Không có (feature thuộc R1B).

### P1 — should have

- Trung tâm thông báo: danh sách thông báo của chính mình, đánh dấu đã đọc, số chưa đọc.
- Nhật ký audit: lọc theo người làm, đối tượng, thời gian; chỉ đọc.
- Dòng thời gian lịch sử của một bản sao, phiếu mượn, đặt trước, khoản phạt hoặc báo cáo hư hỏng.
- Che dữ liệu cá nhân và tài chính theo quyền; mỗi lần xem bị từ chối có audit.

### P2 — nice to have

- Không có.

## 5. Core Flows (Happy Path)

### 5.1 Trung tâm thông báo

1) Người dùng mở trung tâm thông báo; hệ thống hiện thông báo mới nhất trước.
2) Người dùng mở một thông báo, hệ thống đánh dấu đã đọc.

### 5.2 Tra cứu audit và lịch sử

1) Thủ thư mở nhật ký, lọc.
2) Mở một đối tượng để xem dòng thời gian lịch sử.

## 6. System Behavior Deep Dive

### 6.1 Decision Points

| ID | Flow | Khi nào | YES (nhánh đồng ý) | NO (nhánh từ chối) |
|---|---|---|---|---|
| D1 | Nhật ký | Người xem có quyền xem audit? | Hiện | Từ chối, audit |
| D2 | Nhật ký, lịch sử | Có quyền với trường nhạy cảm? | Hiện | Che |
| D3 | Thông báo | Thông báo của chính người xem? | Hiện | Không hiện |

### 6.2 Scenario Matrix

| From State | To State | Rule | Action | Result |
|------------|----------|------|--------|--------|
| Người đọc, Nhân viên | Thông báo của chính mình | Có quyền | Xem | Hiện |
| Thủ thư | Nhật ký audit, lịch sử | Có quyền | Xem | Hiện, che trường theo quyền |
| Người đọc, Nhân viên | Nhật ký audit | Không có quyền | Xem | Từ chối |

### 6.3 State Transitions

| Entity | Từ | Sang | Trigger | Quay lại được? |
|--------|------|----|---------|-------------|
| Thông báo (phía người nhận) | Chưa đọc | Đã đọc | Người nhận mở | TBD |

### 6.4 Interrupted Transactions

Không áp dụng — chủ yếu đọc.

### 6.5 Other Edge Cases

- Nhật ký không cho sửa hay xóa từ màn này.

## 7. Validation, Limits & Wording

### 7.1 Validation rules

| Field | Rule |
|---|---|
| Khoảng thời gian lọc | Ngày bắt đầu không sau ngày kết thúc |

### 7.2 Limits & Quotas (exact values)

| Tham số | Giá trị | Window | Behavior khi vượt |
|---|---|---|---|
| Thời gian giữ thông báo trong trung tâm | TBD | — | — |

### 7.3 Wording samples (exact strings)

#### Error messages

| Tình huống | Wording | Code |
|---|---|---|
| Không có quyền xem nhật ký | "Bạn không có quyền xem nhật ký hoạt động." (đề xuất) | E-core-002 |

#### Success messages

| Tình huống | Wording |
|---|---|
| — | — |

#### Info / neutral messages

| Tình huống | Wording |
|---|---|
| Không có thông báo | "Bạn chưa có thông báo nào." (đề xuất) |

## 8. Assumptions

- Chỉ Thủ thư xem nhật ký audit (nguồn: chỉ vai trò quản trị xem nhật ký).

## 9. Risks

| Rủi ro | Khả năng | Hậu quả nghiệp vụ | Cách phòng |
|--------|----------|-------------------|-----------|
| Compliance: lộ dữ liệu cá nhân trong nhật ký | thỉnh thoảng | Vi phạm quyền riêng tư | Che theo quyền, chờ chính sách lưu giữ |

## 10. Success Criteria (preliminary)

- Chưa có — định nghĩa khi viết SRS.

## 11. Open Questions

- [ ] OQ-1: Thời gian lưu nhật ký và thông báo, quy tắc che dữ liệu? (OQ-core-003; hold — pháp chế)
- [ ] OQ-2: Có cho đánh dấu lại "chưa đọc" không? (hold)

## 12. Next Steps

- `/srs notification-audit-ui`
