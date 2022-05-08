import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_album/DataProvider.dart';
import 'package:smart_album/widgets/PhotoGroupedView.dart';

import 'PhotoList.dart';
import 'bloc/photo_list/PhotoListCubit.dart';
import 'widgets/SelectionToolBar.dart';

class FolderPageArguments {
  final String title;
  List<Photo>? photoList;

  FolderPageArguments({required this.title, this.photoList});
}

class FolderPage extends StatelessWidget {
  final FolderPageArguments arguments;

  const FolderPage({Key? key, required this.arguments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (arguments.photoList == null) {
      arguments.photoList = DataProvider.getPhotoList()
          .where((element) => element.labels.contains(arguments.title))
          .toList();
    }

    return BlocProvider(
        create: (_) => PhotoListCubit(),
        child: Scaffold(
          appBar: PreferredSize(
              child: BlocBuilder<PhotoListCubit, PhotoListState>(
                  builder: (context, state) =>
                      state.mode == PhotoListMode.Selection
                          ? SafeArea(bottom: false, child: SelectionToolBar())
                          : AppBar(
                              title: Text(arguments.title),
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              elevation: 0,
                              foregroundColor: Colors.black)),
              preferredSize: Size.fromHeight(
                  AppBarTheme.of(context).toolbarHeight ?? kToolbarHeight)),
          body: PhotoGroupedView(photos: arguments.photoList!),
          // body: GridView.count(
          //     // 照片
          //     crossAxisCount: 2,
          //     shrinkWrap: true,
          //     children: arguments.photoList!
          //         .map((element) => Container(
          //             margin: EdgeInsets.all(3.0),
          //             decoration: BoxDecoration(
          //               image: DecorationImage(
          //                 image: FileImage(File(element.path)),
          //                 fit: BoxFit.cover,
          //               ),
          //             )))
          //         .toList())
        ));
  }
}
