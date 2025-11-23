import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vfxmoney/core/extensions/text_theme_extension.dart';
import 'package:vfxmoney/core/extensions/theme_extension.dart';
import 'package:vfxmoney/core/formators/email_formator.dart';
import 'package:vfxmoney/core/navigation/route_enums.dart';
import 'package:vfxmoney/core/services/service_locator.dart';
import 'package:vfxmoney/core/services/storage_service.dart';
import 'package:vfxmoney/shared/widgets/custom_appbar.dart';
import 'package:vfxmoney/shared/widgets/custom_loader.dart';
import 'package:vfxmoney/shared/widgets/gap.dart';
import 'package:vfxmoney/shared/widgets/push_button.dart';
import 'package:vfxmoney/features/auth/presentation/bloc/delete_bloc/delete_account_bloc.dart';
import 'package:vfxmoney/shared/widgets/toast.dart';

class DeleteOtpScreen extends StatefulWidget {
  const DeleteOtpScreen({super.key});

  @override
  State<DeleteOtpScreen> createState() => _DeleteOtpScreenState();
}

class _DeleteOtpScreenState extends State<DeleteOtpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController otpController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final loader = CustomLoader();

  Timer? _timer;
  int _secondsRemaining = 30;
  String? reason;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
    reason = extra?['reason'];
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

  void _handleResend() {
    if (_secondsRemaining == 0) {
      _startTimer();
      // You can trigger the same event again to resend OTP
      context.read<DeleteAccountBloc>().add(
        SendDeleteOtpEvent(locator<StorageService>().getToken!),
      );
    }
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      context.read<DeleteAccountBloc>().add(
        SubmitDeleteAccountEvent(
          otp: otpController.text.trim(),
          reason: reason ?? '',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final storage = locator<StorageService>();
    final userEmail = storage.getUser?.email;
    final maskedEmail = maskEmail(userEmail);
    return BlocListener<DeleteAccountBloc, DeleteAccountState>(
      listener: (context, state) {
        if (state is DeleteAccountLoading) {
          loader.show(context);
        } else {
          loader.hide();
        }

        if (state is DeleteAccountError) {
          showToast(msg: state.message);
        }

        if (state is DeleteAccountSuccess) {
          context.goNamed(
            Routes.deleteAccountSuccess.name,
            extra: {'source': 'deleteAccount'},
          );
        }
      },
      child: SafeArea(
        child: Scaffold(
          // appBar: RoundedAppBarWithProfile(
          //   height: 60,
          //   title: "Delete Account",
          //   subTitle: maskedEmail,
          //   alignTitleCenter: true,
          //   showNameLocation: false,
          //   showProfileImage: false,
          //   showIcons: true,
          //   titleColor: Colors.white,
          // ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  "To permanently delete your account, please enter the 4 digit code sent to your email.",
                ),
                const Gap(20),
                // Form(
                //   key: _formKey,
                //   child: Pinput(
                //     controller: otpController,
                //     focusNode: focusNode,
                //     length: 4,
                //     keyboardType: TextInputType.number,
                //     autofocus: true,
                //     validator: (v) {
                //       if (v == null || v.isEmpty) {
                //         return "Please fill the field";
                //       }
                //       if (v.length != 4) return "Please enter 4 digits";
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
                //         color: context.theme.inputDecorationTheme.fillColor,
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
                Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Didn’t receive the OTP? ",
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
                            ..onTap = _handleResend,
                          style: context.labelMedium?.copyWith(
                            decoration: TextDecoration.underline,
                            color: context.colors.primary,
                            decorationColor: context.colors.primary,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: AppSubmitButton(
                    title: "Delete Now",
                    onTap: _handleSubmit,
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
