// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:vfxmoney/core/constants/app_colors.dart';
// import 'package:vfxmoney/core/constants/app_icons.dart';

// class CustomBottomBar extends StatelessWidget {
//   final int currentIndex;
//   final ValueChanged<int> onTabSelected;

//   const CustomBottomBar({
//     super.key,
//     required this.currentIndex,
//     required this.onTabSelected,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final isDark = theme.brightness == Brightness.dark;
    
//     final items = [
//       {'icon': AppIcons.home, 'label': 'Home'},
//       {'icon': AppIcons.order, 'label': 'Orders'},
//       {'icon': AppIcons.chat, 'label': 'Chat'},
//       {'icon': AppIcons.profile, 'label': 'Profile'},
//     ];

//     return Padding(
//       padding: const EdgeInsets.only(bottom: 25),
//       child: Stack(
//         alignment: Alignment.bottomCenter,
//         children: [
//           Container(
//             margin: const EdgeInsets.symmetric(horizontal: 14),
//             height: 70,
//             decoration: BoxDecoration(
//               color: isDark 
//                 ? theme.primaryColor // Use primary color from theme in dark mode
//                 : null,
//               gradient: isDark 
//                 ? null 
//                 : AppColors.primaryGradient, // Use gradient only in light mode
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: isDark
//                 ? [
//                     BoxShadow(
//                       color: theme.primaryColor.withOpacity(0.3),
//                       blurRadius: 10,
//                       spreadRadius: 2,
//                     )
//                   ]
//                 : null,
//             ),
//           ),

//           SizedBox(
//             height: 70,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: List.generate(items.length, (index) {
//                 final selected = currentIndex == index;

//                 return GestureDetector(
//                   onTap: () => onTabSelected(index),
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 350),
//                     curve: Curves.easeOutQuint,
//                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                     decoration: BoxDecoration(
//                       color: selected 
//                         ? isDark 
//                             ? Colors.white.withOpacity(0.9)
//                             : AppColors.white
//                         : Colors.transparent,
//                       borderRadius: BorderRadius.circular(12),
//                       border: isDark && selected
//                         ? Border.all(
//                             color: theme.primaryColor.withOpacity(0.5),
//                             width: 1,
//                           )
//                         : null,
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         AnimatedScale(
//                           scale: selected ? 1.2 : 1.0,
//                           duration: const Duration(milliseconds: 350),
//                           curve: Curves.easeOutQuint,
//                           child: SvgPicture.asset(
//                             items[index]['icon'] as String,
//                             color: selected
//                                 ? isDark
//                                     ? theme.primaryColor
//                                     : AppColors.greenShade
//                                 : isDark
//                                     ? Colors.white.withOpacity(0.8)
//                                     : AppColors.white,
//                             width: selected ? 22 : 20,
//                             height: selected ? 22 : 20,
//                           ),
//                         ),
//                         AnimatedSize(
//                           duration: const Duration(milliseconds: 350),
//                           curve: Curves.easeOutQuint,
//                           child: selected
//                               ? Padding(
//                                   padding: const EdgeInsets.only(left: 6),
//                                   child: Text(
//                                     items[index]['label'] as String,
//                                     style: TextStyle(
//                                       color: selected
//                                           ? isDark
//                                               ? theme.primaryColor
//                                               : AppColors.greenShade
//                                           : Colors.grey,
//                                       fontSize: 13,
//                                       fontWeight: FontWeight.bold,
//                                       fontFamily: 'Nunito',
//                                     ),
//                                   ),
//                                 )
//                               : const SizedBox.shrink(),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               }),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }