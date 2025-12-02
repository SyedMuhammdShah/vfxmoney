import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:vfxmoney/core/constants/app_icons.dart';
import 'package:vfxmoney/core/navigation/route_enums.dart';
import 'package:vfxmoney/features/auth/presentation/bloc/auth_events.dart';
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

  /// This callback will be passed to LoginFormWidget.
  /// Assumes LoginFormWidget calls onSubmit(email, password).
  void _onLoginSubmit(String email, String password) {
    // Dispatch login event to bloc
    final bloc = context.read<AuthBloc>();
    bloc.add(LoginRequested(email: email, password: password));
  }

  /// When signup form submits — keep existing behavior (navigate or implement signup flow).
  void _onSignupSubmit() {
    // placeholder: after signup you might want to navigate or dispatch signup event
    // For now follow the previous behaviour:
    context.pushNamed(Routes.dashboard.name);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = Theme.of(context).colorScheme.onSurface;
    final Color secondaryTextColor = Theme.of(context).colorScheme.secondary;

    return BlocProvider<AuthBloc>(
      create: (_) => locator<AuthBloc>(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthLoading) {
                // optional: show progress indicator via overlay/snack or setState
                // We'll show a simple snackbar (and remove it when done)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Logging in...'),
                    duration: Duration(seconds: 20),
                  ),
                );
              } else {
                // remove any lingering 'Logging in...' snackbars
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              }

              if (state is AuthSuccess) {
                // Navigate to dashboard on successful login
                context.pushNamed(Routes.dashboard.name);
              } else if (state is AuthFailure) {
                // Show failure message
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
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
                        ? _buildLoginWithBloc()
                        : SignupFormWidget(
                            key: const ValueKey("signup"),
                            onSubmit: _onSignupSubmit,
                          ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginWithBloc() {
    return Column(
      key: const ValueKey("login"),
      children: [
        // Login form that calls back with email & password
        LoginFormWidget(
          key: const ValueKey("login_form_widget"),
          onSubmit: (String email, String password) {
            _onLoginSubmit(email, password);
          },
        ),

        const SizedBox(height: 12),

        // Show inline loading indicator while bloc is in AuthLoading
        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: CircularProgressIndicator(),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
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
