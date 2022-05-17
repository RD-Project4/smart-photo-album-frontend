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
  final List<Photo> Function(List<Photo> selectPhoto, List<Photo> allPhoto)?
      onRemoveFromFolder;

  FolderPageArguments(
      {required this.title, required this.photoList, this.onRemoveFromFolder});
}

class FolderPage extends StatefulWidget {
  final FolderPageArguments arguments;

  const FolderPage({Key? key, required this.arguments}) : super(key: key);

  @override
  State<FolderPage> createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage> {
  late List<Photo> currentPhotoList;

  @override
  void initState() {
    super.initState();
    currentPhotoList = widget.arguments.photoList;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => PhotoListCubit(),
        child: Scaffold(
          appBar: PreferredSize(
              child: BlocBuilder<PhotoListCubit, PhotoListState>(
                  builder: (context, state) => state.mode == ListMode.Selection
                      ? SafeArea(
                          bottom: false,
                          child: SelectionToolBar(
                              actionsBuilder: widget
                                          .arguments.onRemoveFromFolder !=
                                      null
                                  ? (selectPhoto) {
                                      return [
                                        IconButton(
                                            onPressed: () {
                                              var newPhotoList = widget
                                                      .arguments
                                                      .onRemoveFromFolder!(
                                                  selectPhoto,
                                                  currentPhotoList);
                                              setState(() {
                                                currentPhotoList = newPhotoList;
                                              });
                                              context.read<PhotoListCubit>()
                                                ..setModeView();
                                            },
                                            icon: Icon(Icons.move_up_outlined))
                                      ];
                                    }
                                  : null))
                      : LightAppBar(
                          context,
                          widget.arguments.title,
                        )),
              preferredSize: Size.fromHeight(
                  AppBarTheme.of(context).toolbarHeight ?? kToolbarHeight)),
          body: BlocBuilder<PhotoListCubit, PhotoListState>(
              builder: (context, state) => PhotoGroupedView(
                  photos: widget.arguments.photoList.toList(),
                  onTap: (photo, index, sortedPhotoList) =>
                      open(context, sortedPhotoList, index))),
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
