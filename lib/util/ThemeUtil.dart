import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThemeUtil {
  static setSystemOverlayLight(BuildContext context, {Color? backgroundColor}) {
    var background =
        backgroundColor ?? Theme.of(context).scaffoldBackgroundColor;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: background,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: background,
    ));
  }

  static setSystemOverlayDark(BuildContext context, {Color? backgroundColor}) {
    var background =
        backgroundColor ?? Theme.of(context).scaffoldBackgroundColor;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: background,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarColor: background,
    ));
  }
}
