---
type: ba-audit-report
status: complete
updated: 2026-10-05
links:
  - docs/he_thong_quan_ly_thu_vien.md
  - docs/features/library-management-platform/brainstorms/product-roadmap-baseline.md
---

# Báo cáo kiểm toán BA cho roadmap Hệ thống Quản lý Thư viện

## Kết luận

Tài liệu hiện tại phù hợp làm nguồn discovery nhưng chưa đủ làm baseline build hoặc UAT. Roadmap ba giai đoạn đúng về hướng, song Giai đoạn 1 chưa khép kín vòng đời vận hành và chưa có các gate dữ liệu, pilot, đào tạo, phục hồi và go-live.

## Điểm mạnh của nguồn hiện tại

- Đã xác định ba vai trò và ma trận quyền sơ bộ.
- Đã bao phủ catalog, QR, mượn–trả, đặt trước, gia hạn, phạt, hư hỏng và báo cáo.
- Có 13 business rules, lifecycle Loan/Reservation, mô hình dữ liệu sơ bộ và NFR ban đầu.
- Có 15 câu hỏi mở và ba giai đoạn ưu tiên.

## Blocker

1. Sơ đồ 7 trạng thái Copy và luồng trả sách không còn nội dung sử dụng được.
2. Fine và DamageReport chưa có vòng đời, thẩm quyền và đường hoàn tất đầy đủ.
3. Giai đoạn 1 tạo quá hạn/phạt/hư hỏng nhưng chức năng giải quyết nằm ở Giai đoạn 2.
4. Chưa có acceptance criteria đầy đủ cho các P1.
5. Quyền quản trị Thủ thư, miễn/điều chỉnh phạt và dữ liệu cá nhân chưa được quản trị hóa.
6. Import/migration được giả định là cần nhưng chưa nằm trong roadmap readiness.

## Mâu thuẫn cần sửa

| Chủ đề | Hiện trạng | Baseline xử lý |
|---|---|---|
| Thông báo | Mục 8 nói in-app; OQ-07 nói in-app + email | Dùng in-app + email cho sự kiện quan trọng |
| Quá hạn | RP-04 P1 nhưng job cập nhật OVERDUE ở P2 | Đưa quá hạn tối thiểu và job liên quan vào MVP |
| Hư hỏng | Báo cáo P1 nhưng duyệt P2 | Đưa disposition tối thiểu vào MVP |
| Fine | Trả P1 tính phạt nhưng thu/xử lý ở P2 | Có Fine ledger P0; thu/miễn nâng cao ở P1 |
| Reservation | Return P1 đã phân bổ hàng chờ nhưng Reservation P2 | MVP không phân bổ nếu module chưa bật; triển khai trọn vòng ở R2 |
| Audit | NFR yêu cầu từ ngày đầu nhưng viewer ở P2 | Ghi audit P0; giao diện tra cứu chi tiết có thể sau |

## Coverage P1

Không có P1 nào đạt acceptance condition hoàn chỉnh. Phần lớn mô tả được happy path nhưng thiếu deny/error, boundary, interruption, concurrent và audit outcome. Các gap nghiêm trọng nhất nằm ở trả sách, cấu hình quy định, QR hàng loạt, kích hoạt người đọc, báo cáo quá hạn và xử lý hư hỏng.

## Dependency bắt buộc cho MVP

- State machine và quy định nghiệp vụ được chốt trước migration.
- Import, QR và đối soát trước khi bật giao dịch.
- Identity/RBAC trước mượn–trả.
- Fine ledger và xác định quá hạn trước khi dùng BR chặn mượn.
- Damage disposition trước khi cho phép tạo DamageReport.
- Audit capture và backup trước giao dịch dữ liệu thật.
- UAT, SOP, restore drill và rollback trước pilot.

## Quality gates đề xuất

1. Requirements gate: mọi P0 có actor, precondition, happy/error/boundary và kết quả đo được.
2. Lifecycle gate: mọi entity đa trạng thái có transition, trigger, actor, side effect và invalid transition.
3. Migration gate: dry-run, deduplicate, đối soát tổng và rollback được duyệt.
4. UAT gate: traceability từ capability đến requirement và scenario, không còn blocker.
5. Pilot gate: người dùng/thiết bị/dữ liệu đại diện, tiêu chí dừng và kênh hỗ trợ rõ.
6. Operations gate: job có owner, backup restore thành công, runbook sẵn sàng.
7. Training gate: SOP và diễn tập cho Nhân viên, Thủ thư.

## Unresolved questions

- Chính sách retention và quyền dữ liệu cá nhân cần phê duyệt pháp lý.
- Cần file Excel thật để khóa mapping và quy tắc làm sạch.
- Cần phục hồi nội dung gốc của state machine Copy và flow trả.

