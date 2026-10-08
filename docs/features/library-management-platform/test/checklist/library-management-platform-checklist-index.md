---
type: test-checklist-index
feature: library-management-platform
status: draft
updated: 2026-10-08
next_chk_id: 98
links:
  - docs/features/library-management-platform/srs/library-management-platform-spec.md
  - docs/features/library-management-platform/test/test-strategy.md
  - docs/features/library-management-platform/test/checklist/checklist-feature.md
---

# Test Checklists — library-management-platform

Checklist này là baseline nghĩa vụ từ SRS, use case, story và Acceptance Criteria đang `draft`. Chưa được duyệt. Chưa sinh test case.

## Checklists

| Scope | Target | File | Items | P1 | P2 | P3 | P4 | Auto | Status | Updated |
|-------|--------|------|-------|----|----|----|----|------|--------|---------|
| feature | — | [checklist-feature.md](checklist-feature.md) | 97 | 87 | 10 | 0 | 0 | 69/28 | draft | 2026-10-08 |

## Coverage

> Đối chiếu nghĩa vụ test ↔ CHK. Bảng này là bản đồ điều hướng, không phải nguồn nội dung test case. Tầng: UI · —. Trạng thái: covered · blocked · tbd · partial. Không có `excluded-approved` vì chưa có quyết định loại trừ của BA. Scope chưa đóng: còn `blocked`, `tbd` và `partial`.

