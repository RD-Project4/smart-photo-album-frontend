import 'package:flutter/material.dart';
import 'package:smart_album/FakeData.dart';

import 'PhotoFolderGridVIew.dart';

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
            PhotoFolderGridView([data[0], data[1]]),
            PhotoFolderGridView([data[0]]),
            PhotoFolderGridView([data[0]])
          ])),
    );
  }
}
