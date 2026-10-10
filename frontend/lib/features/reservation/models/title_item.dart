// Model đầu sách trong kết quả tìm kiếm.
// Bài: 07-reservation/01-reservation-search.md
//
// API: GET /titles?q= -> [{ id, name, author, isbn, priceVnd, loanable, active, category }]
//
// TODO:
// - class TitleItem + fromJson.
// - G7: API chưa có availableCount. Để sẵn field int? availableCount, khi backend thêm thì
//   chỉ hiện nút "Đặt trước" khi availableCount == 0 (BR-08).
