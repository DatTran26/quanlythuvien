---
type: brainstorm
scope: product
status: draft
updated: 2026-10-08
links:
  - docs/he_thong_quan_ly_thu_vien.md
  - docs/_shared/project-profile.md
  - docs/_shared/domain/lifecycle-inventory.md
  - docs/_product/decision-register.md
  - plans/reports/ba-audit-261005-0018-library-management-roadmap.md
---

# Baseline roadmap sản phẩm Hệ thống Quản lý Thư viện

## 1. Idea Seed

Làm rõ toàn bộ roadmap sản phẩm bằng quy trình BA đầy đủ, dùng tài liệu hệ thống hiện có làm nguồn, tự chọn các giả định an toàn và tách rõ điều đã biết, điều đề xuất và điều còn cần phê duyệt.

## 2. Context

Tài liệu hiện tại đã mô tả rộng về vai trò, chức năng, quy tắc, dữ liệu, báo cáo và ba giai đoạn triển khai. Tuy nhiên, roadmap chưa phản ánh đầy đủ dependency vận hành: Giai đoạn 1 tạo ra quá hạn, khoản phạt và báo cáo hư hỏng nhưng các chức năng xử lý cuối vòng đời lại nằm ở Giai đoạn 2. Hai phần quan trọng là vòng đời bản sao và luồng trả cũng chỉ còn placeholder nên chưa thể dùng làm baseline nghiệm thu.

Roadmap mới phải bảo đảm mỗi release tạo ra một năng lực vận hành khép kín, có dữ liệu thật, tiêu chí vào/ra, kiểm soát ngoại lệ và khả năng rollback.

## 3. User Types

| User Type | Pain Point | Primary Need |
|---|---|---|
| Người đọc | Khó biết sách còn hay không, hạn trả và tình trạng khoản mượn | Tra cứu và tự theo dõi minh bạch |
| Nhân viên | Mượn–trả thủ công dễ nhầm sách, người đọc và trạng thái | Quét nhanh, chặn sai ngay, có đường xử lý ngoại lệ |
| Thủ thư | Khó kiểm soát kho, quy định, hư hỏng và số liệu báo cáo | Dữ liệu tin cậy, truy vết được và có báo cáo đối soát |
| Thủ thư trưởng | Thiếu baseline để quyết định scope và go-live | Roadmap theo dependency, KPI và gate rõ ràng |

## 4. Capabilities Breakdown

### P0 — must have trước pilot

- Danh tính, phân quyền và kích hoạt người đọc.
- Quản lý đầu sách, bản sao, danh mục, vị trí và trạng thái khả dụng.
- Import Excel, sinh/in/đối soát QR và nhập mã thủ công khi QR không dùng được.
- Mượn nhiều cuốn trong một lần xác nhận; trả bình thường, quá hạn, hư hỏng và mất sách theo scope đã chốt.
- Quá hạn và sổ khoản phạt tối thiểu để BR chặn mượn hoạt động đúng.
- Duyệt hư hỏng để bản sao không mắc kẹt ở trạng thái chờ.
- Audit cho thao tác thay đổi dữ liệu, backup và diễn tập khôi phục.
- Báo cáo tình trạng kho và danh sách quá hạn phục vụ vận hành.

### P1 — should have sau khi MVP ổn định

- Gia hạn tại quầy và trực tuyến.
- Đặt trước, hàng chờ, giữ sách và hết hạn giữ.
- Thông báo trong ứng dụng và email; tác vụ nhắc hạn.
- Thu phạt, biên nhận, miễn/điều chỉnh phạt theo thẩm quyền.
- Báo cáo xu hướng mượn–trả, phạt, hư hỏng và sách được quan tâm.

### P2 — candidate, chỉ lập release sau quyết định riêng

- Điểm danh và báo cáo hoạt động nhân viên.
- Thanh toán trực tuyến.
- Nhiều chi nhánh và luân chuyển sách.
- Chế độ offline.
- SMS, push hoặc Zalo.

## 5. Core Flows

### 5.1 Chuẩn bị dữ liệu và kho trước pilot

1. Thủ thư chuẩn hóa dữ liệu đầu sách, bản sao và vị trí.
2. Hệ thống chạy thử import, chỉ ra bản ghi lỗi/trùng và không ghi dữ liệu khi chưa xác nhận.
3. Thủ thư sửa dữ liệu, import chính thức và sinh QR.
4. Nhân viên dán nhãn, quét đối soát và xác nhận số lượng vật lý khớp hệ thống.

```text
Excel thật → Dry-run → Danh sách lỗi → Làm sạch → Import
                                           ↓
                                 Sinh QR → Dán nhãn → Đối soát
```

