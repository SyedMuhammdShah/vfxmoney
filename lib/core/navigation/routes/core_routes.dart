part of '../app_router.dart';

final coreRoutes = [
  GoRoute(
    name: Routes.root.name,
    path: Routes.root.path,
    builder: (context, state) => const SplashScreen(),
    pageBuilder: GoTransitions.fadeUpwards.call,
  ),

  GoRoute(
    path: Routes.notification.path,
    name: Routes.notification.name,
    builder: (context, state) => const NotificationScreen(),
  ),
];
