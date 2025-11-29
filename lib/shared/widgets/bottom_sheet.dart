import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:vfxmoney/core/constants/app_icons.dart';
import 'package:vfxmoney/features/depositAndWithdraw/widgets/card_option_widget.dart';
import 'package:vfxmoney/features/depositAndWithdraw/widgets/deposit_option_widget.dart';
import 'package:vfxmoney/features/depositAndWithdraw/widgets/withdraw_option_widget.dart';
import 'package:vfxmoney/shared/popUp/create_card_popup.dart';
import 'package:vfxmoney/shared/popUp/load_money_popup.dart';
import 'package:vfxmoney/shared/popUp/unload_money_popup.dart';

class CustomBottomBar extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const CustomBottomBar({required this.navigationShell, super.key});

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  final GlobalKey<CurvedNavigationBarState> _navKey = GlobalKey();

  void _tap(int index) {
    HapticFeedback.lightImpact();

    // centre button → do nothing except your add-logic
    if (index == 2) {
      _onAddTap();
      return;
    }

    widget.navigationShell.goBranch(index);
  }

  void _onAddTap() {
    HapticFeedback.mediumImpact();

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      isScrollControlled: true, // Added for responsiveness
      useSafeArea: true, // Added for better mobile support
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return ResponsiveBottomSheetContent(); // Extracted to separate widget for better organization
      },
    );
  }

  final List<Map<String, dynamic>> items = [
    {"image": AppIcons.logo, "label": "Home"},
    {"image": AppIcons.myCard, "label": "My Cards"},
    {"image": AppIcons.plusIcon, "label": ""},
    {"image": AppIcons.transaction, "label": "Transactions"},
    {"image": AppIcons.profile, "label": "Profile"},
  ];

  @override
  Widget build(BuildContext context) {
    final int currentIndex = widget.navigationShell.currentIndex;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Theme-based colors with specific background colors
    final Color navBarColor = isDarkMode
        ? const Color.fromARGB(255, 36, 44, 61)
        : Colors.black;
    final Color activeIconColor = Theme.of(
      context,
    ).primaryColor; // Green Velvet
    final Color inactiveIconColor = isDarkMode ? Colors.white : Colors.white;
    final Color labelColor = isDarkMode ? Colors.white : Colors.white;
    final Color activeBackgroundColor = isDarkMode
        ? Colors.white
        : const Color.fromARGB(255, 12, 12, 12);
    final Color addButtonIconColor = isDarkMode
        ? const Color(0xFF00040E)
        : Colors.black;

    return Scaffold(
      extendBody: true,
      body: widget.navigationShell,

      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        children: [
          /* -----------------------------------------
           * CurvedNavigationBar with visible background
           * ----------------------------------------- */
          CurvedNavigationBar(
            key: _navKey,
            index: currentIndex,
            height: 70,
            color: navBarColor,
            buttonBackgroundColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            animationCurve: Curves.easeInOut,
            animationDuration: const Duration(milliseconds: 300),
            onTap: _tap,
            items: items
                .map(
                  (e) => Image.asset(
                    e["image"],
                    color: Colors.transparent,
                    // Apply reduced size for AppIcons.logo here too
                    width: e["image"] == AppIcons.logo ? 10 : 10,
                    height: e["image"] == AppIcons.logo ? 10 : 10,
                  ),
                )
                .toList(),
          ),
          /* -----------------------------------------
 * Custom positioned icons with proper alignment
 * ----------------------------------------- */
          Positioned.fill(
            bottom: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(items.length, (index) {
                final bool isActive = currentIndex == index;
                // Reduced size only for AppIcons.logo (index 0)
                final bool isLogo = items[index]["image"] == AppIcons.logo;
                final double iconSize = index == 2 ? 20 : (isLogo ? 20 : 20);

                return Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _tap(index),
                    child: Container(
                      height: 70,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Add background circle for active tab
                          if (isActive && index != 2)
                            Container(
                              // CHANGE THESE LINES - Reduce size only when Home is active (index 0)
                              width: index == 0
                                  ? 36
                                  : 40, // Reduced from 40 to 36 for active Home
                              height: index == 0
                                  ? 36
                                  : 40, // Reduced from 40 to 36 for active Home
                              decoration: BoxDecoration(
                                color: activeBackgroundColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Image.asset(
                                items[index]["image"],
                                // CHANGE THIS LINE - Reduce icon size only when Home is active
                                width: index == 0
                                    ? 16
                                    : 10, // Reduced from 20 to 16 for active Home
                                height: index == 0
                                    ? 16
                                    : 10, // Reduced from 20 to 16 for active Home
                                color: activeIconColor,
                              ),
                            )
                          else if (index == 2)
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: activeIconColor,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Image.asset(
                                items[index]["image"],
                                width: iconSize,
                                height: iconSize,
                                color: addButtonIconColor,
                              ),
                            )
                          else
                            Image.asset(
                              items[index]["image"],
                              width: iconSize,
                              height: iconSize,
                              color: inactiveIconColor,
                            ),

                          if (index != 2) const SizedBox(height: 4),

                          if (index != 2)
                            Text(
                              items[index]["label"],
                              style: TextStyle(
                                color: isActive ? activeIconColor : labelColor,
                                fontSize: 10,
                                fontWeight: isActive
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontFamily: "Nunito", // Using your theme font
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// Extracted responsive bottom sheet content widget
class ResponsiveBottomSheetContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bottomPadding = mediaQuery.viewInsets.bottom;
    final screenHeight = mediaQuery.size.height;

    // Calculate dynamic padding based on screen size
    final double verticalPadding = screenHeight < 700 ? 8.0 : 16.0;
    final double horizontalPadding = screenHeight < 700 ? 16.0 : 24.0;

    return AnimatedPadding(
      padding: EdgeInsets.only(
        bottom: bottomPadding + mediaQuery.padding.bottom,
        left: horizontalPadding,
        right: horizontalPadding,
        top: verticalPadding,
      ),
      duration: const Duration(milliseconds: 100),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle for better UX
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(2),
            ),
            margin: const EdgeInsets.only(bottom: 8),
          ),

          // Responsive content
          LayoutBuilder(
            builder: (context, constraints) {
              final bool isSmallScreen = constraints.maxWidth < 360;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DepositOptionWidget(
                    onTap: () {
                      Navigator.pop(context);
                      LoadMoneyPopup.show(context);
                    },
                  ),

                  SizedBox(height: isSmallScreen ? 8 : 12),

                  WithdrawOptionWidget(
                    onTap: () {
                      Navigator.pop(context);
                      UnloadMoneyPopup.show(context);
                    },
                  ),

                  SizedBox(height: isSmallScreen ? 8 : 12),

                  CreateCardOptionWidget(
                    onTap: () {
                      Navigator.pop(context);
                      CreateCardPopup.show(context);
                    },
                  ),
                ],
              );
            },
          ),

          // Extra bottom padding for devices with notch/home indicator
          SizedBox(height: mediaQuery.padding.bottom > 0 ? 30 : 50),
        ],
      ),
    );
  }
}
