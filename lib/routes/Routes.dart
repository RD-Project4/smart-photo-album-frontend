import 'package:flutter/material.dart';
import 'package:smart_album/ShareViewPage.dart';
import 'package:smart_album/pages/AddFriends.dart';
import 'package:smart_album/pages/ScannerPage.dart';
import 'package:smart_album/pages/friends/FriendsPage.dart';
import 'package:smart_album/pages/friends/FriendsSelectPage.dart';
import 'package:smart_album/pages/photo/FavoritePage.dart';
import 'package:smart_album/pages/photo/TrashBIn.dart';
import 'package:smart_album/pages/photo/UploadList.dart';
import 'package:smart_album/pages/share/ManageSharePage.dart';
import 'package:smart_album/pages/user/PassResetPage.dart';
import 'package:smart_album/pages/user/RegisterPage.dart';

import '../FolderPage.dart';
import '../pages/Tabs.dart';
import '../pages/tabs/Setting.dart';
import '../pages/user/LoginPage.dart';

//配置路由
final routes = {
  '/Home': (context) => Tabs(),
  '/trashbin': (context) => TrashBin(),
  '/favorite': (context) => FavoritePage(),
  "/uploadList": (context) => UploadList(),
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
  '/friends-select': (context, {arguments}) => FriendsSelectPage(arguments),
  '/scanner': (context) => ScannerPage(),
  '/folderPage': (context, {arguments}) => FolderPage(arguments: arguments),
  '/manage-share': (context) => ManageSharePage(),
  '/share-view': (context, {arguments}) => ShareViewPage(shareId: arguments)
};
//固定写法
var onGenerateRoute = (RouteSettings settings) {
  var name = settings.name;
  var arguments = settings.arguments;
  if (name!.contains("?")) {
    var splitList = name.split("?");
    name = splitList[0];
    arguments = splitList[1];
  }
  print(name);
  print(arguments);
  final Function pageContentBuilder = routes[name] as Function;
  if (arguments != null) {
    final Route route = MaterialPageRoute(
        builder: (context) =>
            pageContentBuilder(context, arguments: arguments));
    return route;
  } else {
    final Route route =
        MaterialPageRoute(builder: (context) => pageContentBuilder(context));
    return route;
  }
};
