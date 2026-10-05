# Tài liệu kỹ thuật – Hệ thống Quản lý Thư viện

Oct 2, 2026 · @Hoàng

## 1. Tổng quan

Hệ thống số hóa toàn bộ luồng mượn – trả – đặt trước sách của một thư viện, dùng mã QR để định danh từng cuốn sách và từng người đọc. Tài liệu này mô tả vai trò, yêu cầu chức năng, quy tắc nghiệp vụ, dữ liệu và các câu hỏi còn mở cần chốt trước khi lập trình.

**Mục tiêu**

- Rút ngắn thời gian tạo phiếu mượn/trả tại quầy bằng thao tác quét QR.
- Theo dõi chính xác số lượng và tình trạng của từng cuốn sách.
- Cho người đọc tự tra cứu, đặt trước, gia hạn và nhận nhắc hạn trả.
- Cung cấp báo cáo để thủ thư ra quyết định nhập, sửa, thanh lý sách.

**Ngoài phạm vi (phiên bản đầu)**: thanh toán trực tuyến, sách điện tử, liên thư viện nhiều chi nhánh (xem Open Questions).

**Thuật ngữ**

| Thuật ngữ | Ý nghĩa |
| --- | --- |
| Đầu sách (Title) | Thông tin chung của một cuốn sách: tên, tác giả, ISBN, thể loại. |
| Bản sao (Copy) | Một cuốn vật lý cụ thể của đầu sách, có mã QR riêng và tình trạng riêng. |
| Phiếu mượn (Loan) | Bản ghi một lần mượn một bản sao, từ lúc mượn đến lúc trả. |
| Đặt trước (Reservation) | Yêu cầu giữ chỗ cho một đầu sách đang hết bản sao sẵn sàng. |
| Số lượng khả dụng | Số bản sao đang ở trạng thái Sẵn sàng, không tính bản đang mượn, đang giữ, hư hỏng. |

## 2. Vai trò & ma trận phân quyền

Hệ thống có 3 vai trò xếp theo cấp: Thủ thư có toàn bộ quyền của Nhân viên, cộng thêm quyền quản trị dữ liệu và cấu hình. Việc có cần thêm vai trò Admin hay không đang là câu hỏi mở (OQ-01).

| Vai trò | Mô tả | Kênh sử dụng dự kiến |
| --- | --- | --- |
| Người đọc | Thành viên thư viện, tra cứu và mượn sách | App di động / web |
| Nhân viên | Trực quầy, xử lý mượn – trả, kiểm tra tình trạng sách | App di động (quét QR, chụp ảnh) / web |
| Thủ thư | Quản trị sách, tài khoản, quy định, báo cáo | Web |

**Ma trận phân quyền** (✓ = được phép, "riêng" = chỉ với dữ liệu của chính mình)

| Chức năng | Người đọc | Nhân viên | Thủ thư |
| --- | --- | --- | --- |
| Tra cứu sách, xem số lượng khả dụng | ✓ | ✓ | ✓ |
| Đặt trước / hủy đặt trước | riêng | thay mặt người đọc | thay mặt người đọc |
| Gia hạn mượn | riêng | thay mặt người đọc | thay mặt người đọc |
| Xem phiếu đang mượn, lịch sử, phạt | riêng | tất cả người đọc | tất cả người đọc |
| Sửa hồ sơ, đổi mật khẩu | riêng | riêng | riêng |
| Tạo phiếu mượn / phiếu trả |  | ✓ | ✓ |
| Quét QR sách và thẻ người đọc |  | ✓ | ✓ |
| Báo cáo hư hỏng (chụp ảnh) |  | ✓ | ✓ |
| Ghi nhận mất sách, thu phạt |  | ✓ | ✓ |
| Cập nhật thông tin người đọc, khóa tạm |  | ✓ | ✓ |
| Điểm danh |  | riêng | ✓ (xem tất cả) |
| CRUD tài khoản người đọc |  |  | ✓ |
| CRUD tài khoản nhân viên |  |  | ✓ |
| CRUD đầu sách, bản sao, danh mục |  |  | ✓ |
| Duyệt báo cáo hư hỏng, thanh lý |  |  | ✓ |
| Cấu hình quy định mượn, phạt |  |  | ✓ |
| Xem nhật ký hoạt động, xuất báo cáo |  |  | ✓ |

