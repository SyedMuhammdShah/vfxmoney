import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vfxmoney/core/extensions/text_theme_extension.dart';
import 'package:vfxmoney/core/extensions/theme_extension.dart';
import 'package:vfxmoney/core/validators/phone_formatter.dart';
import 'package:vfxmoney/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vfxmoney/features/auth/presentation/bloc/auth_events.dart';
import 'package:vfxmoney/features/auth/presentation/bloc/auth_state.dart';
import 'package:vfxmoney/shared/widgets/custom_appbar.dart';
import 'package:vfxmoney/shared/widgets/gap.dart';
import 'package:vfxmoney/shared/widgets/push_button.dart';
import 'package:vfxmoney/shared/widgets/toast.dart';
import '../../../../core/navigation/route_enums.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController otpController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  String source = "login";
  String verificationType = "email";
  String userEmail = "";
  String? otpToken;
  bool _initialized = false;

  Timer? _timer;
  int _secondsRemaining = 30;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      final args =
          GoRouterState.of(context).extra as Map<String, dynamic>? ?? {};

      source = args["source"] ?? "login";
      verificationType = args["verificationType"] ?? "email";
      userEmail = args["email"] ?? '';
      _startTimer();
      _initialized = true;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    otpController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsRemaining = 30);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
      }
    });
  }

  void _sendOtp() {
    if (verificationType == 'email') {
      context.read<AuthBloc>().add(const SendEmailOtpEvent(''));
    } else {
      context.read<AuthBloc>().add(const SendPhoneOtpEvent(''));
    }
  }

  void handleResend() {
    if (_secondsRemaining == 0) {
      _startTimer();
      _sendOtp();
    }
  }

  void handleBack() {
    context.goNamed(Routes.verifyAccount.name);
  }

  void handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final otp = otpController.text;

      if (source == "login") {
        // For login, use the email from navigation extra
        final email = userEmail as String? ?? '';
        context.read<AuthBloc>().add(
          VerifyLoginOtpEvent(otp: otp, email: email),
        );
      } else {
        if (verificationType == 'email') {
          context.read<AuthBloc>().add(
            VerifyEmailOtpEvent(otp: otp, token: otpToken ?? ''),
          );
        } else {
          context.read<AuthBloc>().add(
            VerifyPhoneOtpEvent(otp: otp, token: otpToken ?? ''),
          );
        }
      }
    }
  }

  String _getSubtitle() {
    if (verificationType == 'email') {
      return userEmail.isNotEmpty
          ? 'Enter the code sent to your: $userEmail'
          : 'Enter the code sent to your email';
    } else {
      return userEmail.isNotEmpty
          ? 'Enter the code sent to your:  ${PhoneFormatter.formatUS(userEmail)}'
          : 'Enter the code sent to your phone number';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is OtpSent) {
          showToast(msg: state.message);
        } else if (state is Authenticated) {
          showToast(
            msg: verificationType == 'email'
                ? 'Email verified successfully!'
                : 'Phone verified successfully!',
          );

          Future.delayed(const Duration(milliseconds: 500), () {
            final authUser = state.authUser;

            if (context.mounted) {
              if (source == "login") {
                context.goNamed(
                  Routes.loginSuccess.name,
                  extra: {
                    "title": "Login Successful!",
                    "subtitle": "Welcome back, you are logged in successfully.",
                    "source": "login",
                  },
                );
              } else if (source == "signup") {
                if ((authUser.user?.isEmailVerified ?? false) &&
                    (authUser.user?.isPhoneVerified ?? false)) {
                  context.goNamed(
                    Routes.loginSuccess.name,
                    extra: {
                      "title": "Phone Number and Email verified.",
                      "subtitle":
                          "You have successfully verified your account.",
                      "source": "signup",
                    },
                  );
                } else {
                  context.goNamed(Routes.verifyAccount.name);
                }
              }
            }
          });
        } else if (state is AuthError) {
          errorToast(msg: state.message);
        }
      },

      builder: (context, state) {
        final isLoading = state is AuthLoading || state is OtpSending;

        return SafeArea(
          child: Scaffold(
            // appBar: RoundedAppBarWithProfile(
            //   height: 80,
            //   title: "Verification",
            //   titleSize: 25,
            //   subTitle: _getSubtitle(),
            //   subTitleSize: 13,
            //   alignTitleCenter: true,
            //   showNameLocation: false,
            //   showProfileImage: false,
            //   showIcons: true,
            //   titleColor: Colors.white,
            // ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Gap(20),
                      // Form(
                      //   key: _formKey,
                      //   child: Pinput(
                      //     controller: otpController,
                      //     length: 4,
                      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //     keyboardType: TextInputType.number,
                      //     autofocus: true,
                      //     enabled: !isLoading,
                      //     validator: (v) {
                      //       if (v?.isEmpty ?? false) {
                      //         return "Please fill the field";
                      //       }
                      //       if (v?.length != 4) {
                      //         return "Please enter 4 digits";
                      //       }
                      //       return null;
                      //     },
                      //     defaultPinTheme: PinTheme(
                      //       height: 56,
                      //       width: 56,
                      //       decoration: BoxDecoration(
                      //         color: context.colors.onPrimary,
                      //         borderRadius: BorderRadius.circular(12),
                      //       ),
                      //     ),
                      //     focusedPinTheme: PinTheme(
                      //       height: 56,
                      //       width: 56,
                      //       decoration: BoxDecoration(
                      //         color:
                      //             context.theme.inputDecorationTheme.fillColor,
                      //         border: Border.all(
                      //           color: context.colors.secondary,
                      //           width: 1,
                      //         ),
                      //         borderRadius: BorderRadius.circular(12),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(height: 30),

                      /// Resend timer text
                      Text.rich(
                        textAlign: TextAlign.center,
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "Didn't receive the OTP? ",
                              style: context.labelMedium?.copyWith(
                                color: context.colors.secondary,
                              ),
                            ),
                            if (_secondsRemaining > 0)
                              TextSpan(
                                text:
                                    "Resend in 0:${_secondsRemaining.toString().padLeft(2, '0')}",
                                style: context.labelMedium?.copyWith(
                                  color: context.colors.primary,
                                ),
                              )
                            else
                              TextSpan(
                                text: "Resend",
                                recognizer: TapGestureRecognizer()
                                  ..onTap = isLoading ? null : handleResend,
                                style: context.labelMedium?.copyWith(
                                  decoration: TextDecoration.underline,
                                  color: isLoading
                                      ? Colors.grey
                                      : context.colors.primary,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),

                      /// Verify button
                      SizedBox(
                        width: double.infinity,
                        child: AppSubmitButton(
                          title: "Verify",
                          onTap: isLoading ? () {} : handleSubmit,
                        ),
                      ),
                    ],
                  ),
                ),

                /// Loading Overlay
                if (isLoading)
                  Container(
                    color: Colors.black.withValues(alpha: 0.5),
                    child: Center(
                      child: Card(
                        margin: const EdgeInsets.symmetric(horizontal: 50),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                state is OtpSending
                                    ? 'Sending OTP...'
                                    : 'Verifying...',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
