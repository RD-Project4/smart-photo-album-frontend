import 'package:flutter/material.dart';
import 'package:smart_album/widgets/TabsDrawer.dart';
import 'package:smart_album/widgets/user/LoginForm.dart';
import '../CatagoryPage.dart';
import '../HomePage.dart';
import 'tabs/Setting.dart';
import 'package:smart_album/util/Global.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;

class Tabs extends StatefulWidget {
  final index;
  static int loginstate = 1;
  Tabs({Key? key, this.index = 0}) : super(key: key);

  @override
  _TabsState createState() => _TabsState(this.index);
}

class _TabsState extends State<Tabs> {
  int _currentIndex = 0;

  _TabsState(index) {
    this._currentIndex = index;
  }

  var userId;
  var userAccount = '';
  var userName = '';
  var userEmail = '';
  var userProfile = '';
  var userPhone = '';

  var _status = 4;
  var _msg = '';

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
            if (index == 2 && Setting.state == 5) {
              showuser();
              this._currentIndex = index;
            } else {
              this._currentIndex = index;
            }
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.category), label: "Category"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "My"),
        ],
      ),
      drawer: TabsDrawer(),
      onDrawerChanged: (isOpened) {
        showuser();
      },
    );
  }

  showuser() async {
    print('Tabs posting data');
    print(Setting.userAccount);
    var apiurl = Uri.parse('http://124.223.68.12:8233/smartAlbum/showuser.do');

    var response =
        await http.post(apiurl, body: {"userAccount": Setting.userAccount});
    print('Response status : ${response.statusCode}');
    print('Response status : ${response.body}');
    setState(() {
      this._status = jsonDecode(response.body)["status"];
      Tabs.loginstate = jsonDecode(response.body)["status"];
      this._msg = jsonDecode(response.body)["msg"];
      this.userId = jsonDecode(response.body)["data"]["userId"];
      this.userAccount = jsonDecode(response.body)["data"]["userAccount"];
      this.userName = jsonDecode(response.body)["data"]["userName"];
      Setting.userName = jsonDecode(response.body)["data"]["userName"];
      this.userEmail = jsonDecode(response.body)["data"]["userEmail"];
      this.userProfile = jsonDecode(response.body)["data"]["userProfile"];
      this.userPhone = jsonDecode(response.body)["data"]["userPhone"];

      Setting.userId = jsonDecode(response.body)["data"]["userId"];
      Setting.userEmail = jsonDecode(response.body)["data"]["userEmail"];
      print(Tabs.loginstate);
    });
  }
}