## 3. Yêu cầu chức năng

Độ ưu tiên: **P1** = bắt buộc cho MVP, **P2** = nên có, **P3** = làm nếu còn thời gian. Các mục đánh dấu (bổ sung) là phần còn thiếu so với mô tả ban đầu.

### 3.1 Chung (mọi vai trò)

| Mã | Chức năng | Mô tả | Ưu tiên |
| --- | --- | --- | --- |
| FR-C01 | Đăng nhập / đăng xuất (bổ sung) | Đăng nhập bằng email/mã thẻ + mật khẩu; phân quyền theo vai trò. | P1 |
| FR-C02 | Quên / đổi mật khẩu (bổ sung) | Đặt lại qua email hoặc OTP. | P1 |
| FR-C03 | Hồ sơ cá nhân | Xem và sửa thông tin của chính mình. | P1 |
| FR-C04 | Thông báo trong ứng dụng (bổ sung) | Danh sách thông báo, đánh dấu đã đọc. | P2 |

### 3.2 Người đọc

| Mã | Chức năng | Mô tả | Ưu tiên |
| --- | --- | --- | --- |
| FR-R01 | Đăng ký tài khoản (bổ sung) | Tự đăng ký hoặc do thủ thư cấp (OQ-03). | P1 |
| FR-R02 | Tra cứu sách | Tìm theo tên, tác giả, ISBN, thể loại; lọc theo còn/hết; xem số lượng khả dụng và vị trí kệ. | P1 |
| FR-R03 | Thẻ thư viện QR (bổ sung) | Hiển thị mã QR cá nhân để nhân viên quét khi mượn/trả. | P1 |
| FR-R04 | Sách đang mượn (bổ sung) | Danh sách phiếu đang mở, hạn trả, số ngày còn lại / quá hạn. | P1 |
| FR-R05 | Lịch sử mượn | Các phiếu đã đóng, lọc theo thời gian. | P1 |
| FR-R06 | Gia hạn online (bổ sung) | Gia hạn nếu thỏa BR-04. | P2 |
| FR-R07 | Đặt trước sách | Đặt khi đầu sách hết bản khả dụng; xem vị trí trong hàng chờ. | P2 |
| FR-R08 | Hủy / theo dõi đặt trước (bổ sung) | Xem trạng thái: đang chờ, sẵn sàng, hết hạn, đã hủy. | P2 |
| FR-R09 | Xem phạt / công nợ (bổ sung) | Khoản phạt quá hạn, hư hỏng, mất sách; trạng thái đã/chưa thanh toán. | P2 |

Ghi chú: "Xử lý trùng mượn sách" trong mô tả gốc được chuyển thành quy tắc hệ thống BR-02, không phải thao tác của người đọc.

### 3.3 Nhân viên

| Mã | Chức năng | Mô tả | Ưu tiên |
| --- | --- | --- | --- |
| FR-S01 | Quét QR sách | Hiển thị đầu sách, trạng thái của bản sao đó, vị trí kệ, số lượng khả dụng của đầu sách. | P1 |
| FR-S02 | Quét QR thẻ người đọc (bổ sung) | Hiển thị thông tin, số sách đang mượn, phạt chưa trả, trạng thái khóa. | P1 |
| FR-S03 | Tạo phiếu mượn | Quét thẻ + quét một hoặc nhiều sách (hoặc chọn thủ công) → kiểm tra BR-01..03 → xác nhận. | P1 |
| FR-S04 | Nhận trả sách (bổ sung) | Quét sách → ghi tình trạng → tính phạt (nếu có) → đóng phiếu → cấp cho đặt trước (nếu có). | P1 |
| FR-S05 | Báo cáo hư hỏng | Chụp ảnh (1–5 ảnh), chọn mức độ, ghi chú; bản sao chuyển sang Chờ duyệt. | P1 |
| FR-S06 | Gia hạn tại quầy (bổ sung) | Gia hạn thay người đọc theo BR-04. | P2 |
| FR-S07 | Ghi nhận mất sách (bổ sung) | Đóng phiếu với kết quả Mất, tạo khoản bồi thường. | P2 |
| FR-S08 | Thu phạt (bổ sung) | Ghi nhận đã thu tiền mặt, in/xuất biên nhận. | P2 |
| FR-S09 | Danh sách quá hạn (bổ sung) | Lọc phiếu quá hạn để nhắc nhở. | P2 |
| FR-S10 | Quản lý người đọc (giới hạn) | Xem, sửa thông tin, khóa tạm; không được xóa. | P2 |
| FR-S11 | Điểm danh | Phạm vi chưa rõ (OQ-02). | P3 |

