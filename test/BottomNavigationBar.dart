import 'package:flutter/material.dart';
import 'package:smart_album/pages/Tabs.dart';

void main() => runApp(MyApp());

//页面切换
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(home: Tabs());
  }
}
