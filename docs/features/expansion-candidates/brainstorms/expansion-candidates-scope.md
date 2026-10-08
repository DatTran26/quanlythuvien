---
type: brainstorm
feature: expansion-candidates
status: draft
updated: 2026-10-08
links:
  - docs/_product/prd.md
  - docs/_product/roadmap.md
  - docs/_shared/id-crosswalk-lmp.md
---

# Candidate mở rộng

## 1. Idea Seed

Danh mục các hướng mở rộng sau pilot, không cam kết build: điểm danh, thanh toán online, nhiều chi nhánh, chế độ offline, SMS/push/Zalo, phân loại người đọc, phân tích nâng cao. Mỗi mục chỉ được lập release sau quyết định riêng.

## 2. Context

- Roadmap R3 là candidate, không cam kết. Feature này không có SRS; mỗi candidate khi được chọn sẽ tách thành feature riêng.

## 3. User Types (preliminary)

| User Type | Pain Point | Primary Need |
|-----------|-----------|--------------|
| Thủ thư trưởng | Ý tưởng mở rộng chen vào release đang làm | Danh mục riêng, có điều kiện mở |

## 4. Capabilities Breakdown

### P0 — must have

- Không có.

### P1 — should have

- Không có.

### P2 — nice to have

| Candidate | Mục tiêu | Giả định hiện tại | Điều kiện để mở |
|---|---|---|---|
| Điểm danh | Ghi nhận chấm công nhân viên hoặc người đọc vào thư viện | Chưa rõ là loại nào (OQ-02 nguồn) | OQ-02 có câu trả lời + business case |
| Thanh toán online | Người đọc nộp phạt không cần ra quầy | Thu tiền mặt tại quầy | Chọn cổng thanh toán + kiểm soát tài chính |
| Nhiều chi nhánh | Mượn ở một nơi, trả ở nơi khác | Một cơ sở | Nhu cầu liên thư viện thực tế |
| Offline | Quầy vẫn chạy khi mất mạng | Không hỗ trợ | Đánh giá độ phức tạp riêng |
| SMS / push / Zalo | Thêm kênh thông báo | In-app + email | Chi phí, độ phức tạp tích hợp |
| Phân loại người đọc | Quy định riêng theo nhóm (sinh viên, giảng viên) | Một bộ quy định chung | Nhu cầu chính sách khác biệt |
| Phân tích nâng cao | Xu hướng mượn, đề xuất mua sắm | Chỉ có báo cáo xu hướng R2 | Dữ liệu pilot đủ dài + business case |
| RP-08 hoạt động nhân viên | Số phiếu xử lý theo nhân viên | Phụ thuộc điểm danh | Điểm danh được chọn |

## 5. Core Flows (Happy Path)

### 5.1 Đánh giá một candidate

1) Có business case cho một candidate.
2) Thủ thư trưởng quyết định; nếu chọn thì lập feature mới và release riêng.

## 6. System Behavior Deep Dive

Không áp dụng — chưa có hành vi hệ thống.

## 7. Validation, Limits & Wording

Không áp dụng.

## 8. Assumptions

- Không candidate nào ảnh hưởng release R0–R2.

## 9. Risks

| Rủi ro | Khả năng | Hậu quả nghiệp vụ | Cách phòng |
|--------|----------|-------------------|-----------|
| Timeline: candidate chen vào release cam kết | thỉnh thoảng | Trễ critical path | Chỉ mở sau quyết định riêng |

## 10. Success Criteria (preliminary)

- Không áp dụng.

## 11. Open Questions

- [ ] OQ-1: Điểm danh là chấm công nhân viên hay ghi nhận người đọc vào thư viện? (OQ-02 nguồn; hold)

## 12. Next Steps

- Không chạy `/srs` cho tới khi một candidate được chọn.
