import 'dart:convert';
import 'dart:ui';

import 'package:azlistview/azlistview.dart';
import 'package:flutter/cupertino.dart';

class FriendInfo extends ISuspensionBean {
  String userName;
  String? tagIndex;
  String? userNamePinyin;

  Color? bgColor;
  IconData? iconData;

  String? img;
  String? id;
  String? firstLetter;

  FriendInfo({
    required this.userName,
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
        img = json['img'],
        id = json['id']?.toString(),
        firstLetter = json['firstLetter'],
        tagIndex = json['tagIndex'],
        userNamePinyin = json['userNamePinyin'];

  Map<String, dynamic> toJson() => {
//        'id': id,
        'userName': userName,
        'img': img,
//        'firstletter': firstletter,
//        'tagIndex': tagIndex,
//        'userNamePinyin': userNamePinyin,
//        'isShowSuspension': isShowSuspension
      };

  static FriendInfo copy(FriendInfo model) {
    return FriendInfo.fromJson(model.toJson());
  }

  @override
  String getSuspensionTag() => tagIndex ?? "";

  @override
  String toString() => json.encode(this);
}
