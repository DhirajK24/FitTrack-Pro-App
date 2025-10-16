import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'design_tokens.dart';

/// App theme configuration for FitTrack Pro Dark Mode
class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: DesignTokens.accent1,
        secondary: DesignTokens.accent2,
        surface: DesignTokens.surface,
        background: DesignTokens.brandDark,
        onPrimary: DesignTokens.brandDark,
        onSecondary: DesignTokens.textLight,
        onSurface: DesignTokens.textLight,
        onBackground: DesignTokens.textLight,
        error: DesignTokens.error,
        onError: DesignTokens.textLight,
        outline: DesignTokens.border,
        shadow: Colors.black,
      ),

      // Scaffold
      scaffoldBackgroundColor: DesignTokens.brandDark,

      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: DesignTokens.surface,
        foregroundColor: DesignTokens.textLight,
        elevation: DesignTokens.elevation0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.h3,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: DesignTokens.surface,
        elevation: DesignTokens.elevation0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusCard),
        ),
        margin: EdgeInsets.zero,
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: DesignTokens.accent1,
          foregroundColor: DesignTokens.brandDark,
          elevation: DesignTokens.elevation0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusButton),
          ),
          minimumSize: const Size(double.infinity, DesignTokens.buttonHeight),
          textStyle: AppTextStyles.button,
          padding: AppSpacing.buttonPadding,
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: DesignTokens.textLight,
          side: const BorderSide(color: DesignTokens.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusButton),
          ),
          minimumSize: const Size(double.infinity, DesignTokens.buttonHeight),
          textStyle: AppTextStyles.button,
          padding: AppSpacing.buttonPadding,
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: DesignTokens.accent1,
          textStyle: AppTextStyles.button,
          padding: AppSpacing.buttonPadding,
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: DesignTokens.surface,
        hintStyle: AppTextStyles.body.copyWith(color: DesignTokens.textMuted),
        labelStyle: AppTextStyles.label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
          borderSide: const BorderSide(color: DesignTokens.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
          borderSide: const BorderSide(color: DesignTokens.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
          borderSide: const BorderSide(color: DesignTokens.accent1, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
          borderSide: const BorderSide(color: DesignTokens.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
          borderSide: const BorderSide(color: DesignTokens.error, width: 2),
        ),
        contentPadding: AppSpacing.inputPadding,
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: DesignTokens.surface,
        selectedItemColor: DesignTokens.accent1,
        unselectedItemColor: DesignTokens.textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: DesignTokens.elevation8,
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: DesignTokens.accent1,
        foregroundColor: DesignTokens.brandDark,
        elevation: DesignTokens.elevation4,
        shape: CircleBorder(),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(color: DesignTokens.textLight, size: 24),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: DesignTokens.border,
        thickness: 1,
        space: 1,
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: DesignTokens.surface,
        selectedColor: DesignTokens.accent1.withOpacity(0.2),
        labelStyle: AppTextStyles.caption,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacing3,
          vertical: DesignTokens.spacing1,
        ),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: DesignTokens.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusXLarge),
        ),
        elevation: DesignTokens.elevation16,
      ),

      // Bottom Sheet Theme
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: DesignTokens.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(DesignTokens.radiusXLarge),
          ),
        ),
        elevation: DesignTokens.elevation16,
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: AppTextStyles.h1,
        displayMedium: AppTextStyles.h2,
        displaySmall: AppTextStyles.h3,
        headlineLarge: AppTextStyles.h1,
        headlineMedium: AppTextStyles.h2,
        headlineSmall: AppTextStyles.h3,
        titleLarge: AppTextStyles.h4,
        titleMedium: AppTextStyles.h4,
        titleSmall: AppTextStyles.h4,
        bodyLarge: AppTextStyles.body,
        bodyMedium: AppTextStyles.body,
        bodySmall: AppTextStyles.caption,
        labelLarge: AppTextStyles.label,
        labelMedium: AppTextStyles.caption,
        labelSmall: AppTextStyles.small,
      ),

      // Primary Text Theme
      primaryTextTheme: const TextTheme(
        displayLarge: AppTextStyles.h1,
        displayMedium: AppTextStyles.h2,
        displaySmall: AppTextStyles.h3,
        headlineLarge: AppTextStyles.h1,
        headlineMedium: AppTextStyles.h2,
        headlineSmall: AppTextStyles.h3,
        titleLarge: AppTextStyles.h4,
        titleMedium: AppTextStyles.h4,
        titleSmall: AppTextStyles.h4,
        bodyLarge: AppTextStyles.body,
        bodyMedium: AppTextStyles.body,
        bodySmall: AppTextStyles.caption,
        labelLarge: AppTextStyles.label,
        labelMedium: AppTextStyles.caption,
        labelSmall: AppTextStyles.small,
      ),
    );
  }
}

/// Theme extensions for custom properties
@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  const AppThemeExtension({
    required this.brandDark,
    required this.surface,
    required this.accent1,
    required this.accent2,
    required this.textLight,
    required this.textMuted,
    required this.textSecondary,
    required this.border,
    required this.error,
    required this.success,
    required this.warning,
    required this.info,
  });

  final Color brandDark;
  final Color surface;
  final Color accent1;
  final Color accent2;
  final Color textLight;
  final Color textMuted;
  final Color textSecondary;
  final Color border;
  final Color error;
  final Color success;
  final Color warning;
  final Color info;

  @override
  AppThemeExtension copyWith({
    Color? brandDark,
    Color? surface,
    Color? accent1,
    Color? accent2,
    Color? textLight,
    Color? textMuted,
    Color? textSecondary,
    Color? border,
    Color? error,
    Color? success,
    Color? warning,
    Color? info,
  }) {
    return AppThemeExtension(
      brandDark: brandDark ?? this.brandDark,
      surface: surface ?? this.surface,
      accent1: accent1 ?? this.accent1,
      accent2: accent2 ?? this.accent2,
      textLight: textLight ?? this.textLight,
      textMuted: textMuted ?? this.textMuted,
      textSecondary: textSecondary ?? this.textSecondary,
      border: border ?? this.border,
      error: error ?? this.error,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
    );
  }

  @override
  AppThemeExtension lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) {
      return this;
    }
    return AppThemeExtension(
      brandDark: Color.lerp(brandDark, other.brandDark, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      accent1: Color.lerp(accent1, other.accent1, t)!,
      accent2: Color.lerp(accent2, other.accent2, t)!,
      textLight: Color.lerp(textLight, other.textLight, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      border: Color.lerp(border, other.border, t)!,
      error: Color.lerp(error, other.error, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
    );
  }

  static const AppThemeExtension of = AppThemeExtension(
    brandDark: DesignTokens.brandDark,
    surface: DesignTokens.surface,
    accent1: DesignTokens.accent1,
    accent2: DesignTokens.accent2,
    textLight: DesignTokens.textLight,
    textMuted: DesignTokens.textMuted,
    textSecondary: DesignTokens.textSecondary,
    border: DesignTokens.border,
    error: DesignTokens.error,
    success: DesignTokens.success,
    warning: DesignTokens.warning,
    info: DesignTokens.info,
  );
}

/// Extension to easily access custom theme colors
extension AppThemeExtensionX on ThemeData {
  AppThemeExtension get appColors =>
      extension<AppThemeExtension>() ?? AppThemeExtension.of;
}
