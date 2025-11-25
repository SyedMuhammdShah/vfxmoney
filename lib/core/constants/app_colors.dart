import 'package:flutter/material.dart';

class AppColors {
  static const Color greenVelvet = Color(0xFF51FA7B);
  static const Color bgBlack = Color(0xFF0B0E12);

  static const Color lightgreenVelvet = Color.fromARGB(77, 22, 160, 132);
  static const Color lightGreenVelvet = Color.fromARGB(51, 22, 160, 132);
  static const Color melodicWhisper = Color(0xFFF5F5F5);
  static const Color rhythmObsidian = Color(0xFF303030);
  static const Color white = Colors.white;
  static const Color greyColor = Color(0xFFF0F0F0);
  static const Color greytextColor = Colors.grey;
  static const Color emergencyColor = Colors.red;
  static const Color reportColor = Color.fromARGB(72, 216, 91, 238);
  static const Color lightGreyColor = Color.fromARGB(116, 100, 99, 99);
  static const Color bgGreyColor = Color.fromARGB(95, 226, 222, 222);

  static const Color black = Colors.black;

  /// Gradient Colors
  static const Color tealShade = Color(0xFF03958A);
  static const Color greenShade = Color(0xFF22B573);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [tealShade, greenShade],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const LinearGradient greyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF0F0F0), Color(0xFFE6E6E6)],
  );
}
