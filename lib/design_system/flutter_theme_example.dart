import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Example Flutter ThemeData implementation using design tokens
/// This shows how to map the design tokens to Flutter's ThemeData
class FlutterThemeExample {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF5DD62C), // accent1
        secondary: Color(0xFF337418), // accent2
        surface: Color(0xFF202020), // surface
        background: Color(0xFF0F0F0F), // brandDark
        onPrimary: Color(0xFF0F0F0F), // brandDark
        onSecondary: Color(0xFFF8F8F8), // textLight
        onSurface: Color(0xFFF8F8F8), // textLight
        onBackground: Color(0xFFF8F8F8), // textLight
        error: Color(0xFFEF4444), // error
        onError: Color(0xFFF8F8F8), // textLight
        outline: Color(0xFF374151), // border
        shadow: Colors.black,
      ),

      // Scaffold
      scaffoldBackgroundColor: const Color(0xFF0F0F0F), // brandDark
      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF202020), // surface
        foregroundColor: Color(0xFFF8F8F8), // textLight
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
          color: Color(0xFFF8F8F8),
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: const Color(0xFF202020), // surface
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18), // radiusCard
        ),
        margin: EdgeInsets.zero,
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5DD62C), // accent1
          foregroundColor: const Color(0xFF0F0F0F), // brandDark
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14), // radiusButton
          ),
          minimumSize: const Size(double.infinity, 48), // buttonHeight
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFF8F8F8), // textLight
          side: const BorderSide(color: Color(0xFF374151)), // border
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14), // radiusButton
          ),
          minimumSize: const Size(double.infinity, 48), // buttonHeight
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF5DD62C), // accent1
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF202020), // surface
        hintStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          fontFamily: 'Inter',
          color: Color(0xFF9CA3AF), // textMuted
        ),
        labelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
          color: Color(0xFF9CA3AF), // textMuted
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), // radiusMedium
          borderSide: const BorderSide(color: Color(0xFF374151)), // border
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), // radiusMedium
          borderSide: const BorderSide(color: Color(0xFF374151)), // border
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), // radiusMedium
          borderSide: const BorderSide(
            color: Color(0xFF5DD62C),
            width: 2,
          ), // accent1
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), // radiusMedium
          borderSide: const BorderSide(color: Color(0xFFEF4444)), // error
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), // radiusMedium
          borderSide: const BorderSide(
            color: Color(0xFFEF4444),
            width: 2,
          ), // error
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF202020), // surface
        selectedItemColor: Color(0xFF5DD62C), // accent1
        unselectedItemColor: Color(0xFF9CA3AF), // textMuted
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF5DD62C), // accent1
        foregroundColor: Color(0xFF0F0F0F), // brandDark
        elevation: 4,
        shape: CircleBorder(),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: Color(0xFFF8F8F8), // textLight
        size: 24,
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: Color(0xFF374151), // border
        thickness: 1,
        space: 1,
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF202020), // surface
        selectedColor: const Color(
          0xFF5DD62C,
        ).withOpacity(0.2), // accent1 with opacity
        labelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          fontFamily: 'Inter',
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999), // radiusFull
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: const Color(0xFF202020), // surface
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18), // radiusXLarge
        ),
        elevation: 16,
      ),

      // Bottom Sheet Theme
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Color(0xFF202020), // surface
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(18), // radiusXLarge
          ),
        ),
        elevation: 16,
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          fontFamily: 'Inter',
          color: Color(0xFFF8F8F8),
          height: 1.2,
        ),
        displayMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
          color: Color(0xFFF8F8F8),
          height: 1.3,
        ),
        displaySmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
          color: Color(0xFFF8F8F8),
          height: 1.3,
        ),
        headlineLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          fontFamily: 'Inter',
          color: Color(0xFFF8F8F8),
          height: 1.2,
        ),
        headlineMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
          color: Color(0xFFF8F8F8),
          height: 1.3,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
          color: Color(0xFFF8F8F8),
          height: 1.3,
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
          color: Color(0xFFF8F8F8),
          height: 1.4,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
          color: Color(0xFFF8F8F8),
          height: 1.4,
        ),
        titleSmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
          color: Color(0xFFF8F8F8),
          height: 1.4,
        ),
        bodyLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          fontFamily: 'Inter',
          color: Color(0xFFF8F8F8),
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
          color: Color(0xFFF8F8F8),
          height: 1.5,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          fontFamily: 'Inter',
          color: Color(0xFF9CA3AF),
          height: 1.4,
        ),
        labelLarge: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
          color: Color(0xFF9CA3AF),
          height: 1.2,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          fontFamily: 'Inter',
          color: Color(0xFF9CA3AF),
          height: 1.4,
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w400,
          fontFamily: 'Inter',
          color: Color(0xFF6B7280),
          height: 1.3,
        ),
      ),
    );
  }
}

/// Example of how to use the theme in a widget
class ExampleWidget extends StatelessWidget {
  const ExampleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Example'),
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Hello World', style: theme.textTheme.headlineMedium),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Primary Button'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () {},
              child: const Text('Secondary Button'),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Example Input',
                hintText: 'Enter text here',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
