---
type: brainstorm
feature: access-control
status: draft
updated: 2026-10-12
links:
  - docs/_product/prd.md
  - docs/_shared/core-spec.md
  - docs/_shared/navigation-map.md
  - docs/_shared/id-crosswalk-lmp.md
---

# Đăng nhập và phân quyền

## 1. Idea Seed

Mọi vai trò đăng nhập, đặt lại mật khẩu, quản lý hồ sơ của mình và chỉ thấy chức năng, dữ liệu đúng vai trò; tác vụ nhạy cảm phải xác thực lại, hết phiên thì quay về trạng thái an toàn.

## 2. Context

- Đây là điều kiện đầu tiên của mọi feature khác: chưa có danh tính và phân quyền thì chưa đưa dữ liệu thật vào hệ thống.
- Hệ thống có 3 vai trò: Người đọc, Nhân viên (trực quầy), Thủ thư (quản trị dữ liệu, cấu hình, báo cáo, nhật ký). Mọi kiểm tra quyền làm ở phía hệ thống, không chỉ ẩn nút trên giao diện.
- Mô hình danh tính (tài khoản nội bộ, SSO hay dịch vụ danh tính ngoài) chưa chốt; nội dung dưới đây viết theo tài khoản nội bộ.

## 3. User Types (preliminary)

| User Type | Pain Point | Primary Need |
|-----------|-----------|--------------|
| Người đọc | Không tự xem được tình trạng mượn của mình | Đăng nhập an toàn vào cổng người đọc |
| Nhân viên | Mất dữ liệu đang nhập khi hết phiên giữa giao dịch | Vào thẳng màn quầy, hết phiên không mất việc đã lưu |
| Thủ thư | Không kiểm soát được ai xem dữ liệu cá nhân, tài chính | Quyền tối thiểu theo vai trò, mọi lần bị từ chối có dấu vết |

## 4. Capabilities Breakdown

### P0 — must have

- Đăng nhập, đăng xuất bằng email hoặc mã thẻ và mật khẩu.
- Quên mật khẩu và đặt lại mật khẩu.
- Xem và sửa hồ sơ cá nhân của chính mình.
- Phân quyền theo 3 vai trò, từ chối mặc định; kiểm tra quyền trên từng thao tác và từng trường dữ liệu nhạy cảm.
- Che dữ liệu cá nhân và tài chính khi người xem không có quyền.
- Xác thực lại trước tác vụ nhạy cảm (miễn/điều chỉnh tiền phạt, thanh lý, override import).
- Hết phiên thì chuyển màn xác thực lại; việc đã lưu giữ nguyên, việc chưa xác nhận không được ghi.
- Quyền và trạng thái tài khoản được kiểm lại ở mỗi thao tác, không dựa vào lúc đăng nhập.
- Khóa tạm tài khoản khi đăng nhập sai liên tiếp quá ngưỡng.
- Dashboard theo vai trò làm điểm vào sau đăng nhập.

### P1 — should have

- Không có.

### P2 — nice to have

- Đăng nhập qua SSO hoặc dịch vụ danh tính ngoài (chờ quyết định mô hình danh tính).

## 5. Core Flows (Happy Path)

### 5.1 Đăng nhập

1) Người dùng mở màn đăng nhập, nhập email hoặc mã thẻ và mật khẩu.
2) Hệ thống xác thực, tạo phiên gắn vai trò và phạm vi dữ liệu.
3) Hệ thống mở dashboard, chỉ hiện chức năng người dùng có quyền.

```
Nhập email/mã thẻ + mật khẩu ──> Xác thực đúng? ──không──> Thông báo chung, tăng đếm sai ──> Quá ngưỡng? ──có──> Khóa tạm
                                       │ có                                                     │ không
                                       ▼                                                        ▼
                         Tài khoản đang hoạt động? ──không──> Thông báo chung              Cho nhập lại
                                       │ có
                                       ▼
                         Tạo phiên theo vai trò ──> Dashboard theo vai trò
```

### 5.2 Quên và đặt lại mật khẩu

1) Người dùng chọn "Quên mật khẩu", nhập email.
2) Hệ thống gửi hướng dẫn đặt lại nếu email thuộc một tài khoản; thông báo hiển thị như nhau dù email có tồn tại hay không.
3) Người dùng đặt mật khẩu mới, quay về màn đăng nhập.

