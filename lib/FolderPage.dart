import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_album/viewModel/PhotoViewModel.dart';
import 'package:smart_album/widgets/LoadingCircle.dart';
import 'package:smart_album/widgets/PhotoGroupedView.dart';
import 'package:smart_album/widgets/QueryStreamBuilder.dart';

import 'PhotoView.dart';
import 'bloc/photo_list/PhotoListCubit.dart';
import 'database/Photo.dart';
import 'widgets/LightAppBar.dart';
import 'widgets/SelectionToolBar.dart';

class FolderPageArguments {
  final String title;

  FolderPageArguments({required this.title});
}

class FolderPage extends StatelessWidget {
  final FolderPageArguments arguments;

  const FolderPage({Key? key, required this.arguments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => PhotoListCubit(),
        child: Scaffold(
          appBar: PreferredSize(
              child: BlocBuilder<PhotoListCubit, PhotoListState>(
                  builder: (context, state) =>
                      state.mode == PhotoListMode.Selection
                          ? SafeArea(bottom: false, child: SelectionToolBar())
                          : LightAppBar(context, arguments.title)),
              preferredSize: Size.fromHeight(
                  AppBarTheme.of(context).toolbarHeight ?? kToolbarHeight)),
          body: QueryStreamBuilder<Photo>(
            queryStream: PhotoViewModel.getPhotoList(),
            loadingWidget: LoadingCircle(),
            builder: (context, data) => PhotoGroupedView(
                photos: data
                    .where(
                        (element) => element.labels.contains(arguments.title))
                    .toList(),
                onTap: (photo, index, sortedPhotoList) =>
                    open(context, sortedPhotoList, index)),
          ),
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

  static void open(
      BuildContext context, List<Photo> elements, final int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) {
          return PhotoView<Photo>(
            imageBuilder: (item) {
              return FileImage(File(item.path));
            },
            galleryItems: elements,
            backgroundDecoration: const BoxDecoration(
              color: Colors.black,
            ),
            initialIndex: index,
          );
        },
      ),
    );
  }
}
