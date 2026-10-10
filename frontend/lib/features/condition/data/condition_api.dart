// API hư hỏng (damage-lifecycle).
// Bài: 05-damage-lifecycle/01 và 02
//
// TODO:
// - Future<DamageReport> createReport({copyId, severity, note, XFile? photo})
//     -> POST /damage-reports (multipart: copyId, severity, note, photo)
// - Future<DamageReport> decide(int reportId, String decision)
//     -> POST /damage-reports/{id}/disposition body {decision: REJECT | REPAIR | DISPOSE}
// - Future<BookCopy> repairComplete(int copyId) -> POST /copies/{id}/repair-complete
// - Uri photoUrl(String name) -> GET /files/{name} (web có thể bị CORS: tải bytes rồi Image.memory)
//
// Lỗ hổng:
// - G4: backend nhận 1 ảnh, tài liệu muốn 1–5.
// - G5: chưa có GET /damage-reports và /{id}; danh sách chờ duyệt tạm đọc mock
//   (docs/_shared/mock-data.json, tv2.damageReports).
// - disposition chưa nhận "reason" dù UI bắt nhập lý do -> hỏi nhóm thêm vào DecisionRequest.
