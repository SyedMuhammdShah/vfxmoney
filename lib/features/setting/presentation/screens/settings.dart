import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vfxmoney/core/navigation/route_enums.dart';
import 'package:vfxmoney/core/services/service_locator.dart';
import 'package:vfxmoney/core/services/storage_service.dart';
import 'package:vfxmoney/features/theme/bloc/theme_bloc.dart';
import 'package:vfxmoney/features/theme/bloc/theme_event.dart';
import 'package:vfxmoney/features/theme/bloc/theme_state.dart';
import 'package:vfxmoney/shared/widgets/app_text.dart';
import 'package:vfxmoney/shared/widgets/custom_appbar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        bool isDark = themeState.themeMode == ThemeMode.dark;

        return Scaffold(
          appBar: CustomAppBar(title: "Settings", implyLeading: true),

          /// BODY
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Theme Toggle
              _buildSettingsTile(
                context,
                icon: isDark ? Icons.dark_mode : Icons.light_mode,
                title: isDark ? "Dark Mode" : "Light Mode",
                trailing: Switch(
                  value: isDark,
                  activeColor: Theme.of(context).colorScheme.primary,
                  onChanged: (_) {
                    context.read<ThemeBloc>().add(ToggleThemeEvent());
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Fee and Limit Tile
              _buildSettingsTile(
                context,
                icon: Icons.attach_money_rounded,
                title: "Fee and Limit",
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                onTap: () {
                  context.pushNamed(Routes.feesAndLimit.name);
                },
              ),

              const SizedBox(height: 16),

              // 🚪 LOGOUT BUTTON TILE
              _buildSettingsTile(
                context,
                icon: Icons.logout_rounded,
                title: "Logout",
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Theme.of(context).colorScheme.error,
                ),
                onTap: () => _handleLogout(context),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleLogout(BuildContext context) async {
    final storage = locator<StorageService>();

    /// Clear user session
    await storage.clear();

    /// Redirect to onboarding
    if (context.mounted) {
      context.goNamed(Routes.onboarding.name);
    }
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 20,
                color: title == "Logout"
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.primary,
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: AppText(
                title,
                fontSize: 16,
                color: title == "Logout"
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.onSurface,
                textStyle: 'hb',
                w: FontWeight.w500,
              ),
            ),

            trailing,
          ],
        ),
      ),
    );
  }
}
