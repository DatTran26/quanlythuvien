// API báo cáo.
// Bài: 08-reports/01-report-dashboard.md (Bước 1), 03-trend-dashboard.md
//
// TODO:
// - Future<List<...>> overdue()          -> GET /reports/overdue (List<Loan> lồng reader/title/copy,
//                                           mở Swagger kiểm tra JSON rồi viết fromJson)
// - Future<Map<String,int>> inventory()  -> GET /reports/inventory trả [[status, count], ...]
// - Future<({int loans, int returns})> trends(DateTime from, DateTime to)
//                                        -> GET /reports/trends?from=YYYY-MM-DD&to=YYYY-MM-DD
// - Tải file: GET /reports/overdue.xlsx, /reports/overdue.pdf (getBytes; web và mobile lưu khác nhau).
//
// Lỗ hổng:
// - G10: chưa có API RP-05 phạt, RP-06 top sách, RP-07 hư hỏng.
// - G11: chưa có API RP-01 tài khoản.
// Trong lúc chờ có thể đọc mock: docs/_shared/mock-data.json, tv2.opsReport và tv2.trendReport.
