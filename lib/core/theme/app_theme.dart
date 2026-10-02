import 'package:flutter/cupertino.dart';
import '../constants/app_constants.dart';

class AppTheme {
  static CupertinoThemeData get lightTheme {
    return const CupertinoThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.orangeAccent,
      scaffoldBackgroundColor: AppColors.lightBackground,
      barBackgroundColor: Color(0xCCF2F2F7),
      textTheme: CupertinoTextThemeData(
        textStyle: TextStyle(
          fontFamily: AppConstants.fontFamilyInter,
          color: AppColors.lightTextPrimary,
          fontSize: 17,
        ),
        navTitleTextStyle: TextStyle(
          fontFamily: AppConstants.fontFamilyInter,
          fontWeight: FontWeight.w600,
          color: AppColors.lightTextPrimary,
          fontSize: 17,
        ),
        navLargeTitleTextStyle: TextStyle(
          fontFamily: AppConstants.fontFamilyInter,
          fontWeight: FontWeight.w700,
          color: AppColors.lightTextPrimary,
          fontSize: 34,
        ),
      ),
    );
  }

  static CupertinoThemeData get darkTheme {
    return const CupertinoThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.orangeAccent,
      scaffoldBackgroundColor: AppColors.darkBackground,
      barBackgroundColor: Color(0xCC1C1C1E),
      textTheme: CupertinoTextThemeData(
        textStyle: TextStyle(
          fontFamily: AppConstants.fontFamilyInter,
          color: AppColors.darkTextPrimary,
          fontSize: 17,
        ),
        navTitleTextStyle: TextStyle(
          fontFamily: AppConstants.fontFamilyInter,
          fontWeight: FontWeight.w600,
          color: AppColors.darkTextPrimary,
          fontSize: 17,
        ),
        navLargeTitleTextStyle: TextStyle(
          fontFamily: AppConstants.fontFamilyInter,
          fontWeight: FontWeight.w700,
          color: AppColors.darkTextPrimary,
          fontSize: 34,
        ),
      ),
    );
  }
}
