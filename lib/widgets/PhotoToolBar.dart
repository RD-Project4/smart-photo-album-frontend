import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_album/pages/photo_edit_page/PhotoEditPage.dart';
import 'package:smart_album/TensorflowResultPanel.dart';
import 'package:smart_album/bloc/photo_list/PhotoListCubit.dart';
import 'package:flutter/services.dart';
import 'package:smart_album/pages/Tabs.dart';
import 'package:smart_album/pages/tabs/Setting.dart';
import 'package:smart_album/util/CommonUtil.dart';
import 'package:smart_album/util/FavoritesUtil.dart';
import 'package:smart_album/util/ShareUtil.dart';
import 'package:http/http.dart' as http;

class PhotoToolBar extends StatefulWidget {
  final photoIndex;

  const PhotoToolBar({Key? key, required this.photoIndex}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PhotoToolBarState();
}

class _PhotoToolBarState extends State<PhotoToolBar> {
  var isFavorite = false;

  @override
  Widget build(BuildContext context) {
    var photos = BlocProvider.of<PhotoListCubit>(context).state.photos;
    var currentPhoto = photos[widget.photoIndex];


    FavoritesUtil.isFavorite(currentPhoto.id).then((value) {
      if(isFavorite == value) {
        return;
      }
      setState(() {
        isFavorite = value;
      });
    });

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
              TensorflowResultPanel.open(context, photos[widget.photoIndex]);
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
          IconText(
              icon: Icons.edit,
              text: "Edit",
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return PhotoEditPage(
                    entity: currentPhoto,
                  );
                }));
              }),
          IconText(
            icon: Icons.cloud_upload_rounded,
            text: "Upload",
            onTap: () {
              if (Tabs.loginstate == 1) {
                // Navigator.pushNamed(context, '/login-page');
                Navigator.pushNamed(context, '/testpage'); //测试时候用的，需要删除
                _clouds();
              } else {
                Navigator.pushNamed(context, '/testpage');
                // _clouds();

                // Navigator.pushNamed(context, '/testpage');
              }
            },
          ),
          IconText(
            icon: Icons.favorite,
            color: isFavorite ? Colors.red : Colors.white,
            text: "Favorite",
            onTap: () async {
              if (isFavorite) {
                print('取消收藏');
                var res = await FavoritesUtil.removeFromFavoritesList(
                    currentPhoto.id);
                if (res) {
                  setState(() {
                    isFavorite = false;
                  });
                }
              } else {
                print('添加收藏');
                var res =
                    await FavoritesUtil.addToFavoritesList(currentPhoto.id);
                if (res) {
                  setState(() {
                    isFavorite = true;
                  });
                }
              }
            },
          ),
          // IconText(
          //   icon: Icons.delete,
          //   text: "Delete",
          //   onTap: () {},
          // )
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
  final icon, text, onTap, color;

  IconText(
      {Key? key,
      required this.icon,
      required this.text,
      Color? this.color,
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
            color: color != null ? color : Colors.white,
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