### 5.3 Tác vụ nhạy cảm và hết phiên

1) Người dùng chọn tác vụ nhạy cảm; hệ thống yêu cầu xác thực lại.
2) Xác thực thành công thì tiếp tục đúng tác vụ đang làm; thất bại hoặc hủy thì tác vụ không thực hiện.
3) Phiên hết hạn giữa chừng thì chuyển màn xác thực lại; xác thực xong quay về màn an toàn, dữ liệu đã lưu giữ nguyên.

## 6. System Behavior Deep Dive

### 6.1 Decision Points

| ID | Flow | Khi nào | YES (nhánh đồng ý) | NO (nhánh từ chối) |
|---|---|---|---|---|
| D1 | Đăng nhập | Thông tin đăng nhập đúng? | Kiểm tra trạng thái tài khoản | Thông báo chung, tăng bộ đếm sai |
| D2 | Đăng nhập | Số lần sai liên tiếp vượt ngưỡng? | Khóa tạm, từ chối mọi lần thử trong thời gian khóa | Cho nhập lại |
| D3 | Đăng nhập | Tài khoản đang hoạt động? | Tạo phiên | Thông báo chung, không tiết lộ lý do |
| D4 | Mọi thao tác | Vai trò có quyền với thao tác này? | Thực hiện | Từ chối, ghi audit, quay về màn an toàn |
| D5 | Hiển thị dữ liệu | Người xem có quyền với trường nhạy cảm? | Hiện dữ liệu | Che trường, ghi audit |
| D6 | Tác vụ nhạy cảm | Xác thực lại thành công? | Tiếp tục tác vụ | Hủy tác vụ, giữ phiên hiện tại |

### 6.2 Scenario Matrix

| From State | To State | Rule | Action | Result |
|------------|----------|------|--------|--------|
| Người đọc | Chức năng quầy hoặc quản trị | Không có quyền | Gọi chức năng | Từ chối, ghi audit |
| Nhân viên | Chức năng quản trị của Thủ thư | Không có quyền | Gọi chức năng | Từ chối, ghi audit |
| Nhân viên | Dữ liệu cá nhân ngoài phạm vi phục vụ quầy | Thiếu quyền trường | Xem hồ sơ | Trường bị che |
| Thủ thư | Mọi chức năng quản trị | Có quyền | Gọi chức năng | Thực hiện |
| Tài khoản vừa bị khóa khi phiên đang mở | — | Kiểm lại quyền ở thao tác kế tiếp | Thao tác bất kỳ | Từ chối ngay, buộc đăng nhập lại |

### 6.3 State Transitions

| Entity | Từ | Sang | Trigger | Quay lại được? |
|--------|------|----|---------|-------------|
| Phiên | Đang hoạt động | Hết hạn | Hết thời gian phiên hoặc tài khoản bị khóa/thu hồi quyền | Có, đăng nhập lại |
| Tài khoản | Đang hoạt động | Khóa tạm | Đăng nhập sai liên tiếp quá ngưỡng | Có, hết thời gian khóa hoặc Thủ thư mở |

### 6.4 Interrupted Transactions

| Tình huống | Hệ thống còn lại gì | Resume | Cleanup |
|---|---|---|---|
| Phiên hết hạn khi đang nhập form | Dữ liệu đã lưu trước đó | Xác thực lại, quay về màn an toàn; dữ liệu nhập dở khôi phục nếu còn trên máy | Không ghi phần chưa xác nhận |
| Hủy hoặc thất bại khi xác thực lại | Phiên hiện tại | Quay về trạng thái trước tác vụ | Không có |
| Link đặt lại mật khẩu đã dùng hoặc hết hạn | Mật khẩu cũ | Yêu cầu link mới | Không có |

### 6.5 Other Edge Cases

- Đăng nhập sai không tiết lộ tài khoản có tồn tại hay không.
- Quét QR thẻ hay QR sách chỉ dùng để tìm bản ghi, không thay cho đăng nhập hay kiểm tra quyền.
- Quyền mới được cấp có hiệu lực ngay ở thao tác kế tiếp.

