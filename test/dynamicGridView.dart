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
  Widget _getListData(context, index) {
    return Container(
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 1.0 / 1.0,
            child: Image.network(
              listData[index]['imageUrl'],
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              listData[index]['title'],
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
          )
        ],
      ),

      // Column(
      //   children: [
      //     Image.network(listData[index]['imageUrl']),
      //     SizedBox(height: 12),
      //     Text(
      //       listData[index]['title'],
      //       textAlign: TextAlign.center,
      //       style: TextStyle(fontSize: 15),
      //     )
      //   ],
      // ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, //每行的个数
        mainAxisSpacing: 10, //主轴方向item之间的间隙
        crossAxisSpacing: 10, //非主轴方向item之间的间隙
        childAspectRatio: 1, //非主轴方向的item内容与主轴方向的内容宽高比默认=1.0（即1:1展示）
      ),
      itemCount: listData.length,
      itemBuilder: this._getListData,
    );
  }
}
