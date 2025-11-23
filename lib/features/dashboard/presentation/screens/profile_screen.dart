// profile_screen.dart
import 'package:flutter/material.dart';
import 'package:vfxmoney/core/constants/app_colors.dart';
import 'package:vfxmoney/features/dashboard/presentation/widgets/profile_form_widget.dart';
import 'package:vfxmoney/features/dashboard/presentation/widgets/security_form_widget.dart';
import 'package:vfxmoney/shared/widgets/app_text.dart';
import 'package:vfxmoney/shared/widgets/custom_appbar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: CustomAppBar(
        title: _currentTabIndex == 0 ? 'Profile' : 'Security',
        implyLeading: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // // Header
              // Row(
              //   children: [
              //     IconButton(
              //       icon: const Icon(Icons.arrow_back, color: Colors.white),
              //       onPressed: () => Navigator.pop(context),
              //     ),
              //     const SizedBox(width: 16),
              //     AppText(
              //       _currentTabIndex == 0 ? 'Profile' : 'Security',
              //       fontSize: 20,
              //       color: Colors.white,
              //       textStyle: 'jb',
              //       w: FontWeight.w600,
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 20),

              // Tab Switcher
              _buildTabSwitcher(),
              const SizedBox(height: 24),

              // Content based on selected tab
              Expanded(
                child: _currentTabIndex == 0
                    ? const ProfileForm()
                    : const SecurityForm(),
              ),
            ],
          ),
        ),
      ),
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
          // Profile Tab
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _currentTabIndex = 0),
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: _currentTabIndex == 0
                      ? AppColors.greenVelvet
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    'Profile',
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: _currentTabIndex == 0
                          ? AppColors.black
                          : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Security Tab
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _currentTabIndex = 1),
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: _currentTabIndex == 1
                      ? AppColors.greenVelvet
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    'Security',
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: _currentTabIndex == 1
                          ? AppColors.black
                          : Colors.white,
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
