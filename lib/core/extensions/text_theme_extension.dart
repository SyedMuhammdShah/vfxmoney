import 'package:flutter/material.dart';
import 'package:vfxmoney/core/constants/app_colors.dart';

extension TextThemeExtension on BuildContext {
  TextStyle? get displayLarge => Theme.of(this).textTheme.displayLarge;
  TextStyle? get displayMedium => Theme.of(this).textTheme.displayMedium;
  TextStyle? get displaySmall => Theme.of(this).textTheme.displaySmall;

  TextStyle? get titleLarge => Theme.of(
    this,
  ).textTheme.titleLarge?.copyWith(fontSize: 20, fontWeight: FontWeight.w500);
  TextStyle? get titleMediumBold => Theme.of(
    this,
  ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700);
  TextStyle? get titleSmallBold => Theme.of(
    this,
  ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700);

  TextStyle? get titleMedium => Theme.of(this).textTheme.titleMedium;
  TextStyle? get titleSmall => Theme.of(this).textTheme.titleSmall;

  TextStyle? get headlineLarge => Theme.of(
    this,
  ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w600);
  TextStyle? get headlineMedium => Theme.of(
    this,
  ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold);
  TextStyle? get headlineSmall => Theme.of(
    this,
  ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600);

  TextStyle? get bodyLarge => Theme.of(this).textTheme.bodyLarge;
  TextStyle? get bodyMedium => Theme.of(this).textTheme.bodyMedium;
  TextStyle? get bodySmall => Theme.of(this).textTheme.bodySmall;

  TextStyle? get bodySemiBoldLarge =>
      Theme.of(this).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500);
  TextStyle? get bodySemiBoldMedium => Theme.of(
    this,
  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500);
  TextStyle? get bodySemiBoldSmall =>
      Theme.of(this).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500);

  TextStyle? get titleStyle =>
      Theme.of(this).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500);
  TextStyle? get contentStyle => Theme.of(this).textTheme.bodySmall?.copyWith(
    fontWeight: FontWeight.w500,
    color: Colors.black45,
  );

  TextStyle? get labelLarge => Theme.of(
    this,
  ).textTheme.labelLarge?.copyWith(color: AppColors.rhythmObsidian);
  TextStyle? get labelMedium => Theme.of(
    this,
  ).textTheme.labelMedium?.copyWith(color: AppColors.rhythmObsidian);
  TextStyle? get labelSmall => Theme.of(
    this,
  ).textTheme.labelSmall?.copyWith(color: AppColors.rhythmObsidian);
}
