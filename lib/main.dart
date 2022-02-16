import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_album/routes/Routes.dart';
import 'package:oktoast/oktoast.dart';

void main() {
  runApp(OKToast(child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: onGenerateRoute,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
    );
  }
}
