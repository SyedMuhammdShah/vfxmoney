import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vfxmoney/core/navigation/route_enums.dart';
import 'package:vfxmoney/core/services/storage_service.dart';
import 'package:vfxmoney/features/auth/data/auth_model/auth_user_model.dart';
import 'package:vfxmoney/core/services/service_locator.dart';

class UserSessionManager {
  final StorageService _storage = locator<StorageService>();

  Future<void> validateAndRedirect(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3));

    final token = _storage.getToken;
    final user = _storage.getUser;
    final isSocial = _storage.isSocialLogin;

    if (context.mounted) {
      if (token == null || token.isEmpty) {
        _go(context, Routes.onboarding.name);
        return;
      }

      if (user == null) {
        _go(context, Routes.onboarding.name);
        return;
      }

    }
  }


  void _go(
    BuildContext context,
    String routeName, {
    Map<String, dynamic>? extra,
  }) {
    if (context.mounted) {
      context.goNamed(routeName, extra: extra);
    }
  }
}
