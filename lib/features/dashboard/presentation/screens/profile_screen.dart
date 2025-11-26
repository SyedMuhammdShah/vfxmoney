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
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
              // Tab Switcher
              _buildTabSwitcher(isDarkMode),
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

  Widget _buildTabSwitcher(bool isDarkMode) {
    final Color tabBackgroundColor = isDarkMode
        ? const Color.fromARGB(28, 87, 88, 88)
        : const Color.fromARGB(169, 163, 163, 163);
    final Color activeTextColor = isDarkMode ? Colors.black : Colors.black;
    final Color inactiveTextColor = isDarkMode
        ? Colors.white
        : Colors.grey.shade700;

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: tabBackgroundColor,
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
                      ? Theme.of(context)
                            .primaryColor // Green Velvet
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: AppText(
                    'Profile',
                    color: _currentTabIndex == 0
                        ? activeTextColor
                        : inactiveTextColor,
                    fontSize: 14,
                    w: FontWeight.w500,
                    textStyle: 'jb', // JetBrainsMono
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
                      ? Theme.of(context)
                            .primaryColor // Green Velvet
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: AppText(
                    'Security',
                    color: _currentTabIndex == 1
                        ? activeTextColor
                        : inactiveTextColor,
                    fontSize: 14,
                    w: FontWeight.w500,
                    textStyle: 'jb', // JetBrainsMono
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