## 7. Validation, Limits & Wording

### 7.1 Validation rules

| Field | Rule |
|---|---|
| Email hoặc mã thẻ | Bắt buộc |
| Mật khẩu | Bắt buộc; quy tắc độ dài và ký tự chưa chốt |
| Mật khẩu mới | Nhập lại phải khớp |

### 7.2 Limits & Quotas (exact values)

| Tham số | Giá trị | Window | Behavior khi vượt |
|---|---|---|---|
| Số lần đăng nhập sai trước khi khóa tạm | TBD | Liên tiếp trên một tài khoản | Khóa tạm |
| Thời gian khóa tạm | TBD | Từ lần sai cuối | Từ chối mọi lần thử |
| Thời lượng phiên | TBD | Từ thao tác cuối | Chuyển màn xác thực lại |
| Hiệu lực link đặt lại mật khẩu | TBD | Từ lúc gửi | Phải yêu cầu link mới |

### 7.3 Wording samples (exact strings)

#### Error messages

| Tình huống | Wording | Code |
|---|---|---|
| Đăng nhập sai hoặc tài khoản không dùng được | "Thông tin đăng nhập không đúng hoặc tài khoản chưa thể sử dụng." (đề xuất) | E-core-002 |
| Không có quyền | "Bạn không có quyền thực hiện thao tác này." (đề xuất) | E-core-002 |
| Hết phiên | "Phiên làm việc đã hết hạn. Vui lòng đăng nhập lại." (đề xuất) | E-access-control-001 |

#### Success messages

| Tình huống | Wording |
|---|---|
| Đặt lại mật khẩu thành công | "Đã đặt lại mật khẩu. Vui lòng đăng nhập bằng mật khẩu mới." (đề xuất) |

#### Info / neutral messages

| Tình huống | Wording |
|---|---|
| Đã gửi yêu cầu quên mật khẩu | "Nếu email thuộc một tài khoản, hướng dẫn đặt lại mật khẩu đã được gửi." (đề xuất) |
| Tác vụ nhạy cảm | "Vui lòng xác thực lại để tiếp tục." (đề xuất) |

## 8. Assumptions

- Dùng tài khoản nội bộ (email hoặc mã thẻ + mật khẩu) cho tới khi chốt mô hình danh tính.
- Thủ thư đầu tiên được tạo sẵn khi triển khai; Thủ thư không sửa vai trò của nhau (mặc định OQ-01 nguồn).
- Mở khóa tạm do hết thời gian khóa hoặc Thủ thư mở thủ công.

## 9. Risks

| Rủi ro | Khả năng | Hậu quả nghiệp vụ | Cách phòng |
|--------|----------|-------------------|-----------|
| Compliance: quyền xem dữ liệu cá nhân chưa được pháp chế duyệt | thỉnh thoảng | Trì hoãn hoặc thu hẹp go-live | Chốt ma trận quyền trường trước GATE-GNG |
| Process: mô hình danh tính chốt muộn | thỉnh thoảng | Làm lại luồng đăng nhập, quên mật khẩu | Chốt ở GATE-DEC trước R0 |
| Adoption: khóa tạm làm kẹt quầy giờ cao điểm | hiếm | Quầy ngưng phục vụ | Thủ thư mở khóa được ngay |

## 10. Success Criteria (preliminary)

- 100% truy cập ngoài quyền bị từ chối và có audit.
- 0 trường hợp dữ liệu nhạy cảm hiển thị cho người không có quyền trong kiểm thử phân quyền.

## 11. Open Questions

- [ ] OQ-1: Mô hình danh tính: tài khoản nội bộ, SSO hay dịch vụ danh tính ngoài? (OQ-access-control-001; hold — security/IT)
- [ ] OQ-2: Ngưỡng đăng nhập sai, thời gian khóa tạm, thời lượng phiên, hiệu lực link đặt lại mật khẩu? (hold — security/IT)
- [ ] OQ-3: Quy tắc mật khẩu (độ dài, ký tự)? (hold — security/IT)
- [ ] OQ-4: Mở khóa tạm tự động theo thời gian hay chỉ Thủ thư mở? (hold)

## 12. Next Steps

- `/srs access-control`
