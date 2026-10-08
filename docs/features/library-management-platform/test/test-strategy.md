---
type: test-strategy
feature: library-management-platform
status: draft
updated: 2026-10-08
language: vi
device: mobile-375
profile: core-functional
purpose: baseline-obligation
---

# Chiến lược test — library-management-platform

## Durable

- Ngôn ngữ checklist và test case: tiếng Việt. Giữ nguyên mã ID, tên màn và nhãn trạng thái trong SRS.
- Thiết bị đối chiếu UI: khung Mobile 375 đã chốt cho HTML wireframe ngày 2026-10-07. Ma trận trình duyệt production chưa có.
- Dữ liệu: chỉ dùng dữ liệu giả. Không đưa PII, secret hay file Excel thật vào tài liệu test.
- Nguồn thiếu: không bịa wording, ngưỡng, công thức tiền hay side-effect. Obligation chưa có oracle được ghi `blocked` hoặc `tbd` kèm OQ và owner.
- Ngưỡng định lượng: OQ-LMP-010 còn mở. Profile hiện tại là Core-functional, không bật Performance theo số.

## Per-run 2026-10-08

- Mục đích: lập baseline nghĩa vụ test từ SRS, use case, story và Acceptance Criteria đang `draft`.
- Không phải biên bản UAT và không phải bằng chứng go-live.
- Đối tượng bàn giao: BA, QA và dev để review coverage. Checklist chưa được duyệt nên chưa sinh test case.
