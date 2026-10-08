---
type: srs-userflow
feature: library-management-platform
updated: 2026-10-07
primary_device: mobile
stage: flow-approved
flow_approved_at: 2026-10-07
flow_hash: "c4d1b86d"
---

# Library Management Platform — User Flow

> Nguồn chia flow duy nhất cho wireframe và prototype của feature này. Bộ HTML wireframe dùng khung Mobile 375 theo quyết định ngày 2026-10-07. Phạm vi production của portal Người đọc R2 và màn reader R1B vẫn chờ OQ-LMP-015 và OQ-LMP-016.

## 1. User Flow (tổng)

> Phủ happy, error và edge case. `[n]` là số màn hình đối chiếu Mục 2. Reservation R2 là future/not in pilot.

### Flow: auth-flow — R0

```mermaid
flowchart TD
    n1["[1] Đăng nhập"]
    d1{"Thông tin hợp lệ<br/>và tài khoản hoạt động?"}
    n4["[4] Dashboard theo vai trò"]
    n2["[2] Quên mật khẩu<br/>PROPOSAL nếu local identity"]
    n3["[3] Đặt lại mật khẩu<br/>PROPOSAL nếu local identity"]
    n5["[5] Phiên hết hạn hoặc cần step-up"]
    e1["E-LMP-002<br/>banner hoặc redirect an toàn"]
    e2["Chuyển sang SSO hoặc IdP<br/>theo OQ-LMP-007"]

    n1 -->|"Đăng nhập local"| d1
    d1 -->|"Có"| n4
    d1 -->|"Không"| e1
    e1 -.->|"Thử lại"| n1
    n1 -->|"Quên mật khẩu"| n2
    n2 -->|"Danh tính local và yêu cầu hợp lệ"| n3
    n3 -->|"Đặt lại thành công"| n1
    n1 -->|"Dùng SSO hoặc IdP"| e2
    e2 -.->|"Provider trả về"| n4
    n4 -->|"Phiên hết hạn hoặc tác vụ nhạy cảm"| n5
    n5 -.->|"Xác thực lại thành công"| n4

    classDef happy fill:#d4edda,stroke:#28a745
    classDef error fill:#f8d7da,stroke:#dc3545
    classDef edge fill:#fff3cd,stroke:#ffc107
    class n1,n4 happy
    class e1 error
    class n2,n3,n5,e2 edge
```

### Flow: catalog-admin-flow — R0/R1A

```mermaid
flowchart TD
    n6["[6] Tra cứu danh mục"]
    n7["[7] Chi tiết đầu sách"]
    n8["[8] Biểu mẫu đầu sách"]
    n9["[9] Kho bản sao"]
    n10["[10] Biểu mẫu bản sao"]
    d2{"Hành động và dữ liệu hợp lệ?"}
    e3["E-LMP-001/002/003/005/015<br/>inline, banner hoặc modal conflict"]

    n6 -->|"Chọn kết quả"| n7
    n6 -->|"Tạo đầu sách"| n8
    n7 -->|"Sửa hoặc vô hiệu hóa"| n8
    n7 -->|"Xem bản sao"| n9
    n9 -->|"Tạo hoặc sửa bản sao"| n10
    n8 -->|"Lưu"| d2
    n10 -->|"Lưu"| d2
    d2 -->|"Có"| n7
    d2 -->|"Không"| e3
    e3 -.->|"Sửa hoặc tải lại"| n8

    classDef happy fill:#d4edda,stroke:#28a745
    classDef error fill:#f8d7da,stroke:#dc3545
    classDef edge fill:#fff3cd,stroke:#ffc107
    class n6,n7,n8,n9,n10 happy
    class e3 error
```

### Flow: reader-admin-flow — R0/R1B

