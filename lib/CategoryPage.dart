import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_album/bloc/SelectableList/SelectableListCubit.dart';
import 'package:smart_album/bloc/categoryFolder/CategoryFolderCubit.dart';
import 'package:smart_album/bloc/categoryFolder/CategoryFolderState.dart';
import 'package:smart_album/bloc/photo/PhotoCubit.dart';
import 'package:smart_album/util/Labels.dart';
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
          length: superCategories.length,
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: Stack(
                children: [
                  NestedScrollView(
                      headerSliverBuilder:
                          (BuildContext context, bool innerBoxIsScrolled) {
                        return <Widget>[
                          SliverOverlapAbsorber(
                              handle: NestedScrollView
                                  .sliverOverlapAbsorberHandleFor(context),
                              sliver: BlocBuilder<CategoryFolderCubit,
                                      CategoryFolderState>(
                                  builder: (context, state) => SliverAppBar(
                                        title: const Text("Category"),
                                        backgroundColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        titleTextStyle: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                        floating: true,
                                        snap: false,
                                        pinned: true,
                                        actions: state.mode == ListMode.View
                                            ? null
                                            : [
                                                IconButton(
                                                    onPressed: () {
                                                      context
                                                          .read<
                                                              CategoryFolderCubit>()
                                                          .removeSelectedCategory();
                                                    },
                                                    icon: Icon(
                                                        Icons.delete_outline,
                                                        color: Colors.black))
                                              ],
                                        bottom: ShiftingTabBar(
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          tabs: superCategories
                                              .map((superCategory) =>
                                                  ShiftingTab(
                                                    icon: Icon(
                                                        superCategory.icon),
                                                    text: superCategory.name,
                                                  ))
                                              .toList(),
                                        ),
                                      )))
                        ];
                      },
                      body: Padding(
                          padding: EdgeInsets.only(top: 46),
                          child: TabBarView(
                              children: superCategories
                                  .map<Widget>((superCategory) =>
                                      RefreshIndicator(
                                          onRefresh: () => context
                                              .read<PhotoCubit>()
                                              .refresh(context),
                                          child: PhotoCategoryGridView(
                                              superCategory,
                                              padding: EdgeInsets.only(
                                                  top: 10,
                                                  left: 10,
                                                  right: 10,
                                                  bottom: mediaQuery
                                                      .padding.bottom),
                                              onTap: (category, photoList) {
                                            Navigator.pushNamed(
                                                context, '/folderPage',
                                                arguments: FolderPageArguments(
                                                    title: category.name,
                                                    photoList: photoList));
                                          })))
                                  .toList()))),
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
