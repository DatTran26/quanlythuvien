// Model đặt trước.
// Bài: 07-reservation/03-reservation-queue.md (Bước 1)
//
// API trả về: { id, titleId, readerId, status, heldCopyId, createdAt, readyUntil }
//   status: WAITING, READY, EXPIRED, CANCELLED, FULFILLED
//
// TODO:
// - class Reservation + fromJson (title có thể lồng object, mở Swagger kiểm tra).
// - getter remaining: readyUntil - now, dùng cho đếm ngược ở tab Sẵn sàng.
// - getter isOpen: WAITING hoặc READY.
