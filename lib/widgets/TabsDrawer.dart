import 'package:flutter/material.dart';
import 'package:smart_album/pages/Tabs.dart';
import 'package:smart_album/pages/tabs/Setting.dart';
import 'package:smart_album/routes/API.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;

/// 侧边栏，点击Home页面中的搜索框最左边的三条杠调出
class TabsDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TabsDrawerState();
  static List list = [];
}

class _TabsDrawerState extends State<TabsDrawer> {
  @override
  Widget build(BuildContext context) {
    if (Tabs.loginstate == 1) {
      return Drawer(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: UserAccountsDrawerHeader(
                    accountName: Text('welcome'),
                    accountEmail: Text('please login first'),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fnimg.ws.126.net%2F%3Furl%3Dhttp%253A%252F%252Fdingyue.ws.126.net%252F2021%252F0720%252F27836c7fj00qwiper0016c000hs00hsg.jpg%26thumbnail%3D650x2147483647%26quality%3D80%26type%3Djpg&refer=http%3A%2F%2Fnimg.ws.126.net&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1646826366&t=14ab6dfab50dc92f5d07cdc12c9a5ddf"),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.deepOrangeAccent,
                      image: DecorationImage(
                          image: NetworkImage(
                              'https://www.itying.com/images/flutter/3.png'),
                          fit: BoxFit.cover),
                    ),
                  ),
                )
              ],
            ),
            ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.favorite),
              ),
              title: Text('Please login first'),
              onTap: () {
                Navigator.pushNamed(context, '/login-page');
              },
            ),
          ],
        ),
      );
    }

    return Drawer(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: UserAccountsDrawerHeader(
                  accountName: Text(Setting.userName),
                  accountEmail: Text(Setting.userEmail),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fnimg.ws.126.net%2F%3Furl%3Dhttp%253A%252F%252Fdingyue.ws.126.net%252F2021%252F0720%252F27836c7fj00qwiper0016c000hs00hsg.jpg%26thumbnail%3D650x2147483647%26quality%3D80%26type%3Djpg&refer=http%3A%2F%2Fnimg.ws.126.net&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1646826366&t=14ab6dfab50dc92f5d07cdc12c9a5ddf"),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.deepOrangeAccent,
                    image: DecorationImage(
                        image: NetworkImage(
                            'https://www.itying.com/images/flutter/3.png'),
                        fit: BoxFit.cover),
                  ),
                ),
              )
            ],
          ),
          ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.favorite),
            ),
            title: Text('My Favorite'),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.people),
            ),
            title: Text('My Friends'),
            onTap: () {
              print('you tap my friends');
              print(Setting.userAccount);
              _friends();
              Navigator.pushNamed(context, '/friends');
            },
          ),
          Divider(),
          ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.auto_delete_rounded),
            ),
            title: Text('Recent Delete'),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.add_reaction_rounded),
            ),
            title: Text('Add Friends!'),
            onTap: () {
              Navigator.pushNamed(context, '/add-friends');
            },
          ),
          Divider(),
        ],
      ),
    );
  }

  _friends() async {
    print('showing friends');
    print(Setting.userAccount);
    var apiurl =
        Uri.parse('http://124.223.68.12:8233/smartAlbum/showuserfriend.do');
    var response =
        await http.post(apiurl, body: {"userAccount": Setting.userAccount});

    print('Response status : ${response.statusCode}');
    print('Response status : ${response.body}');
    setState(() {
      TabsDrawer.list = jsonDecode(response.body)["data"];
      print(TabsDrawer.list);
    });
  }
}
