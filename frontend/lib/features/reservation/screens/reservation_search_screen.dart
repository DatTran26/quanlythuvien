// Màn 13 – Tìm sách để đặt trước (reservation-search). Route: /reservation/search · R2
// Bài: 07-reservation/01-reservation-search.md · Độ khó ⭐⭐
//
// Mục đích: tìm đầu sách muốn đặt trước. BR-08: chỉ đặt khi số bản khả dụng = 0.
//
// TODO:
// - TextField tìm kiếm có debounce (~400ms, dùng Timer) -> searchTitles().
// - ListView kết quả: tên, tác giả, thể loại, nút "Đặt trước" -> reservation-form.
// - Trạng thái đang tải / không có kết quả / lỗi (state_views của TV1).
// - G7: chưa có availableCount -> hiện nút cho mọi đầu sách; để sẵn đoạn code chú thích.
