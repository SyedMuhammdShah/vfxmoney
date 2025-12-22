import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:vfxmoney/core/constants/app_colors.dart';
import 'package:vfxmoney/core/constants/app_icons.dart';
import 'package:vfxmoney/core/navigation/route_enums.dart';
import 'package:vfxmoney/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vfxmoney/features/auth/presentation/bloc/auth_events.dart';
import 'package:vfxmoney/features/auth/presentation/bloc/auth_state.dart';
import 'package:vfxmoney/shared/widgets/app_text.dart';
import 'package:vfxmoney/shared/widgets/push_button.dart';
import 'package:vfxmoney/shared/widgets/toast.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;
  final String? debugOtpCode;
  final String? tempToken;

  const OtpVerificationScreen({
    super.key,
    required this.email,
    this.debugOtpCode,
    required this.tempToken,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  bool _isVerifying = false;

  @override
  void dispose() {
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _otpCode => _otpControllers.map((c) => c.text).join();

  bool get _isOtpComplete => _otpCode.length == 6;

  void _onOtpChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    setState(() {});
  }

  void _onBackspace(int index, String value) {
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _verifyOtp() {
    if (!_isOtpComplete || _isVerifying) return;

    context.read<AuthBloc>().add(
      VerifyOtpRequested(
        email: widget.email,
        code: _otpCode,
        token: widget.tempToken.toString(),
      ),
    );
  }

  void _resendOtp() {
    // Optional: hook resend API here later
    successToast(msg: 'OTP resent to your email');
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = AppColors.bgBlack;
    final Color textColor = Colors.white;
    final Color secondaryTextColor = AppColors.greytextColor;
    final Color surfaceColor = const Color(0xFF1A1A1A);
    final Color primaryColor = AppColors.greenVelvet;
    final Color borderColor = const Color(0xFF2A2A2A);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthOtpVerifying) {
          setState(() => _isVerifying = true);
        } else {
          setState(() => _isVerifying = false);
        }

        if (state is AuthOtpVerified) {
          successToast(msg: 'Email verified successfully');
          context.pushReplacementNamed(Routes.dashboard.name);
        }

        if (state is AuthFailure) {
          errorToast(msg: state.error);
        }
      },
      child: Theme(
        data: ThemeData.dark().copyWith(
          primaryColor: primaryColor,
          scaffoldBackgroundColor: backgroundColor,
          colorScheme: const ColorScheme.dark().copyWith(
            primary: primaryColor,
            onSurface: Colors.white,
            secondary: AppColors.greytextColor,
            surface: surfaceColor,
          ),
        ),
        child: Scaffold(
          backgroundColor: backgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 50),

                  SizedBox(
                    width: 80,
                    height: 80,
                    child: Image.asset(AppIcons.logo),
                  ),

                  const SizedBox(height: 32),

                  AppText(
                    'Verify Your Email',
                    fontSize: 24,
                    color: textColor,
                    textStyle: 'hb',
                    w: FontWeight.w600,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 12),

                  AppText(
                    'Enter the 6-digit code sent to\n${widget.email}',
                    fontSize: 14,
                    color: secondaryTextColor,
                    textStyle: 'jb',
                    w: FontWeight.w400,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 40),

                  /// OTP INPUTS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(6, (index) {
                      return SizedBox(
                        width: 50,
                        height: 60,
                        child: TextField(
                          controller: _otpControllers[index],
                          focusNode: _focusNodes[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                            fontFamily: 'JetBrainsMono',
                          ),
                          decoration: InputDecoration(
                            counterText: '',
                            filled: true,
                            fillColor: surfaceColor,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: borderColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: primaryColor,
                                width: 2,
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            _onOtpChanged(index, value);
                            _onBackspace(index, value);
                          },
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 24),

                  /// DEBUG OTP
                  if (widget.debugOtpCode != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange),
                      ),
                      child: Column(
                        children: [
                          AppText(
                            'DEBUG OTP',
                            fontSize: 10,
                            color: Colors.orange,
                            textStyle: 'jb',
                            w: FontWeight.bold,
                          ),
                          const SizedBox(height: 4),
                          AppText(
                            widget.debugOtpCode!,
                            fontSize: 18,
                            color: Colors.orange,
                            textStyle: 'hb',
                            w: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  /// VERIFY BUTTON
                  Opacity(
                    opacity: _isOtpComplete && !_isVerifying ? 1.0 : 0.6,
                    child: AbsorbPointer(
                      absorbing: !_isOtpComplete || _isVerifying,
                      child: AppSubmitButton(
                        title: _isVerifying ? 'Verifying...' : 'Verify',
                        onTap: _verifyOtp,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// RESEND
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(
                        "Didn't receive the code? ",
                        fontSize: 14,
                        color: secondaryTextColor,
                        textStyle: 'jb',
                      ),
                      GestureDetector(
                        onTap: _resendOtp,
                        child: AppText(
                          'Resend',
                          fontSize: 14,
                          color: primaryColor,
                          textStyle: 'jb',
                          w: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
