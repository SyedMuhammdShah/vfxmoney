import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:vfxmoney/core/constants/app_icons.dart';
import 'package:vfxmoney/core/navigation/route_enums.dart';
import 'package:vfxmoney/features/auth/presentation/bloc/auth_events.dart';
import 'package:vfxmoney/features/auth/presentation/screens/otp_screen.dart';
import 'package:vfxmoney/features/auth/presentation/widgets/auth_tab_switcher.dart';
import 'package:vfxmoney/features/auth/presentation/widgets/login_form_widget.dart';
import 'package:vfxmoney/features/auth/presentation/widgets/signup_form_widget.dart';
import 'package:vfxmoney/shared/widgets/app_text.dart';

import 'package:vfxmoney/core/services/service_locator.dart';
import 'package:vfxmoney/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vfxmoney/features/auth/presentation/bloc/auth_state.dart';

class VortexAuthScreen extends StatefulWidget {
  const VortexAuthScreen({super.key});

  @override
  State<VortexAuthScreen> createState() => _VortexAuthScreenState();
}

class _VortexAuthScreenState extends State<VortexAuthScreen> {
  bool _isLogin = false;
  late final AuthBloc _authBloc; // Store the bloc instance

  @override
  void initState() {
    super.initState();
    _authBloc = locator<AuthBloc>();
    // Listen to bloc stream directly
    _authBloc.stream.listen((state) {
      debugPrint('[UI] 👂 Stream listener - State: ${state.runtimeType}');
      _handleAuthState(state);
    });
  }

  @override
  void dispose() {
    debugPrint('[UI] 🗑️ VortexAuthScreen dispose');
    _authBloc.close();
    super.dispose();
  }

  void _onLoginSubmit(String email, String password) {
    debugPrint('========================================');
    debugPrint('[UI] 🚀 Login button tapped');
    debugPrint('[UI] Email: $email');
    debugPrint('[UI] Bloc hashCode: ${_authBloc.hashCode}');
    debugPrint('========================================');

    _authBloc.add(LoginRequested(email: email, password: password));
  }

  void _onSignupSubmit() {
    context.pushReplacementNamed(Routes.dashboard.name);
  }

  void _handleAuthState(AuthState state) {
    debugPrint('========================================');
    debugPrint('[UI] 🎯 Handling state: ${state.runtimeType}');
    debugPrint('========================================');

    if (state is AuthSuccess) {
      debugPrint('[UI] ✅ AuthSuccess - Navigating to dashboard');

      if (mounted) {
        context.pushReplacementNamed(Routes.dashboard.name);
      }
    } else if (state is AuthOtpSent) {
      debugPrint('========================================');
      debugPrint('[UI] 🎉 AuthOtpSent DETECTED!!!');
      debugPrint('[UI] User email: ${state.user.email}');
      debugPrint('[UI] User status: ${state.user.status}');
      debugPrint('[UI] OTP Code: ${state.user.emailVerificationCode}');
      debugPrint('========================================');

      final email = state.user.email ?? 'No email';
      final otpCode = state.user.emailVerificationCode;

      if (mounted) {
        debugPrint('[UI] 🚀 Navigating to OTP screen...');
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              debugPrint('[UI] 📱 Building OtpVerificationScreen');
              return OtpVerificationScreen(email: email, debugOtpCode: otpCode);
            },
          ),
        );
      }
    } else if (state is AuthFailure) {
      debugPrint('[UI] ❌ AuthFailure: ${state.error}');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.error), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color textColor = Theme.of(context).colorScheme.onSurface;
    final Color secondaryTextColor = Theme.of(context).colorScheme.secondary;

    return BlocProvider<AuthBloc>.value(
      value: _authBloc, // Use .value to provide existing instance
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: BlocBuilder<AuthBloc, AuthState>(
            bloc: _authBloc, // Explicitly pass the bloc
            builder: (context, state) {
              debugPrint('[UI] 🎨 Builder - State: ${state.runtimeType}');

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: Image.asset(AppIcons.logo),
                    ),
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
                              key: const ValueKey("login_form_widget"),
                              onSubmit: _onLoginSubmit,
                            )
                          : SignupFormWidget(
                              key: const ValueKey("signup"),
                              onSubmit: _onSignupSubmit,
                            ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
