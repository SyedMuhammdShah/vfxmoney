
import 'package:flutter/material.dart';

extension DynamicTextColor on Color {
  /// Returns either [Colors.black] or [Colors.white]
  /// depending on the brightness of this color.
  Color get adaptiveTextColor {
    return computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }
}