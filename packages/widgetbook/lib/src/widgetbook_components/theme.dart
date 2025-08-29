// ignore_for_file: avoid_classes_with_only_static_members

part of 'widgetbook_components.dart';

class WidgetbookCustomTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: WdsFontFamily.pretendard,
    colorScheme: ColorScheme.fromSeed(
      seedColor: WdsColorBlue.v400,
      primary: WdsColorBlue.v400,
      onPrimary: WdsColorCommon.white,
      secondary: WdsColorPink.v500,
      onSecondary: WdsColorCommon.white,
      surface: WdsColorCommon.white,
      onSurface: WdsColorNeutral.v900,
      surfaceContainerHighest: WdsColorNeutral.v50,
      outline: WdsColorNeutral.v200,
      outlineVariant: WdsColorNeutral.v100,
    ),
    textTheme: const TextTheme(
      displayLarge: WdsSemanticTypography.title32Bold,
      displayMedium: WdsSemanticTypography.title22Bold,
      displaySmall: WdsSemanticTypography.title20Bold,
      headlineLarge: WdsSemanticTypography.heading18Bold,
      headlineMedium: WdsSemanticTypography.heading17Bold,
      headlineSmall: WdsSemanticTypography.heading16Bold,
      titleLarge: WdsSemanticTypography.heading18Medium,
      titleMedium: WdsSemanticTypography.heading17Medium,
      titleSmall: WdsSemanticTypography.heading16Medium,
      bodyLarge: WdsSemanticTypography.body15NormalRegular,
      bodyMedium: WdsSemanticTypography.body14NormalRegular,
      bodySmall: WdsSemanticTypography.body13NormalRegular,
      labelLarge: WdsSemanticTypography.body14NormalMedium,
      labelMedium: WdsSemanticTypography.caption12Medium,
      labelSmall: WdsSemanticTypography.caption11Medium,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: WdsColorCommon.white,
      foregroundColor: WdsColorNeutral.v900,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: WdsSemanticTypography.heading18Bold,
    ),
    cardTheme: CardThemeData(
      color: WdsColorCommon.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: WdsColorNeutral.v200),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: WdsColorBlue.v400,
        foregroundColor: WdsColorCommon.white,
        textStyle: WdsSemanticTypography.body14NormalMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: WdsColorBlue.v400,
        side: const BorderSide(color: WdsColorBlue.v400),
        textStyle: WdsSemanticTypography.body14NormalMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: FilledButton.styleFrom(
        foregroundColor: WdsColorBlue.v400,
        textStyle: WdsSemanticTypography.body14NormalMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: WdsColorNeutral.v200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: WdsColorNeutral.v200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: WdsColorBlue.v400, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: WdsColorPink.v500),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: WdsColorPink.v500, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      labelStyle: WdsSemanticTypography.body14NormalRegular.copyWith(
        color: WdsColorNeutral.v500,
      ),
      hintStyle: WdsSemanticTypography.body14NormalRegular.copyWith(
        color: WdsColorNeutral.v400,
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: WdsColorNeutral.v200,
      thickness: 1,
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: WdsColorCommon.white,
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all(WdsColorCommon.white),
      ),
    ),
    popupMenuTheme: const PopupMenuThemeData(
      color: WdsColorCommon.white,
      position: PopupMenuPosition.under,
    ),
  );

  static ThemeData darkTheme = lightTheme.copyWith(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: WdsColorBlue.v400,
      brightness: Brightness.dark,
      primary: WdsColorBlue.v300,
      onPrimary: WdsColorNeutral.v900,
      secondary: WdsColorPink.v400,
      onSecondary: WdsColorNeutral.v900,
      surface: WdsColorNeutral.v900,
      onSurface: WdsColorCommon.white,
      surfaceContainerHighest: WdsColorNeutral.v800,
      outline: WdsColorNeutral.v600,
      outlineVariant: WdsColorNeutral.v700,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: WdsColorNeutral.v900,
      foregroundColor: WdsColorCommon.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: WdsSemanticTypography.heading18Bold.copyWith(
        color: WdsColorCommon.white,
      ),
    ),
    cardTheme: CardThemeData(
      color: WdsColorNeutral.v800,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: WdsColorNeutral.v600),
      ),
    ),
  );
}