### 3.4 Thủ thư

| Mã | Chức năng | Mô tả | Ưu tiên |
| --- | --- | --- | --- |
| FR-L01 | Toàn bộ quyền Nhân viên | Kế thừa FR-S01..S11. | P1 |
| FR-L02 | CRUD đầu sách | Tạo/sửa/ẩn đầu sách; ảnh bìa; mô tả. | P1 |
| FR-L03 | Nhập bản sao + in QR (bổ sung) | Nhập N bản cho một đầu sách, sinh mã QR hàng loạt, xuất file in nhãn. | P1 |
| FR-L04 | Danh mục (bổ sung) | CRUD thể loại, tác giả, NXB, vị trí kệ. | P1 |
| FR-L05 | CRUD tài khoản người đọc | Xóa mềm; chặn xóa khi còn phiếu mở hoặc nợ phạt. | P1 |
| FR-L06 | CRUD tài khoản nhân viên | Tạo, khóa, đặt lại mật khẩu; xóa mềm. | P1 |
| FR-L07 | Cấu hình quy định (bổ sung) | Sửa các tham số ở mục 4 mà không cần sửa code. | P1 |
| FR-L08 | Duyệt hư hỏng, thanh lý (bổ sung) | Duyệt báo cáo của nhân viên → Sửa chữa / Thanh lý / Bác bỏ. | P2 |
| FR-L09 | Báo cáo & xuất file | Xem mục 9; xuất Excel/PDF. | P2 |
| FR-L10 | Nhật ký hoạt động (bổ sung) | Ai làm gì, lúc nào, trên bản ghi nào; chỉ đọc. | P2 |

## 4. Quy tắc nghiệp vụ

Mọi con số dưới đây là **giá trị đề xuất**, lưu trong bảng cấu hình để thủ thư sửa được (FR-L07); giá trị thật cần chốt ở OQ-04.

| Mã | Quy tắc | Giá trị đề xuất |
| --- | --- | --- |
| BR-01 | Số sách tối đa một người đọc được mượn cùng lúc | 5 cuốn |
| BR-02 | Chống trùng mượn: không mượn 2 bản sao của cùng một đầu sách khi phiếu trước chưa trả | Luôn áp dụng |
| BR-03 | Chặn mượn khi: tài khoản bị khóa, có sách quá hạn, hoặc nợ phạt vượt ngưỡng | Ngưỡng nợ: 50.000 đ |
| BR-04 | Thời hạn mượn; gia hạn tối đa N lần; không gia hạn nếu đang quá hạn hoặc có người đặt trước đầu sách đó | 14 ngày; gia hạn 1 lần, +7 ngày |
| BR-05 | Phạt quá hạn tính theo ngày, có trần | 2.000 đ/ngày/cuốn, tối đa bằng giá sách |
| BR-06 | Bồi thường mất sách | 100% giá sách + phí xử lý |
| BR-07 | Bồi thường hư hỏng theo mức độ | Nhẹ 0%, Vừa 30%, Nặng 100% giá sách |
| BR-08 | Đặt trước chỉ cho đầu sách đang hết bản khả dụng; tối đa số đặt trước đang mở mỗi người | 3 đặt trước |
| BR-09 | Hàng chờ đặt trước theo thứ tự thời gian (FIFO) | Luôn áp dụng |
| BR-10 | Thời gian giữ sách cho người đặt sau khi có sách; quá hạn thì chuyển cho người kế tiếp | 48 giờ |
| BR-11 | Số lượng khả dụng = số bản sao ở trạng thái Sẵn sàng (tính từ trạng thái, không lưu cộng/trừ thủ công) | Luôn áp dụng |
| BR-12 | Xóa mềm: người đọc, nhân viên, đầu sách, bản sao đã có lịch sử chỉ được vô hiệu hóa | Luôn áp dụng |
| BR-13 | Hai thao tác cùng lúc trên một bản sao: chỉ thao tác ghi trước thành công, thao tác sau nhận lỗi "Sách vừa được cập nhật" | Khóa lạc quan (version) |

