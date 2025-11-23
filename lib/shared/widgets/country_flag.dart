import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vfxmoney/core/constants/app_colors.dart';
import 'package:vfxmoney/core/constants/app_icons.dart';

class CountryCodeComponent extends StatelessWidget {
  const CountryCodeComponent({super.key, this.fillColor = AppColors.white});
  final Color fillColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 49,
      width: 74,
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: AppColors.lightGreyColor,
            offset: const Offset(0, 4),
            blurRadius: 22,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            AppIcons.apple,
            width: 10,
            height: 19,
            fit: BoxFit.fitWidth,
          ),
          const Text('+1', style: TextStyle(fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }
}
