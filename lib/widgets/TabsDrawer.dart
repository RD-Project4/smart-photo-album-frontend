import 'package:flutter/material.dart';
import 'package:smart_album/pages/tabs/Setting.dart';

/// 侧边栏，点击Home页面中的搜索框最左边的三条杠调出
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
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  accountName: Text("Smart Album",
                      style: TextStyle(color: Colors.black)),
                  accountEmail: Text(""),
                  currentAccountPicture: Image.asset("images/logo.png"),
                ),
              )
            ],
          ),

          ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.favorite),
            ),
            title: Text('My Favorite'),
            onTap: () {
              Navigator.pushNamed(context, '/favorite');
            },
          ),
          ItemDivider(),
          ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.auto_delete_rounded),
            ),
            title: Text('Recent Delete'),
            onTap: () {
              Navigator.pushNamed(context, '/trashbin');
            },
          ),
          ItemDivider(),
          ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.people),
            ),
            title: Text('My Friends'),
            onTap: () {
              Navigator.pushNamed(context, '/friends');
            },
          ),
          ItemDivider(),
          ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.people),
            ),
            title: Text('Backup manager'),
            onTap: () {
              Navigator.pushNamed(context, '/uploadList');
            },
          ),

          // ListTile(
          //   leading: CircleAvatar(
          //     child: Icon(Icons.add_reaction_rounded),
          //   ),
          //   title: Text('Add Friends!'),
          //   onTap: () {
          //     Navigator.pushNamed(context, '/add-friends');
          //   },
          // ),
          // Divider(),
        ],
      ),
    );
  }
}

class ItemDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: Divider(
        color: Colors.grey[300],
        height: 20,
        thickness: 1,
        indent: 1,
        endIndent: 1,
      ),
    );
  }
}
