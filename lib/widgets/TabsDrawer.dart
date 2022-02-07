import 'package:flutter/material.dart';

class TabsDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TabsDrawerState();
}

class _TabsDrawerState extends State<TabsDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: UserAccountsDrawerHeader(
                  accountName: Text("fkmog"),
                  accountEmail: Text("1073638314@qq.com"),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fnimg.ws.126.net%2F%3Furl%3Dhttp%253A%252F%252Fdingyue.ws.126.net%252F2021%252F0720%252F27836c7fj00qwiper0016c000hs00hsg.jpg%26thumbnail%3D650x2147483647%26quality%3D80%26type%3Djpg&refer=http%3A%2F%2Fnimg.ws.126.net&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1646826366&t=14ab6dfab50dc92f5d07cdc12c9a5ddf"),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber[50],
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
          ),
          Divider(),
          ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.home),
            ),
            title: Text('User Center'),
          ),
          Divider(),
          ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.auto_delete_rounded),
            ),
            title: Text('Recent Delete'),
          ),
          Divider(),
        ],
      ),
    );
  }
}
