import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:smart_album/pages/friends/FriendsSelectPage.dart';
import 'package:smart_album/widgets/PhotoToolBar.dart';
import 'package:smart_album/model/FriendInfo.dart';

class ShareUtil {
  static Future openShareBottomSheet(BuildContext context, int photoNum) async {
    final option = await showModalBottomSheet(
        context: context,
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
                        text: '$photoNum',
                        style: TextStyle(color: Colors.blueAccent)),
                    TextSpan(text: ' photo${photoNum > 1 ? 's' : ''} with:'),
                  ],
                ),
              )),
              ListTile(
                title: Text('Everyone', textAlign: TextAlign.center),
                onTap: () {
                  Navigator.pop(context, '分享给所有人');
                  shareToEveryone(context);
                },
              ),
              ListTile(
                title: Text('Only my friends', textAlign: TextAlign.center),
                onTap: () {
                  Navigator.pop(context, '只分享给朋友');
                  Navigator.pushNamed(context, '/friends-select');
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

  static void shareToEveryone(BuildContext context) {
    // TODO: 从api获取分享链接并赋值给shareUrl
    var shareUrl = FriendsSelectPage.url;
    _showLink(context, shareUrl);
  }

  static void shareToFriends(BuildContext context, List<FriendInfo> friends) {
    print(friends);

    // TODO: 从api获取分享链接并赋值给shareUrl
    var shareUrl = FriendsSelectPage.url;
    _showLink(context, shareUrl);
  }

  static _showLink(BuildContext context, String shareUrl) {
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
                  CopyBtn(
                    text: shareUrl,
                  )
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
