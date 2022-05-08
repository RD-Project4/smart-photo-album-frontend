import 'package:flutter/material.dart';
import 'package:shifting_tabbar/shifting_tabbar.dart';
import 'package:smart_album/widgets/AddCategoryFolder.dart';
import 'package:smart_album/ViewModel/PhotoViewModel.dart';
import 'package:smart_album/widgets/LoadingCircle.dart';
import 'package:smart_album/widgets/QueryStreamBuilder.dart';

import 'FolderPage.dart';
import 'PhotoFolderGridView.dart';
import 'database/Photo.dart';

class CategoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          body: Stack(
        children: [
          NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                  ),
                ),
              ];
            },
            body: TabBarView(children: [
              QueryStreamBuilder<Photo>(
                  queryStream: PhotoViewModel.getPhotoList(),
                  loadingWidget: LoadingCircle(),
                  builder: (context, data) => PhotoFolderGridView(
                      photoList: data,
                      onTap: (entry) {
                        Navigator.pushNamed(context, '/folderPage',
                            arguments: FolderPageArguments(title: entry.key));
                      })),
              Container(),
              Container()
            ]),
          ),
          Positioned(
            bottom: 100,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => AddCategoryFolder()));
              },
              child: const Icon(Icons.create_new_folder),
            ),
          )
        ],
      )),
    );
  }
}
