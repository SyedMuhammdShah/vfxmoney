import 'package:flutter/material.dart';
import 'package:vfxmoney/core/constants/app_colors.dart';
import 'package:vfxmoney/shared/widgets/app_text.dart';

class AppSubmitButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final double height;
  final double radius;
  final Color background;
  final Color textColor;
  final FontWeight fontWeight;

  const AppSubmitButton({
    Key? key,
    required this.title,
    required this.onTap,
    this.height = 52,
    this.radius = 26,
    this.background = AppColors.greenVelvet,
    this.textColor = AppColors.black,
    this.fontWeight = FontWeight.w600,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Center(
          child: AppText(
            title,
            fontSize: 16,
            w: fontWeight,
            color: textColor,
            textStyle: 'jb',
          ),
        ),
      ),
    );
  }
}
