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

// Replace your VortexAuthScreen state class with this version (only the state class shown)
class _VortexAuthScreenState extends State<VortexAuthScreen> {
  // show login by default to simplify testing
  bool _isLogin = true;
  bool _isDialogShowing = false; // track loader dialog

  late final AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    // Create a single bloc instance for this screen (avoid calling locator repeatedly)
    _authBloc = locator<AuthBloc>();
  }

  @override
  void dispose() {
    // If you created the bloc here, close it to release resources.
    // If you're sharing this bloc higher in the widget tree (e.g., app-level),
    // DO NOT close it here. Only close if you created it in initState as above.
    _authBloc.close();
    super.dispose();
  }

  void _onLoginSubmit(String email, String password) {
    debugPrint('[UI] Dispatching LoginRequested for $email via _authBloc');
    _authBloc.add(LoginRequested(email: email, password: password));
  }

  void _onSignupSubmit() {
    context.goNamed(Routes.dashboard.name);
  }

  void _showLoader() {
    if (_isDialogShowing) return;
    _isDialogShowing = true;
    showDialog(
      context: context,
      useRootNavigator: true,
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

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = Theme.of(context).colorScheme.onSurface;
    final Color secondaryTextColor = Theme.of(context).colorScheme.secondary;

    // Provide the same bloc instance we created in initState
    return BlocProvider<AuthBloc>.value(
      value: _authBloc,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: BlocConsumer<AuthBloc, AuthState>(
            listenWhen: (prev, cur) => prev != cur,
            listener: (context, state) {
              debugPrint('[UI] Auth state => $state');

              if (state is AuthLoading) {
                _showLoader();
                return;
              }

              // hide loader on any non-loading state
              _hideLoader();

              if (state is AuthSuccess) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!mounted) return;
                  debugPrint('[UI] navigating to dashboard (AuthSuccess)');
                  context.goNamed(Routes.dashboard.name);
                });
              } else if (state is AuthFailure) {
                final error = state.error;
                if (!mounted) return;
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(error)));
              } else if (state is AuthOtpSent) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!mounted) return;
                  context.goNamed(Routes.dashboard.name);
                });
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
  
      ],
    );
  }

  Widget _buildLogo() {
    return SizedBox(width: 80, height: 80, child: Image.asset(AppIcons.logo));
  }
}
