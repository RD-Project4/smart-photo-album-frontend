import 'dart:convert';
import 'dart:ui';

import 'package:azlistview/azlistview.dart';
import 'package:flutter/cupertino.dart';

class FriendInfo extends ISuspensionBean {
  String userName;
  String? tagIndex;
  String? namePinyin;

  Color? bgColor;
  IconData? iconData;

  String? img;
  String? id;
  String? firstLetter;

  FriendInfo({
    required this.userName,
    this.tagIndex,
    this.namePinyin,
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
        namePinyin = json['namPinyin'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'userName': userName,
        'img': img,
        'firstLetter': firstLetter,
        'tagIndex': tagIndex,
        'namePinyin': namePinyin,
        // 'isShowSuspension': isShowSuspension
      };

  static FriendInfo copy(FriendInfo model) {
    return FriendInfo.fromJson(model.toJson());
  }

  @override
  String getSuspensionTag() => tagIndex ?? "";

  @override
  String toString() => json.encode(this);
}