import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smart_album/api/api.dart';
import 'package:smart_album/model/FriendInfo.dart';
import 'package:smart_album/model/Photo.dart';

class ShareUtil {
  static Future openShareBottomSheet(
      BuildContext parentContext, List<Photo> photoList) async {
    final option = await showModalBottomSheet(
        context: parentContext,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                  title: RichText(
                text: TextSpan(
                  text: 'Share ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(
                        text: photoList.length.toString(),
                        style: TextStyle(color: Colors.blueAccent)),
                    TextSpan(
                        text: ' photo${photoList.length > 1 ? 's' : ''} with:'),
                  ],
                ),
              )),
              ListTile(
                title: Text('Everyone', textAlign: TextAlign.center),
                onTap: () {
                  Navigator.pop(context, '分享给所有人');
                  shareToEveryone(parentContext, photoList);
                },
              ),
              ListTile(
                title: Text('Only my friends', textAlign: TextAlign.center),
                onTap: () {
                  Navigator.pop(context, '只分享给朋友');
                  Navigator.pushNamed(parentContext, '/friends-select',
                      arguments: photoList);
                },
              ),
              ListTile(
                title: Text(
                  'Cancel',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context, '取消');
                },
              ),
            ],
          );
        });

    print(option);
  }

  static void shareToEveryone(
      BuildContext context, List<Photo> photoList) async {
    String id = await Api.get().shareToEveryone(photoList);
    showLink(context, Api.toShareLink(id));
  }

  static void shareToFriends(BuildContext context, List<FriendInfo> friends,
      List<Photo> photoList) async {
    String id = await Api.get().shareTo(photoList, friends);
    showLink(context, Api.toShareLink(id));
  }

  static void showLink(BuildContext context, String shareUrl) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(mainAxisSize: MainAxisSize.min, children: [
            QrImage(
              data: shareUrl,
              version: QrVersions.auto,
              size: 200.0,
              embeddedImage: AssetImage('images/logo_white_bg.png'),
              errorCorrectionLevel: QrErrorCorrectLevel.H,
            ),
            ListTile(
              title: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      shareUrl,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        showToast("Link Copied");
                        Clipboard.setData(ClipboardData(text: shareUrl));
                      },
                      icon: Icon(Icons.content_copy)),
                  IconButton(
                    icon: Icon(Icons.share_outlined),
                    onPressed: () {
                      Share.share(shareUrl);
                    },
                  ),
                  // CopyBtn(
                  //   text: shareUrl,
                  // )
                ],
              ),
            ),
            ListTile(
              title: Text(
                'Cancel',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context, '取消');
              },
            ),
          ]);
        });
  }
}
