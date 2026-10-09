---
type: test-strategy
scope: shared
status: draft
updated: 2026-10-08
language: vi
device: mobile-375
links:
  - docs/_shared/core-spec.md
---

# Chiến lược test dùng chung

## Durable

- Ngôn ngữ checklist và test case: tiếng Việt. Giữ nguyên mã ID, tên màn và nhãn trạng thái trong SRS.
- Thiết bị đối chiếu UI: khung Mobile 375 đã chốt cho HTML wireframe ngày 2026-10-07. Ma trận trình duyệt production chưa có.
- Dữ liệu: chỉ dùng dữ liệu giả. Không đưa PII, secret hay file Excel thật vào tài liệu test.
- Nguồn thiếu: không bịa wording, ngưỡng, công thức tiền hay side-effect. Obligation chưa có oracle được ghi `blocked` hoặc `tbd` kèm OQ và owner.
- Ngưỡng định lượng: OQ-policy-config-001 còn mở. Profile hiện tại là Core-functional, không bật Performance theo số.
