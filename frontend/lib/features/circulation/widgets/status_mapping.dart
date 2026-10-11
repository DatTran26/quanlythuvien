// Ánh xạ trạng thái (bản sao, phiếu mượn) -> nhãn tiếng Việt + kiểu chip.
// Bài: 01-nen-tang/02-theme-va-widget-dung-chung.md, docs/design/color-system.md
//
// TODO:
// - String copyStatusLabel(String status): AVAILABLE "Sẵn sàng", ON_LOAN "Đang mượn",
//   ON_HOLD "Đang giữ", PENDING_REVIEW "Chờ duyệt", IN_REPAIR "Đang sửa",
//   LOST "Mất", DISPOSED "Đã thanh lý".
// - String loanStatusLabel(String status): ACTIVE, OVERDUE, RETURNED, LOST.
// - Hàm trả về loại chip để StatusChip (core/widgets/status_chip.dart, TV1) tô màu.
//   Quy tắc vàng: mọi màn dùng chung hàm này, không tự chọn màu.
