import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';

/// Today App Theme
/// Minimalist, editorial, and Apple-inspired.
class AppTheme {
  AppTheme._();

  // BRAND COLORS
  static const Color primary = Color(0xFFFA5536);
  static const Color black = Color(0xFF0B0B0B);
  static const Color white = Color(0xFFFFFFFF);

  // LIGHT MODE
  static const Color lightBackground = Color(0xFFE8E8E6); // sebelumnya 0xFFDADAD8
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightText = Color(0xFF0B0B0B);
  static const Color lightSecondaryText = Color(0xFF5F5F5F);

  // DARK MODE
  static const Color darkBackground = Color(0xFF171717);
  static const Color darkSurface = Color(0xFF252525);
  static const Color darkText = Color(0xFFF5F5F5);
  static const Color darkSecondaryText = Color(0xFFA0A0A0);

  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final background = isDark ? darkBackground : lightBackground;

    final surface = isDark ? darkSurface : lightSurface;

    final textColor = isDark ? darkText : lightText;

    final secondaryText = isDark ? darkSecondaryText : lightSecondaryText;

    final scheme =
        ColorScheme.fromSeed(
          seedColor: primary,
          brightness: brightness,
        ).copyWith(
          primary: primary,
          onPrimary: white,
          secondary: primary,
          onSecondary: white,
          surface: surface,
          onSurface: textColor,
          surfaceContainer: isDark
              ? const Color(0xFF303030)
              : const Color(0xFFF4F4F2),
          surfaceContainerLow: isDark
              ? const Color(0xFF202020)
              : const Color(0xFFECECEA),
          outline: isDark ? const Color(0xFF555555) : const Color(0xFFCCCCCC),
        );

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
    );

    final text = base.textTheme;

    return base.copyWith(
      scaffoldBackgroundColor: background,

      // TYPOGRAPHY
      textTheme: text.copyWith(
        headlineLarge: text.headlineLarge?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -1.2,
          color: textColor,
        ),
        headlineMedium: text.headlineMedium?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.8,
          color: textColor,
        ),
        headlineSmall: text.headlineSmall?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
          color: textColor,
        ),
        titleLarge: text.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.4,
          color: textColor,
        ),
        titleMedium: text.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
        bodyLarge: text.bodyLarge?.copyWith(height: 1.5, color: textColor),
        bodyMedium: text.bodyMedium?.copyWith(
          height: 1.4,
          color: secondaryText,
        ),
        bodySmall: text.bodySmall?.copyWith(color: secondaryText),
      ),

      // APP BAR
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: textColor,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        centerTitle: false,
        elevation: 0,
        titleTextStyle: text.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: textColor,
          letterSpacing: -0.5,
        ),
      ),

      // ICONS
      iconTheme: IconThemeData(color: textColor),

      // CARDS
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.zero,
      ),

      // BUTTONS
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: black,
          foregroundColor: white,
          elevation: 0,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: white,
          elevation: 0,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),

      // INPUT FIELDS
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
        hintStyle: TextStyle(color: secondaryText),
      ),

      // CHIPS
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: surface,
        selectedColor: primary,
        secondarySelectedColor: primary,
        labelStyle: TextStyle(color: textColor, fontWeight: FontWeight.w500),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide.none,
      ),

      // DIVIDERS
      dividerTheme: DividerThemeData(
        color: scheme.outline.withValues(alpha: 0.4),
        thickness: 1,
        space: 1,
      ),

      // NAVIGATION BAR
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: primary.withValues(alpha: 0.15),
        elevation: 0,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: primary);
          }
          return IconThemeData(color: secondaryText);
        }),
      ),

      // SNACKBAR
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? const Color(0xFF383838) : black,
        contentTextStyle: const TextStyle(color: white, fontSize: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // PAGE TRANSITIONS
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
