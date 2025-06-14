import 'package:flutter/material.dart';

class ResponsiveHelper {
  static double getHeight(BuildContext context, double height) {
    return MediaQuery.of(context).size.height * height;
  }

  static double getWidth(BuildContext context, double width) {
    return MediaQuery.of(context).size.width * width;
  }

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 600 && MediaQuery.of(context).size.width < 1200;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1200;
  }
}