---
type: mock-data
scope: shared
status: draft
updated: 2026-10-12
links:
  - docs/_shared/mock-data.json
  - docs/_product/team-assignment.md
  - docs/_shared/domain/library-states.md
---

# Dữ liệu mẫu dùng chung

`mock-data.json` thay CSDL thật trong lúc app chưa nối API. Tên trường và giá trị enum khớp entity trong `apps/api`, nên khi chuyển sang API thật chỉ cần đổi nguồn dữ liệu, không phải đổi model.

- Mốc thời gian "hiện tại" của bộ dữ liệu: `_meta.referenceNow` = `2026-10-10T08:00:00`. Tính quá hạn, đến hạn, hết giữ chỗ theo mốc này, không theo đồng hồ máy.
- Quan hệ ghi bằng id: `titleId`, `copyId`, `readerId`, `userId`, `fineId`.
- Không có mật khẩu. Đăng nhập giả lập bằng cách chọn email trong `shared.users`.
- Flutter không đọc được thư mục `docs/`. Khi dựng app, copy file vào `apps/mobile/assets/` và khai báo trong `pubspec.yaml`. File gốc vẫn là bản trong `docs/_shared/`.

## Phân loại

### `shared` – dùng chung cả 3 thành viên

Chỉ sửa qua PR chung, vì đổi một bản ghi có thể làm hỏng màn của người khác.

| Key | Entity backend | Chủ sở hữu | Ai đọc |
|---|---|---|---|
| `users` | `UserAccount` | TV1 (`access-control`) | Cả 3: đăng nhập, hiển thị tên, lọc theo vai trò |
| `readerProfiles` | `ReaderProfile` | TV3 (`reader-onboarding`) | TV2 quét thẻ khi mượn/trả, TV3 thẻ QR người đọc |
| `categories` | `Category` | TV1 (`catalog-admin`) | TV1 danh mục, TV2 báo cáo, TV3 tra cứu |
| `titles` | `Title` | TV1 (`catalog-admin`) | Cả 3 |
| `copies` | `BookCopy` | TV1 (`copy-inventory`) | TV2 mượn/trả/hư hỏng, TV3 tra cứu còn sách |
| `lendingPolicy` | `LendingPolicy` | TV1 (`policy-config`) | TV2 hạn mượn, gia hạn, giữ chỗ; TV3 mức phạt, ngưỡng chặn |
| `loans` | `Loan` | TV2 (`checkout`, `return-handling`) | TV3 sách đang mượn, lịch sử, tính phạt |
| `fines` | `Fine` | TV3 (`overdue-fines`, `fine-collection-*`) | TV2 chặn mượn khi nợ ≥ `fineBlockVnd`, hiển thị phạt khi trả |

### `tv1` – riêng TV1

| Key | Dùng cho |
|---|---|
| `importBatches` | `data-import`: một lô đã nhập và một lô chạy thử có dòng lỗi để dựng màn đối soát |
| `backupRuns` | `ops-foundation`: lịch sử backup, có một lần lỗi |

### `tv2` – riêng TV2

| Key | Dùng cho |
|---|---|
| `reservations` | `reservation`: đủ 5 trạng thái `WAITING`, `READY`, `EXPIRED`, `CANCELLED`, `FULFILLED` |
| `damageReports` | `damage-lifecycle`: đủ 4 trạng thái `PENDING`, `REPAIR`, `DISPOSED`, `REJECTED` |
| `opsReport` | `ops-reports`: số liệu tổng hợp, tính đúng từ `shared` |
| `trendReport` | `trend-reports`: số liệu theo tháng, sách mượn nhiều, theo thể loại (số giả lập, không suy ra từ `loans`) |

### `tv3` – riêng TV3

| Key | Dùng cho |
|---|---|
| `notifications` | `notification-core`, `notification-audit-ui`: có thông báo đã đọc và chưa đọc |
| `fineTransactions` | `fine-collection-basic` (thu tiền mặt, biên nhận), `fine-collection-adv` (miễn phạt) |
| `auditLogs` | `notification-audit-ui`: màn xem nhật ký của Thủ thư |
| `notificationOutbox` | `notification-core`: trạng thái gửi từng thông báo (`SENT`, `RETRYING`, `DEAD`), số lần thử, lỗi cuối. Backend chưa có outbox (T13) |

Mỗi người được tự thêm key mới vào section của mình mà không cần hỏi ai. Nếu sau đó người khác cũng cần key đó, chuyển nó lên `shared` bằng PR chung.

## Tình huống có sẵn để test

| Tình huống | Dữ liệu |
|---|---|
| Mượn bình thường | Người đọc #3 (`R10000001`), bản sao `BC000002` |
| Bị chặn mượn vì nợ phạt | Người đọc #6 (`R10000004`), nợ 55.000đ ≥ 50.000đ |
| Tài khoản bị khóa | Người đọc #9 (`R10000007`) |
| Tài khoản chờ kích hoạt | Người đọc #8 (`R10000006`) |
| Sách không cho mượn | Đầu sách #10 (từ điển); bản sao `BC000018` (ghi đè `loanableOverride: false`) |
| Đầu sách ngưng | Đầu sách #11 (`active: false`) |
| Trả sách quá hạn | Phiếu #2 (`BC000003`, trễ 11 ngày), phiếu #4 (`BC000010`, trễ 6 ngày) |
| Gia hạn được / hết lượt | Phiếu #1 (`renewCount: 0`) / phiếu #6 (`renewCount: 1` = `maxRenewals`) |
| Gia hạn bị chặn vì có người đặt trước | Phiếu #7 (đầu sách #9 có đặt trước #2 đang chờ) |
| Nhận sách đặt trước | Đặt trước #1, người đọc #7, bản sao `BC000007` đang giữ |
| Duyệt hư hỏng | Báo cáo #1, bản sao `BC000005` ở trạng thái `PENDING_REVIEW` |
| Thu phạt một phần còn nợ | Phạt #5 (60.000đ, còn 40.000đ) |
