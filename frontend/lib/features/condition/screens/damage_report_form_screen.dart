// Màn 9 – Báo hư hỏng (damage-report-form). Route: /damage/new
// Bài: 05-damage-lifecycle/01-damage-report-form.md · Độ khó ⭐⭐⭐
//
// Mục đích: lập báo cáo hư hỏng gồm bản sao, mức độ, mô tả, ảnh.
// Gửi xong: báo cáo PENDING, bản sao PENDING_REVIEW (ngừng cho mượn ngay).
// Đến từ: circulation-desk. Đi tới: damage-report-detail.
//
// TODO:
// - Cài image_picker + quyền camera/thư viện ảnh (Bước 1).
// - Ô mã bản sao + camera -> findCopyByCode() hiển thị đầu sách, trạng thái.
// - Form + validator: mức độ (bắt buộc), mô tả (bắt buộc).
// - Chọn ảnh: GridView ảnh + Stack nút xóa. _maxPhotos = 1 (G4), mỗi ảnh ≤ 500KB sau nén (NFR-05).
// - LoadingButton "Gửi báo cáo" -> createReport() -> pushReplacement detail, TRUYỀN THẲNG
//   DamageReport vừa nhận (G5).