## 5. Vòng đời trạng thái

Trạng thái của bản sao là nguồn duy nhất để tính số lượng khả dụng (BR-11); mọi chuyển trạng thái ngoài sơ đồ dưới đây đều bị API từ chối.

&#91;embedded content: vòng đời bản sao · 7 trạng thái\]

Khi một bản sao Đang sửa quay về mà đầu sách đó có hàng chờ đặt trước, hệ thống chuyển thẳng sang Đang giữ thay vì Sẵn sàng.

**Phiếu mượn (Loan):** Đang mượn (ACTIVE) → Quá hạn (OVERDUE, do tác vụ nền) → Đã trả (RETURNED) hoặc Mất (LOST). Phiếu Đang mượn cũng có thể đi thẳng sang Đã trả hoặc Mất.

**Đặt trước (Reservation):** Đang chờ (WAITING) → Sẵn sàng lấy (READY) → Đã nhận (FULFILLED) hoặc Hết hạn (EXPIRED). Ở WAITING hoặc READY, người đọc có thể chuyển sang Đã hủy (CANCELLED).

## 6. Luồng nghiệp vụ chính

Bốn luồng dưới đây bao trọn vòng đời một lần mượn; mọi bước ghi dữ liệu chạy trong một transaction (NFR-03).

### 6.1 Mượn sách tại quầy

1. Nhân viên quét QR thẻ người đọc.
   - Hệ thống kiểm tra BR-03 (khóa, quá hạn, nợ phạt). Không đạt → hiển thị lý do, dừng.
2. Nhân viên quét QR từng cuốn (hoặc tìm và chọn thủ công khi QR hỏng).
   - Mỗi cuốn phải ở trạng thái Sẵn sàng, hoặc Đang giữ cho chính người đọc này.
   - Kiểm tra BR-01 (tổng số cuốn) và BR-02 (trùng đầu sách) ngay khi quét, không đợi đến lúc xác nhận.
3. Màn hình hiển thị danh sách sách và hạn trả dự kiến; nhân viên bấm Xác nhận.
4. Hệ thống tạo Loan cho từng cuốn, chuyển bản sao sang Đang mượn, đóng đặt trước liên quan (nếu có), gửi thông báo.

### 6.2 Trả sách

&#91;embedded content: luồng trả sách · 3 bước, 2 quyết định\]

Phiếu luôn được đóng và tính phạt quá hạn trước, sau đó mới quyết định trạng thái mới của bản sao.

### 6.3 Đặt trước

1. Người đọc bấm Đặt trước trên đầu sách đang có số lượng khả dụng = 0 (BR-08).
2. Hệ thống thêm vào cuối hàng chờ (BR-09), hiển thị vị trí.
3. Khi có bản sao được trả hoặc sửa xong: gán cho người đầu hàng chờ, bản sao → Đang giữ, đặt trước → READY, gửi thông báo.
4. Người đọc đến quầy trong 48 giờ → đi theo luồng 6.1. Quá 48 giờ → EXPIRED, bản sao chuyển cho người kế tiếp hoặc về Sẵn sàng.

### 6.4 Báo cáo hư hỏng

1. Nhân viên quét QR bản sao, chụp 1–5 ảnh, chọn mức độ (Nhẹ / Vừa / Nặng), ghi chú.
2. Bản sao → Chờ duyệt (không cho mượn, theo mặc định của OQ-11); thủ thư nhận thông báo.
3. Thủ thư duyệt: Bác bỏ → Sẵn sàng; Sửa → Đang sửa; Thanh lý → Đã thanh lý.
4. Nếu hư hỏng phát hiện lúc trả sách, hệ thống tạo khoản phạt theo BR-07 gắn với phiếu mượn đó.

