import 'package:flutter/material.dart';
import 'package:fms/core/constant/fonts.dart';

import '../constant/colors.dart';
import '../constant/text_styles.dart';

enum ThemeEnum {
  light(),
  dark();

  const ThemeEnum();
  factory ThemeEnum.parse(String value) {
    switch (value) {
      case 'dark':
        return ThemeEnum.dark;
      default:
        return ThemeEnum.light;
    }
  }
}

extension ThemeEnumExtension on ThemeEnum {
  ThemeData get theme {
    return switch (this) {
      ThemeEnum.light => lightTheme,
      ThemeEnum.dark => darkTheme,
    };
  }
}

const Duration kDialogTransitionDuration = Duration(milliseconds: 300);
const Duration kScrollTransitionDuration = Duration(milliseconds: 50);
const ScrollPhysics kPhysics =
    RangeMaintainingScrollPhysics(parent: ClampingScrollPhysics());

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: AppFonts.lato,
    colorScheme: ColorScheme.light(
      surface: AppColors.aliceBlue,
      primary: AppColors.blackRussian,
    ),
    splashFactory: NoSplash.splashFactory,
    visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
    pageTransitionsTheme:
        PageTransitionsTheme(builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    }),
    extensions: [AppTextTheme.fallback()]);

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: AppFonts.lato,
    colorScheme: ColorScheme.dark(
      surface: AppColors.aliceBlue,
    ),
    splashFactory: NoSplash.splashFactory,
    visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
    pageTransitionsTheme:
        PageTransitionsTheme(builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    }),
    extensions: [AppTextTheme.fallback()]);
