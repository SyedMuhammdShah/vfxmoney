import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vfxmoney/core/constants/app_colors.dart';
import 'package:vfxmoney/core/navigation/route_enums.dart';
import 'package:vfxmoney/core/validators/form_validators.dart';
import 'package:vfxmoney/shared/widgets/input_field.dart';
import 'package:vfxmoney/shared/widgets/push_button.dart';

/// Pixel-perfect login / register toggle screen
class VortexAuthScreen extends StatefulWidget {
  const VortexAuthScreen({super.key});

  @override
  State<VortexAuthScreen> createState() => _VortexAuthScreenState();
}

class _VortexAuthScreenState extends State<VortexAuthScreen> {
  bool _isLogin =
      false; // false = register (left tab), true = login (right tab)

  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _repeatPassword = TextEditingController();

  bool _termsChecked = false;
  bool _obscurePassword = true;
  bool _obscureRepeatPassword = true;

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _password.dispose();
    _repeatPassword.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (!_isLogin && !_termsChecked) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please accept Terms & Privacy Policy')),
        );
        return;
      } else {
        context.pushNamed(Routes.dashboard.name);
      }
      // TODO: Implement auth logic
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  // Vortex Logo
                  _buildLogo(),

                  const SizedBox(height: 24),

                  // Title
                  Text(
                    _isLogin
                        ? 'Login Your Account Vortex'
                        : 'Sign Up Your Account Vortex',
                    style: const TextStyle(
                      fontFamily: 'HubotSans',
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  // Subtitle
                  Text(
                    _isLogin
                        ? 'Enter Your Credentials To Access Your Account'
                        : 'Fill In The Details To Create Your Account',
                    style: const TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 12,
                      color: AppColors.greytextColor,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 28),

                  // Tab Switcher
                  _buildTabSwitcher(),

                  const SizedBox(height: 24),

                  // Form Fields
                  if (!_isLogin) ...[
                    AppInputField(
                      controller: _firstName,
                      hintText: 'First Name',
                      validator: FormValidators.validateFullName,
                    ),
                    const SizedBox(height: 12),
                    AppInputField(
                      controller: _lastName,
                      hintText: 'Last Name',
                      validator: FormValidators.validateFullName,
                    ),
                    const SizedBox(height: 12),
                  ],

                  AppInputField(
                    controller: _email,
                    hintText: 'Email Address',
                    keyboardType: TextInputType.emailAddress,
                    validator: FormValidators.validateEmail,
                  ),

                  const SizedBox(height: 12),

                  AppInputField(
                    controller: _password,
                    hintText: 'Password',
                    obscureText: _obscurePassword,
                    validator: FormValidators.validatePhoneNumber,

                    isPassword: true,
                    onToggleObscure: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),

                  if (!_isLogin) ...[
                    const SizedBox(height: 12),
                    AppInputField(
                      controller: _repeatPassword,
                      hintText: 'Repeat Password',
                      obscureText: _obscureRepeatPassword,
                      validator: FormValidators.validatePhoneNumber,
                      isPassword: true,
                      onToggleObscure: () {
                        setState(
                          () =>
                              _obscureRepeatPassword = !_obscureRepeatPassword,
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Terms Checkbox
                    _buildTermsRow(),
                  ],

                  if (_isLogin) ...[
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () {
                          // TODO: Forgot password
                        },
                        child: const Text(
                          'Forget Password?',
                          style: TextStyle(
                            fontFamily: 'JetBrainsMono',
                            fontSize: 12,
                            color: AppColors.bgGreyColor,
                          ),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 28),

                  // Submit Button
                  AppSubmitButton(
                    title: _isLogin ? "Login" : "Register",
                    onTap: _submit,
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

  Widget _buildLogo() {
    return SizedBox(
      width: 80,
      height: 80,
      child: CustomPaint(painter: VortexLogoPainter()),
    );
  }

  Widget _buildTabSwitcher() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.bgGreyColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          // Register Tab
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isLogin = false),
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: !_isLogin ? AppColors.greenVelvet : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    'Register',
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: !_isLogin ? AppColors.black : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Login Tab
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isLogin = true),
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: _isLogin ? AppColors.greenVelvet : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: _isLogin ? AppColors.black : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: Checkbox(
            value: _termsChecked,
            onChanged: (v) => setState(() => _termsChecked = v ?? false),
            side: const BorderSide(color: AppColors.greytextColor),
            activeColor: AppColors.greenVelvet,
            checkColor: AppColors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text.rich(
            TextSpan(
              style: const TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 12,
                color: AppColors.greytextColor,
              ),
              children: [
                const TextSpan(text: 'I Agree With '),
                TextSpan(
                  text: 'Terms Of Use',
                  style: const TextStyle(color: AppColors.greenVelvet),
                  recognizer: TapGestureRecognizer()..onTap = () {},
                ),
                const TextSpan(text: ', '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: const TextStyle(color: AppColors.greenVelvet),
                  recognizer: TapGestureRecognizer()..onTap = () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Custom painter for the Vortex logo
class VortexLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw the V shape with gradient effect
    final path = Path();

    // Main V shape - left arm
    paint.color = const Color(0xFF4ADE80);
    path.moveTo(size.width * 0.1, size.height * 0.15);
    path.lineTo(size.width * 0.5, size.height * 0.85);
    path.lineTo(size.width * 0.5, size.height * 0.65);
    path.lineTo(size.width * 0.25, size.height * 0.15);
    path.close();
    canvas.drawPath(path, paint);

    // Right arm
    final path2 = Path();
    path2.moveTo(size.width * 0.9, size.height * 0.15);
    path2.lineTo(size.width * 0.5, size.height * 0.85);
    path2.lineTo(size.width * 0.5, size.height * 0.65);
    path2.lineTo(size.width * 0.75, size.height * 0.15);
    path2.close();
    canvas.drawPath(path2, paint);

    // Checkmark overlay (darker green)
    paint.color = const Color(0xFF22C55E);
    final checkPath = Path();
    checkPath.moveTo(size.width * 0.35, size.height * 0.45);
    checkPath.lineTo(size.width * 0.5, size.height * 0.65);
    checkPath.lineTo(size.width * 0.85, size.height * 0.2);
    checkPath.lineTo(size.width * 0.75, size.height * 0.15);
    checkPath.lineTo(size.width * 0.5, size.height * 0.45);
    checkPath.lineTo(size.width * 0.4, size.height * 0.35);
    checkPath.close();
    canvas.drawPath(checkPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
