import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_album/PhotoList.dart';
import 'package:smart_album/SearchBar.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SearchBar(scrollTarget: PhotoList(isHasTopBar: true))),
    );
  }
}
