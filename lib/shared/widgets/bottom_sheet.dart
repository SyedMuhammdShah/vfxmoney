import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:go_router/go_router.dart';

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
    // TODO: open your add sheet / page
  }

  final List<Map<String, dynamic>> items = [
    {"icon": Icons.check_circle, "label": "Home"},
    {"icon": Icons.credit_card, "label": "My Cards"},
    {"icon": Icons.add, "label": ""},
    {"icon": Icons.history, "label": "Transactions"},
    {"icon": Icons.person, "label": "Profile"},
  ];

  @override
  Widget build(BuildContext context) {
    final int currentIndex = widget.navigationShell.currentIndex;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Theme-based colors with specific background colors
    final Color navBarColor = isDarkMode
        ? const Color(0xFF00040E)
        : Colors.black;
    final Color activeIconColor = Theme.of(
      context,
    ).primaryColor; // Green Velvet
    final Color inactiveIconColor = isDarkMode ? Colors.white : Colors.white;
    final Color labelColor = isDarkMode ? Colors.white : Colors.white;
    final Color activeBackgroundColor = isDarkMode
        ? Colors.white
        : Colors.white;
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
                  (e) => Icon(
                    e["icon"],
                    color: Colors.transparent, // Keep icons transparent
                    size: 24,
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
                final double iconSize = index == 2 ? 30 : 24; // Larger add icon

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
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: activeBackgroundColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                items[index]["icon"],
                                size: iconSize,
                                color: activeIconColor,
                              ),
                            )
                          else if (index == 2)
                            // Special styling for add button
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: activeIconColor, // Green Velvet
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Icon(
                                items[index]["icon"],
                                size: iconSize,
                                color: addButtonIconColor,
                              ),
                            )
                          else
                            Icon(
                              items[index]["icon"],
                              size: iconSize,
                              color: inactiveIconColor,
                            ),

                          if (index != 2) const SizedBox(height: 4),

                          // Labels (hidden for center button)
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
