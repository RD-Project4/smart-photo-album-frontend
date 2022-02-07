import 'package:flutter/material.dart';
import 'package:smart_album/widgets/TabsDrawer.dart';
import '../CatagoryPage.dart';
import '../HomePage.dart';
import 'tabs/Setting.dart';
import 'package:smart_album/util/Global.dart';

class Tabs extends StatefulWidget {
  final index;

  Tabs({Key? key, this.index = 0}) : super(key: key);

  @override
  _TabsState createState() => _TabsState(this.index);
}

class _TabsState extends State<Tabs> {
  int _currentIndex = 0;

  _TabsState(index) {
    this._currentIndex = index;
  }

  List _pageList = [HomePage(), CategoryPage(), Setting()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text('Smart Photo'),
        //   // backgroundColor: Colors.green[100],
        //   // leading: IconButton(
        //   //   icon: Icon(Icons.menu),
        //   //   onPressed: () {},
        //   // ),
        //   // actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
        // )
        body: SafeArea(
          child: this._pageList[this._currentIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          fixedColor: Colors.indigo,
          currentIndex: this._currentIndex, //表示当前默认选中哪一个
          onTap: (int index) {
            setState(() {
              this._currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.category), label: "Category"),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), label: "My"),
          ],
        ),
        drawer: TabsDrawer());
  }
}
