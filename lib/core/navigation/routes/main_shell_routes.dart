import 'package:go_router/go_router.dart';
import 'package:vfxmoney/core/navigation/app_router.dart';
import 'package:vfxmoney/core/navigation/route_enums.dart';
import 'package:vfxmoney/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:vfxmoney/features/dashboard/presentation/screens/my_card_screen.dart';
import 'package:vfxmoney/features/dashboard/presentation/screens/profile_screen.dart';
import 'package:vfxmoney/features/dashboard/presentation/screens/transactions_screen.dart';
import 'package:vfxmoney/shared/widgets/bottom_sheet.dart';
import 'package:vfxmoney/shared/widgets/generic_popup_widget.dart';

final StatefulShellRoute mainShellRoutes = StatefulShellRoute.indexedStack(
  parentNavigatorKey: AppRouter.rootNavigatorKey,
  branches: <StatefulShellBranch>[
    /* ----------  1. Bookings  ---------- */
    StatefulShellBranch(
      routes: [
        GoRoute(
          name: Routes.dashboard.name,
          path: Routes.dashboard.path,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: DashboardScreen()),
        ),
      ],
    ),

    /* ----------  2. Payments  ---------- */
    StatefulShellBranch(
      routes: [
        GoRoute(
          name: Routes.myCard.name,
          path: Routes.myCard.path,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: MyCardScreen()),
        ),
      ],
    ),

    /* ----------  3. Add (Dummy branch)  ---------- */
    StatefulShellBranch(
      routes: [
        GoRoute(
          name: 'add', // Add a dummy route for the center button
          path: '/add',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: DashboardScreen()),
        ),
      ],
    ),

    /* ----------  4. History  ---------- */
    StatefulShellBranch(
      routes: [
        GoRoute(
          name: Routes.transactions.name,
          path: Routes.transactions.path,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: TransactionsScreen()),
        ),
      ],
    ),

    /* ----------  5. Profile  ---------- */
    StatefulShellBranch(
      routes: [
        GoRoute(
          name: Routes.profile.name,
          path: Routes.profile.path,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: ProfileScreen()),
        ),
      ],
    ),
  ],

  builder: (context, state, navigationShell) =>
      CustomBottomBar(navigationShell: navigationShell),
);
