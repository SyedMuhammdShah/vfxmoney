import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vfxmoney/core/navigation/route_enums.dart';
import 'package:vfxmoney/core/extensions/text_theme_extension.dart';
import 'package:vfxmoney/shared/widgets/push_button.dart';

class SuccessScreen extends StatefulWidget {
  final String title;
  final String subtitle;
  final bool showButton;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final String? routeName;
  final Map<String, String>? routeParams;

  const SuccessScreen({
    super.key,
    required this.title,
    required this.subtitle,
    this.showButton = false, // default: no button
    this.buttonText,
    this.onButtonPressed,
    this.routeName,
    this.routeParams,
  });

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  String? source;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get extra from GoRouter
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
    source = extra?['source'];
  }

  void _handleNavigation(BuildContext context) {
    if (source == "login") {
      context.goNamed(Routes.dashboard.name);
    } else if (source == "signup") {
      context.goNamed(Routes.enableLocationScreen.name);
    } else if (source == "deleteAccount") {
      context.goNamed(Routes.login.name);
    } else {
      context.goNamed(Routes.dashboard.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2FBF9), // Light greenish background
      body: InkWell(
        onTap: () {
          _handleNavigation(context);
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Green check icon
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: const Icon(Icons.check, color: Colors.white, size: 40),
                ),
                const SizedBox(height: 24),

                // Title
                Text(
                  widget.title,
                  style: context.headlineLarge?.copyWith(),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                // Subtitle
                Text(
                  widget.subtitle,
                  style: context.bodyMedium?.copyWith(),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                if (widget.showButton)
                  SizedBox(
                    width: double.infinity,
                    child: AppSubmitButton(
                      title: widget.buttonText ?? "Continue",
                      onTap:
                          widget.onButtonPressed ??
                          () {
                            _handleNavigation(context);
                          },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
