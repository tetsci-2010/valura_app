import 'package:flutter/material.dart';
import 'package:valura/constants/colors.dart';
import 'package:valura/utils/size_constant.dart';

class AppTheme {
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      fontFamily: 'BYekan',
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: kPrimaryColor,
        foregroundColor: kWhiteColor,
      ),
      appBarTheme: AppBarTheme(backgroundColor: kPrimaryColor, foregroundColor: kWhiteColor),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: kPrimaryColor,
        linearTrackColor: kWarningTrackColor,
        refreshBackgroundColor: kWarningBgColor,
      ),
      datePickerTheme: DatePickerThemeData(locale: Locale('fa')),
      typography: Typography.material2021(),
      popupMenuTheme: PopupMenuThemeData(
        color: Theme.of(context).scaffoldBackgroundColor,
        textStyle: Theme.of(context).textTheme.titleMedium,
      ),
      brightness: Brightness.light,
      primaryColor: kPrimaryColor,
      cardColor: kGreyColor200,
      menuButtonTheme: MenuButtonThemeData(style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Theme.of(context).scaffoldBackgroundColor))),
      menuTheme: MenuThemeData(
        style: MenuStyle(backgroundColor: WidgetStatePropertyAll(Theme.of(context).scaffoldBackgroundColor)),
      ),
      shadowColor: lightBoxShadowColor,
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: kPrimaryColor.withAlpha(80), fontWeight: FontWeight.bold),
        labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: kPrimaryColor, fontWeight: FontWeight.bold),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
          borderSide: BorderSide(color: kPrimaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
          borderSide: BorderSide(color: kRedColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
          borderSide: BorderSide(color: kPrimaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
          borderSide: BorderSide(color: kSecondaryColor),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
          borderSide: BorderSide(color: kPrimaryColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
          borderSide: BorderSide(color: kPrimaryColor),
        ),
      ),
      textTheme: getLightTextTheme(),
    );
  }

  static ThemeData darkTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.dark,
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      fontFamily: 'BYekan',
      typography: Typography.material2021(),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: kPrimaryColor,
        foregroundColor: kWhiteColor,
      ),
      menuButtonTheme: MenuButtonThemeData(style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Theme.of(context).scaffoldBackgroundColor))),
      menuTheme: MenuThemeData(
        style: MenuStyle(backgroundColor: WidgetStatePropertyAll(Theme.of(context).scaffoldBackgroundColor)),
      ),
      appBarTheme: AppBarTheme(backgroundColor: kPrimaryColor, foregroundColor: kWhiteColor),
      datePickerTheme: DatePickerThemeData(locale: Locale('fa')),
      primaryColor: kPrimaryColor,
      shadowColor: darkBoxShadowColor,
      popupMenuTheme: PopupMenuThemeData(
        color: Theme.of(context).scaffoldBackgroundColor,
        textStyle: Theme.of(context).textTheme.titleMedium,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: kPrimaryColor,
        linearTrackColor: kWarningTrackColor,
        refreshBackgroundColor: kWarningBgColor,
      ),
      cardColor: kGreyColor800,
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: kPrimaryColor.withAlpha(80), fontWeight: FontWeight.bold),
        labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: kPrimaryColor, fontWeight: FontWeight.bold),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
          borderSide: BorderSide(color: kPrimaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
          borderSide: BorderSide(color: kRedColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
          borderSide: BorderSide(color: kPrimaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
          borderSide: BorderSide(color: kSecondaryColor),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
          borderSide: BorderSide(color: kPrimaryColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
          borderSide: BorderSide(color: kPrimaryColor),
        ),
      ),
      textTheme: getDarkTextTheme(),
    );
  }
}

TextTheme getLightTextTheme() {
  return TextTheme(
    displayLarge: TextStyle(
      fontSize: sizeConstants.fontDisplayLarge,
      fontWeight: FontWeight.bold,
      color: kBlackColor87,
    ),
    displayMedium: TextStyle(
      fontSize: sizeConstants.fontDisplayMedium,
      fontWeight: FontWeight.w600,
      color: kBlackColor87,
    ),
    headlineLarge: TextStyle(
      fontSize: sizeConstants.fontHeadlineLarge,
      fontWeight: FontWeight.w600,
      color: kBlackColor87,
    ),
    headlineMedium: TextStyle(
      fontSize: sizeConstants.fontHeadlineMedium,
      fontWeight: FontWeight.w500,
      color: kBlackColor87,
    ),
    titleLarge: TextStyle(
      fontSize: sizeConstants.fontTitleLarge,
      fontWeight: FontWeight.w600,
      color: kBlackColor87,
    ),
    titleMedium: TextStyle(
      fontSize: sizeConstants.fontTitleMedium,
      color: kBlackColor87,
    ),
    bodyLarge: TextStyle(
      fontSize: sizeConstants.fontBodyLarge,
      color: kBlackColor87,
    ),
    bodyMedium: TextStyle(
      fontSize: sizeConstants.fontBodyMedium,
      color: kPrimaryColor,
    ),
    labelLarge: TextStyle(
      fontSize: sizeConstants.fontLabelLarge,
      color: kGreyColor700,
    ),
    labelSmall: TextStyle(
      fontSize: sizeConstants.fontLabelSmall,
      color: kGreyColor600,
    ),
  );
}

TextTheme getDarkTextTheme() {
  return TextTheme(
    displayLarge: TextStyle(
      fontSize: sizeConstants.fontDisplayLarge,
      fontWeight: FontWeight.bold,
      color: kWhiteColor,
    ),
    displayMedium: TextStyle(
      fontSize: sizeConstants.fontDisplayMedium,
      fontWeight: FontWeight.w600,
      color: kWhiteColor,
    ),
    headlineLarge: TextStyle(
      fontSize: sizeConstants.fontHeadlineLarge,
      fontWeight: FontWeight.w600,
      color: kWhiteColor,
    ),
    headlineMedium: TextStyle(
      fontSize: sizeConstants.fontHeadlineMedium,
      fontWeight: FontWeight.w500,
      color: kWhiteColor,
    ),
    titleLarge: TextStyle(
      fontSize: sizeConstants.fontTitleLarge,
      fontWeight: FontWeight.w600,
      color: kWhiteColor,
    ),
    titleMedium: TextStyle(
      fontSize: sizeConstants.fontTitleMedium,
      color: kWhiteColor,
    ),
    bodyLarge: TextStyle(
      fontSize: sizeConstants.fontBodyLarge,
      color: kWhiteColor,
    ),
    bodyMedium: TextStyle(
      fontSize: sizeConstants.fontBodyMedium,
      color: kWhiteColor,
    ),
    labelLarge: TextStyle(
      fontSize: sizeConstants.fontLabelLarge,
      color: kGreyColor400,
    ),
    labelSmall: TextStyle(
      fontSize: sizeConstants.fontLabelSmall,
      color: kGreyColor500,
    ),
  );
}