```mermaid
flowchart TD
    n11["[11] Danh sách người đọc"]
    n12["[12] Biểu mẫu người đọc"]
    n13["[13] Chi tiết người đọc"]
    d3{"Dữ liệu và quyền hợp lệ?"}
    e4["E-LMP-001/002/003/005/015/016<br/>mask field hoặc feedback phù hợp"]

    n11 -->|"Chọn hồ sơ"| n13
    n11 -->|"Tạo hồ sơ"| n12
    n13 -->|"Sửa hồ sơ"| n12
    n13 -->|"Khóa hoặc mở khóa R1B"| d3
    n12 -->|"Lưu"| d3
    d3 -->|"Có"| n13
    d3 -->|"Không"| e4
    e4 -.->|"Sửa hoặc quay lại an toàn"| n13

    classDef happy fill:#d4edda,stroke:#28a745
    classDef error fill:#f8d7da,stroke:#dc3545
    classDef edge fill:#fff3cd,stroke:#ffc107
    class n11,n12,n13 happy
    class e4 error
```

### Flow: checkout-flow — R1A

```mermaid
flowchart TD
    n14["[14] Quầy lưu thông"]
    n15["[15] Quét người đọc và bản sao"]
    n16["[16] Rà soát mượn"]
    d4{"Đủ điều kiện và trạng thái còn mới?"}
    n17["[17] Xung đột checkout"]
    ok1["Commit nguyên tử<br/>và hiển thị biên nhận"]
    e5["E-LMP-003/004/007/015<br/>inline, giữ dữ liệu để sửa"]

    n14 -->|"Bắt đầu mượn"| n15
    n15 -->|"Đủ mã hợp lệ"| n16
    n15 -->|"Không tìm thấy hoặc quét trùng"| e5
    e5 -.->|"Nhập hoặc quét lại"| n15
    n16 -->|"Xác nhận commit"| d4
    d4 -->|"Có"| ok1
    d4 -->|"Concurrency conflict E-LMP-005"| n17
    d4 -->|"Không đủ điều kiện"| e5
    n17 -.->|"Tải trạng thái mới"| n16
    ok1 -.->|"Giao dịch mới"| n14

    classDef happy fill:#d4edda,stroke:#28a745
    classDef error fill:#f8d7da,stroke:#dc3545
    classDef edge fill:#fff3cd,stroke:#ffc107
    class n14,n15,n16,ok1 happy
    class e5 error
    class n17 edge
```

### Flow: return-renewal-flow — trả R1A, gia hạn R1B

```mermaid
flowchart TD
    n18["[18] Quét trả sách"]
    d5{"Kết quả kiểm tra bản sao?"}
    n19["[19] Kết quả trả"]
    n20["[20] Kết quả gia hạn R1B"]
    endFine["End: Tiếp tục tại fine-payment-flow"]
    endDamage["End: Tiếp tục tại damage-lost-found-flow"]
    e6["E-LMP-004/005/007/015<br/>feedback và recovery theo nguyên nhân"]

    n18 -->|"Quét bản sao"| d5
    d5 -->|"Trả bình thường"| n19
    d5 -->|"Quá hạn"| endFine
    d5 -->|"Hư hỏng hoặc mất"| endDamage
    d5 -->|"Trạng thái không hợp lệ"| e6
    e6 -.->|"Tải lại hoặc quét lại"| n18
    n19 -->|"Yêu cầu gia hạn R1B"| n20
    n20 -.->|"Gia hạn thành công hoặc bị chặn có lý do"| n19

    classDef happy fill:#d4edda,stroke:#28a745
    classDef error fill:#f8d7da,stroke:#dc3545
    classDef edge fill:#fff3cd,stroke:#ffc107
    class n18,n19,n20 happy
    class e6 error
    class endFine,endDamage edge
```

### Flow: reservation-flow — R2 future/not in pilot

