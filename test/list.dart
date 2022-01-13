import 'package:flutter/material.dart';
import 'package:multiutillib/utils/ui_helpers.dart';

class list extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView(
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        Container(
          width: 180.0,
          height: 180.0,
          color: Colors.red[900],
        ),
        Container(
          width: 180.0,
          height: 180.0,
          color: Colors.red[900],
        ),
        Container(
          width: 180.0,
          height: 180.0,
          color: Colors.red[900],
        ),
        Container(
          width: 180.0,
          height: 180.0,
          color: Colors.red[900],
        ),
        Container(
          width: 180.0,
          height: 180.0,
          color: Colors.red[900],
        ),
      ],
    );
  }
}
