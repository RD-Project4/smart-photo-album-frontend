import 'package:flutter/material.dart';
import 'package:smart_album/FakeData.dart';
import 'package:smart_album/PhotoList.dart';

import 'FolderPage.dart';
import 'PhotoFolderGridView.dart';

class CategoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var data = DataProvider.getElements();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: TabBar(
            tabs: [
              Tab(text: "LandScape"),
              Tab(text: "Food"),
              Tab(text: "Avatar"),
            ],
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            isScrollable: true,
          ),
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
          ])),
    );
  }
}
