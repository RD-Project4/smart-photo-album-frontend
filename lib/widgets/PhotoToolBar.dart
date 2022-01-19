import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PhotoToolBar extends StatelessWidget {

  // ignore: non_constant_identifier_names
  Widget IconText(icon, text) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: Colors.white,
        ),
        Text(
          text,
          style: TextStyle(color: Colors.white),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(128, 128, 128, 128),
      height: 70,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconText(Icons.share, "Share"),
          IconText(Icons.edit, "Edit"),
          IconText(Icons.favorite_border, "Favorite"),
          IconText(Icons.delete, "Delete")
        ],
      ),
    );
  }
}
