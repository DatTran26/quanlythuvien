// Ghép tên route -> màn hình, đọc arguments có kiểu rõ ràng.
// Bài: Hoang/01-nen-tang/04-dieu-huong-routing.md mục 2.2
// TV1 (Đạt) quản lý file này; route của người khác chưa làm thì trỏ về PlaceholderScreen.

import 'package:flutter/material.dart';

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
    final Widget page = switch (settings.name) {
      // TV1 — chưa làm
      AppRoutes.dashboard => const PlaceholderScreen(title: 'Trang chủ', owner: 'TV1 (Đạt)'),
      AppRoutes.sessionExpired => StepUpPlaceholderScreen(reason: args as String?),

      // TV2 — lưu thông
      AppRoutes.circulationDesk => const CirculationDeskScreen(),
      AppRoutes.checkoutScan => const CheckoutScanScreen(),
      AppRoutes.checkoutReview => CheckoutReviewScreen(session: args as CheckoutSession),
      AppRoutes.checkoutConflict => CheckoutConflictScreen(copies: args as List<BookCopy>),
      AppRoutes.returnScan => ReturnScanScreen(openCamera: args == true),
      AppRoutes.returnResult => ReturnResultScreen(result: args as ReturnOutcome),
      AppRoutes.renewalRequest => const RenewalRequestScreen(),
      AppRoutes.renewalResult => RenewalResultScreen(results: args as List<RenewalItemResult>),

      // TV2 — hư hỏng, mất
      AppRoutes.damageForm => DamageReportFormScreen(initialCopyCode: args as String?),
      AppRoutes.damageDetail => DamageReportDetailScreen(args: args as DamageDetailArgs, isAdmin: AppSession.isAdmin),
      AppRoutes.lostRecord => LostRecordScreen(args: args),
      AppRoutes.foundAfterLost => const FoundAfterLostScreen(),

      // TV2 — đặt trước
      AppRoutes.reservationSearch => const ReservationShell(),
      AppRoutes.reservationQueue => const ReservationShell(initialTab: 1),
      AppRoutes.reservationForm => ReservationFormScreen(title: args as TitleItem),
      AppRoutes.reservationPickup => ReservationPickupScreen(reservation: args as Reservation?),

      // TV2 — báo cáo
      AppRoutes.reportDashboard => const ReportDashboardScreen(),
      AppRoutes.overdueList => const OverdueListScreen(),
      AppRoutes.trendDashboard => const TrendDashboardScreen(),

      // TV3 — chưa làm
      AppRoutes.finePayment => const PlaceholderScreen(title: 'Thu phạt', owner: 'TV3 (Bảo)'),

      _ => const PlaceholderScreen(), // màn chưa làm -> trang tạm
    };
    return MaterialPageRoute(builder: (_) => page, settings: settings);
  }
}