```mermaid
flowchart TD
    n21["[21] Tìm tài liệu để đặt trước"]
    n22["[22] Biểu mẫu đặt trước"]
    n23["[23] Hàng đợi đặt trước"]
    n24["[24] Nhận bản giữ"]
    d6{"Reservation còn hợp lệ?"}
    empty1["Empty state<br/>chưa có hàng đợi"]
    e7["E-LMP-005/008/015<br/>inline hoặc modal conflict"]
    e8["E-LMP-012/018<br/>notify fail nhưng nghiệp vụ vẫn commit"]

    n21 -->|"Chọn tài liệu"| n22
    n22 -->|"Gửi yêu cầu"| d6
    d6 -->|"Có"| n23
    d6 -->|"Không"| e7
    e7 -.->|"Sửa hoặc tải lại"| n22
    n23 -->|"Đến lượt và hold còn hạn"| n24
    n23 -->|"Hủy"| empty1
    n24 -->|"Hủy hoặc hết hạn"| n23
    n24 -->|"Nhận sách"| n16
    n16 -->|"Checkout hoàn tất"| endReservation["End: Reservation đã pickup"]
    n23 -->|"Gửi thông báo thất bại"| e8
    e8 -.->|"Retry qua outbox"| n23
    empty1 -.->|"Tạo đặt trước mới"| n21

    classDef happy fill:#d4edda,stroke:#28a745
    classDef error fill:#f8d7da,stroke:#dc3545
    classDef edge fill:#fff3cd,stroke:#ffc107
    class n21,n22,n23,n24 happy
    class e7,e8 error
    class empty1 edge
```

### Flow: fine-payment-flow — R1A/R1B

```mermaid
flowchart TD
    n25["[25] Danh sách công nợ"]
    n26["[26] Chi tiết công nợ"]
    n27["[27] Thanh toán tiền mặt"]
    n28["[28] Sự kiện tài chính R1B"]
    d7{"Tác vụ tài chính hợp lệ?"}
    step1["Step-up re-auth<br/>cho waiver, adjustment, refund"]
    e9["E-LMP-005/006/009/010/013/015/016<br/>modal chặn cho lỗi critical"]

    n25 -->|"Chọn khoản nợ"| n26
    n26 -->|"Thu tiền mặt R1A"| n27
    n26 -->|"Xem ledger hoặc tác vụ R1B"| n28
    n27 -->|"Xác nhận"| d7
    n28 -->|"Waiver, adjustment hoặc refund"| step1
    step1 -->|"E-LMP-017 xác thực lại thành công"| d7
    d7 -->|"Có"| n28
    d7 -->|"Không hoặc audit fail"| e9
    e9 -.->|"Retry idempotent hoặc quay lại"| n26

    classDef happy fill:#d4edda,stroke:#28a745
    classDef error fill:#f8d7da,stroke:#dc3545
    classDef edge fill:#fff3cd,stroke:#ffc107
    class n25,n26,n27,n28 happy
    class e9 error
    class step1 edge
```

### Flow: damage-lost-found-flow — R1A/R1B

```mermaid
flowchart TD
    n29["[29] Biểu mẫu báo hư hỏng"]
    n30["[30] Chi tiết báo cáo hư hỏng"]
    n31["[31] Xử lý mất và tìm lại"]
    d8{"Disposition hợp lệ?"}
    step2["Step-up re-auth<br/>cho thanh lý"]
    e10["E-LMP-001/003/011/015<br/>inline và giữ dữ liệu an toàn"]
    endFinancialFollowup["End: Tiếp tục tại fine-payment-flow"]

    n29 -->|"Gửi báo cáo và ảnh"| d8
    d8 -->|"Có"| n30
    d8 -->|"Không"| e10
    e10 -.->|"Sửa dữ liệu hoặc file"| n29
    n30 -->|"Ghi nhận mất R1A"| n31
    n30 -->|"Quyết định tính phí"| endFinancialFollowup
    n30 -->|"Thanh lý theo DEC-D3-07"| step2
    step2 -->|"E-LMP-017 xác thực lại thành công"| n30
    n31 -->|"Tìm lại và đối soát R1B"| n30

    classDef happy fill:#d4edda,stroke:#28a745
    classDef error fill:#f8d7da,stroke:#dc3545
    classDef edge fill:#fff3cd,stroke:#ffc107
    class n29,n30,n31 happy
    class e10 error
    class step2,endFinancialFollowup edge
```

### Flow: notification-audit-flow — R0/R1A/R1B

