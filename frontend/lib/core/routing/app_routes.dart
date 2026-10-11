// Tên route của cả app. Bài: Hoang/01-nen-tang/04-dieu-huong-routing.md
// TV1 (Đạt) quản lý file này; mỗi người bổ sung phần của mình qua PR nhỏ.
// Bảng ghép route -> màn nằm ở app_router.dart.

abstract final class AppRoutes {
  // TV1
  static const dashboard = '/';
  static const sessionExpired = '/session-expired';
  static const forgotPassword = '/forgot-password';
  static const resetPassword = '/reset-password';
  static const catalogSearch = '/catalog';
  static const bibliographicDetail = '/catalog/detail';
  static const bibliographicForm = '/catalog/form';
  static const categoryAdmin = '/catalog/categories';
  static const copyInventory = '/copies';
  static const copyForm = '/copies/form';
  static const importUpload = '/import';
  static const importReport = '/import/report';
  static const adminConfig = '/policy';
  static const backupRuns = '/ops/backups';

  // TV2 — Hoàng
  static const circulationDesk = '/circulation';
  static const checkoutScan = '/checkout/scan';
  static const checkoutReview = '/checkout/review';
  static const checkoutConflict = '/checkout/conflict';
  static const returnScan = '/return/scan';
  static const returnResult = '/return/result';
  static const renewalRequest = '/renewal/request';
  static const renewalResult = '/renewal/result';
  static const damageForm = '/damage/new';
  static const damageDetail = '/damage/detail';
  static const lostRecord = '/lost/record';
  static const foundAfterLost = '/lost/found';
  static const reservationSearch = '/reservation/search';
  static const reservationForm = '/reservation/form';
  static const reservationQueue = '/reservation/queue';
  static const reservationPickup = '/reservation/pickup';
  static const reportDashboard = '/reports';
  static const overdueList = '/reports/overdue';
  static const trendDashboard = '/reports/trends';

  // TV3 — Bảo
  static const finePayment = '/fines/payment';
  static const readerList = '/readers';
  static const readerPortal = '/portal';
  static const notifications = '/notifications';
  static const auditLog = '/audit';
  static const notificationStatus = '/notifications/status';
}
