import 'package:flutter/material.dart';
import 'package:smart_album/res/listData.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(title: Text('FlutterDemo')),
      body: HomeContent(),
    ));
  }
}

class HomeContent extends StatelessWidget {
//自定义方法
  List<Widget> _getData() {
    var tempList = listData.map((value) {
      return ListTile(
        leading: Image.network(value["imageUrl"]),
        title: Text(value["title"]),
        subtitle: Text(value["author"]),
      );
    });
    return tempList.toList(); //注意！！！！！
    // List<Widget> list = [];

    // for (var i = 0; i < 20; i++) {
    //   list.add(ListTile(
    //     title: Text('data$i'),
    //   ));
    // }
    // return list;
    //只有当前类可以使用
    // return [
    //   ListTile(
    //     title: Text('List'),
    //   ),
    //   ListTile(
    //     title: Text('List'),
    //   ),
    //   ListTile(
    //     title: Text('List'),
    //   ),
    //   ListTile(
    //     title: Text('List'),
    //   ),
    //   ListTile(
    //     title: Text('List'),
    //   )
    // ];
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView(
      children: this._getData(),
    );
  }
}
