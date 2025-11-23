import 'package:flutter/material.dart';
import 'package:vfxmoney/core/constants/app_icons.dart';

class AppLogo extends StatelessWidget {
  final bool dense;
  const AppLogo({super.key, this.dense = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: dense ? 150 : 200,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(dense ? 20 : 25),
        ),
        child: Center(
          child: Image.asset(
            AppIcons.logo,
            height: MediaQuery.sizeOf(context).height * (dense ? 0.12 : 0.18),
          ),
        ),
      ),
    );
  }
}
