import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vfxmoney/core/constants/app_icons.dart';
import 'package:vfxmoney/core/navigation/route_enums.dart';
import 'package:vfxmoney/shared/widgets/app_text.dart';
import 'package:vfxmoney/shared/widgets/push_button.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;
  final String? debugOtpCode;

  const OtpVerificationScreen({
    Key? key,
    required this.email,
    this.debugOtpCode,
  }) : super(key: key);

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
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String get _otpCode {
    return _otpControllers.map((c) => c.text).join();
  }

  bool get _isOtpComplete {
    return _otpCode.length == 6;
  }

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

  Future<void> _verifyOtp() async {
    if (!_isOtpComplete) return;

    setState(() => _isVerifying = true);

    try {
      // TODO: Implement your OTP verification API call here
      // final response = await apiService.post('/verify-otp', payload: {
      //   'email': widget.email,
      //   'otp': _otpCode,
      // });

      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        context.pushReplacementNamed(Routes.dashboard.name);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Verification failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isVerifying = false);
      }
    }
  }

  Future<void> _resendOtp() async {
    // TODO: Implement resend OTP API call
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('OTP resent to your email')));
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final secondaryTextColor = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 20),
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
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: secondaryTextColor.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface,
                      ),
                      onChanged: (value) {
                        _onOtpChanged(index, value);
                        _onBackspace(index, value);
                      },
                      onTap: () {
                        _otpControllers[index].clear();
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
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
                      Text(
                        'DEBUG MODE',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'OTP: ${widget.debugOtpCode}',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    "Didn't receive the code? ",
                    fontSize: 14,
                    color: secondaryTextColor,
                    textStyle: 'jb',
                    w: FontWeight.w400,
                  ),
                  GestureDetector(
                    onTap: _resendOtp,
                    child: AppText(
                      'Resend',
                      fontSize: 14,
                      color: Theme.of(context).primaryColor,
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
    );
  }
}
