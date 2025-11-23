import 'package:flutter/material.dart';
import 'package:vfxmoney/core/extensions/theme_extension.dart';

class CustomTabBar extends StatelessWidget {
  final List<Tab> tabs;
  const CustomTabBar({super.key, required this.tabs});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.colors.secondary, // Background grey
          borderRadius: BorderRadius.circular(25), // Rounded background
        ),
        child: TabBar(
          indicator: BoxDecoration(
            color: context.colors.primary, // Selected tab color
            borderRadius: BorderRadius.circular(25), // Rounded selected tab
          ),
          labelColor: Colors.white, // Selected text color
          unselectedLabelColor: Colors.black, // Unselected text color
          indicatorColor: Colors.transparent,
          dividerColor: Colors.transparent,
          indicatorSize: TabBarIndicatorSize.tab,
          splashBorderRadius: BorderRadius.circular(25),
          tabs: tabs,
        ),
      ),
    );
  }
}
