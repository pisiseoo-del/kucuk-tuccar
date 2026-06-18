import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();
  static const Color neonGreen  = Color(0xFF39FF14);
  static const Color neonYellow = Color(0xFFFFFF00);
  static const Color deepDark   = Color(0xFF0A0A14);
  static const Color cardDark   = Color(0xFF14141F);
  static const Color cardBorder = Color(0xFF2A2A3D);
  static const Color textPrimary= Color(0xFFF0F0FF);
  static const Color textSecond = Color(0xFF9090AA);
  static const Color goldShine  = Color(0xFFFFD700);
  static const Color priceHigh  = Color(0xFF4CAF50);
  static const Color priceNorm  = Color(0xFFFFC107);
  static const Color priceLow   = Color(0xFFF44336);

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: deepDark,
    colorScheme: const ColorScheme.dark(
      primary: neonGreen, secondary: neonYellow,
      surface: cardDark, onSurface: textPrimary,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: textPrimary, letterSpacing: -1),
      titleLarge:   TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: textPrimary),
      titleMedium:  TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textPrimary),
      bodyLarge:    TextStyle(fontSize: 16, color: textPrimary),
      bodyMedium:   TextStyle(fontSize: 14, color: textSecond),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: neonGreen, foregroundColor: deepDark,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: 1),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 8, shadowColor: Color(0x6639FF14),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent, elevation: 0, centerTitle: true,
      titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textPrimary),
    ),
  );

  static BoxDecoration glassCard({Color? borderColor}) => BoxDecoration(
    color: cardDark.withValues(alpha: 0.85),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: borderColor ?? cardBorder, width: 1.5),
    boxShadow: [BoxShadow(color: (borderColor ?? cardBorder).withValues(alpha: 0.3), blurRadius: 20)],
  );

  static BoxDecoration neonButton(Color color) => BoxDecoration(
    gradient: LinearGradient(colors: [color, color.withValues(alpha: 0.7)], begin: Alignment.topLeft, end: Alignment.bottomRight),
    borderRadius: BorderRadius.circular(16),
    boxShadow: [BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 15, spreadRadius: -2)],
  );
}
