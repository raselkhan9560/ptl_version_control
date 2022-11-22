
import 'package:flutter/material.dart';

class Utils {
  static var unFocus = FocusManager.instance.primaryFocus?.unfocus();
  static Duration connectionDuration = Duration(seconds: 3);

  static String DEACTIVATE = '3';
  static String DEPRICATED = '2';
  static String ACTIVE = '1';
}

class AppColors {
  static Color primaryColor = Color(0xffFec7e23);
  static Color onPrimaryColor = Colors.white;

  static Color secondaryColor = Color(0xff275a8a);
  static Color onSecondaryColor = Colors.white;

  static Color surfaceColor = Colors.white;
  static Color onSurfaceColor = Colors.black;
}