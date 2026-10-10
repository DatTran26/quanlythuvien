// Màn 10 – Chi tiết báo cáo hư hỏng (damage-report-detail). Route: /damage/detail
// Bài: 05-damage-lifecycle/02-damage-report-detail.md · Độ khó ⭐⭐⭐
//
// Mục đích: xem báo cáo và để Quản trị viên quyết định.
//
// TODO:
// - Nhận DamageReport qua arguments. Hiện bản sao, mức độ, người báo, thời điểm, mô tả, ảnh
//   (GestureDetector mở InteractiveViewer phóng to).
// - Theo vai trò (lấy role TV1 lưu khi đăng nhập):
//   · ADMIN thấy khối quyết định:
//     Bác bỏ (REJECT, Outlined) -> bản sao AVAILABLE
//     Đưa đi sửa (REPAIR, Tonal) -> IN_REPAIR
//     Thanh lý (DISPOSE, Danger) -> DISPOSED: dialog xác nhận + bắt nhập lý do + xác thực lại
//       qua /session-expired (TV1), DEC-D3-07.
//   · LIBRARIAN chỉ thấy banner "Đang chờ Quản trị viên duyệt".
// - Báo cáo ở REPAIR: nút "Xác nhận sửa xong" -> repairComplete().
// - Báo cáo đã đóng: chỉ xem (E-core-008, không mở lại).
// - Tác vụ khác: "Ghi nhận mất" -> lost-record; "Tính phí" -> /fines/payment (TV3).