### 5.2 Mượn sách tại quầy

1. Nhân viên quét thẻ người đọc và hệ thống kiểm tra trạng thái đủ điều kiện.
2. Nhân viên quét từng bản sao; hệ thống kiểm tra trạng thái, hạn mức và trùng đầu sách ngay khi thêm.
3. Nhân viên xác nhận toàn bộ danh sách.
4. Hệ thống ghi các Loan trong một giao dịch, chuyển trạng thái bản sao, ghi audit và trả biên nhận.

```text
Quét người đọc → Đủ điều kiện? ──không──> Từ chối có lý do
       │ có
       ▼
Quét sách → Từng cuốn hợp lệ? ──không──> Loại cuốn lỗi, giữ giỏ
       │ có
       ▼
Xác nhận → Ghi nguyên giao dịch → Loan + trạng thái + audit + biên nhận
```

### 5.3 Trả sách và xử lý ngoại lệ

1. Nhân viên quét bản sao và hệ thống tìm Loan đang mở.
2. Nhân viên ghi nhận tình trạng trả.
3. Hệ thống đóng Loan, tính quá hạn và tạo khoản phạt nếu có.
4. Bản sao chuyển về Sẵn sàng, Đang giữ, Chờ duyệt hư hỏng hoặc Mất theo kết quả nghiệp vụ.
5. Hệ thống ghi audit và hiển thị kết quả để nhân viên xác nhận với người đọc.

```text
Quét bản sao → Có Loan mở? ──không──> Dừng, yêu cầu kiểm tra
      │ có
      ▼
Ghi tình trạng → Bình thường / Hư hỏng / Mất
      │
      ▼
Đóng Loan + tính quá hạn/phạt → chuyển trạng thái Copy → audit
```

### 5.4 Đặt trước và giao sách

1. Người đọc đặt trước khi đầu sách hết bản khả dụng.
2. Hệ thống thêm yêu cầu vào hàng chờ FIFO.
3. Khi có bản sao, hệ thống gán cho người đầu hàng, giữ 48 giờ và gửi thông báo.
4. Người đọc nhận sách hoặc yêu cầu hết hạn; bản sao được chuyển tiếp cho người kế tiếp.

## 6. System Behavior Deep Dive

### 6.1 Decision Points

| ID | Flow | Khi nào | YES | NO |
|---|---|---|---|---|
| D1 | Mượn | Người đọc đủ điều kiện? | Cho quét sách | Dừng và nêu lý do |
| D2 | Mượn | Bản sao hợp lệ? | Thêm vào giỏ | Không thêm, giữ các cuốn hợp lệ |
| D3 | Trả | Có Loan đang mở? | Tiếp tục trả | Dừng để kiểm tra |
| D4 | Trả | Bản sao hư hỏng? | Chuyển Chờ duyệt | Xét hàng chờ đặt trước |
| D5 | Trả | Có người đặt trước? | Chuyển Đang giữ | Chuyển Sẵn sàng |
| D6 | Đặt trước | Đến nhận trong 48 giờ? | Hoàn tất đặt trước | Hết hạn và chuyển người kế tiếp |

### 6.2 Scenario Matrix

| From State | To State | Rule | Action | Result |
|---|---|---|---|---|
| Sẵn sàng | Đang mượn | Người đọc và bản sao hợp lệ | Xác nhận mượn | Loan ACTIVE |
| Đang giữ | Đang mượn | Đúng người được giữ | Xác nhận mượn | Reservation FULFILLED |
| Đang mượn | Sẵn sàng | Trả bình thường, không có hàng chờ | Đóng Loan | Bản sao khả dụng |
| Đang mượn | Đang giữ | Trả bình thường, có hàng chờ | Đóng Loan và gán người kế tiếp | Reservation READY |
| Đang mượn | Chờ duyệt | Phát hiện hư hỏng | Tạo DamageReport | Không cho mượn |
| Đang mượn | Mất | Ghi nhận mất | Đóng Loan, tạo bồi thường | Không còn khả dụng |

### 6.3 State Transitions

| Entity | Từ | Sang | Trigger | Quay lại được? |
|---|---|---|---|---|
| Loan | ACTIVE | OVERDUE | Qua hạn trả | Có, khi đóng bằng trả/mất |
| Loan | ACTIVE/OVERDUE | RETURNED | Nhận trả hợp lệ | Không; sửa sai qua quy trình điều chỉnh |
| Loan | ACTIVE/OVERDUE | LOST | Ghi nhận mất | Có điều kiện nếu tìm lại, cần audit |
| Reservation | WAITING | READY | Có bản sao được gán | Có thể hủy/hết hạn |
| Reservation | READY | FULFILLED | Nhận sách | Không |
| Reservation | WAITING/READY | CANCELLED | Người đọc hoặc nhân viên hủy | Không |
| Reservation | READY | EXPIRED | Hết 48 giờ | Không |

