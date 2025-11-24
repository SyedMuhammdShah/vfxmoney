// security_form.dart
import 'package:flutter/material.dart';
import 'package:vfxmoney/core/constants/app_colors.dart';
import 'package:vfxmoney/shared/widgets/app_text.dart';
import 'package:vfxmoney/shared/widgets/input_field.dart';
import 'package:vfxmoney/shared/widgets/push_button.dart';

class SecurityForm extends StatefulWidget {
  const SecurityForm({super.key});

  @override
  State<SecurityForm> createState() => _SecurityFormState();
}

class _SecurityFormState extends State<SecurityForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _googleAuthenticatorEnabled = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Current Password
            AppInputField(
              controller: _currentPasswordController,
              hintText: 'Enter Current Password',
              isPassword: true,
              obscureText: _obscureCurrentPassword,
              onToggleObscure: () {
                setState(() {
                  _obscureCurrentPassword = !_obscureCurrentPassword;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Current password is required';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),

            // New Password
            AppInputField(
              controller: _newPasswordController,
              hintText: 'Enter New Password',
              isPassword: true,
              obscureText: _obscureNewPassword,
              onToggleObscure: () {
                setState(() {
                  _obscureNewPassword = !_obscureNewPassword;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'New password is required';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),

            // Confirm Password
            AppInputField(
              controller: _confirmPasswordController,
              hintText: 'Confirm Password',
              isPassword: true,
              obscureText: _obscureConfirmPassword,
              onToggleObscure: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                if (value != _newPasswordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Google Authenticator Description
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    'Google Authenticator',
                    fontSize: 14,
                    color: Colors.white,
                    textStyle: 'hb',
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(
                        'Google Authenticator codes synchronized\n across all your devices',
                        fontSize: 8,
                        color: Colors.white,
                        textStyle: 'jb',
                        w: FontWeight.w500,
                      ),
                      Transform.scale(
                        scale: 0.8,
                        child: Switch(
                          value: _googleAuthenticatorEnabled,
                          onChanged: (v) =>
                              setState(() => _googleAuthenticatorEnabled = v),
                          activeColor: AppColors.greenVelvet,
                          inactiveTrackColor: AppColors.greytextColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Divider
            Container(
              height: 1,
              color: AppColors.greytextColor.withOpacity(0.3),
            ),
            const SizedBox(height: 32),

            // Update Button
            AppSubmitButton(title: 'Update', onTap: _updateSecurity),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.bgGreyColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: AppText(
        title,
        fontSize: 14,
        color: Colors.white,
        textStyle: 'jb',
        w: FontWeight.w600,
      ),
    );
  }

  void _updateSecurity() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Security settings updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
