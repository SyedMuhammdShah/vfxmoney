import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vfxmoney/core/navigation/route_enums.dart';
import 'package:vfxmoney/core/services/storage_service.dart';
import 'package:vfxmoney/core/services/service_locator.dart';
import 'package:vfxmoney/features/auth/data/auth_model/auth_user_model.dart';

class UserSessionManager {
  final StorageService _storage = locator<StorageService>();

  Future<void> validateAndRedirect(
    BuildContext context, {
    Duration initialDelay = const Duration(seconds: 3),
    Duration userWaitTimeout = const Duration(seconds: 2),
    Duration pollInterval = const Duration(milliseconds: 250),
  }) async {
    // Keep the splash delay (animation) — caller can override if needed.
    if (initialDelay > Duration.zero) await Future.delayed(initialDelay);

    if (!context.mounted) return;

    // Read token and login flag quickly
    final token = _storage.getToken;
    final isLoggedIn = _storage.isLoggedIn();

    if (kDebugMode) {
      debugPrint('[UserSessionManager] token=$token isLoggedIn=$isLoggedIn');
    }

    // If there's no token and the user is not logged in -> onboarding
    if (token == null || token.isEmpty || !isLoggedIn) {
      _goTo(context, Routes.onboarding.name);
      return;
    }

    // Token exists (and/or isLoggedIn true). Try to get stored user:
    AuthUserModel? user = _storage.getUser;
    if (kDebugMode)
      debugPrint('[UserSessionManager] initial user from storage: $user');

    // If token present but user is null -> wait/poll a short time for persistence to complete.
    if (user == null) {
      final endAt = DateTime.now().add(userWaitTimeout);
      while (DateTime.now().isBefore(endAt)) {
        if (!context.mounted) return; // abort if screen gone
        // quick sleep
        await Future.delayed(pollInterval);
        user = _storage.getUser;
        if (user != null) break;
      }
      if (kDebugMode) debugPrint('[UserSessionManager] post-wait user: $user');
    }

    // Final decision
    if (!context.mounted) return;

    if (user != null) {
      _goTo(context, Routes.dashboard.name);
    } else {
      // Defensive fallback: clear any partial state and route to onboarding
      try {
        await _storage.clearToken();
      } catch (_) {}
      _goTo(context, Routes.onboarding.name);
    }
  }

  void _goTo(BuildContext context, String routeName) {
    if (!context.mounted) return;
    // Use goNamed to replace location (go_router)
    context.goNamed(routeName);
  }
}