State machine đầy đủ của Copy đã được dựng lại thành artifact riêng tại `docs/_shared/domain/lifecycle-inventory.md` dưới nhãn **PROPOSAL** (DEC-D3-01/DEC-D3-02, liên quan OQ-LMP-004) — nguồn gốc đã mất nên đây là reconstruction chờ domain approval, không phải "phục hồi từ nguồn". Bảng trên chỉ ghi các transition đã có căn cứ từ tài liệu nguồn.

### 6.4 Interrupted Transactions

| Tình huống | Hệ thống còn lại gì | Resume | Cleanup |
|---|---|---|---|
| Mất kết nối trước xác nhận | Không tạo giao dịch | Quét lại hoặc khôi phục giỏ cục bộ nếu còn | Không có dữ liệu nghiệp vụ cần xóa |
| Mất kết nối sau xác nhận | Kết quả phải truy vấn lại theo lần giao dịch | Hiển thị trạng thái đã ghi, không tạo lần thứ hai | Đối soát giao dịch chưa nhận phản hồi |
| Import bị lỗi | Chỉ báo cáo dry-run hoặc rollback toàn batch | Sửa file và chạy lại | Không để dữ liệu nhập dở |
| Tác vụ nền chạy lại | Bản ghi đã xử lý không được nhân đôi side effect | Chạy idempotent theo kỳ | Đối soát các mục lỗi |
| Hai quầy xử lý cùng một bản sao | Chỉ thao tác hợp lệ đầu tiên thành công | Quầy sau tải trạng thái mới | Không phát sinh double-loan |

### 6.5 Other Edge Cases

- QR sai, mờ, trùng hoặc đã bị thay thế.
- Quét trùng một bản sao trong cùng giỏ.
- Một cuốn lỗi trong batch mượn: cuốn lỗi bị loại, các cuốn hợp lệ vẫn được xác nhận khi nhân viên đồng ý.
- Trả lặp, báo mất lặp hoặc thu phạt lặp.
- Hủy đặt trước đúng thời điểm sách vừa được gán hoặc vừa hết hạn.
- Cấu hình thay đổi chỉ áp dụng cho giao dịch bắt đầu sau thời điểm hiệu lực; Loan đã tạo giữ quy định tại thời điểm mượn.

## 7. Validation, Limits & Wording

### 7.1 Validation rules

| Đối tượng | Rule |
|---|---|
| QR bản sao | Duy nhất, đang hiệu lực và trỏ đúng một bản sao |
| QR thẻ | Thuộc tài khoản còn hiệu lực và đã kích hoạt |
| Giỏ mượn | Không trùng bản sao; không vượt hạn mức; không trùng đầu sách đang mượn |
| Ảnh hư hỏng | Từ 1 đến 5 ảnh; mỗi ảnh sau nén không quá 500 KB |
| Import | Có mã nhận diện, trạng thái hợp lệ; lỗi/trùng được báo theo dòng |

### 7.2 Limits & Quotas

| Tham số | Giá trị baseline | Window | Behavior khi vượt |
|---|---:|---|---|
| Sách đang mượn tối đa | 5 bản sao | Tại thời điểm xác nhận | Từ chối phần vượt hạn mức |
| Thời hạn mượn | 14 ngày | Mỗi Loan | Tính quá hạn sau thời điểm kết thúc hạn |
| Gia hạn | 1 lần, thêm 7 ngày | Mỗi Loan | Từ chối nếu quá hạn hoặc có người đặt trước |
| Đặt trước đang mở | 3 yêu cầu | Mỗi người đọc | Từ chối yêu cầu mới |
| Thời gian giữ | 48 giờ | Từ lúc READY | Chuyển người kế tiếp hoặc Sẵn sàng |
| Ảnh báo hư hỏng | 1–5 ảnh | Mỗi báo cáo | Không cho gửi ngoài giới hạn |

### 7.3 Wording samples

#### Error messages

| Tình huống | Wording |
|---|---|
| Bản sao vừa được xử lý ở quầy khác | “Sách vừa được cập nhật. Vui lòng quét lại để xem trạng thái mới.” |
| Người đọc không đủ điều kiện mượn | “Không thể tạo phiếu mượn. Vui lòng kiểm tra trạng thái thẻ, sách quá hạn và công nợ.” |
| Không tìm thấy Loan đang mở | “Không tìm thấy phiếu mượn đang mở cho cuốn sách này.” |
| Vượt hạn mức | “Người đọc đã đạt giới hạn 5 cuốn đang mượn.” |