| Source ID | Nghĩa vụ (obligation) | Scope | CHK-ID | Tầng | Trạng thái | Lý do (nếu excluded) |
|-----------|----------------------|-------|--------|------|-----------|----------------------|
| FR-LMP-001 | Lưu hồ sơ thư mục hợp lệ và mở lại đúng thuộc tính | feature | CHK-LMP-008 | UI | covered | — |
| FR-LMP-001 | Thiếu dữ liệu bắt buộc thì không ghi | feature | CHK-LMP-009, CHK-LMP-010 | UI | covered | — |
| FR-LMP-001 | Khóa nghiệp vụ đã tồn tại không tạo hồ sơ thứ hai | feature | CHK-LMP-011 | UI | covered | — |
| FR-LMP-001 | Hồ sơ đã có lịch sử chỉ vô hiệu hóa, không xóa cứng | feature | CHK-LMP-012 | — | covered | — |
| FR-LMP-001 | Người không có quyền catalog không ghi được | feature | CHK-LMP-013 | UI | covered | — |
| FR-LMP-002 | Đăng ký bản sao với một mã định vị chưa trùng | feature | CHK-LMP-014 | UI | covered | — |
| FR-LMP-002 | Mã định vị đã dùng không tạo bản sao mới | feature | CHK-LMP-017 | UI | covered | — |
| FR-LMP-002 | Bản sao đã có lịch sử không bị xóa cứng | feature | CHK-LMP-018 | — | covered | — |
| FR-LMP-002 | Trạng thái ban đầu của bản sao | feature | — | — | blocked | DEC-D3-01 còn mở; checklist không khẳng định AVAILABLE |
| FR-LMP-003 | Số khả dụng, đang giữ, đang mượn và không khả dụng khớp trạng thái bản sao | feature | CHK-LMP-019 | UI | covered | — |
| FR-LMP-003 | Tra cứu không khớp không trả đầu sách giả | feature | CHK-LMP-020 | UI | covered | — |
| FR-LMP-003 | Tra cứu trên cổng người đọc | feature | — | — | blocked | OQ-LMP-016; cổng thuộc FR-LMP-024 |
| FR-LMP-004 | Lưu thông tin liên hệ và trạng thái hoạt động | feature | CHK-LMP-021, CHK-LMP-022 | UI | covered | — |
| FR-LMP-004 | Thiếu dữ liệu bắt buộc thì không ghi | feature | CHK-LMP-023 | UI | covered | — |
| FR-LMP-004 | Định danh đã tồn tại không tạo hồ sơ thứ hai | feature | CHK-LMP-024 | UI | covered | — |
| FR-LMP-004 | Trường dữ liệu cá nhân ngoài quyền bị che | feature | CHK-LMP-025 | UI | covered | — |
| FR-LMP-004 | Hồ sơ đã có lịch sử không bị xóa cứng | feature | CHK-LMP-026 | — | covered | — |
| FR-LMP-004 | Quy tắc định danh và che dữ liệu đã chốt | feature | — | — | tbd | OQ-LMP-006, OQ-LMP-007, OQ-LMP-012, OQ-LMP-014 |
| FR-LMP-005 | Khóa và mở quyền mượn kèm lý do và audit | feature | — | — | blocked | R1B; chưa có story AC trong baseline này |
| FR-LMP-006 | Người hợp lệ chỉ mở không gian làm việc đúng vai trò | feature | CHK-LMP-001 | UI | covered | — |
| FR-LMP-006 | Từ chối truy cập và không lộ dữ liệu ngoài quyền | feature | CHK-LMP-002, CHK-LMP-003 | UI | covered | — |
| FR-LMP-006 | Che trường nhạy cảm theo quyền trường | feature | CHK-LMP-004 | UI | covered | — |
| FR-LMP-006 | Số lần khóa đăng nhập | feature | — | — | blocked | Chưa có ngưỡng đã duyệt |
| FR-LMP-007 | Hết phiên thì dữ liệu đã ghi còn, việc đang dở không được ghi | feature | CHK-LMP-005, CHK-LMP-006 | UI | covered | FR-LMP-007 vẫn là proposal |
| FR-LMP-007 | Tác vụ nhạy cảm không chạy khi chưa xác thực lại | feature | CHK-LMP-007 | UI | covered | Thời lượng phiên thuộc OQ-LMP-010 |
| FR-LMP-008 | Phiếu đủ điều kiện ghi mọi khoản mượn và chuyển mọi bản sao | feature | CHK-LMP-045, CHK-LMP-046 | UI | covered | — |
| FR-LMP-008 | Một bản sao không hợp lệ thì không khoản mượn nào được ghi | feature | CHK-LMP-047 | UI | covered | — |
| FR-LMP-008 | Người đọc không đủ điều kiện thì không tạo phiếu và nêu lý do | feature | CHK-LMP-048, CHK-LMP-049 | UI | covered | — |
| FR-LMP-008 | Audit thất bại thì phiếu không được giữ | feature | CHK-LMP-052 | — | covered | — |
| FR-LMP-008 | Ngưỡng số sách được mượn | feature | — | — | tbd | OQ-LMP-010 |
| FR-LMP-009 | Gửi lại cùng yêu cầu không tạo phiếu thứ hai | feature | CHK-LMP-050 | UI | covered | — |
| FR-LMP-009 | Phiếu thua khi tranh cùng bản sao không ghi khoản mượn nào | feature | CHK-LMP-051 | — | covered | — |
| FR-LMP-010 | Đóng khoản mượn trước trạng thái tiếp theo của bản sao | feature | CHK-LMP-054 | UI | covered | — |
| FR-LMP-010 | Người đọc không đủ điều kiện mượn mới vẫn trả được | feature | CHK-LMP-055 | UI | covered | — |
| FR-LMP-010 | Trả lại khoản đã đóng không nhân đôi kết quả | feature | CHK-LMP-056 | UI | covered | — |
| FR-LMP-010 | Yêu cầu trả đến sau không đóng phiếu thêm lần nữa | feature | CHK-LMP-057 | — | covered | — |
| FR-LMP-010 | Audit thất bại thì lần trả không đổi khoản mượn | feature | CHK-LMP-058 | — | covered | — |
| FR-LMP-010 | Trạng thái bản sao sau khi trả | feature | — | — | blocked | DEC-D3-02 và OQ-LMP-004 còn mở |
| FR-LMP-011 | Gia hạn đủ điều kiện và từ chối khi quá hạn, có giữ chỗ hoặc vượt giới hạn | feature | — | — | blocked | R1B; ngưỡng OQ-LMP-010; chưa có CHK |
| FR-LMP-012 | Tạo, hủy và giữ thứ tự đặt trước | feature | — | — | blocked | R2; chưa có CHK |
| FR-LMP-013 | Hết hạn giữ chỗ thì hủy lượt và đẩy người kế tiếp | feature | — | — | blocked | R2; chưa có CHK |
| FR-LMP-014 | Trả quá hạn ghi một ASSESSMENT và Fine UNPAID | feature | CHK-LMP-059, CHK-LMP-060 | UI | covered | Số tiền phạt chưa chốt, OQ-LMP-010 và OQ-LMP-005 |
| FR-LMP-014 | Event đã ghi không bị sửa trực tiếp | feature | CHK-LMP-061 | — | covered | — |
| FR-LMP-014 | Trả lặp không tạo ASSESSMENT thứ hai | feature | CHK-LMP-062 | UI | covered | — |
| FR-LMP-014 | Audit thất bại thì Fine và ASSESSMENT bị rollback | feature | CHK-LMP-063 | — | covered | — |
| FR-LMP-015 | Thu tiền mặt ghi một PAYMENT; Fine PAID khi số dư bằng 0 | feature | CHK-LMP-064, CHK-LMP-065 | UI | covered | — |
| FR-LMP-015 | Cùng operation_id không tạo PAYMENT thứ hai | feature | CHK-LMP-066 | UI | covered | — |
| FR-LMP-015 | Ghi PAYMENT thất bại thì Fine giữ nghĩa vụ cũ | feature | CHK-LMP-067 | UI | covered | — |
| FR-LMP-015 | Khoản thu đến sau không ghi vượt số dư lúc commit | feature | CHK-LMP-068 | — | covered | UC thu tiền dùng E-LMP-005; Error Matrix mô tả E-LMP-005 là xung đột bản sao/đặt trước. Matrix chưa được sửa |
| FR-LMP-015 | Audit thất bại thì PAYMENT bị rollback | feature | CHK-LMP-069 | — | covered | — |
| FR-LMP-015 | Thủ thư quầy không ghi event ngoài PAYMENT | feature | CHK-LMP-070 | UI | covered | — |
| FR-LMP-015 | Thu một phần, đối soát và biên nhận đầy đủ | feature | — | — | blocked | OQ-LMP-005, OQ-LMP-009; biên nhận đầy đủ thuộc R1B |
| FR-LMP-016 | Miễn, điều chỉnh, đảo bút toán và hoàn tiền | feature | — | — | blocked | R1B; OQ-LMP-005; DEC-D3-04 |
| FR-LMP-017 | Báo cáo hư hỏng lưu mức độ, mô tả và trạng thái chờ xử lý | feature | CHK-LMP-071 | UI | covered | — |
| FR-LMP-017 | Báo cáo chờ xử lý không tự đóng | feature | CHK-LMP-072 | UI | covered | — |
| FR-LMP-017 | Tệp bằng chứng rủi ro không được lưu | feature | CHK-LMP-073 | UI | covered | — |
| FR-LMP-017 | Upload tệp hợp lệ được lưu | feature | CHK-LMP-073 | UI | partial | Mới có oracle từ chối tệp rủi ro; chưa có oracle upload hợp lệ |
| FR-LMP-017 | Bác bỏ, sửa hoặc thanh lý thì báo cáo đóng và có audit | feature | CHK-LMP-075, CHK-LMP-076, CHK-LMP-077 | UI | covered | — |
| FR-LMP-017 | Thủ thư quầy không đóng báo cáo bằng disposition | feature | CHK-LMP-078 | UI | covered | — |
| FR-LMP-017 | Disposition không hợp lệ không đổi báo cáo | feature | CHK-LMP-079 | UI | covered | — |
| FR-LMP-017 | Disposition đến sau không ghi đè disposition đã commit | feature | CHK-LMP-080 | — | covered | — |
| FR-LMP-017 | Audit thất bại thì báo cáo hoặc disposition bị rollback | feature | CHK-LMP-074, CHK-LMP-081 | — | covered | — |
| FR-LMP-017 | Trạng thái bản sao sau disposition | feature | — | — | blocked | DEC-D3-01, DEC-D3-06, DEC-D3-07 |
| FR-LMP-017 | Cách ly bản sao ngay khi báo hư hỏng | feature | — | — | blocked | Quyết định còn mở; checklist không khẳng định PENDING_REVIEW |
| FR-LMP-017 | Số ảnh và dung lượng tệp | feature | — | — | tbd | 1–5 ảnh và giới hạn dung lượng vẫn là proposal |
| FR-LMP-018 | Ghi nhận mất tạo một ASSESSMENT và đánh dấu bản sao đã mất | feature | CHK-LMP-082, CHK-LMP-083 | UI | covered | Số tiền bồi thường chưa chốt |
| FR-LMP-018 | Ghi nhận mất lặp không tạo ASSESSMENT thứ hai | feature | CHK-LMP-084 | UI | covered | — |
| FR-LMP-018 | Tìm lại không xóa nghĩa vụ đã ghi | feature | CHK-LMP-085 | — | covered | — |
| FR-LMP-018 | Audit thất bại thì ghi nhận mất bị rollback | feature | CHK-LMP-086 | — | covered | — |
| FR-LMP-018 | Đối soát khi tìm lại và thứ tự nhả bản sao | feature | — | — | blocked | DEC-P2-07, DEC-D3-05, OQ-LMP-005 |
| FR-LMP-019 | Giao dịch nghiệp vụ vẫn commit và có sự kiện trong outbox | feature | CHK-LMP-087, CHK-LMP-088 | — | covered | — |
| FR-LMP-019 | Kênh gửi lỗi thì ghi trạng thái lỗi và không xóa giao dịch đã commit | feature | CHK-LMP-089, CHK-LMP-090 | UI | covered | — |
| FR-LMP-019 | Kênh, số lần gửi lại và dead-letter | feature | — | — | tbd | OQ-LMP-008, OQ-LMP-010, DEC-D3-08 |
| FR-LMP-020 | Người có quyền xem ai, thời điểm, tài nguyên và kết quả | feature | CHK-LMP-041, CHK-LMP-042 | UI | covered | — |
| FR-LMP-020 | Audit thất bại thì hành động nhạy cảm không còn kết quả đã commit | feature | CHK-LMP-043 | — | covered | — |
| FR-LMP-020 | Người không có quyền audit bị từ chối | feature | CHK-LMP-044 | UI | covered | — |
| FR-LMP-020 | Màn xem audit đầy đủ | feature | — | — | blocked | R1B |
| FR-LMP-021 | Giao dịch sau thời điểm hiệu lực dùng tham số mới | feature | CHK-LMP-027 | UI | covered | — |
| FR-LMP-021 | Giao dịch đã ghi giữ bằng chứng quy định tại thời điểm ghi | feature | CHK-LMP-028 | — | covered | — |
| FR-LMP-021 | Người không có quyền không đổi quy định đang hiệu lực | feature | CHK-LMP-029 | UI | covered | — |
| FR-LMP-021 | Tham số không hợp lệ theo quy tắc đã phê duyệt không được kích hoạt | feature | CHK-LMP-030 | UI | covered | Giá trị tham số thuộc OQ-LMP-010 |
| FR-LMP-022 | Dry-run báo đủ nhóm dòng và không đổi kho | feature | CHK-LMP-031, CHK-LMP-032 | UI | covered | — |
| FR-LMP-022 | File không đọc được không ghi dữ liệu nghiệp vụ | feature | CHK-LMP-033 | UI | covered | — |
| FR-LMP-022 | Commit lô đã đạt, cấp mã không trùng và có báo cáo đối soát | feature | CHK-LMP-034, CHK-LMP-035, CHK-LMP-036 | UI | covered | — |
| FR-LMP-022 | Dry-run còn lỗi và chưa có override đã duyệt thì không ghi kho | feature | CHK-LMP-037 | UI | covered | — |
| FR-LMP-022 | Một dòng commit lỗi làm rollback toàn bộ lô | feature | CHK-LMP-038 | — | covered | — |
| FR-LMP-022 | Gửi lại cùng operation_id trả kết quả lô gốc | feature | CHK-LMP-039 | UI | covered | Cơ chế replay cùng lô vẫn là proposal |
| FR-LMP-022 | Audit không ghi được thì lô bị rollback | feature | CHK-LMP-040 | — | covered | — |
| FR-LMP-022 | Mapping cột Excel | feature | — | — | blocked | OQ-LMP-002 |
| FR-LMP-022 | Ngưỡng đối soát vật lý | feature | — | — | tbd | OQ-LMP-018 |
| FR-LMP-023 | Báo cáo vận hành quá hạn, đang mượn, hàng đợi, phạt và hư hỏng | feature | — | — | blocked | Chưa có story AC và CHK |
| FR-LMP-024 | Cổng tự phục vụ người đọc | feature | — | — | blocked | R2; OQ-LMP-016; xem công nợ thuộc R1B |
| FR-LMP-025 | Kiểm tra loại, kích thước và nội dung trước khi lưu ảnh | feature | CHK-LMP-073 | UI | partial | Oracle hiện có là từ chối tệp rủi ro |
| FR-LMP-026 | Quét mã chỉ mở đúng bản ghi và không thay quyền | feature | CHK-LMP-015, CHK-LMP-016, CHK-LMP-053 | UI | covered | — |
| FR-LMP-027 | Xem lịch sử trạng thái của bản sao, phiếu, đặt trước, phạt và báo cáo | feature | CHK-LMP-041, CHK-LMP-042 | UI | partial | Mới phủ bằng chứng audit của hành động đã commit; viewer lịch sử đầy đủ thuộc R1B |
| FR-LMP-028 | Phân tích xu hướng và đề xuất mua | feature | — | — | blocked | R3-candidate; chưa phải yêu cầu build |
| BR-LMP-001 | Một điều kiện fail thì không bản sao nào được ghi mượn | feature | CHK-LMP-045, CHK-LMP-047 | UI | covered | — |
| BR-LMP-002 | Chỉ mượn bản sao ở trạng thái được phép | feature | CHK-LMP-047 | UI | covered | — |
| BR-LMP-002 | Bản sao đang giữ chỗ chỉ mượn cho đúng lượt đặt trước | feature | — | — | blocked | Chưa có luồng đặt trước trong checklist |
| BR-LMP-003 | Người đọc phải đủ điều kiện mượn | feature | CHK-LMP-048 | UI | covered | Ngưỡng số sách thuộc OQ-LMP-010 |
| BR-LMP-004 | Từ chối gia hạn khi quá hạn, có đặt trước hoặc đạt giới hạn | feature | — | — | blocked | Chưa có CHK gia hạn |
| BR-LMP-005 | Hàng đợi và chuyển giữ chỗ nguyên tử | feature | — | — | blocked | Chưa có CHK đặt trước |
| BR-LMP-006 | Hết hạn giữ chỗ thì nhả bản sao và đẩy hàng đợi | feature | — | — | blocked | Chưa có CHK đặt trước |
| BR-LMP-007 | ASSESSMENT và PAYMENT là sự kiện append-only | feature | CHK-LMP-061, CHK-LMP-064 | — | covered | — |
| BR-LMP-007 | Waiver, adjustment, reversal, refund và reconciliation | feature | — | — | blocked | Chưa được duyệt; FR-LMP-016 |
| BR-LMP-008 | Cùng yêu cầu thanh toán không ghi hai PAYMENT | feature | CHK-LMP-066 | UI | covered | — |
| BR-LMP-009 | Báo cáo không đóng khi chưa có disposition | feature | CHK-LMP-072 | UI | covered | — |
| BR-LMP-009 | Đóng báo cáo sau bác bỏ, sửa hoặc thanh lý | feature | CHK-LMP-075, CHK-LMP-076, CHK-LMP-077 | UI | partial | Ba tên disposition là fact của story. BR ghi repair, replace, no-charge, fine-linked; chưa có quyết định ánh xạ |
| BR-LMP-010 | Tìm lại không tự xóa nghĩa vụ đã ghi | feature | CHK-LMP-085 | — | covered | — |
| BR-LMP-010 | Bản sao tìm lại chỉ về khả dụng sau đối soát | feature | — | — | blocked | DEC-D3-05 |
| BR-LMP-011 | Quét mã là định vị, không phải ủy quyền | feature | CHK-LMP-015, CHK-LMP-016, CHK-LMP-053 | UI | covered | — |
| BR-LMP-012 | Tệp rủi ro không được lưu | feature | CHK-LMP-073 | UI | covered | — |
| BR-LMP-012 | Tệp hợp lệ đi qua trust boundary và được lưu | feature | — | — | partial | Chưa có oracle upload hợp lệ |
| BR-LMP-013 | Audit thất bại thì ghi nghiệp vụ bị rollback | feature | CHK-LMP-040, CHK-LMP-043, CHK-LMP-052, CHK-LMP-058, CHK-LMP-063, CHK-LMP-069, CHK-LMP-074, CHK-LMP-081, CHK-LMP-086 | — | covered | — |
| BR-LMP-014 | Dry-run, không commit khi còn lỗi chưa được override, và đối soát sau commit | feature | CHK-LMP-031, CHK-LMP-032, CHK-LMP-036, CHK-LMP-037 | UI | covered | Mapping Excel vẫn blocked ở FR-LMP-022 |
| BR-LMP-015 | Từ chối mặc định với trường và hành động nhạy cảm | feature | CHK-LMP-004, CHK-LMP-025 | UI | covered | — |
| BR-LMP-016 | Lỗi gửi thông báo không làm mất giao dịch đã commit | feature | CHK-LMP-087, CHK-LMP-088, CHK-LMP-090 | — | covered | — |
| BR-LMP-017 | Hồ sơ thư mục, bản sao và người đọc đã có lịch sử không bị xóa cứng | feature | CHK-LMP-012, CHK-LMP-018, CHK-LMP-026 | — | covered | — |
| NFR-LMP-001 | Khả dụng trong giờ vận hành theo SLA | feature | — | — | tbd | OQ-LMP-010; profile không đo ngưỡng |
| NFR-LMP-002 | Thời gian phản hồi tra cứu | feature | — | — | tbd | Ngưỡng là proposal; profile Core-functional không bật Performance |
| NFR-LMP-003 | Chuyển trạng thái không ghi một phần khi tranh chấp hoặc mất mạng | feature | CHK-LMP-051, CHK-LMP-096 | — | covered | — |
| NFR-LMP-004 | Kiểm tra quyền theo actor, tài nguyên, hành động và trường | feature | CHK-LMP-001, CHK-LMP-002, CHK-LMP-004 | UI | covered | — |
| NFR-LMP-005 | Che dữ liệu cá nhân theo quyền | feature | CHK-LMP-025 | UI | covered | — |
| NFR-LMP-005 | Thời gian lưu và xóa dữ liệu cá nhân | feature | — | — | blocked | OQ-LMP-006; chưa approved |
| NFR-LMP-006 | Audit thất bại làm hành động nhạy cảm thất bại | feature | CHK-LMP-043 | — | covered | — |
| NFR-LMP-007 | Ghi nhận gửi thông báo lỗi | feature | CHK-LMP-089 | UI | covered | — |
| NFR-LMP-007 | Số lần gửi lại và dead-letter | feature | — | — | tbd | OQ-LMP-010, DEC-D3-08 |
| NFR-LMP-008 | Màn quầy hiện trạng thái đang xử lý trước kết quả | feature | CHK-LMP-091 | UI | covered | — |
| NFR-LMP-008 | Thao tác được bằng bàn phím khi có bàn phím phần cứng | feature | CHK-LMP-092, CHK-LMP-093 | UI | covered | — |
| NFR-LMP-009 | Điều khiển có tên đọc được và focus nhìn thấy | feature | CHK-LMP-092, CHK-LMP-093 | UI | covered | — |
| NFR-LMP-009 | Mức WCAG | feature | — | — | tbd | Mức chưa chốt; profile không bật a11y đầy đủ |
| NFR-LMP-010 | Log điều tra không lộ secret và PII không cần thiết | feature | — | — | blocked | R1B; chưa có oracle log trong checklist UI |
| NFR-LMP-011 | Dry-run, lỗi theo dòng và đối soát trước khi commit | feature | CHK-LMP-031, CHK-LMP-036 | UI | covered | — |
| NFR-LMP-012 | Khung Mobile 375 vẫn hiện hành động chính | feature | CHK-LMP-094 | UI | covered | — |
| NFR-LMP-012 | Ma trận desktop, tablet và thiết bị production của cổng người đọc | feature | — | — | tbd | R2; OQ-LMP-015 |
| E-LMP-001 | Báo lỗi và không ghi khi thiếu dữ liệu bắt buộc | feature | CHK-LMP-009, CHK-LMP-023, CHK-LMP-030 | UI | covered | — |
| E-LMP-001 | Giữ dữ liệu đã nhập để sửa | feature | CHK-LMP-010 | UI | partial | Oracle giữ dữ liệu mới có ở form hồ sơ thư mục |
| E-LMP-002 | Từ chối quyền và không lộ dữ liệu | feature | CHK-LMP-002, CHK-LMP-013, CHK-LMP-029, CHK-LMP-044, CHK-LMP-078 | UI | covered | — |
| E-LMP-002 | Ghi nhận lần từ chối | feature | CHK-LMP-003 | — | covered | — |
| E-LMP-003 | Không tạo bản ghi trùng và không trả đầu sách giả | feature | CHK-LMP-011, CHK-LMP-017, CHK-LMP-020, CHK-LMP-024 | UI | covered | — |
| E-LMP-004 | Bản sao không hợp lệ thì cả phiếu không được ghi | feature | CHK-LMP-047 | UI | covered | AC chọn rollback cả phiếu. Error Matrix còn chữ cho loại từng item hoặc chọn bản sao khác; matrix chưa sửa |
| E-LMP-005 | Xung đột đồng thời không ghi kết quả thứ hai | feature | CHK-LMP-051, CHK-LMP-057, CHK-LMP-068, CHK-LMP-080 | — | covered | CHK-LMP-068 theo UC thu tiền. Matrix hiện gắn E-LMP-005 với bản sao và đặt trước |
| E-LMP-006 | Gửi lại cùng khóa trả kết quả gốc | feature | CHK-LMP-039, CHK-LMP-050, CHK-LMP-066 | UI | covered | — |
| E-LMP-007 | Người đọc không đủ điều kiện thì không tạo phiếu và nêu lý do | feature | CHK-LMP-048, CHK-LMP-049 | UI | covered | Nhánh gia hạn chưa có CHK |
| E-LMP-008 | Đặt trước không khả dụng | feature | — | — | blocked | FR-LMP-012 và FR-LMP-013 chưa có CHK |
| E-LMP-009 | Thanh toán thất bại thì giữ nghĩa vụ | feature | CHK-LMP-067 | UI | covered | — |
| E-LMP-010 | Nhận ra khoản thu trùng và không ghi PAYMENT thứ hai | feature | CHK-LMP-066 | UI | covered | — |
| E-LMP-011 | Không lưu tệp rủi ro | feature | CHK-LMP-073 | UI | covered | Ngưỡng loại và dung lượng chưa chốt |
| E-LMP-012 | Ghi trạng thái gửi lỗi | feature | CHK-LMP-089 | UI | covered | — |
| E-LMP-012 | Gửi lại và dead-letter sau ngưỡng | feature | — | — | tbd | OQ-LMP-010, DEC-D3-08 |
| E-LMP-013 | Rollback ghi nghiệp vụ khi audit thất bại | feature | CHK-LMP-040, CHK-LMP-043, CHK-LMP-052, CHK-LMP-058, CHK-LMP-063, CHK-LMP-069, CHK-LMP-074, CHK-LMP-081, CHK-LMP-086 | — | covered | — |
| E-LMP-013 | Cảnh báo vận hành khi audit thất bại | feature | — | — | tbd | Chưa có điểm đến cảnh báo đã duyệt |
| E-LMP-014 | File không đọc được, còn lỗi hoặc lệch thì không commit | feature | CHK-LMP-033, CHK-LMP-037, CHK-LMP-038 | UI | covered | — |
| E-LMP-015 | Hành động không hợp lệ với trạng thái hiện tại không nhân đôi kết quả | feature | CHK-LMP-056, CHK-LMP-062, CHK-LMP-079, CHK-LMP-084 | UI | covered | — |
| E-LMP-015 | Hồ sơ đã có lịch sử không bị xóa cứng | feature | CHK-LMP-012, CHK-LMP-018 | — | covered | — |
| E-LMP-016 | Che hoặc chặn trường và event ngoài quyền | feature | CHK-LMP-004, CHK-LMP-025, CHK-LMP-044, CHK-LMP-070 | UI | covered | — |
| E-LMP-017 | Hết phiên không mất dữ liệu đã ghi và không ghi việc đang dở | feature | CHK-LMP-005, CHK-LMP-006, CHK-LMP-097 | UI | covered | — |
| E-LMP-017 | Tác vụ nhạy cảm không chạy khi chưa xác thực lại | feature | CHK-LMP-007 | UI | covered | Thời lượng phiên thuộc OQ-LMP-010 |
| E-LMP-018 | Lỗi kênh không xóa giao dịch đã commit | feature | CHK-LMP-089, CHK-LMP-090 | UI | covered | — |

## Retired CHK-IDs

> ID của item đã xóa — không dùng lại, không lấp chỗ trống.

| CHK-ID | Retired date | Lý do |
|--------|--------------|-------|
