import 'package:flutter/material.dart';
import 'package:smart_album/pages/ScannerPage.dart';

import 'package:smart_album/pages/user/PassResetPage.dart';
import 'package:smart_album/pages/user/RegisterPage.dart';
import 'package:smart_album/pages/AddFriends.dart';

import 'package:smart_album/pages/friends/FriendsPage.dart';
import 'package:smart_album/pages/friends/FriendsSelectPage.dart';

import '../FolderPage.dart';
import '../HomePage.dart';
import '../pages/Tabs.dart';

import '../pages/tabs/Setting.dart';
import '../pages/user/LoginPage.dart';

import '../pages/TestPage.dart';

//配置路由
final routes = {
  '/': (context) => Tabs(),

  // '/search': (context, {arguments}) => SearchPage(arguments: arguments), //需要传值
  // '/productinfo': (context, {arguments}) =>
  //     ProductInfoPage(arguments: arguments),
  '/login-page': (context) => LoginPage(),
  '/register-page': (context) => RegisterPage(),
  '/pass-reset': (context) => PassResetPage(),
  '/setting': (context) => Setting(),
  '/main': (context) => Tabs(),
  '/friends': (context) => FriendsPage(),
  '/add-friends': (context) => AddFriends(),
  '/friends-select': (context) => FriendsSelectPage(),
  '/scanner': (context) => ScannerPage(),
  '/folderPage': (context, {arguments}) => FolderPage(arguments: arguments),
  '/testpage': (context) => TestPage(),
};
//固定写法
var onGenerateRoute = (RouteSettings settings) {
  final String? name = settings.name;
  print(settings.name);
  print(settings.arguments);
  final Function pageContentBuilder = routes[name] as Function;
  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      final Route route = MaterialPageRoute(
          builder: (context) =>
              pageContentBuilder(context, arguments: settings.arguments));
      return route;
    } else {
      final Route route =
          MaterialPageRoute(builder: (context) => pageContentBuilder(context));
      return route;
    }
  }
};
