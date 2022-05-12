import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';

class Global {
  static const String API_URL = 'http://124.223.68.12:8233/smartAlbum/';

  static const String ROOT_PATH = "/storage/emulated/0/";

  // 用在Tabs页面
  @Deprecated("不再使用")
  static final GlobalKey<ScaffoldState> tabsKey = GlobalKey<ScaffoldState>();

  static EventBus eventBus = EventBus();
}
