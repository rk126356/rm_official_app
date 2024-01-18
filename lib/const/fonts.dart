import 'package:flutter/material.dart';
import 'package:rm_official_app/const/colors.dart';

class AppFonts {
  static const String regularFont = 'Roboto';
  static const String headingFont = 'Montserrat';

  static const TextStyle regularTextStyle = TextStyle(
    fontFamily: regularFont,
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle headingTextStyle = TextStyle(
      fontFamily: headingFont,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
      color: AppColors.yellowType);
}
