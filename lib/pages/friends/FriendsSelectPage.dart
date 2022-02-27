import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:smart_album/PhotoList.dart';
import 'package:smart_album/model/FriendInfo.dart';
import 'package:smart_album/pages/tabs/Setting.dart';
import 'package:smart_album/util/ShareUtil.dart';
import 'package:smart_album/widgets/TabsDrawer.dart';

class FriendsSelectPage extends StatefulWidget {
  static var url = '';
  @override
  State<StatefulWidget> createState() => _FriendsSelectPageState();
}

class _FriendsSelectPageState extends State<FriendsSelectPage> {
  List<FriendInfo> _friends = [];
  List<FriendInfo> _selectedFriends = [];
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

    setState(() {});
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
    bool _isSelected = _selectedFriends.indexOf(model) != -1;

    void _changeSelection() {
      setState(() {
        if (_isSelected) {
          _selectedFriends.remove(model);
        } else {
          _selectedFriends.add(model);
        }
      });
    }

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
            onTap: _changeSelection,
            trailing: Container(
              margin: EdgeInsets.only(right: 20),
              child: Checkbox(
                value: _isSelected,
                onChanged: (bool? newValue) {
                  _changeSelection();
                },
              ),
            ))
      ],
    );
  }

  Decoration getIndexBarDecoration(Color color) {
    return BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: Colors.grey[300]!, width: .5));
  }

  /// 分享
  void _share() {
    Navigator.pop(context);
    ShareUtil.shareToFriends(context, _selectedFriends);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Share with ${_selectedFriends.length} friend${_selectedFriends.length > 1 ? 's' : ''}',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          elevation: 0,
        ),
        body: Stack(
          children: [
            AzListView(
              data: _friends,
              itemCount: _friends.length,
              itemBuilder: (BuildContext context, int index) {
                FriendInfo model = _friends[index];

                if (index == _friends.length - 1) {
                  // 最后一个在末尾增加占位空格

                  return Column(
                    children: [
                      _buildListItem(model),
                      Container(
                        width: double.infinity,
                        height: 50,
                      )
                    ],
                  );
                }

                return _buildListItem(model);
              },
              physics: BouncingScrollPhysics(),
              indexBarData: SuspensionUtil.getTagIndexList(_friends),
              indexHintBuilder: (context, hint) {
                // 头像
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
            ),
            Positioned(
                bottom: 0,
                // height: 100,
                width: MediaQuery.of(context).size.width,
                child: BottomBar(
                  selectAll: () {
                    setState(() {
                      _selectedFriends = [..._friends];
                    });
                  },
                  selectNone: () {
                    setState(() {
                      _selectedFriends = [];
                    });
                  },
                  haveSelectAll: _friends.length != 0 &&
                      _selectedFriends.length == _friends.length,
                  share: _selectedFriends.length != 0 ? _share : null,
                )),
          ],
        ));
  }
}

class BottomBar extends StatefulWidget {
  final selectAll, selectNone;
  final share;
  final bool haveSelectAll;

  BottomBar({
    Key? key,
    this.selectAll,
    this.selectNone,
    this.share,
    this.haveSelectAll = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    bool _haveSelectAll = widget.haveSelectAll;

    print('widget.haveSelectAll ${widget.haveSelectAll}');

    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, -1.0), //阴影y轴偏移量
            blurRadius: 10, //阴影模糊程度
            spreadRadius: 1)
      ]),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
              onPressed: () {
                _share();
                widget.share();
              },
              child: Text('Share')),
          Row(
            children: [
              Text('Select all'),
              Checkbox(
                  value: _haveSelectAll,
                  onChanged: (newValue) {
                    if (!_haveSelectAll) {
                      widget.selectAll();
                      _haveSelectAll = true;
                    } else {
                      widget.selectNone();
                      _haveSelectAll = false;
                    }
                  }),
            ],
          )
        ],
      ),
    );
  }

  _share() async {
    print('share pics');
    // print(Setting.userAccount);
    print(Setting.userEmail);
    print(PhotoList.picId);
    var apiurl = Uri.parse('http://124.223.68.12:8233/smartAlbum/addshare.do');
    var response = await http.post(apiurl, body: {
      "shareOwner": Setting.userEmail,
      "shareContentId": PhotoList.picId,
      "shareObject": "846630947@qq.com"
    });
    print('Response status : ${response.statusCode}');
    print('Response status : ${response.body}');
    setState(() {
      FriendsSelectPage.url = jsonDecode(response.body)["data"];
    });
  }
}