```mermaid
flowchart TD
    n32["[32] Trạng thái thông báo R1B"]
    n33["[33] Nhật ký audit R1B"]
    n34["[34] Dòng thời gian lịch sử R1B"]
    d9{"Đọc dữ liệu nhạy cảm hợp lệ?"}
    e11["E-LMP-012/018<br/>retry hoặc dead-letter"]
    e12["E-LMP-013/016<br/>rollback action hoặc mask field"]

    n32 -->|"Xem delivery lỗi"| e11
    e11 -.->|"Retry hoặc xử lý dead-letter"| n32
    n33 -->|"Mở resource"| d9
    d9 -->|"Có quyền"| n34
    d9 -->|"Không có quyền hoặc audit fail"| e12
    e12 -.->|"Quay lại dữ liệu đã redacted"| n33
    n34 -.->|"Quay lại audit log"| n33

    classDef happy fill:#d4edda,stroke:#28a745
    classDef error fill:#f8d7da,stroke:#dc3545
    classDef edge fill:#fff3cd,stroke:#ffc107
    class n32,n33,n34 happy
    class e11,e12 error
```

### Flow: admin-import-flow — R0

```mermaid
flowchart TD
    n35["[35] Cấu hình quản trị"]
    n36["[36] Tải file import"]
    n37["[37] Báo cáo import và reconciliation"]
    d10{"Dry-run pass?"}
    step3["Step-up re-auth<br/>cho override theo OQ-LMP-018"]
    ok2["Commit toàn batch<br/>sinh QR và đối soát vật lý"]
    e13["E-LMP-001/002/005/006/014/016<br/>sửa file và chạy lại"]

    n35 -->|"Mở import"| n36
    n36 -->|"Upload và dry-run"| d10
    d10 -->|"Pass"| ok2
    d10 -->|"Không pass"| e13
    d10 -->|"Yêu cầu override"| step3
    step3 -->|"Được duyệt và xác thực lại"| ok2
    step3 -->|"Không được duyệt"| e13
    e13 -.->|"Sửa file hoặc tải lại"| n36
    ok2 -->|"Hoàn tất commit và đối soát"| n37
    n37 -.->|"Chạy batch mới"| n36

    classDef happy fill:#d4edda,stroke:#28a745
    classDef error fill:#f8d7da,stroke:#dc3545
    classDef edge fill:#fff3cd,stroke:#ffc107
    class n35,n36,n37,ok2 happy
    class e13 error
    class step3 edge
```

### Flow: reports-flow — R1A/R2

```mermaid
flowchart TD
    n38["[38] Dashboard báo cáo"]
    d11{"Có dữ liệu và có quyền xem?"}
    r1["R1A<br/>RP-01, RP-02, RP-04"]
    r2["R2<br/>RP-03, RP-05, RP-06, RP-07"]
    empty2["Empty state<br/>chưa có dữ liệu kỳ báo cáo"]
    e14["E-LMP-002/016<br/>banner, redirect hoặc mask field"]

    n4 -->|"Mở báo cáo"| n38
    n38 -->|"Tải dữ liệu"| d11
    d11 -->|"Có quyền và release R1A"| r1
    d11 -->|"Có quyền và release R2"| r2
    d11 -->|"Có quyền nhưng chưa có dữ liệu"| empty2
    d11 -->|"Không có quyền"| e14
    empty2 -.->|"Đổi bộ lọc"| n38
    e14 -.->|"Quay lại dashboard"| n4
    r1 -.->|"Đổi bộ lọc"| n38
    r2 -.->|"Đổi bộ lọc"| n38

    classDef happy fill:#d4edda,stroke:#28a745
    classDef error fill:#f8d7da,stroke:#dc3545
    classDef edge fill:#fff3cd,stroke:#ffc107
    class n38,r1,r2 happy
    class e14 error
    class empty2 edge
```

## 2. Danh sách màn hình

