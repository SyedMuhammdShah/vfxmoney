// core/extensions/theme_extensions.dart

import 'package:flutter/material.dart';

extension ThemeX on BuildContext {
  ThemeData get theme => Theme.of(this);
  ThemeMode get themeMode => theme.brightness == Brightness.dark
      ? ThemeMode.dark
      : ThemeMode.light;
  ColorScheme get colors => theme.colorScheme;
  TextTheme get text => theme.textTheme;
}
