import 'package:flutter/material.dart';

class LightAppBar extends AppBar {
  final String titleString;

  LightAppBar(BuildContext context, this.titleString,
      {Key? key, List<Widget>? actions})
      : super(
            key: key,
            title: Text(titleString),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            foregroundColor: Colors.black,
            actions: actions);
}
