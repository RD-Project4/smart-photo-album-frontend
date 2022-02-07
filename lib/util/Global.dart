import 'package:flutter/material.dart';

class Global {
  static const String ROOT_PATH = "/storage/emulated/0/";
  // 用在Tabs页面
  @Deprecated("不再使用")
  static final GlobalKey<ScaffoldState> tabsKey = GlobalKey<ScaffoldState>();
}
