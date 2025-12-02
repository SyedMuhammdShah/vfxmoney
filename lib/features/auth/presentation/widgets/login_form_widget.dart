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

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(_email.text.trim(), _password.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color textColor = Theme.of(context).colorScheme.onSurface;

    return Form(
      key: _formKey,
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

          AppSubmitButton(title: "Login", onTap: _handleSubmit),
        ],
      ),
    );
  }
}
