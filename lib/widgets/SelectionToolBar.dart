import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectionToolBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SelectionToolBarState();
}

class _SelectionToolBarState extends State<SelectionToolBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(220, 194, 231, 255),
      height: 60,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(width: 10),
              Icon(Icons.close),
              SizedBox(width: 10),
              Text('123'),
            ],
          ),
          Row(
            children: [
              Icon(Icons.share),
              SizedBox(width: 10),
              Icon(Icons.delete),
              SizedBox(width: 10),
              Icon(Icons.more_vert),
              SizedBox(width: 10),
            ],
          )
        ],
      ),
    );
  }
}
