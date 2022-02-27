import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:smart_album/pages/tabs/Setting.dart';
import 'package:smart_album/widgets/TabsDrawer.dart';
import 'package:smart_album/model/FriendInfo.dart';

class FriendsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _FriendsPageState();
  }
}

class _FriendsPageState extends State<FriendsPage> {
  List<FriendInfo> _friends = [];
  double susItemHeight = 40;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    print('showing friends');
    print(Setting.userAccount);
    var apiurl =
        Uri.parse('http://124.223.68.12:8233/smartAlbum/showuserfriend.do');
    var response =
        await http.post(apiurl, body: {"userAccount": Setting.userAccount});
    print('Response status : ${response.statusCode}');
    print('Response status : ${response.body}');
    setState(() {
      TabsDrawer.list = jsonDecode(response.body)["data"];
    });

    //加载联系人列表
    // rootBundle.loadString('assets/data/friends.json').then((value) {
    //   print(value);
    //   List list = json.decode(value);
    //   print(list);
    //   list.forEach((v) {
    //     _friends.add(FriendInfo.fromJson(v));
    //   });
    //   _handleList(_friends);
    // });
    print(TabsDrawer.list);

    TabsDrawer.list.forEach((v) {
      _friends.add(FriendInfo.fromJson(v));
    });
    _handleList(_friends);
  }

  void _handleList(List<FriendInfo> list) {
    if (list.isEmpty) return;
    for (int i = 0, length = list.length; i < length; i++) {
      String pinyin = PinyinHelper.getPinyinE(list[i].userName);
      String tag = pinyin.substring(0, 1).toUpperCase();
      list[i].userNamePinyin = pinyin;
      if (RegExp("[A-Z]").hasMatch(tag)) {
        list[i].tagIndex = tag;
      } else {
        list[i].tagIndex = "#";
      }
    }
    // A-Z sort.
    SuspensionUtil.sortListBySuspensionTag(_friends);

    // show sus tag.
    SuspensionUtil.setShowSuspensionStatus(_friends);

    // add header.
    _friends.insert(0, FriendInfo(userName: 'header', tagIndex: '↑'));

    setState(() {});
  }

  /// 用户个人信息
  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ClipOval(
              child: Image.network(
            "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fnimg.ws.126.net%2F%3Furl%3Dhttp%253A%252F%252Fdingyue.ws.126.net%252F2021%252F0720%252F27836c7fj00qwiper0016c000hs00hsg.jpg%26thumbnail%3D650x2147483647%26quality%3D80%26type%3Djpg&refer=http%3A%2F%2Fnimg.ws.126.net&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1646826366&t=14ab6dfab50dc92f5d07cdc12c9a5ddf",
            width: 80.0,
          )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              Setting.userName,
              textScaleFactor: 1.2,
            ),
          ),
          Text(Setting.userEmail),
        ],
      ),
    );
  }

  /// 悬停效果
  Widget _buildSusWidget(String susTag) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      height: susItemHeight,
      width: double.infinity,
      alignment: Alignment.centerLeft,
      child: Row(
        children: <Widget>[
          Text(
            '$susTag',
            textScaleFactor: 1.2,
          ),
          Expanded(
              child: Divider(
            height: .0,
            indent: 10.0,
          ))
        ],
      ),
    );
  }

  /// 好友列表项
  Widget _buildListItem(FriendInfo model) {
    String susTag = model.getSuspensionTag();
    return Column(
      children: <Widget>[
        Offstage(
          offstage: model.isShowSuspension != true,
          child: _buildSusWidget(susTag),
        ),
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blue[700],
            child: Text(
              model.userName[0],
              style: TextStyle(color: Colors.white),
            ),
          ),
          title: Text(model.userName),
          onTap: () {
            print("OnItemClick: $model");

            // Navigator.pop(context, model);
          },
        )
      ],
    );
  }

  Decoration getIndexBarDecoration(Color color) {
    return BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: Colors.grey[300]!, width: .5));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'My Friends',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () {
                  print('add friends');
                },
                icon: Icon(Icons.person_add))
          ],
        ),
        body: AzListView(
          data: _friends,
          itemCount: _friends.length,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) return _buildHeader();
            FriendInfo model = _friends[index];
            return _buildListItem(model);
          },
          physics: BouncingScrollPhysics(),
          indexBarData: SuspensionUtil.getTagIndexList(_friends),
          indexHintBuilder: (context, hint) {
            return Container(
              alignment: Alignment.center,
              width: 60.0,
              height: 60.0,
              decoration: BoxDecoration(
                color: Colors.blue[700]!.withAlpha(200),
                shape: BoxShape.circle,
              ),
              child: Text(hint,
                  style: TextStyle(color: Colors.white, fontSize: 30.0)),
            );
          },
          indexBarMargin: EdgeInsets.all(10),
          indexBarOptions: IndexBarOptions(
            needRebuild: true,
            decoration: getIndexBarDecoration(Colors.grey[50]!),
            downDecoration: getIndexBarDecoration(Colors.grey[200]!),
          ),
        ));
  }
}

class FriendInfo extends ISuspensionBean {
  String userName;
  String? userEmail;
  String? tagIndex;
  String? userNamePinyin;

  Color? bgColor;
  IconData? iconData;

  String? img;
  String? id;
  String? firstLetter;

  FriendInfo({
    required this.userName,
    this.userEmail,
    this.tagIndex,
    this.userNamePinyin,
    this.bgColor,
    this.iconData,
    this.img,
    this.id,
    this.firstLetter,
  });

  FriendInfo.fromJson(Map<String, dynamic> json)
      : userName = json['userName'],
        userEmail = json['userEmail'],
        img = json['img'],
        id = json['id']?.toString(),
        firstLetter = json['firstletter'];

  Map<String, dynamic> toJson() => {
//        'id': id,
        'userName': userName,
        'userEmail': userEmail,
        // 'img': img,
//        'firstletter': firstletter,
//        'tagIndex': tagIndex,
//        'userNamePinyin': userNamePinyin,
//        'isShowSuspension': isShowSuspension
      };

  @override
  String getSuspensionTag() => tagIndex!;

  @override
  String toString() => json.encode(this);
}
