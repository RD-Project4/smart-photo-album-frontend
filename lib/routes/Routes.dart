import 'package:flutter/material.dart';
import 'package:smart_album/RegisterPage.dart';
import 'package:smart_album/pages/FriendsPage.dart';

import '../HomePage.dart';
import '../pages/Tabs.dart';

import '../user/Login.dart';
import '../user/RegisterFirst.dart';
import '../user/RegisterSecond.dart';
import '../pages/tabs/Setting.dart';
import '../user/RegisterThird.dart';
import '../LoginPage.dart';

//配置路由
final routes = {
  '/': (context) => Tabs(),

  // '/search': (context, {arguments}) => SearchPage(arguments: arguments), //需要传值
  // '/productinfo': (context, {arguments}) =>
  //     ProductInfoPage(arguments: arguments),
  // '/login': (context) => LoginPage(),
  '/login-page': (context) => LoginPage(),
  '/register-page': (context) => RegisterPage(),
  // '/register-first': (context) => RegisterFirstPage(),
  // '/register-second': (context) => RegisterSecondPage(),
  // '/register-third': (context) => RegisterThirdPage(),
  '/setting': (context) => Setting(),
  '/main': (context) => Tabs(),
  '/friends': (context) => FriendsPage()
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
