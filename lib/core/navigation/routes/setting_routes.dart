part of '../app_router.dart';

final settingRoutes = [
  GoRoute(
    name: "settings",
    path: "/settings",
    builder: (context, state) => const SettingsScreen(),
  ),

  GoRoute(
    name: "feesAndLimit",
    path: "/feesAndLimit",
    builder: (context, state) => const FeesAndLimitScreen(),
  ),
];