| [#] | Slug | Màn hình | Mục đích | Thuộc flow |
|-----|------|----------|----------|------------|
| 1 | access-login | Đăng nhập | Xác thực local hoặc chuyển sang SSO/IdP. | auth-flow |
| 2 | forgot-password | Quên mật khẩu | Khởi tạo account recovery khi identity là local. | auth-flow |
| 3 | reset-password | Đặt lại mật khẩu | Hoàn tất account recovery khi identity là local. | auth-flow |
| 4 | dashboard-home | Dashboard theo vai trò | Điều hướng theo vai trò và quick actions. | auth-flow |
| 5 | session-expired | Phiên hết hạn / step-up | Xác thực lại rồi quay về trạng thái an toàn. | auth-flow |
| 6 | catalog-search | Tra cứu danh mục | Tìm đầu sách và bản sao khả dụng. | catalog-admin-flow |
| 7 | bibliographic-detail | Chi tiết đầu sách | Xem thông tin thư mục và điều hướng tới kho bản sao. | catalog-admin-flow |
| 8 | bibliographic-form | Biểu mẫu đầu sách | Tạo, sửa hoặc vô hiệu hóa đầu sách. | catalog-admin-flow |
| 9 | copy-inventory | Kho bản sao | Xem và quản lý bản sao vật lý. | catalog-admin-flow |
| 10 | copy-form | Biểu mẫu bản sao | Tạo hoặc sửa bản sao. | catalog-admin-flow |
| 11 | reader-list | Danh sách người đọc | Tra cứu và chọn hồ sơ người đọc. | reader-admin-flow |
| 12 | reader-form | Biểu mẫu người đọc | Tạo hoặc cập nhật hồ sơ. | reader-admin-flow |
| 13 | reader-detail | Chi tiết người đọc | Xem hồ sơ và khóa/mở theo quyền. | reader-admin-flow |
| 14 | circulation-desk | Quầy lưu thông | Điểm vào cho nghiệp vụ mượn/trả tại quầy. | checkout-flow |
| 15 | checkout-scan | Quét checkout | Nhập/quét người đọc và các bản sao. | checkout-flow |
| 16 | checkout-review | Rà soát checkout | Kiểm tra và commit checkout nguyên tử. | checkout-flow |
| 17 | checkout-conflict | Xung đột checkout | Hiển thị trạng thái mới và cho tải lại an toàn. | checkout-flow |
| 18 | return-scan | Quét trả sách | Nhận diện bản sao và kiểm tra trạng thái trả. | return-renewal-flow |
| 19 | return-result | Kết quả trả | Hiển thị kết quả, fine hoặc follow-up. | return-renewal-flow |
| 20 | renewal-result | Kết quả gia hạn | Hiển thị thành công hoặc lý do bị chặn. | return-renewal-flow |
| 21 | reservation-search | Tìm tài liệu đặt trước | Chọn tài liệu cho reservation R2. | reservation-flow |
| 22 | reservation-form | Biểu mẫu đặt trước | Gửi yêu cầu reservation. | reservation-flow |
| 23 | reservation-queue | Hàng đợi đặt trước | Xem vị trí, empty state và hủy yêu cầu. | reservation-flow |
| 24 | reservation-pickup | Nhận bản giữ | Xác nhận pickup, hủy hoặc xử lý hết hạn. | reservation-flow |
| 25 | fine-list | Danh sách công nợ | Tra cứu các khoản fine. | fine-payment-flow |
| 26 | fine-detail | Chi tiết công nợ | Xem số dư và hành động được phép. | fine-payment-flow |
| 27 | fine-payment | Thanh toán fine | Ghi nhận thu tiền mặt tối thiểu R1A. | fine-payment-flow |
| 28 | financial-events | Sự kiện tài chính | Xem ledger và tác vụ nâng cao R1B. | fine-payment-flow |
| 29 | damage-report-form | Biểu mẫu hư hỏng | Gửi báo cáo và 1–5 ảnh bằng chứng. | damage-lost-found-flow |
| 30 | damage-report-detail | Chi tiết hư hỏng | Duyệt disposition và follow-up. | damage-lost-found-flow |
| 31 | lost-found | Mất / tìm lại | Ghi nhận mất và xử lý found-after-lost. | damage-lost-found-flow |
| 32 | notification-status | Trạng thái thông báo | Theo dõi outbox, retry và dead-letter. | notification-audit-flow |
| 33 | audit-log | Nhật ký audit | Tra cứu hành động nhạy cảm đã audit. | notification-audit-flow |
| 34 | history-timeline | Dòng thời gian lịch sử | Xem lịch sử resource đã redacted theo quyền. | notification-audit-flow |
| 35 | admin-config | Cấu hình quản trị | Quản lý policy và mở luồng import. | admin-import-flow |
| 36 | import-upload | Tải file import | Upload, validate và chạy dry-run. | admin-import-flow |
| 37 | import-report | Báo cáo import | Xem lỗi, commit result và reconciliation. | admin-import-flow |
| 38 | report-dashboard | Dashboard báo cáo | Xem báo cáo nghiệp vụ theo release và quyền. | reports-flow |

## 3. Danh sách flow

| Flow-slug | Tên flow | Màn hình gồm | Cases phủ |
|-----------|----------|--------------|-----------|
| auth-flow | Xác thực và điều hướng | access-login → forgot-password → reset-password → dashboard-home → session-expired | happy; credential/permission; session; local-vs-SSO edge |
| catalog-admin-flow | Danh mục và bản sao | catalog-search → bibliographic-detail → bibliographic-form → copy-inventory → copy-form | CRUD; validation; permission; conflict; soft-delete |
| reader-admin-flow | Quản lý người đọc | reader-list → reader-form → reader-detail | CRUD; khóa/mở R1B; permission; field masking |
| checkout-flow | Mượn tại quầy | circulation-desk → checkout-scan → checkout-review → checkout-conflict | atomic commit; unavailable/ineligible; duplicate; concurrency |
| return-renewal-flow | Trả và gia hạn | return-scan → return-result → renewal-result | trả R1A; gia hạn R1B; fine/damage/lost branches |
| reservation-flow | Đặt trước R2 | reservation-search → reservation-form → reservation-queue → reservation-pickup | queue; pickup; cancel; expiry; notify fail; empty state |
| fine-payment-flow | Công nợ và thanh toán | fine-list → fine-detail → fine-payment → financial-events | cash payment; ledger; duplicate; audit failure; step-up |
| damage-lost-found-flow | Hư hỏng, mất và tìm lại | damage-report-form → damage-report-detail → lost-found | upload reject; disposition; found-after-lost; step-up |
| notification-audit-flow | Thông báo và audit | notification-status → audit-log → history-timeline | retry/dead-letter; audit rollback; redaction |
| admin-import-flow | Cấu hình và import | admin-config → import-upload → import-report | dry-run; all-or-nothing commit; override; reconciliation |
| reports-flow | Báo cáo vận hành | report-dashboard | R1A/R2 datasets; permission; empty state |

## 3.5. Chuyển màn (transitions)

> Nguồn duy nhất cho chuyển màn. `(giữ nguyên)` nghĩa là hiển thị feedback tại màn hiện tại; node hệ thống/thông báo trong Mermaid được diễn đạt tại cột điều kiện.

| Từ màn [#] | Đến màn [#] | Trigger | Điều kiện |
|-----------|------------|---------|-----------|
| Đăng nhập [1] | Dashboard [4] | Submit đăng nhập | Local hợp lệ hoặc provider trả về thành công. |
| Đăng nhập [1] | (giữ nguyên) [1] | Submit đăng nhập | E-LMP-002; hiển thị banner/redirect an toàn. |
| Đăng nhập [1] | Quên mật khẩu [2] | Chọn Quên mật khẩu | Chỉ khi identity là local. |
| Quên mật khẩu [2] | Đặt lại mật khẩu [3] | Gửi yêu cầu recovery | Yêu cầu hợp lệ; cơ chế chờ OQ-LMP-007. |
| Đặt lại mật khẩu [3] | Đăng nhập [1] | Đặt lại thành công | Local identity. |
| Dashboard [4] | Phiên hết hạn [5] | Session timeout / sensitive action | E-LMP-017. |
| Phiên hết hạn [5] | Dashboard [4] | Xác thực lại | Thành công; quay về trạng thái an toàn. |
| Tra cứu danh mục [6] | Chi tiết đầu sách [7] | Chọn kết quả | Bản ghi tồn tại. |
| Tra cứu danh mục [6] | Biểu mẫu đầu sách [8] | Tạo mới | Có quyền. |
| Chi tiết đầu sách [7] | Biểu mẫu đầu sách [8] | Sửa/vô hiệu hóa | Có quyền; BR-LMP-017. |
| Chi tiết đầu sách [7] | Kho bản sao [9] | Xem bản sao | Luôn. |
| Kho bản sao [9] | Biểu mẫu bản sao [10] | Tạo/sửa | Có quyền. |
| Biểu mẫu đầu sách [8] | Chi tiết đầu sách [7] | Lưu | Validation và concurrency pass. |
| Biểu mẫu bản sao [10] | Chi tiết đầu sách [7] | Lưu | Validation và concurrency pass. |
| Danh sách người đọc [11] | Chi tiết người đọc [13] | Chọn hồ sơ | Hồ sơ tồn tại. |
| Danh sách người đọc [11] | Biểu mẫu người đọc [12] | Tạo mới | Chỉ actor được phép. |
| Chi tiết người đọc [13] | Biểu mẫu người đọc [12] | Sửa | Có quyền field. |
| Biểu mẫu người đọc [12] | Chi tiết người đọc [13] | Lưu | Validation/concurrency pass. |
| Chi tiết người đọc [13] | (giữ nguyên) [13] | Khóa/mở R1B | Có quyền; lỗi hiển thị tại chỗ. |
| Quầy lưu thông [14] | Quét checkout [15] | Bắt đầu mượn | R1A. |
| Quét checkout [15] | Rà soát checkout [16] | Hoàn tất quét | Mã tồn tại và không trùng. |
| Quét checkout [15] | (giữ nguyên) [15] | Quét/nhập | E-LMP-003/006; sửa rồi thử lại. |
| Rà soát checkout [16] | Quầy lưu thông [14] | Xác nhận commit | Mọi điều kiện pass; commit nguyên tử. |
| Rà soát checkout [16] | Xung đột checkout [17] | Xác nhận commit | E-LMP-005. |
| Xung đột checkout [17] | Rà soát checkout [16] | Tải trạng thái mới | Cho retry an toàn. |
| Quét trả [18] | Kết quả trả [19] | Quét bản sao | Trả bình thường. |
| Quét trả [18] | (giữ nguyên) [18] | Quét bản sao | E-LMP-004/005/007/015. |
| Kết quả trả [19] | Kết quả gia hạn [20] | Yêu cầu gia hạn | R1B. |
| Kết quả gia hạn [20] | Kết quả trả [19] | Đóng kết quả | Thành công hoặc bị chặn có lý do. |
| Tìm đặt trước [21] | Biểu mẫu đặt trước [22] | Chọn tài liệu | R2 future. |
| Biểu mẫu đặt trước [22] | Hàng đợi [23] | Gửi yêu cầu | Hợp lệ. |
| Biểu mẫu đặt trước [22] | (giữ nguyên) [22] | Gửi yêu cầu | E-LMP-005/008/015. |
| Hàng đợi [23] | Nhận bản giữ [24] | Đến lượt | Hold còn hạn. |
| Hàng đợi [23] | Tìm đặt trước [21] | Hủy / queue rỗng | Hiển thị empty state. |
| Nhận bản giữ [24] | Hàng đợi [23] | Hủy / hết hạn | Queue advance. |
| Nhận bản giữ [24] | Rà soát checkout [16] | Nhận sách | Reservation đúng lượt. |
| Hàng đợi [23] | (giữ nguyên) [23] | Notify fail | E-LMP-012/018; outbox retry. |
| Danh sách công nợ [25] | Chi tiết công nợ [26] | Chọn khoản nợ | Luôn. |
| Chi tiết công nợ [26] | Thanh toán fine [27] | Thu tiền mặt | R1A. |
| Chi tiết công nợ [26] | Sự kiện tài chính [28] | Xem ledger/tác vụ | R1B và policy đã duyệt. |
| Thanh toán fine [27] | Sự kiện tài chính [28] | Xác nhận | Ghi event thành công. |
| Thanh toán fine [27] | Chi tiết công nợ [26] | Lỗi/retry | Idempotent; E-LMP-009/010/013. |
| Sự kiện tài chính [28] | Phiên hết hạn [5] | Waiver/adjustment/refund | Step-up E-LMP-017. |
| Biểu mẫu hư hỏng [29] | Chi tiết hư hỏng [30] | Gửi báo cáo | Validation/upload pass. |
| Biểu mẫu hư hỏng [29] | (giữ nguyên) [29] | Gửi báo cáo | E-LMP-001/003/011/015. |
| Chi tiết hư hỏng [30] | Mất / tìm lại [31] | Ghi nhận mất | R1A. |
| Chi tiết hư hỏng [30] | Phiên hết hạn [5] | Thanh lý | Step-up E-LMP-017; DEC-D3-07. |
| Mất / tìm lại [31] | Chi tiết hư hỏng [30] | Tìm lại/đối soát | R1B. |
| Trạng thái thông báo [32] | (giữ nguyên) [32] | Retry/dead-letter | E-LMP-012/018. |
| Nhật ký audit [33] | Dòng thời gian [34] | Mở resource | Có quyền. |
| Nhật ký audit [33] | (giữ nguyên) [33] | Mở resource | E-LMP-013/016; redacted. |
| Dòng thời gian [34] | Nhật ký audit [33] | Quay lại | Luôn. |
| Cấu hình quản trị [35] | Tải file import [36] | Mở import | Có quyền. |
| Tải file import [36] | Báo cáo import [37] | Dry-run/commit | Dry-run pass hoặc override được duyệt; commit toàn batch rồi reconcile. |
| Tải file import [36] | (giữ nguyên) [36] | Dry-run | E-LMP-014; sửa file/chạy lại. |
| Tải file import [36] | Phiên hết hạn [5] | Yêu cầu override | Step-up; approver/evidence chờ OQ-LMP-018. |
| Báo cáo import [37] | Tải file import [36] | Chạy batch mới | Batch trước đã kết thúc. |
| Dashboard [4] | Dashboard báo cáo [38] | Mở báo cáo | Actor có route. |
| Dashboard báo cáo [38] | (giữ nguyên) [38] | Tải/đổi bộ lọc | R1A/R2 dataset, empty state hoặc E-LMP-002/016. |
| Dashboard báo cáo [38] | Dashboard [4] | Không có quyền / quay lại | Redirect an toàn. |

## 4. Open Questions

- [ ] OQ-LMP-015 — Reader portal R2 có chính thức mobile-first không? Owner: Product Owner. Gate: duyệt device/layout trước wireframe portal.
- [ ] OQ-LMP-016 — FR-R09 dùng màn reader tối thiểu ở R1B hay chuyển sang portal R2? Owner: Product Owner. Gate: chốt release và UI owner trước wireframe reader.
- [ ] OQ-LMP-017 — Thủ thư quầy có quyền xem reports không? Owner: Domain Approver. Gate: chốt permission trước wireframe/report acceptance.
- [ ] OQ-LMP-018 — Ai approve commit import khi dry-run chưa pass, điều kiện và bằng chứng override là gì? Owner: Data Owner + Thủ thư trưởng/Product Owner. Gate: GATE-MIG.

## References

- `docs/features/library-management-platform/srs/library-management-platform-spec.md`
- `docs/features/library-management-platform/usecases/library-management-platform-usecase-index.md`
- `docs/features/library-management-platform/srs/library-management-platform-flows.md`
- `docs/_product/decision-register.md`
- `docs/_product/roadmap.md`
