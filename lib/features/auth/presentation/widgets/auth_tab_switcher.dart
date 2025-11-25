import 'package:flutter/material.dart';
import 'package:vfxmoney/core/constants/app_colors.dart';

class AuthTabSwitcher extends StatelessWidget {
  final bool isLogin;
  final VoidCallback onLoginTap;
  final VoidCallback onRegisterTap;

  const AuthTabSwitcher({
    super.key,
    required this.isLogin,
    required this.onLoginTap,
    required this.onRegisterTap,
  });

  @override
  Widget build(BuildContext context) {
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
              onTap: onRegisterTap,
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: !isLogin ? AppColors.greenVelvet : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    'Register',
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: !isLogin ? AppColors.black : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Login Tab
          Expanded(
            child: GestureDetector(
              onTap: onLoginTap,
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isLogin ? AppColors.greenVelvet : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isLogin ? AppColors.black : Colors.white,
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
}
