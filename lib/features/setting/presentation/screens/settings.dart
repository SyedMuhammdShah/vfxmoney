import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vfxmoney/features/theme/bloc/theme_bloc.dart';
import 'package:vfxmoney/features/theme/bloc/theme_event.dart';
import 'package:vfxmoney/features/theme/bloc/theme_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        bool isDark = themeState.themeMode == ThemeMode.dark;

        return Scaffold(
          appBar: AppBar(title: const Text("Settings"), centerTitle: true),

          /// BODY
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(isDark ? Icons.dark_mode : Icons.light_mode, size: 28),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        isDark ? "Dark Mode" : "Light Mode",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),

                    /// Toggle Button
                    BlocBuilder<ThemeBloc, ThemeState>(
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
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
