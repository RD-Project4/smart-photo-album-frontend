import 'dart:io';
import 'package:flutter/material.dart';

class ListedPhoto extends StatefulWidget {
  final path;
  final onTap;

  const ListedPhoto({Key? key, required this.path, this.onTap})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ListedPhotoState();
}

class _ListedPhotoState extends State<ListedPhoto> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: GestureDetector(
      child: Stack(
        children: [
          Container(
              margin: EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(File(widget.path)),
                  fit: BoxFit.cover,
                ),
              )),
          Checkbox(
            value: isChecked,
            side: BorderSide(color: Colors.white, width: 2),
            onChanged: (status) {},
          )
        ],
      ),
      onTap: () {
        widget.onTap();
      },
      onLongPress: () {
        setState(() {
          isChecked = !isChecked;
        });
      },
    ));
  }
}
