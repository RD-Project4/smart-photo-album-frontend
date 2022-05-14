import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LightAppBar extends AppBar {
  LightAppBar(BuildContext context, String titleString,
      {Key? key, List<Widget>? actions, Color? backgroundColor})
      : super(
            key: key,
            title: Text(titleString),
            backgroundColor:
                backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            foregroundColor: Colors.black,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Theme.of(context).scaffoldBackgroundColor,
              statusBarIconBrightness: Brightness.dark,
            ),
            actions: actions);
}
