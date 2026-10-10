// Model báo cáo hư hỏng.
// Bài: 05-damage-lifecycle/01-damage-report-form.md (Bước 2)
//
// API trả về: { id, copyId, reporterId, status, severity, note, photoPath, createdAt }
//   status:   PENDING, REJECTED, REPAIR, DISPOSED
//   severity: LIGHT, MEDIUM, HEAVY
//
// TODO:
// - class DamageReport + fromJson.
// - getter isClosed: REJECTED / DISPOSED -> chỉ xem, ẩn nút quyết định.
// - Nhãn tiếng Việt cho severity: Nhẹ / Trung bình / Nặng.
