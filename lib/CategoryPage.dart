import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_album/bloc/categoryFolder/CategoryFolderCubit.dart';
import 'package:smart_album/widgets/AddCategoryFolder.dart';

import 'FolderPage.dart';
import 'PhotoCategoryGridView.dart';
import 'widgets/ShiftingTabBar.dart';

class CategoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    return BlocProvider(
        create: (context) => CategoryFolderCubit(),
        child: DefaultTabController(
          length: 3,
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: Stack(
                children: [
                  NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        SliverOverlapAbsorber(
                            handle:
                                NestedScrollView.sliverOverlapAbsorberHandleFor(
                                    context),
                            sliver: SliverAppBar(
                              title: const Text("Category"),
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              titleTextStyle:
                                  Theme.of(context).textTheme.titleLarge,
                              floating: true,
                              snap: false,
                              pinned: true,
                              bottom: ShiftingTabBar(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                tabs: [
                                  ShiftingTab(
                                    icon: Icon(Icons.landscape),
                                    text: "LandScape",
                                  ),
                                  ShiftingTab(
                                      icon: Icon(Icons.food_bank),
                                      text: "Food"),
                                  ShiftingTab(
                                      icon: Icon(Icons.location_city),
                                      text: "Cities"),
                                ],
                              ),
                            ))
                      ];
                    },
                    body: Padding(
                        padding: EdgeInsets.only(top: 46),
                        child: TabBarView(children: [
                          PhotoCategoryGridView(
                              padding: EdgeInsets.only(
                                  top: 10,
                                  left: 10,
                                  right: 10,
                                  bottom: mediaQuery.padding.bottom),
                              onTap: (entry) {
                                Navigator.pushNamed(context, '/folderPage',
                                    arguments: FolderPageArguments(
                                        title: entry.key,
                                        photoList: entry.value));
                              }),
                          Container(),
                          Container()
                        ])),
                  ),
                  Positioned(
                    bottom: 100,
                    right: 20,
                    child: FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => AddCategoryFolder()));
                      },
                      child: const Icon(Icons.create_new_folder),
                    ),
                  )
                ],
              )),
        ));
  }
}
