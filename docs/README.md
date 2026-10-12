# Tài liệu Hệ thống Quản lý Thư viện

## Tài liệu nền tảng kỹ thuật

| Tài liệu | Mục đích |
|---|---|
| [Tổng quan sản phẩm](project-overview-pdr.md) | Mục tiêu, người dùng, ràng buộc và phạm vi nền tảng. |
| [Kiến trúc hệ thống](system-architecture.md) | Các thành phần đang có, ranh giới và các quyết định kỹ thuật. |
| [Hướng dẫn cài đặt và vận hành](deployment-guide.md) | Chạy cục bộ, kiểm thử, cấu hình và các giới hạn deployment hiện tại. |
| [Điều hướng mã nguồn](codebase-summary.md) | Điểm vào và owner thực thi của mỗi khu vực. |
| [Quy ước phát triển](code-standards.md) | Chất lượng mã, kiểm thử và quy trình đóng góp. |
| [Hướng dẫn thiết kế](design-guidelines.md) | Điểm vào của hệ thống thiết kế Flutter. |
| [Định hướng sản phẩm](project-roadmap.md) | Liên kết tới roadmap sản phẩm có thẩm quyền. |

## Cấu trúc

| Thư mục | Nội dung |
|---|---|
| `he_thong_quan_ly_thu_vien.md` | Tài liệu nguồn ban đầu, chỉ đọc. Dùng tên vai trò nguồn ("Nhân viên", "Nhân viên") — xem DEC-SF-01 |
| `_product/` | Tầng sản phẩm: PRD, roadmap, decision register, priority crosswalk, readiness gates, brainstorm sản phẩm |
| `_shared/` | Dùng chung: project profile, đặc tả chung (`core-spec.md`), mô hình miền (`domain/`), điều hướng giữa feature, chiến lược test và checklist chung, ID registry, bảng đối chiếu mã LMP |
| `features/{slug}/` | Mỗi feature một thư mục: brainstorm, URD, BRD, PRD, SRS, use case, user flow, wireframe, user story, checklist |
| `references/` | Quy ước commit |

## Thứ tự đọc

1. `_shared/project-profile.md` — bối cảnh, người dùng, thuật ngữ.
   Bộ tên role hiện hành và hướng dẫn chuyển dữ liệu: [`_shared/role-names.md`](_shared/role-names.md).
2. `_product/prd.md` — Feature Map và mô tả 23 feature.
3. `_product/roadmap.md` — release, xếp hạng ưu tiên, phụ thuộc giữa feature.
4. `_shared/core-spec.md` và `_shared/domain/` — quy tắc, lỗi, entity, state dùng chung.
5. `features/{slug}/` — chi tiết từng feature.

## Feature theo release

Trạng thái chi tiết hóa xem cột "Chi tiết hóa" trong `_product/prd.md` Mục 7.

**R0**

- `access-control` — Đăng nhập & phân quyền
- `reader-onboarding` — Cấp & kích hoạt tài khoản người đọc tại quầy
- `account-admin` — Quản trị tài khoản
- `catalog-admin` — Danh mục & đầu sách
- `copy-inventory` — Bản sao & nhãn QR
- `data-import` — Import Excel & đối soát
- `policy-config` — Cấu hình quy định
- `ops-foundation` — Audit capture & backup/restore

**R1A**

- `checkout` — Mượn tại quầy
- `return-handling` — Trả & ngoại lệ
- `overdue-fines` — Job quá hạn & fine ledger
- `damage-lifecycle` — Báo cáo hư hỏng & duyệt
- `lost-handling` — Ghi nhận mất & tìm lại
- `fine-collection-basic` — Thu phạt tiền mặt tối thiểu
- `reader-self-service` — Tự phục vụ người đọc
- `notification-core` — Thông báo tối thiểu
- `ops-reports` — Báo cáo vận hành

**R1B**

- `renewal` — Gia hạn tại quầy & online
- `fine-collection-adv` — Thu phạt nâng cao (biên nhận, miễn/điều chỉnh)
- `notification-audit-ui` — Trung tâm thông báo & audit viewer

**R2**

- `reservation` — Đặt trước trọn vòng
- `trend-reports` — Báo cáo xu hướng

**R3**

- `expansion-candidates` — Candidate mở rộng

## Trạng thái chuyển đổi

Feature gộp đã gỡ 2026-10-09. Tài liệu sống nằm ở 23 thư mục `features/{slug}/` theo Feature Map. Tra mã cũ (series đã retired) ở `_shared/id-crosswalk-lmp.md`.
