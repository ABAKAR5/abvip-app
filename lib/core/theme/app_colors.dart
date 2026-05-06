import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors - Vibrant Purple/Blue Theme
  static const Color primary = Color(0xFF6B4EE6); // More vibrant purple
  static const Color primaryLight = Color(0xFFF1EEFF);
  static const Color primaryDark = Color(0xFF4A34B2);
  
  static const Color secondary = Color(0xFF00D4FF); // Bright cyan for accents
  static const Color accent = Color(0xFFE900A3); // Hot pink for highlights
  
  static const Color bgDark = Color(0xFF08052E); // Deep navy for dark mode
  static const Color bgLight = Color(0xFFF7F9FC); // Very light grey-blue
  
  static const Color teal = Color(0xFF00BFA5);
  static const Color tealLight = Color(0xFFE0F2F1);
  static const Color amber = Color(0xFFFFAB00);
  static const Color amberLight = Color(0xFFFFF8E1);
  static const Color coral = Color(0xFFFF5252);
  static const Color coralLight = Color(0xFFFFEBEE);

  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF676781);
  static const Color textHint = Color(0xFF9EA3AE);
  
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE8ECF1);
  static const Color white = Color(0xFFFFFFFF);

  static const Color success = Color(0xFF00C853);
  static const Color warning = Color(0xFFFFD600);
  static const Color error = Color(0xFFFF1744);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6B4EE6), Color(0xFF9075FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient premiumGradient = LinearGradient(
    colors: [Color(0xFF21084E), Color(0xFF6B4EE6), Color(0xFF00D4FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFE900A3), Color(0xFF6B4EE6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}