import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shifting_tabbar/shifting_tabbar.dart';
import 'package:smart_album/widgets/AddCategoryFolder.dart';
import 'package:smart_album/widgets/LoadingCircle.dart';
import 'package:smart_album/widgets/QueryStreamBuilder.dart';

import 'FolderPage.dart';
import 'PhotoFolderGridView.dart';
import 'bloc/photo/PhotoCubit.dart';
import 'model/Photo.dart';

class CategoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    var cubit = context.read<PhotoCubit>();

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
                  queryStream: cubit.getPhotoList(),
                  loadingWidget: LoadingCircle(),
                  builder: (context, data) => PhotoFolderGridView(
                      padding: EdgeInsets.only(
                          top: 10,
                          left: 10,
                          right: 10,
                          bottom: mediaQuery.padding.bottom),
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
