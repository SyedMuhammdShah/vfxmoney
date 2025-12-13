import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vfxmoney/core/validators/form_validators.dart';
import 'package:vfxmoney/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vfxmoney/features/auth/presentation/bloc/auth_state.dart';
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

  @override
  void initState() {
    super.initState();
    _email.addListener(_validateForm);
    _password.addListener(_validateForm);
  }

  void _validateForm() {
    final emailError = FormValidators.validateEmail(_email.text);
    final passwordError = FormValidators.validatePassword(_password.text);
    final nextValid = emailError == null && passwordError == null;
    if (nextValid != _isValid) {
      setState(() => _isValid = nextValid);
    }
  }

  void _handleSubmit() {
    final isFormValid = _formKey.currentState?.validate() ?? false;
    if (!isFormValid) {
      setState(() {});
      return;
    }
    widget.onSubmit(_email.text.trim(), _password.text.trim());
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
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isSubmitting = state is AuthLoading;

        return Form(
          key: _formKey,
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
              Opacity(
                opacity: _isValid && !isSubmitting ? 1.0 : 0.6,
                child: AbsorbPointer(
                  absorbing: !_isValid || isSubmitting,
                  child: AppSubmitButton(
                    title: isSubmitting ? 'Please wait...' : "Login",
                    onTap: _handleSubmit,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
