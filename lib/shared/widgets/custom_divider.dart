import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Color(0xff20222c33),
                Color(0xFF20222C).withValues(alpha: .6),
                Color(0xff20222c33),
              ]
          )
      ),
      width: double.infinity,
      height: .5,
    );
  }
}
