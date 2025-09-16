import 'package:flutter/material.dart';

class AppConstants {
  // App Name
  static const String appName = "ApexAutoLab";

  // App Logo widget (can be reused anywhere)
  static Widget appLogo({double size = 120}) {
    return Image.asset(
      'assets/logo.jpg',
      width: size,
      height: size,
    );
  }
}