## 7. Mô hình dữ liệu

Thay đổi quan trọng nhất so với mô tả gốc là tách **Đầu sách** và **Bản sao**: QR gắn với bản sao, nên tình trạng và lịch sử được theo dõi cho từng cuốn.

| Thực thể | Thuộc tính chính | Quan hệ |
| --- | --- | --- |
| User | id, email, password\_hash, role (READER / STAFF / LIBRARIAN), full\_name, phone, status (ACTIVE / LOCKED / DELETED), created\_at | 1 User – 0..1 ReaderProfile |
| ReaderProfile | user\_id, card\_code (QR), dob, address, expiry\_date | 1 Reader – n Loan, n Reservation, n Fine |
| Title (Đầu sách) | id, isbn, name, publisher\_id, year, price, cover\_url, description, is\_active | n–n Author, n–n Category; 1 Title – n Copy |
| Copy (Bản sao) | id, title\_id, qr\_code, shelf\_id, condition (NEW / GOOD / WORN / DAMAGED), status (xem mục 5), version, acquired\_at | 1 Copy – n Loan, n DamageReport |
| Author / Category / Publisher / Shelf | id, name (+ vị trí với Shelf) | Danh mục phụ trợ |
| Loan (Phiếu mượn) | id, reader\_id, copy\_id, borrowed\_at, due\_at, returned\_at, renew\_count, status, created\_by, closed\_by, return\_condition | 1 Loan – 0..n Fine |
| Reservation | id, reader\_id, title\_id, created\_at, status, held\_copy\_id, hold\_expires\_at | Giữ 0..1 Copy khi sẵn sàng |
| Fine (Khoản phạt) | id, reader\_id, loan\_id, type (OVERDUE / DAMAGE / LOST), amount, status (UNPAID / PAID / WAIVED), paid\_at, collected\_by |  |
| DamageReport | id, copy\_id, reported\_by, severity, note, photo\_urls\[\], status (PENDING / REPAIR / DISPOSE / REJECTED), reviewed\_by, reviewed\_at |  |
| Setting | key, value, updated\_by, updated\_at | Lưu các tham số BR-01..BR-10 |
| Notification | id, user\_id, type, content, is\_read, sent\_at, channel |  |
| AuditLog | id, actor\_id, action, entity, entity\_id, before, after, at |  |
| Attendance (nếu làm) | id, user\_id, check\_in, check\_out | Phụ thuộc OQ-02 |

Một phiếu mượn ứng với **một bản sao**. Khi mượn nhiều cuốn cùng lúc, hệ thống tạo nhiều Loan trong một giao dịch; có cần thêm bảng "phiếu" cha để in gộp hay không là OQ-06.

## 8. Thông báo & tác vụ tự động

Kênh mặc định là thông báo trong ứng dụng; email/push là OQ-07.

| Sự kiện | Người nhận | Thời điểm |
| --- | --- | --- |
| Phiếu mượn được tạo | Người đọc | Ngay lập tức, kèm hạn trả |
| Sắp đến hạn trả | Người đọc | 2 ngày trước hạn |
| Quá hạn | Người đọc | Ngày đầu quá hạn, sau đó mỗi 3 ngày |
| Sách đặt trước đã sẵn sàng | Người đọc | Ngay khi gán bản sao, kèm hạn lấy (BR-10) |
| Đặt trước hết hạn giữ | Người đọc | Khi hết 48 giờ |
| Phát sinh khoản phạt | Người đọc | Khi đóng phiếu |
| Có báo cáo hư hỏng mới | Thủ thư | Ngay lập tức |
| Tài khoản bị khóa / mở khóa | Người bị ảnh hưởng | Ngay lập tức |

**Tác vụ nền (cron)**

| Tác vụ | Tần suất | Việc làm |
| --- | --- | --- |
| Quét quá hạn | Hằng ngày 00:05 | Chuyển phiếu sang Quá hạn, cập nhật số tiền phạt tạm tính, gửi nhắc |
| Nhắc sắp đến hạn | Hằng ngày 08:00 | Gửi thông báo cho phiếu có hạn trong 2 ngày tới |
| Hết hạn giữ đặt trước | Mỗi 15 phút | Hủy giữ, chuyển bản sao cho người kế tiếp hoặc về Sẵn sàng |
| Hết hạn thẻ | Hằng ngày | Khóa mượn với thẻ đã hết hạn (nếu áp dụng OQ-05) |

