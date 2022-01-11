import 'package:flutter/material.dart';
import 'package:multiutillib/utils/ui_helpers.dart';

void main() {
  runApp(MyApp());
}

//自定义
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Flutter Demo')),
        body: HomeContent(),
      ),
      theme: ThemeData(primarySwatch: Colors.amber),
    );
  }
}

class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      //整个屏幕
      child: Container(
        //屏幕中的某个部件
        child: Text(
          'Im a text',
          textAlign: TextAlign.right,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
              fontSize: 16.0,
              color: Colors.amber,
              fontWeight: FontWeight.w300,
              decoration: TextDecoration.lineThrough,
              decorationColor: Colors.blue,
              decorationStyle: TextDecorationStyle.dashed),
        ),
        height: 300.0,
        width: 300.0,
        decoration: BoxDecoration(
            color: Colors.yellow,
            border: Border.all(color: Colors.black, width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        // transform: Matrix4.translationValues(100, 0, 0),
        // transform: Matrix4.rotationZ(0.3),
        alignment: Alignment.bottomRight,
      ),
    );
  }
}
