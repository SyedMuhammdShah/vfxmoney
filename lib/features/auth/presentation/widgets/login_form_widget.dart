import 'package:flutter/material.dart';
import 'package:vfxmoney/core/constants/app_colors.dart';
import 'package:vfxmoney/core/validators/form_validators.dart';
import 'package:vfxmoney/shared/widgets/app_text.dart';
import 'package:vfxmoney/shared/widgets/input_field.dart';
import 'package:vfxmoney/shared/widgets/push_button.dart';

class LoginFormWidget extends StatefulWidget {
  final void Function(String email, String password) onSubmit;

  const LoginFormWidget({super.key, required this.onSubmit});

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscurePassword = true;
  bool _isValid = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // validate on every text change
    _email.addListener(_validateForm);
    _password.addListener(_validateForm);
  }

  void _validateForm() {
    // Run simple synchronous validators to avoid relying on FormState before first build.
    final emailError = FormValidators.validateEmail(_email.text);
    final passwordError = FormValidators.validatePassword(_password.text);

    final nextValid = emailError == null && passwordError == null;
    if (nextValid != _isValid) {
      setState(() {
        _isValid = nextValid;
      });
    }
  }

  void _handleSubmit() {
    // prevent double submit
    if (_isSubmitting) return;

    // final validation via FormState for consistent error display
    final isFormValid = _formKey.currentState?.validate() ?? false;
    if (!isFormValid) {
      // ensure UI shows errors
      setState(() {});
      return;
    }

    setState(() => _isSubmitting = true);

    widget.onSubmit(_email.text.trim(), _password.text.trim());

    // NOTE: it's caller's responsibility (Bloc/listener) to navigate / show errors.
    // you may reset _isSubmitting when the login result arrives (e.g., via BlocListener).
  }

  @override
  void dispose() {
    _email.removeListener(_validateForm);
    _password.removeListener(_validateForm);
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      // show validation errors after user interacts
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
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
            isPassword: true,
            validator: FormValidators.validatePassword,
            onToggleObscure: () {
              setState(() => _obscurePassword = !_obscurePassword);
            },
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: AppText(
              'Forget Password?',
              fontSize: 12,
              color: Theme.of(context).colorScheme.secondary,
              textStyle: 'jb',
              w: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 28),

          // Disable button visually + block taps when form invalid or submitting.
          Opacity(
            opacity: _isValid && !_isSubmitting ? 1.0 : 0.6,
            child: AbsorbPointer(
              absorbing: !_isValid || _isSubmitting,
              child: AppSubmitButton(
                title: _isSubmitting ? 'Please wait...' : "Login",
                onTap: _handleSubmit,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
  