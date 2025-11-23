import 'package:flutter/material.dart';
import 'package:vfxmoney/core/extensions/text_theme_extension.dart';
import 'package:vfxmoney/core/extensions/theme_extension.dart';

class BuyButton extends StatelessWidget {
  final String price;
  final VoidCallback onTap;
  const BuyButton({super.key, required this.price, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: context.colors.primary,
        foregroundColor: context.colors.onPrimary,
        textStyle: context.titleSmallBold,
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 40),
      ),
      onPressed: onTap,
      child: Column(
        children: [
          Text(
            "Buy Now",
            style: context.labelSmall?.copyWith(
              color: context.colors.onPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "\$$price",
            style: context.bodySemiBoldLarge?.copyWith(
              color: context.colors.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
