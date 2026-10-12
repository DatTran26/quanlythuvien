// Ghép tên route -> màn hình.
// TV1 quản lý file này. Route chưa làm thì trỏ về PlaceholderScreen.

import 'package:flutter/material.dart';
import 'package:frontend/features/access/screens/dashboard_screen.dart';
import 'package:frontend/features/access/screens/forgot_password_screen.dart';
import 'package:frontend/features/access/screens/login_screen.dart';
import 'package:frontend/features/access/screens/reset_password_screen.dart';
import 'package:frontend/features/access/screens/session_expired_screen.dart';
import 'package:frontend/features/accounts/screens/reader_list_screen.dart';
import 'package:frontend/features/catalog/screens/bibliographic_detail_screen.dart';
import 'package:frontend/features/catalog/screens/bibliographic_form_screen.dart';
import 'package:frontend/features/catalog/screens/catalog_search_screen.dart';
import 'package:frontend/features/catalog/screens/category_admin_screen.dart';
import 'package:frontend/features/fine/data/fine_api.dart';
import 'package:frontend/features/fine/screens/fine_list_screen.dart';
import 'package:frontend/features/imports/screens/import_report_screen.dart';
import 'package:frontend/features/imports/screens/import_upload_screen.dart';
import 'package:frontend/features/inventory/screens/copy_form_screen.dart';
import 'package:frontend/features/inventory/screens/copy_inventory_screen.dart';
import 'package:frontend/features/notification/data/notification_api.dart';
import 'package:frontend/features/notification/screens/audit_log_screen.dart';
import 'package:frontend/features/notification/screens/notification_center_screen.dart';
import 'package:frontend/features/notification/screens/notification_status_screen.dart';
import 'package:frontend/features/notification/widgets/access_denied_view.dart';
import 'package:frontend/features/ops/screens/backup_runs_screen.dart';
import 'package:frontend/features/policy/screens/admin_config_screen.dart';
import 'package:frontend/features/reader_portal/data/portal_api.dart';
import 'package:frontend/features/reader_portal/screens/reader_portal_shell.dart';

import '../../features/circulation/models/book_copy.dart';
import '../../features/circulation/models/checkout_session.dart';
import '../../features/circulation/models/return_outcome.dart';
import '../../features/circulation/screens/checkout_conflict_screen.dart';
import '../../features/circulation/screens/checkout_review_screen.dart';
import '../../features/circulation/screens/checkout_scan_screen.dart';
import '../../features/circulation/screens/circulation_desk_screen.dart';
import '../../features/circulation/screens/renewal_request_screen.dart';
import '../../features/circulation/screens/renewal_result_screen.dart';
import '../../features/circulation/screens/return_result_screen.dart';
import '../../features/circulation/screens/return_scan_screen.dart';
import '../../features/condition/screens/damage_report_detail_screen.dart';
import '../../features/condition/screens/damage_report_form_screen.dart';
import '../../features/condition/screens/found_after_lost_screen.dart';
import '../../features/condition/screens/lost_record_screen.dart';
import '../../features/reports/screens/overdue_list_screen.dart';
import '../../features/reports/screens/report_dashboard_screen.dart';
import '../../features/reports/screens/trend_dashboard_screen.dart';
import '../../features/reservation/models/reservation.dart';
import '../../features/reservation/models/title_item.dart';
import '../../features/reservation/screens/reservation_form_screen.dart';
import '../../features/reservation/screens/reservation_pickup_screen.dart';
import '../../features/reservation/screens/reservation_shell.dart';
import '../auth/session.dart';
import 'app_routes.dart';
import 'placeholder_screens.dart';

abstract final class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    final page = switch (settings.name) {
      AppRoutes.dashboard => AppSession.isSignedIn ? const DashboardScreen() : const LoginScreen(),
      AppRoutes.sessionExpired => SessionExpiredScreen(reason: args is String ? args : null),
      AppRoutes.forgotPassword => const ForgotPasswordScreen(),
      AppRoutes.resetPassword => const ResetPasswordScreen(),

