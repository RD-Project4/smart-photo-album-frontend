import 'package:flutter/material.dart';
import 'package:smart_album/res/listData.dart';

import 'demo.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('FlutterDemo'),
        ),
        body: LayoutDemo(),
      ),
    );
  }
}

class LayoutDemo extends StatelessWidget {
  List<Widget> _getListData() {
    var tempList = listData.map((value) {
      return Container(
        child: Column(
          children: <Widget>[
            Image.network(value['imageUrl']),
            SizedBox(
              height: 10,
            ),
            Text(
              value['title'],
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
            ),
          ],
        ),
        decoration: BoxDecoration(
            border: Border.all(
                color: Color.fromRGBO(233, 233, 233, 0.9), width: 1)),
      );
    });
    return tempList.toList();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GridView.count(
      crossAxisCount: 2, //一行widget数量
      children: this._getListData(),
      crossAxisSpacing: 10.0, //水平子widget之间的距离
      mainAxisSpacing: 10.0, //垂直子widget之间的距离
      // childAspectRatio: 0.7, //宽度与高度之间的比例
      padding: EdgeInsets.all(10),
    );
  }
}
