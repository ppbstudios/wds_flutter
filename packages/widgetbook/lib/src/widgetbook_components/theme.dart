// ignore_for_file: avoid_classes_with_only_static_members

part of 'widgetbook_components.dart';

class WidgetbookCustomTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: WdsTypography.fontFamily,
    colorScheme: ColorScheme.fromSeed(
      seedColor: WdsColors.blue400,
      primary: WdsColors.blue400,
      onPrimary: WdsColors.white,
      secondary: WdsColors.pink500,
      onSecondary: WdsColors.white,
      surface: WdsColors.white,
      onSurface: WdsColors.neutral900,
      surfaceContainerHighest: WdsColors.neutral50,
      outline: WdsColors.neutral200,
      outlineVariant: WdsColors.neutral100,
    ),
    textTheme: const TextTheme(
      displayLarge: WdsTypography.title32Bold,
      displayMedium: WdsTypography.title22Bold,
      displaySmall: WdsTypography.title20Bold,
      headlineLarge: WdsTypography.heading18Bold,
      headlineMedium: WdsTypography.heading17Bold,
      headlineSmall: WdsTypography.heading16Bold,
      titleLarge: WdsTypography.heading18Medium,
      titleMedium: WdsTypography.heading17Medium,
      titleSmall: WdsTypography.heading16Medium,
      bodyLarge: WdsTypography.body15NormalRegular,
      bodyMedium: WdsTypography.body14NormalRegular,
      bodySmall: WdsTypography.body13NormalRegular,
      labelLarge: WdsTypography.body14NormalMedium,
      labelMedium: WdsTypography.caption12NormalMedium,
      labelSmall: WdsTypography.caption11Medium,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: WdsColors.white,
      foregroundColor: WdsColors.neutral900,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: WdsTypography.heading18Bold,
    ),
    cardTheme: CardThemeData(
      color: WdsColors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: WdsColors.neutral200),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: WdsColors.blue400,
        foregroundColor: WdsColors.white,
        textStyle: WdsTypography.body14NormalMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: WdsColors.blue400,
        side: const BorderSide(color: WdsColors.blue400),
        textStyle: WdsTypography.body14NormalMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: FilledButton.styleFrom(
        foregroundColor: WdsColors.blue400,
        textStyle: WdsTypography.body14NormalMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: WdsColors.neutral200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: WdsColors.neutral200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: WdsColors.blue400, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: WdsColors.pink500),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: WdsColors.pink500, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      labelStyle: WdsTypography.body14NormalRegular.copyWith(
        color: WdsColors.neutral500,
      ),
      hintStyle: WdsTypography.body14NormalRegular.copyWith(
        color: WdsColors.neutral400,
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: WdsColors.neutral200,
      thickness: 1,
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: WdsColors.white,
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all(WdsColors.white),
      ),
    ),
    popupMenuTheme: const PopupMenuThemeData(
      color: WdsColors.white,
      position: PopupMenuPosition.under,
    ),
  );

  static ThemeData darkTheme = lightTheme.copyWith(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: WdsColors.blue400,
      brightness: Brightness.dark,
      primary: WdsColors.blue300,
      onPrimary: WdsColors.neutral900,
      secondary: WdsColors.pink400,
      onSecondary: WdsColors.neutral900,
      surface: WdsColors.neutral900,
      onSurface: WdsColors.white,
      surfaceContainerHighest: WdsColors.neutral800,
      outline: WdsColors.neutral600,
      outlineVariant: WdsColors.neutral700,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: WdsColors.neutral900,
      foregroundColor: WdsColors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: WdsTypography.heading18Bold.copyWith(
        color: WdsColors.white,
      ),
    ),
    cardTheme: CardThemeData(
      color: WdsColors.neutral800,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: WdsColors.neutral600),
      ),
    ),
  );
}
