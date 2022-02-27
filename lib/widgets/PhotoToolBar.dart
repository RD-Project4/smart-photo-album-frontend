import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_album/PhotoEditPage.dart';
import 'package:smart_album/PhotoList.dart';
import 'package:smart_album/TensorflowResultPanel.dart';
import 'package:smart_album/bloc/photo_list/PhotoListCubit.dart';
import 'package:flutter/services.dart';
import 'package:smart_album/pages/Tabs.dart';
import 'package:smart_album/pages/tabs/Setting.dart';
import 'package:smart_album/util/ShareUtil.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;

class PhotoToolBar extends StatelessWidget {
  final photoIndex;

  const PhotoToolBar({Key? key, required this.photoIndex}) : super(key: key);

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
            icon: Icons.search,
            text: "Similar",
            onTap: () {
              var photos =
                  BlocProvider.of<PhotoListCubit>(context).state.photos;
              TensorflowResultPanel.open(context, photos[photoIndex]);
            },
          ),
          IconText(
              icon: Icons.share,
              text: "Share",
              onTap: () {
                // Fluttertoast.showToast(msg: "Share");
                ShareUtil.openShareBottomSheet(context, 1);
                // _shareToEveryone(context);
              }),
          // IconText(
          //     icon: Icons.edit,
          //     text: "Edit",
          //     onTap: () {
          //       var photos =
          //           BlocProvider.of<PhotoListCubit>(context).state.photos;
          //       Navigator.push(context, MaterialPageRoute(builder: (context) {
          //         return PhotoEditPage(
          //           entity: photos[photoIndex],
          //         );
          //       }));
          //     }),
          IconText(
            icon: Icons.cloud_upload_rounded,
            text: "Upload",
            onTap: () {
              if (Tabs.loginstate == 1) {
                Navigator.pushNamed(context, '/login-page');
              } else {
                _clouds();
              }
            },
          ),
          IconText(
            icon: Icons.favorite_border,
            text: "Favorite",
            onTap: () {},
          ),
          IconText(
            icon: Icons.delete,
            text: "Delete",
            onTap: () {},
          )
        ],
      ),
    );
  }

  _clouds() async {
    print('uploading clouds');
    // print(Setting.userAccount);
    print(Setting.userEmail);
    var apiurl =
        Uri.parse('http://124.223.68.12:8233/smartAlbum/uploadcloudpic.do');
    var response = await http.post(apiurl, body: {
      "local":
          '/usr/local/bttomcat/tomcat9/webapps/smartAlbum/WEB-INF/views/robot.jpeg',
      "picOwner": Setting.userEmail,
      "label": "null"
    });

    print('Response status : ${response.statusCode}');
    print('Response status : ${response.body}');
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

class CopyBtn extends StatefulWidget {
  final String text;

  CopyBtn({Key? key, required this.text}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CopyBtnState();
}

class _CopyBtnState extends State<CopyBtn> {
  var hasCopied = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          Clipboard.setData(ClipboardData(text: widget.text));
          setState(() {
            hasCopied = true;
          });
        },
        child: Text(hasCopied ? 'Copied' : 'Copy'));
  }
}
