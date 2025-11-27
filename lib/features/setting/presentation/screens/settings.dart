import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vfxmoney/core/navigation/route_enums.dart';
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
              // Theme Toggle Tile
              _buildSettingsTile(
                context,
                icon: isDark ? Icons.dark_mode : Icons.light_mode,
                title: isDark ? "Dark Mode" : "Light Mode",
                trailing: BlocBuilder<ThemeBloc, ThemeState>(
                  builder: (context, state) {
                    return Switch(
                      value: state.themeMode == ThemeMode.dark,
                      activeColor: Theme.of(context).colorScheme.primary,
                      onChanged: (_) {
                        context.read<ThemeBloc>().add(ToggleThemeEvent());
                      },
                    );
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
                  // TODO: Navigate to Fee and Limit screen
                  context.pushNamed(Routes.feesAndLimit.name);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
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
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppText(
                title,
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurface,
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
