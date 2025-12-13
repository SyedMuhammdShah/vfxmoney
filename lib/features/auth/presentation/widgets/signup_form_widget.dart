import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vfxmoney/core/constants/app_colors.dart';
import 'package:vfxmoney/core/validators/form_validators.dart';
import 'package:vfxmoney/shared/widgets/app_text.dart';
import 'package:vfxmoney/shared/widgets/input_field.dart';
import 'package:vfxmoney/shared/widgets/push_button.dart';
import 'package:vfxmoney/shared/widgets/toast.dart';

class SignupFormWidget extends StatefulWidget {
  final VoidCallback onSubmit;

  const SignupFormWidget({super.key, required this.onSubmit});

  @override
  State<SignupFormWidget> createState() => _SignupFormWidgetState();
}

class _SignupFormWidgetState extends State<SignupFormWidget> {
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

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      if (!_termsChecked) {
        errorToast(msg: 'Please accept Terms & Privacy Policy');
        return;
      }
      widget.onSubmit();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color textColor = Theme.of(context).colorScheme.onSurface;
    final Color secondaryTextColor = Theme.of(context).colorScheme.secondary;
    final Color checkboxBorderColor = Theme.of(context).colorScheme.secondary;

    return Form(
      key: _formKey,
      child: Column(
        children: [
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
            validator: FormValidators.validatePhoneNumber,
            onToggleObscure: () {
              setState(() => _obscurePassword = !_obscurePassword);
            },
          ),
          const SizedBox(height: 12),

          AppInputField(
            controller: _repeatPassword,
            hintText: 'Repeat Password',
            obscureText: _obscureRepeatPassword,
            isPassword: true,
            validator: FormValidators.validatePhoneNumber,
            onToggleObscure: () {
              setState(() => _obscureRepeatPassword = !_obscureRepeatPassword);
            },
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Checkbox(
                value: _termsChecked,
                onChanged: (v) => setState(() => _termsChecked = v ?? false),
                side: BorderSide(color: checkboxBorderColor),
                activeColor: Theme.of(context).primaryColor,
                checkColor: Colors.black,
              ),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 12,
                      color: secondaryTextColor,
                    ),
                    children: [
                      const TextSpan(text: 'I Agree With '),
                      TextSpan(
                        text: 'Terms Of Use',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                      const TextSpan(text: ', '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          AppSubmitButton(title: "Register", onTap: _handleSubmit),
        ],
      ),
    );
  }
}
