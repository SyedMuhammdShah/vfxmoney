import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vfxmoney/core/constants/app_icons.dart';
import 'package:vfxmoney/core/navigation/route_enums.dart';
import 'package:vfxmoney/features/auth/presentation/widgets/auth_tab_switcher.dart';
import 'package:vfxmoney/features/auth/presentation/widgets/login_form_widget.dart';
import 'package:vfxmoney/features/auth/presentation/widgets/signup_form_widget.dart';

import 'package:vfxmoney/shared/widgets/app_text.dart';

class VortexAuthScreen extends StatefulWidget {
  const VortexAuthScreen({super.key});

  @override
  State<VortexAuthScreen> createState() => _VortexAuthScreenState();
}

class _VortexAuthScreenState extends State<VortexAuthScreen> {
  bool _isLogin = false;

  void _handleSubmit() {
    context.pushNamed(Routes.dashboard.name);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = Theme.of(context).colorScheme.onSurface;
    final Color secondaryTextColor = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 40),

              _buildLogo(),
              const SizedBox(height: 24),

              AppText(
                _isLogin
                    ? 'Login Your Account Vortex'
                    : 'Sign Up Your Account Vortex',
                fontSize: 24,
                color: textColor,
                textStyle: 'hb',
                w: FontWeight.w600,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              AppText(
                _isLogin
                    ? 'Enter Your Credentials To Access Your Account'
                    : 'Fill In The Details To Create Your Account',
                fontSize: 12,
                color: secondaryTextColor,
                textStyle: 'jb',
                w: FontWeight.w400,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 28),

              AuthTabSwitcher(
                isLogin: _isLogin,
                onLoginTap: () => setState(() => _isLogin = true),
                onRegisterTap: () => setState(() => _isLogin = false),
              ),

              const SizedBox(height: 28),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, anim) =>
                    FadeTransition(opacity: anim, child: child),
                child: _isLogin
                    ? LoginFormWidget(
                        key: const ValueKey("login"),
                        onSubmit: _handleSubmit,
                      )
                    : SignupFormWidget(
                        key: const ValueKey("signup"),
                        onSubmit: _handleSubmit,
                      ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return SizedBox(
      width: 80,
      height: 80,
      child: Image.asset(AppIcons.logo),
      //child: CustomPaint(painter: VortexLogoPainter()),
    );
  }
}
