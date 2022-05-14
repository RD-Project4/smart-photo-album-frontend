import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_album/bloc/SelectableList/SelectableListCubit.dart';
import 'package:smart_album/pages/photo/PhotoPage.dart';
import 'package:smart_album/widgets/PhotoGroupedView.dart';

import 'bloc/photo_list/PhotoListCubit.dart';
import 'model/Photo.dart';
import 'widgets/LightAppBar.dart';
import 'widgets/SelectionToolBar.dart';

class FolderPageArguments {
  final String title;
  final List<Photo> photoList;

  FolderPageArguments({required this.title, required this.photoList});
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
                  builder: (context, state) => state.mode == ListMode.Selection
                      ? SafeArea(bottom: false, child: SelectionToolBar())
                      : LightAppBar(context, arguments.title)),
              preferredSize: Size.fromHeight(
                  AppBarTheme.of(context).toolbarHeight ?? kToolbarHeight)),
          body: PhotoGroupedView(
              photos: arguments.photoList.toList(),
              onTap: (photo, index, sortedPhotoList) =>
                  open(context, sortedPhotoList, index)),
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
          return PhotoPage(
            photoList: elements,
            initialIndex: index,
          );
        },
      ),
    );
  }
}
