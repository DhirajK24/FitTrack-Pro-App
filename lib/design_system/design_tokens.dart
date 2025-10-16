import 'package:flutter/material.dart';

/// Design tokens for FitTrack Pro Dark Mode
class DesignTokens {
  // Private constructor to prevent instantiation
  DesignTokens._();

  // Color Palette
  static const Color brandDark = Color(0xFF0F0F0F);
  static const Color surface = Color(0xFF202020);
  static const Color accent1 = Color(0xFF5DD62C);
  static const Color accent2 = Color(0xFF337418);
  static const Color textLight = Color(0xFFF8F8F8);
  static const Color textMuted = Color(0xFF9CA3AF);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color border = Color(0xFF374151);
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Typography
  static const String fontFamily = 'Inter';

  // Font Sizes
  static const double h1Size = 28.0;
  static const double h2Size = 22.0;
  static const double h3Size = 18.0;
  static const double h4Size = 16.0;
  static const double bodySize = 14.0;
  static const double captionSize = 12.0;
  static const double smallSize = 10.0;

  // Font Weights
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;

  // Spacing Scale (8px baseline)
  static const double spacing0 = 0.0;
  static const double spacing1 = 4.0; // 0.5 * 8
  static const double spacing2 = 8.0; // 1 * 8
  static const double spacing3 = 12.0; // 1.5 * 8
  static const double spacing4 = 16.0; // 2 * 8
  static const double spacing5 = 20.0; // 2.5 * 8
  static const double spacing6 = 24.0; // 3 * 8
  static const double spacing8 = 32.0; // 4 * 8
  static const double spacing10 = 40.0; // 5 * 8
  static const double spacing12 = 48.0; // 6 * 8
  static const double spacing16 = 64.0; // 8 * 8
  static const double spacing20 = 80.0; // 10 * 8

  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 18.0;
  static const double radiusButton = 14.0;
  static const double radiusCard = 18.0;
  static const double radiusFull = 999.0;

  // Elevation/Shadows
  static const double elevation0 = 0.0;
  static const double elevation1 = 1.0;
  static const double elevation2 = 2.0;
  static const double elevation4 = 4.0;
  static const double elevation8 = 8.0;
  static const double elevation16 = 16.0;

  // Component Heights
  static const double buttonHeight = 48.0;
  static const double inputHeight = 48.0;
  static const double appBarHeight = 56.0;
  static const double bottomNavHeight = 60.0;
  static const double fabSize = 56.0;

  // Screen Padding
  static const double screenPadding = 16.0;
  static const double screenPaddingHorizontal = 16.0;
  static const double screenPaddingVertical = 16.0;

  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationMedium = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // Animation Curves
  static const Curve animationEase = Curves.easeInOut;
  static const Curve animationEaseOut = Curves.easeOut;
  static const Curve animationEaseIn = Curves.easeIn;
  static const Curve animationBounce = Curves.bounceOut;

  // Breakpoints
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 900.0;
  static const double desktopBreakpoint = 1200.0;
}

/// Text styles following the design system
class AppTextStyles {
  AppTextStyles._();

  static const TextStyle h1 = TextStyle(
    fontSize: DesignTokens.h1Size,
    fontWeight: DesignTokens.bold,
    fontFamily: DesignTokens.fontFamily,
    color: DesignTokens.textLight,
    height: 1.2,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: DesignTokens.h2Size,
    fontWeight: DesignTokens.semiBold,
    fontFamily: DesignTokens.fontFamily,
    color: DesignTokens.textLight,
    height: 1.3,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: DesignTokens.h3Size,
    fontWeight: DesignTokens.semiBold,
    fontFamily: DesignTokens.fontFamily,
    color: DesignTokens.textLight,
    height: 1.3,
  );

  static const TextStyle h4 = TextStyle(
    fontSize: DesignTokens.h4Size,
    fontWeight: DesignTokens.medium,
    fontFamily: DesignTokens.fontFamily,
    color: DesignTokens.textLight,
    height: 1.4,
  );

  static const TextStyle body = TextStyle(
    fontSize: DesignTokens.bodySize,
    fontWeight: DesignTokens.regular,
    fontFamily: DesignTokens.fontFamily,
    color: DesignTokens.textLight,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: DesignTokens.bodySize,
    fontWeight: DesignTokens.medium,
    fontFamily: DesignTokens.fontFamily,
    color: DesignTokens.textLight,
    height: 1.5,
  );

  static const TextStyle caption = TextStyle(
    fontSize: DesignTokens.captionSize,
    fontWeight: DesignTokens.regular,
    fontFamily: DesignTokens.fontFamily,
    color: DesignTokens.textMuted,
    height: 1.4,
  );

  static const TextStyle small = TextStyle(
    fontSize: DesignTokens.smallSize,
    fontWeight: DesignTokens.regular,
    fontFamily: DesignTokens.fontFamily,
    color: DesignTokens.textSecondary,
    height: 1.3,
  );

  static const TextStyle button = TextStyle(
    fontSize: DesignTokens.bodySize,
    fontWeight: DesignTokens.semiBold,
    fontFamily: DesignTokens.fontFamily,
    height: 1.2,
  );

  static const TextStyle label = TextStyle(
    fontSize: DesignTokens.captionSize,
    fontWeight: DesignTokens.medium,
    fontFamily: DesignTokens.fontFamily,
    color: DesignTokens.textMuted,
    height: 1.2,
  );
}

/// Spacing utilities
class AppSpacing {
  AppSpacing._();

  static const EdgeInsets screenPadding = EdgeInsets.all(
    DesignTokens.screenPadding,
  );
  static const EdgeInsets screenPaddingHorizontal = EdgeInsets.symmetric(
    horizontal: DesignTokens.screenPaddingHorizontal,
  );
  static const EdgeInsets screenPaddingVertical = EdgeInsets.symmetric(
    vertical: DesignTokens.screenPaddingVertical,
  );

  static const EdgeInsets cardPadding = EdgeInsets.all(DesignTokens.spacing4);
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: DesignTokens.spacing6,
    vertical: DesignTokens.spacing3,
  );

  static const EdgeInsets inputPadding = EdgeInsets.symmetric(
    horizontal: DesignTokens.spacing4,
    vertical: DesignTokens.spacing3,
  );
}

/// Shadow definitions
class AppShadows {
  AppShadows._();

  static const List<BoxShadow> soft = [
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 2),
      blurRadius: 8,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> medium = [
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> strong = [
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 8),
      blurRadius: 24,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> glow = [
    BoxShadow(
      color: Color(0x1A5DD62C),
      offset: Offset(0, 0),
      blurRadius: 12,
      spreadRadius: 0,
    ),
  ];
}
