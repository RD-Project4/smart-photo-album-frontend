import 'dart:convert';

import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lpinyin/lpinyin.dart';
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
    //加载联系人列表
    rootBundle.loadString('assets/data/friends.json').then((value) {
      List list = json.decode(value);
      list.forEach((v) {
        _friends.add(FriendInfo.fromJson(v));
      });
      _handleList(_friends);
    });
  }

  void _handleList(List<FriendInfo> list) {
    if (list.isEmpty) return;
    for (int i = 0, length = list.length; i < length; i++) {
      String pinyin = PinyinHelper.getPinyinE(list[i].name);
      String tag = pinyin.substring(0, 1).toUpperCase();
      list[i].namePinyin = pinyin;
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
    _friends.insert(0, FriendInfo(name: 'header', tagIndex: '↑'));

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
              "fkmog",
              textScaleFactor: 1.2,
            ),
          ),
          Text("1073638314@qq.com"),
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
              model.name[0],
              style: TextStyle(color: Colors.white),
            ),
          ),
          title: Text(model.name),
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

