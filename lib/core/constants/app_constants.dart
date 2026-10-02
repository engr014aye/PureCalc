import 'package:flutter/cupertino.dart';

class AppConstants {
  static const String appName = 'PureCalc';
  static const String dbName = 'purecalc_offline_journal.db';
  static const int dbVersion = 1;
  static const String historyTable = 'calculation_history';

  // Fonts
  static const String fontFamilyInter = 'Inter';
  static const String fontFamilyPlusJakarta = 'PlusJakartaSans';

  // Asset paths
  static const String bgDark = 'assets/images/bg_obsidian_mesh.png';
  static const String bgLight = 'assets/images/bg_cupertino_frost.png';
  static const String lottieRipple = 'assets/animations/calc_ripple.json';
  static const String lottieParticles = 'assets/animations/ambient_particles.json';

  // Key labels
  static const String keyClear = 'C';
  static const String keyAllClear = 'AC';
  static const String keyBackspace = '⌫';
  static const String keyPlusMinus = '±';
  static const String keyPercent = '%';
  static const String keyDivide = '÷';
  static const String keyMultiply = '×';
  static const String keySubtract = '−';
  static const String keyAdd = '+';
  static const String keyEquals = '=';
  static const String keyDecimal = '.';
  static const String keyParentheses = '( )';
}

class AppColors {
  // Cupertino Orange Accent
  static const Color orangeAccent = Color(0xFFFF9F0A);
  static const Color orangePressed = Color(0xFFCC7F08);

  // Dark Theme Palette
  static const Color darkBackground = Color(0xFF000000);
  static const Color darkSurface = Color(0xFF1C1C1E);
  static const Color darkKeyNum = Color(0xFF333333);
  static const Color darkKeyFunction = Color(0xFFA5A5A5);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFF8E8E93);

  // Light Theme Palette
  static const Color lightBackground = Color(0xFFF2F2F7);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightKeyNum = Color(0xFFE5E5EA);
  static const Color lightKeyFunction = Color(0xFFD1D1D6);
  static const Color lightTextPrimary = Color(0xFF000000);
  static const Color lightTextSecondary = Color(0xFF6C6C70);
}
