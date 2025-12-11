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
  bool _isDialogShowing = false;

  void _onLoginSubmit(String email, String password) {
    final bloc = context.read<AuthBloc>();
    bloc.add(LoginRequested(email: email, password: password));
  }

  void _onSignupSubmit() {
    context.pushReplacementNamed(Routes.dashboard.name);
  }

  void _showLoader() {
    if (_isDialogShowing) return;
    _isDialogShowing = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
  }

  void _hideLoader() {
    if (!_isDialogShowing) return;
    _isDialogShowing = false;
    try {
      if (Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    } catch (_) {}
  }

  // Simple OTP dialog — show verification code for testing (remove showing code in prod)
  void _showOtpDialog(String title, String message, String? code) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final TextEditingController otpController = TextEditingController(
          text: '',
        );
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message),
              const SizedBox(height: 8),
              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'Enter OTP'),
              ),
              if (code != null) ...[
                const SizedBox(height: 8),
                Text(
                  'DEBUG OTP: $code', // show for dev/test, remove for prod
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // For now we just close and navigate — implement verify call if available
                Navigator.of(context).pop();
                // If you have verification endpoint, dispatch event to verify here.
                context.pushReplacementNamed(Routes.dashboard.name);
              },
              child: const Text('Proceed'),
            ),
          ],
        );
      },
    );
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
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              // Logging
              debugPrint('[UI] Auth state => $state');

              // Manage loader visibility
              if (state is AuthLoading) {
                _showLoader();
                return;
              } else {
                _hideLoader();
              }

              if (state is AuthSuccess) {
                // Normal success -> navigate to dashboard
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  context.pushReplacementNamed(Routes.dashboard.name);
                });
              } else if (state is AuthOtpSent) {
                // Account pending -> show OTP popup using the user info
                final user = state.user;
                final message = state.message;
                final debugCode =
                    (user.emailVerificationCode != null &&
                        user.emailVerificationCode!.isNotEmpty)
                    ? user.emailVerificationCode
                    : null;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _showOtpDialog('Verify Account', message, debugCode);
                });
              } else if (state is AuthFailure) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
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
                          ? _buildLoginWithBloc(state)
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

  Widget _buildLoginWithBloc(AuthState state) {
    return Column(
      key: const ValueKey("login"),
      children: [
        LoginFormWidget(
          key: const ValueKey("login_form_widget"),
          onSubmit: (String email, String password) {
            _onLoginSubmit(email, password);
          },
        ),
        const SizedBox(height: 12),
        // optional inline indicator while AuthLoading
        if (state is AuthLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }

  Widget _buildLogo() {
    return SizedBox(width: 80, height: 80, child: Image.asset(AppIcons.logo));
  }
}