#### Success messages

| Tình huống | Wording |
|---|---|
| Mượn thành công | “Đã tạo phiếu mượn. Hạn trả được hiển thị trong danh sách sách đang mượn.” |
| Trả thành công | “Đã nhận trả sách và cập nhật trạng thái bản sao.” |
| Import thành công | “Đã nhập dữ liệu và tạo báo cáo đối soát.” |

#### Info / neutral messages

| Tình huống | Wording |
|---|---|
| Sách được giữ | “Sách đã sẵn sàng. Vui lòng đến nhận trong vòng 48 giờ.” |
| Hư hỏng chờ duyệt | “Bản sao đã được tạm ngừng lưu thông và đang chờ thủ thư xử lý.” |

## 8. Assumptions

- Pilot tại một cơ sở với hai quầy; quy mô thực tế được xác nhận bằng dữ liệu import.
- Thủ thư trưởng là người phê duyệt nghiệp vụ và go-live.
- Một bộ quy định chung áp dụng cho mọi người đọc trong MVP.
- Web responsive là nền tảng duy nhất của baseline; không hỗ trợ offline.
- Dữ liệu thật sẽ được import từ Excel và đối soát trước pilot.
- Các mục tiêu KPI chưa có baseline lịch sử được xem là target pilot cần đo lại, không phải cam kết SLA dài hạn.

## 9. Risks

| Rủi ro | Khả năng | Hậu quả nghiệp vụ | Cách phòng |
|---|---|---|---|
| Dữ liệu Excel sai hoặc QR trùng | thường | Sai lệch kho, không thể vận hành tại quầy | Dry-run, báo lỗi theo dòng, đối soát vật lý |
| Quy định mượn/phạt thay đổi muộn | thỉnh thoảng | Viết lại luồng và trì hoãn pilot | Chốt policy baseline trước SRS |
| Bản sao kẹt ở Chờ duyệt | thỉnh thoảng | Giảm số sách khả dụng không rõ nguyên nhân | Đưa duyệt hư hỏng tối thiểu vào MVP |
| Nhân viên chưa quen quy trình | thường | Thời gian giao dịch tăng và phát sinh sửa tay | SOP, dữ liệu tập, diễn tập trước pilot |
| Quyền riêng tư chưa được phê duyệt | thỉnh thoảng | Trì hoãn go-live hoặc phải thu hẹp dữ liệu | Gate pháp lý và kiểm soát quyền trước pilot |
| Phạm vi mở rộng chen vào MVP | thỉnh thoảng | Trễ critical path mượn–trả | Giữ candidate initiatives ngoài release cam kết |

## 10. Success Criteria

- Thời gian phản hồi quét QR dưới 1 giây và tra cứu dưới 2 giây với quy mô 50.000 bản sao.
- Không phát sinh hai Loan mở cho cùng một bản sao.
- 100% thao tác thay đổi dữ liệu quan trọng có actor, thời điểm và đối tượng trong audit.
- Sai lệch giữa kho vật lý và hệ thống sau đối soát pilot không quá 1%.
- 100% bản ghi import lỗi hoặc trùng được chỉ rõ để xử lý trước khi ghi chính thức.
- Backup được tạo theo lịch và có ít nhất một lần khôi phục thành công trước go-live.
- Mọi trạng thái tạm như Chờ duyệt, Đang giữ và Quá hạn có owner và đường kết thúc.

## 11. Open Questions

- [ ] OQ-BS-1 (trước ghi `OQ-1`): Chính sách lưu giữ và xử lý yêu cầu dữ liệu cá nhân nào được người phụ trách pháp lý phê duyệt?
- [ ] OQ-BS-2 (trước ghi `OQ-2`): File Excel thực tế có cấu trúc, chất lượng và mã QR cũ như thế nào?
- [ ] OQ-BS-3 (trước ghi `OQ-3`): Sơ đồ 7 trạng thái Copy và chi tiết luồng trả gốc có thể phục hồi từ nguồn nào? — Đã reconstruct-as-PROPOSAL tại `docs/_shared/domain/lifecycle-inventory.md` (DEC-D3-01/02); vẫn mở cho tới khi domain approver xác nhận hoặc nguồn gốc được tìm lại.

## 12. Next Steps

- Lập product roadmap R0–R3 theo dependency và readiness gate.
- Phục hồi state machine Copy và flow trả trước khi khóa SRS — PROPOSAL đã có (`docs/_shared/domain/lifecycle-inventory.md`); còn bước domain approval qua `decision-register.md`.
- Tách capability thành các feature/epic có thể truy vết.
- Viết URD/BRD/PRD rồi SRS theo từng workstream sau khi roadmap được duyệt.

