import 'package:flutter/material.dart';
import 'package:multiutillib/utils/ui_helpers.dart';

class imageStyle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: ClipOval(
        //头像
        child: Image.asset('images/1.jpg'),
      ),
    );
  }
}