## 9. Báo cáo & thống kê

Tất cả báo cáo lọc được theo khoảng thời gian và xuất được Excel/PDF; chỉ Thủ thư truy cập.

| Mã | Báo cáo | Nội dung | Ưu tiên |
| --- | --- | --- | --- |
| RP-01 | Tổng quan tài khoản | Số người đọc / nhân viên theo trạng thái, người đọc mới theo tháng | P1 |
| RP-02 | Tình trạng kho sách | Số bản sao theo trạng thái và tình trạng (mới, cũ, hư, mất, thanh lý) | P1 |
| RP-03 | Mượn – trả theo thời gian (bổ sung) | Số lượt mượn/trả theo ngày, tháng, năm | P2 |
| RP-04 | Quá hạn (bổ sung) | Danh sách phiếu quá hạn, số ngày, người đọc | P1 |
| RP-05 | Phạt (bổ sung) | Tổng phạt phát sinh, đã thu, chưa thu, miễn | P2 |
| RP-06 | Sách được quan tâm (bổ sung) | Top sách mượn nhiều, sách có hàng chờ đặt trước dài, sách không ai mượn trong 12 tháng | P2 |
| RP-07 | Hư hỏng & thanh lý (bổ sung) | Báo cáo hư hỏng theo trạng thái duyệt, số sách thanh lý trong kỳ | P2 |
| RP-08 | Hoạt động nhân viên (bổ sung) | Số phiếu xử lý theo nhân viên; giờ làm nếu có điểm danh | P3 |

## 10. Yêu cầu phi chức năng

| Mã | Nhóm | Yêu cầu |
| --- | --- | --- |
| NFR-01 | Hiệu năng | Quét QR → hiển thị thông tin dưới 1 giây; tra cứu sách dưới 2 giây với 50.000 bản sao |
| NFR-02 | Bảo mật | Mật khẩu băm bcrypt; JWT có hạn; kiểm tra quyền ở server cho mọi API, không chỉ ẩn nút ở giao diện |
| NFR-03 | Toàn vẹn dữ liệu | Mượn/trả chạy trong transaction; khóa lạc quan trên Copy (BR-13) |
| NFR-04 | Truy vết | Mọi thao tác tạo/sửa/xóa ghi vào AuditLog |
| NFR-05 | Lưu trữ ảnh | Ảnh hư hỏng nén còn ≤ 500 KB, lưu object storage, chỉ lưu URL trong DB |
| NFR-06 | Khả dụng | Quét QR hoạt động trên camera điện thoại Android/iOS phổ biến; có nút nhập mã thủ công khi QR mờ |
| NFR-07 | Sao lưu | Backup cơ sở dữ liệu hằng ngày, giữ 30 bản |
| NFR-08 | Ngôn ngữ & định dạng | Giao diện tiếng Việt; tiền VND; ngày dd/mm/yyyy; múi giờ UTC+7 |

## 11. Open Questions

Có 15 câu hỏi cần chốt; OQ-04, OQ-06, OQ-09, OQ-10 ảnh hưởng trực tiếp đến thiết kế cơ sở dữ liệu nên cần trả lời trước khi code. Cột "Mặc định nếu chưa chốt" là giả định đang dùng trong tài liệu này.

