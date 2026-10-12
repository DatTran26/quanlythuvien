---
type: team-assignment
scope: product
status: draft
updated: 2026-10-12
links:
  - docs/_product/prd.md
  - docs/_product/roadmap.md
  - docs/_shared/navigation-map.md
---

# Phân công feature cho 3 thành viên

Chia 22 feature P0–P1 trong `prd.md` Mục 7 cho 3 thành viên. `expansion-candidates` (R3) nằm ngoài phạm vi đồ án nên không chia.

Nguyên tắc: **các màn có link sang nhau (theo `_shared/navigation-map.md`) giao cho cùng một người**. Backend Spring trong `apps/api` đã có đủ module và `DevSeed` để tạo dữ liệu mẫu, nên phần phụ thuộc dữ liệu giữa các nhóm chỉ là gọi API, không phải chờ màn hình của người khác.

## Bảng phân công

Khối lượng tính theo cột Effort trong `roadmap.md` Mục 12 (S=1, M=2, L=3).

| | **TV1 – Nền tảng, Danh mục & Kho** | **TV2 – Lưu thông tại quầy & Báo cáo** | **TV3 – Người đọc, Tài chính & Thông báo** |
|---|---|---|---|
| Feature | `access-control` (M)<br>`catalog-admin` (M)<br>`copy-inventory` (M)<br>`data-import` (L)<br>`policy-config` (M)<br>`ops-foundation` (M)<br>**+ khung app dùng chung** | `checkout` (L)<br>`return-handling` (L)<br>`damage-lifecycle` (M)<br>`lost-handling` (S)<br>`renewal` (S)<br>`reservation` (L)<br>`ops-reports` (S)<br>`trend-reports` (M) | `reader-onboarding` (S)<br>`account-admin` (M)<br>`reader-self-service` (M)<br>`notification-core` (M)<br>`notification-audit-ui` (M)<br>`overdue-fines` (M)<br>`fine-collection-basic` (S)<br>`fine-collection-adv` (M) |
| Khối lượng | 13 + khung app (~2) ≈ **15** | **16** | **14** |
| Vai trò chính | Thủ thư | Nhân viên | Người đọc + tài chính |
| Module backend liên quan | `identity`, `catalog`, `imports`, `audit`, `ops`, `config` | `circulation`, `condition`, `reservation`, `report` | `identity` (ReaderProfile), `fine`, `notification`, `audit` (viewer) |

## Chuyển màn nằm gọn trong một người

| Thành viên | Cặp màn liên kết |
|---|---|
| TV1 | `catalog-admin` ↔ `copy-inventory`; `policy-config` → `data-import` |
| TV2 | `return-handling` ↔ `renewal`; `reservation` → `checkout`; `damage-lifecycle` ↔ `lost-handling` |
| TV3 | `account-admin` ↔ `reader-onboarding`; `fine-collection-basic` → `fine-collection-adv` |

## Điểm đi qua người khác và cách tránh chờ

| Điểm nối | Bên cung cấp | Bên dùng | Cách tránh chờ |
|---|---|---|---|
| Đăng nhập, `dashboard-home`, `session-expired` (xác thực lại cho thao tác nhạy cảm) | TV1 | TV2, TV3 | TV1 làm khung app trong 1–2 ngày đầu. Trong lúc đó TV2, TV3 dựng giao diện với dữ liệu giả hoặc thử API qua Swagger. |
| Ô "Báo cáo" trên `dashboard-home` → `report-dashboard` | TV1 | TV2 | Chỉ là một route đã thống nhất tên trước. |
| Tiền phạt hiển thị ở màn trả sách | TV3 (`overdue-fines`) | TV2 (`return-handling`) | Đọc từ API; `FineService` đã có ở backend. |
| Phiếu đang mượn ở màn tự phục vụ | TV2 (`checkout`) | TV3 (`reader-self-service`) | Đọc từ API lưu thông với dữ liệu `DevSeed`. |
| Thông báo sách sẵn sàng khi đặt trước | TV3 (`notification-core`) | TV2 (`reservation`) | Gọi `NotificationService` đã có ở backend. |

## Việc chốt chung trước khi tách nhánh

TV1 làm, cả nhóm duyệt:

1. **Danh sách tên route** cho mọi màn trong `_shared/navigation-map.md` (ví dụ `/checkout/review`, `/fines/:id`). Màn chưa làm thì để trang tạm, nên ai cũng điều hướng được sang màn của người khác.
2. **Lớp gọi API dùng chung**: gắn JWT, xử lý lỗi theo `ApiExceptionHandler`, chuyển sang `session-expired` khi cần xác thực lại.
3. **Widget dùng chung**: theme theo `docs/design` (bảng màu, spec nút), widget quét QR (dùng ở `copy-inventory`, `checkout`, `return-handling`, thẻ người đọc), các trạng thái đang tải / trống / lỗi.

## Quy ước làm việc

- Mỗi người một nhánh riêng, chỉ sửa trong thư mục feature của mình.
- Muốn đổi phần dùng chung (route, API client, widget, theme) thì mở PR nhỏ riêng để cả nhóm duyệt.
- Commit theo `docs/references/` (quy ước commit).
