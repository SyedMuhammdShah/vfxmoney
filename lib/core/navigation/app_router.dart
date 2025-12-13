import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:go_transitions/go_transitions.dart';
import 'package:vfxmoney/core/navigation/routes/main_shell_routes.dart';
import 'package:vfxmoney/core/services/service_locator.dart';
import 'package:vfxmoney/core/theme/app_theme.dart';
import 'package:vfxmoney/features/auth/presentation/screens/change_pass_screen.dart';
import 'package:vfxmoney/features/auth/presentation/screens/edit_profile.dart';
import 'package:vfxmoney/features/auth/presentation/screens/forgot_pass_screen.dart';
import 'package:vfxmoney/features/auth/presentation/screens/login_screen.dart';
import 'package:vfxmoney/features/auth/presentation/screens/otp_screen.dart';
import 'package:vfxmoney/features/auth/presentation/screens/signup_screen.dart';
import 'package:vfxmoney/features/notification/presentation/screens/notification_screen.dart';
import 'package:vfxmoney/features/profile/presentation/screens/user_profile_screen.dart';
import 'package:vfxmoney/features/setting/presentation/screens/fees_&_limit.dart';
import 'package:vfxmoney/features/setting/presentation/screens/settings.dart';
import 'package:vfxmoney/shared/screens/onboarding_screen.dart';
import 'package:vfxmoney/shared/widgets/delete_account.dart';
import 'package:vfxmoney/shared/widgets/delete_otp_screen.dart';
import 'package:vfxmoney/shared/widgets/success_screen.dart';
import 'package:vfxmoney/shared/screens/splash_screen.dart';

import 'route_enums.dart';

part 'routes/core_routes.dart';
part 'routes/auth_routes.dart';
part 'routes/setting_routes.dart';

class AppRouter {
  static final rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: Routes.root.path,
    routerNeglect: true,
    debugLogDiagnostics: kDebugMode,
    routes: [...coreRoutes, ...authRoutes, mainShellRoutes,  ...settingRoutes],
  );
}
