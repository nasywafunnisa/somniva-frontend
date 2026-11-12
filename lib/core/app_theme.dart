import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static const String fontKeluarga = 'PlusJakartaSans';

  static ThemeData get terang {
    return ThemeData(
      useMaterial3: true,
      fontFamily: fontKeluarga,
      scaffoldBackgroundColor: AppColors.krim,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.hijauTua,
        primary: AppColors.hijauTua,
        surface: AppColors.krim,
      ),
    );
  }
}