      AppRoutes.catalogSearch => _staff(const CatalogSearchScreen()),
      AppRoutes.bibliographicDetail => _staff(BibliographicDetailScreen(titleId: args as int)),
      AppRoutes.bibliographicForm => _librarian(BibliographicFormScreen(titleId: args as int?)),
      AppRoutes.categoryAdmin => _librarian(const CategoryAdminScreen()),
      AppRoutes.copyInventory => _staff(CopyInventoryScreen(titleId: args as int)),
      AppRoutes.copyForm => _librarian(CopyFormScreen(titleId: args as int)),
      AppRoutes.importUpload => _librarian(const ImportUploadScreen()),
      AppRoutes.importReport => _librarian(ImportReportScreen(batchId: args as int)),
      AppRoutes.adminConfig => _librarian(const AdminConfigScreen()),
      AppRoutes.backupRuns => _librarian(const BackupRunsScreen()),

      AppRoutes.circulationDesk => _staff(const CirculationDeskScreen()),
      AppRoutes.checkoutScan => _staff(const CheckoutScanScreen()),
      AppRoutes.checkoutReview => _staff(CheckoutReviewScreen(session: args as CheckoutSession)),
      AppRoutes.checkoutConflict => _staff(CheckoutConflictScreen(copies: args as List<BookCopy>)),
      AppRoutes.returnScan => _staff(ReturnScanScreen(openCamera: args == true)),
      AppRoutes.returnResult => _staff(ReturnResultScreen(result: args as ReturnOutcome)),
      AppRoutes.renewalRequest => _staff(const RenewalRequestScreen()),
      AppRoutes.renewalResult => _staff(RenewalResultScreen(results: args as List<RenewalItemResult>)),
      AppRoutes.damageForm => _staff(DamageReportFormScreen(initialCopyCode: args as String?)),
      AppRoutes.damageDetail => _staff(
          DamageReportDetailScreen(args: args as DamageDetailArgs, isLibrarian: AppSession.isLibrarian),
        ),
      AppRoutes.lostRecord => _staff(LostRecordScreen(args: args)),
      AppRoutes.foundAfterLost => _staff(const FoundAfterLostScreen()),
      AppRoutes.reservationSearch => _staff(const ReservationShell()),
      AppRoutes.reservationQueue => _staff(const ReservationShell(initialTab: 1)),
      AppRoutes.reservationForm => _staff(ReservationFormScreen(title: args as TitleItem)),
      AppRoutes.reservationPickup => _staff(ReservationPickupScreen(reservation: args as Reservation?)),
      AppRoutes.reportDashboard => _staff(const ReportDashboardScreen()),
      AppRoutes.overdueList => _staff(const OverdueListScreen()),
      AppRoutes.trendDashboard => _staff(const TrendDashboardScreen()),

      AppRoutes.finePayment => _staff(
          FineListScreen(
            api: MockFineApi(),
            actorId: AppSession.userId ?? 0,
            initialCardCode: args is String ? args : null,
          ),
        ),
      AppRoutes.readerList => _staff(const ReaderListScreen()),
      AppRoutes.readerPortal => _reader(
          ReaderPortalShell(
            api: MockPortalApi(readerId: AppSession.userId ?? 0),
            userId: AppSession.userId ?? 0,
          ),
        ),
      AppRoutes.notifications => _signedIn(
          NotificationCenterScreen(userId: AppSession.userId ?? 0, api: MockNotificationApi()),
        ),
      AppRoutes.auditLog => _librarian(AuditLogScreen(actorId: AppSession.userId ?? 0, api: MockNotificationApi())),
      AppRoutes.notificationStatus => _librarian(
          NotificationStatusScreen(actorId: AppSession.userId ?? 0, api: MockNotificationApi()),
        ),

      _ => const PlaceholderScreen(),
    };
    return MaterialPageRoute(builder: (_) => page, settings: settings);
  }

  static Widget _signedIn(Widget page) => AppSession.isSignedIn ? page : const LoginScreen();

  static Widget _staff(Widget page) {
    if (!AppSession.isSignedIn) return const LoginScreen();
    if (!AppSession.isStaff) return const _DeniedScreen();
    return page;
  }

  static Widget _librarian(Widget page) {
    if (!AppSession.isSignedIn) return const LoginScreen();
    if (!AppSession.isLibrarian) return const _DeniedScreen();
    return page;
  }

  static Widget _reader(Widget page) {
    if (!AppSession.isSignedIn) return const LoginScreen();
    if (!AppSession.isReader) return const _DeniedScreen();
    return page;
  }
}

class _DeniedScreen extends StatelessWidget {
  const _DeniedScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: AccessDeniedView(message: 'Tài khoản của bạn không có quyền mở màn này.'),
      ),
    );
  }
}