| Mã | Câu hỏi | Vì sao quan trọng | Mặc định nếu chưa chốt |
| --- | --- | --- | --- |
| OQ-01 | Ai quản lý tài khoản Thủ thư? Có cần vai trò Admin riêng? | Tránh thủ thư tự nâng quyền hoặc xóa lẫn nhau | Tài khoản Thủ thư đầu tiên tạo bằng seed; thủ thư không sửa vai trò của nhau |
| OQ-02 | "Điểm danh" là chấm công nhân viên hay ghi nhận người đọc vào thư viện? | Hai nghiệp vụ, hai bảng dữ liệu khác nhau | Chấm công nhân viên, để P3 |
| OQ-03 | Người đọc tự đăng ký online hay phải đến quầy để cấp thẻ? | Quyết định có cần luồng xác minh danh tính | Tự đăng ký, nhưng chỉ được mượn sau khi nhân viên kích hoạt tại quầy |
| OQ-04 | Giá trị thật của BR-01..BR-10 (số sách tối đa, hạn mượn, mức phạt...)? Có khác nhau theo loại người đọc (sinh viên, giảng viên)? | Nếu khác theo loại thì cần bảng ReaderType | Một bộ quy định chung, giá trị như mục 4 |
| OQ-05 | Thẻ người đọc có thời hạn không? Có thu phí làm thẻ? | Ảnh hưởng BR-03 và tác vụ nền | Có hạn 1 năm, không thu phí |
| OQ-06 | Có cần "phiếu" cha gom nhiều cuốn mượn cùng lúc để in biên nhận? | Thay đổi cấu trúc bảng Loan | Không; mỗi cuốn một Loan, in gộp theo thời điểm tạo |
| OQ-07 | Kênh thông báo: chỉ trong app, hay thêm email / push / SMS / Zalo? | Chi phí và độ phức tạp tích hợp | Trong app + email |
| OQ-08 | Phạt thu tiền mặt tại quầy hay có thanh toán online (VNPay, MoMo, chuyển khoản QR)? | Tích hợp cổng thanh toán là việc lớn | Tiền mặt tại quầy |
| OQ-09 | Thư viện có nhiều chi nhánh/cơ sở không? Mượn ở A trả ở B được không? | Cần thêm bảng Branch và luồng luân chuyển | Một cơ sở |
| OQ-10 | Có loại sách chỉ đọc tại chỗ, không cho mượn về (sách tham khảo, tạp chí)? | Cần cờ is\_loanable trên Title/Copy | Có, thêm cờ is\_loanable |
| OQ-11 | Báo cáo hư hỏng có chặn mượn ngay, hay đợi thủ thư duyệt? | Quyết định trạng thái của bản sao | Chặn ngay (Chờ duyệt), thủ thư duyệt sau |
| OQ-12 | Ai được xem lịch sử mượn của người đọc? Có tự xóa lịch sử sau N năm? | Quyền riêng tư (Nghị định 13/2023 về dữ liệu cá nhân) | Nhân viên và thủ thư xem được; không tự xóa |
| OQ-13 | Mất mạng tại quầy thì xử lý mượn/trả thế nào? | Chế độ offline làm tăng đáng kể độ phức tạp | Không hỗ trợ offline |
| OQ-14 | Nền tảng: app di động, web, hay cả hai? Nhân viên quét bằng điện thoại hay máy quét cầm tay? | Ảnh hưởng lựa chọn công nghệ (React Native/Flutter vs web) | Web responsive + camera điện thoại |
| OQ-15 | Có dữ liệu sách cũ cần nhập vào (Excel)? Sách hiện có đã dán mã nào chưa? | Cần chức năng import và kế hoạch dán nhãn QR | Có import Excel cho đầu sách và bản sao |

## 12. Ưu tiên triển khai

Triển khai theo 3 giai đoạn; giai đoạn 1 đủ để chạy trọn vòng mượn – trả tại quầy.

**Giai đoạn 1 – MVP (P1):** đăng nhập/phân quyền, CRUD đầu sách + bản sao + in QR, danh mục, tra cứu, thẻ QR người đọc, tạo phiếu mượn, nhận trả, báo cáo hư hỏng, cấu hình quy định, báo cáo RP-01, RP-02, RP-04.

- [ ] **Giai đoạn 2 (P2):** đặt trước + hàng chờ, gia hạn, phạt và thu phạt, mất sách, duyệt hư hỏng/thanh lý, thông báo + tác vụ nền, nhật ký hoạt động, báo cáo RP-03, RP-05..RP-07.
- [ ] **Giai đoạn 3 (P3):** điểm danh, báo cáo RP-08, các mục mở rộng từ Open Questions (thanh toán online, nhiều chi nhánh, offline).
