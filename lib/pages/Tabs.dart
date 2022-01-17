import 'package:flutter/material.dart';
import 'package:smart_album/pages/tabs/Catagory.dart';
import 'package:smart_album/pages/tabs/Home.dart';
import 'package:smart_album/pages/tabs/Setting.dart';

class Tabs extends StatefulWidget {
  Tabs({Key? key}) : super(key: key);

  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  int _currentIndex = 0;
  List _pagelist = [HomePage(), Catagory(), Setting()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter'),
      ),
      body: this._pagelist[this._currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.amber[800],
        type: BottomNavigationBarType.fixed, //多个按钮
        currentIndex: this._currentIndex, //表示当前默认选中哪一个
        onTap: (int index) {
          setState(() {
            this._currentIndex = index;
          });
          print(index);
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("首页")),
          BottomNavigationBarItem(
              icon: Icon(Icons.category), title: Text("分类")),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), title: Text("设置")),
        ],
      ),
    );
  }
}
