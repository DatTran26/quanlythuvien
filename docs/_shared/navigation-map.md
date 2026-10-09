---
type: navigation-map
scope: shared
status: draft
updated: 2026-10-08
links:
  - docs/_shared/id-crosswalk-lmp.md
  - docs/features/library-management-platform/srs/library-management-platform-userflow.md
---

# Bản đồ điều hướng giữa các feature

## Chuyển màn giữa feature

| Từ màn (feature) | Đến màn (feature) | Trigger | Điều kiện |
|---|---|---|---|
| `bibliographic-detail` (`catalog-admin`) | `copy-inventory` (`copy-inventory`) | Xem bản sao | Luôn. |
| `copy-form` (`copy-inventory`) | `bibliographic-detail` (`catalog-admin`) | Lưu | Validation và concurrency pass. |
| `reader-list` (`account-admin`) | `reader-form` (`reader-onboarding`) | Tạo mới | Chỉ actor được phép. |
| `reader-detail` (`account-admin`) | `reader-form` (`reader-onboarding`) | Sửa | Có quyền field. |
| `reader-form` (`reader-onboarding`) | `reader-detail` (`account-admin`) | Lưu | Validation/concurrency pass. |
| `return-result` (`return-handling`) | `renewal-result` (`renewal`) | Yêu cầu gia hạn | R1B. |
| `renewal-result` (`renewal`) | `return-result` (`return-handling`) | Đóng kết quả | Thành công hoặc bị chặn có lý do. |
| `reservation-pickup` (`reservation`) | `checkout-review` (`checkout`) | Nhận sách | Reservation đúng lượt. |
| `fine-detail` (`fine-collection-basic`) | `financial-events` (`fine-collection-adv`) | Xem ledger/tác vụ | R1B và policy đã duyệt. |
| `fine-payment` (`fine-collection-basic`) | `financial-events` (`fine-collection-adv`) | Xác nhận | Ghi event thành công. |
| `financial-events` (`fine-collection-adv`) | `session-expired` (`access-control`) | Waiver/adjustment/refund | Step-up E-access-control-001. |
| `damage-report-detail` (`damage-lifecycle`) | `lost-found` (`lost-handling`) | Ghi nhận mất | R1A. |
| `damage-report-detail` (`damage-lifecycle`) | `session-expired` (`access-control`) | Thanh lý | Step-up E-access-control-001; DEC-D3-07. |
| `lost-found` (`lost-handling`) | `damage-report-detail` (`damage-lifecycle`) | Tìm lại/đối soát | R1B. |
| `admin-config` (`policy-config`) | `import-upload` (`data-import`) | Mở import | Có quyền. |
| `import-upload` (`data-import`) | `session-expired` (`access-control`) | Yêu cầu override | Step-up; approver/evidence chờ OQ-data-import-002. |
| `dashboard-home` (`access-control`) | `report-dashboard` (`ops-reports`) | Mở báo cáo | Actor có route. |
| `report-dashboard` (`ops-reports`) | `dashboard-home` (`access-control`) | Không có quyền / quay lại | Redirect an toàn. |

## Màn điều hướng chung

- `dashboard-home` (`access-control`): điểm vào sau đăng nhập, hiển thị lối vào theo vai trò.
- `session-expired` (`access-control`): mọi tác vụ nhạy cảm cần xác thực lại (step-up) đều chuyển qua màn này rồi quay về màn gọi.
