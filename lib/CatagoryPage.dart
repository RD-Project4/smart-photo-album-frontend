import 'package:flutter/material.dart';
import 'package:smart_album/DataProvider.dart';

import 'FolderPage.dart';
import 'PhotoFolderGridView.dart';
import 'package:shifting_tabbar/shifting_tabbar.dart';

class CategoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var data = DataProvider.getPhotoList();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
          body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
                backgroundColor: Colors.transparent,
                floating: true,
                snap: true,
                pinned: false,
                flexibleSpace: ShiftingTabBar(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  tabs: [
                    ShiftingTab(
                      icon: Icon(Icons.landscape),
                      text: "LandScape",
                    ),
                    ShiftingTab(icon: Icon(Icons.food_bank), text: "Food"),
                    ShiftingTab(
                        icon: Icon(Icons.location_city), text: "Cities"),
                  ],
                )),
          ];
        },
        body: TabBarView(children: [
          PhotoFolderGridView(
              photoList: data,
              onTap: (entry) {
                Navigator.pushNamed(context, '/folderPage',
                    arguments: FolderPageArguments(
                        title: entry.key, photoList: entry.value));
              }),
          Container(),
          Container()
        ]),
      )),
    );
  }
}
