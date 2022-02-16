import 'dart:convert';
import 'dart:ui';

import 'package:azlistview/azlistview.dart';
import 'package:flutter/cupertino.dart';

class FriendInfo extends ISuspensionBean {
  String name;
  String? tagIndex;
  String? namePinyin;

  Color? bgColor;
  IconData? iconData;

  String? img;
  String? id;
  String? firstLetter;

  FriendInfo({
    required this.name,
    this.tagIndex,
    this.namePinyin,
    this.bgColor,
    this.iconData,
    this.img,
    this.id,
    this.firstLetter,
  });

  FriendInfo.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        img = json['img'],
        id = json['id']?.toString(),
        firstLetter = json['firstLetter'],
        tagIndex = json['tagIndex'],
        namePinyin = json['namPinyin'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
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
