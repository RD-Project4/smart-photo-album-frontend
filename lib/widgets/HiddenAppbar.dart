import 'package:flutter/material.dart';

class HiddenAppbar extends StatelessWidget with PreferredSizeWidget {
  final String title;

  const HiddenAppbar({Key? key, this.title = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(
        color: Colors.black, //change your color here
      ),
      title: Text(title),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
