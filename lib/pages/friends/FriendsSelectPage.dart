import 'dart:convert';

import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:smart_album/model/FriendInfo.dart';

class FriendsSelectPage extends StatefulWidget {
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
                model.name[0],
                style: TextStyle(color: Colors.white),
              ),
            ),
            title: Text(model.name),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Share with friends',
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
            ),
            Positioned(
                bottom: 0,
                // height: 100,
                width: MediaQuery.of(context).size.width,
                child: BottomBar()),
          ],
        ));
  }
}

class BottomBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  bool _haveSelectAll = false; // 是否已全选

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left:10,right: 10),
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
          ElevatedButton(onPressed: () {}, child: Text('Share')),
          Row(
            children: [
              Text('Select all'),
              Checkbox(
                value: _haveSelectAll,
                onChanged: (bool? newValue) {
                  setState(() {
                    // if (_haveSelectAll) {
                    //   _selectedFriends = [];
                    //   _haveSelectAll = false;
                    // } else {
                    //   _selectedFriends = [..._friends];
                    //   _haveSelectAll = true;
                    // }
                  });
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
