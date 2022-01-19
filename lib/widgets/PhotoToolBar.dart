import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_album/PhotoEditPage.dart';

class PhotoToolBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(128, 128, 128, 128),
      height: 70,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconText(
              icon: Icons.share,
              text: "Share",
              onTap: () {
                Fluttertoast.showToast(msg: "Share");
              }),
          IconText(
              icon: Icons.edit,
              text: "Edit",
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return PhotoEditPage();
                }));
              }),
          IconText(icon: Icons.favorite_border, text: "Favorite"),
          IconText(icon: Icons.delete, text: "Delete")
        ],
      ),
    );
  }
}

class IconText extends StatelessWidget {
  final icon, text, onTap;

  IconText(
      {Key? key,
      required this.icon,
      required this.text,
      void Function()? this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
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
      ),
      onTap: onTap,
    );
  }
}
