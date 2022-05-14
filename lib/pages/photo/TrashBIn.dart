import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_album/bloc/SelectableList/SelectableListCubit.dart';
import 'package:smart_album/bloc/photo/PhotoCubit.dart';
import 'package:smart_album/bloc/photo/PhotoState.dart';
import 'package:smart_album/bloc/photo_list/PhotoListCubit.dart';
import 'package:smart_album/model/Photo.dart';
import 'package:smart_album/pages/photo/PhotoPage.dart';
import 'package:smart_album/util/DialogUtil.dart';
import 'package:smart_album/widgets/LightAppBar.dart';
import 'package:smart_album/widgets/PhotoGroupedView.dart';

class TrashBin extends StatelessWidget {
  const TrashBin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => PhotoListCubit(),
        child: BlocBuilder<PhotoCubit, PhotoState>(
            builder: (context, state) => Scaffold(
                appBar: LightAppBar(
                  context,
                  "Trash Bin",
                  actions: [
                    IconButton(
                      icon: Icon(Icons.restore_outlined),
                      onPressed: () {
                        DialogUtil.showConfirmDialog(
                            context, "Restore from trash bin", "Are you sure?",
                            () {
                          var cubit = context.read<PhotoListCubit>();
                          var listState = cubit.state;
                          var photoList = listState.mode == ListMode.Selection
                              ? listState.selectedItems.toList()
                              : state.deletedPhotoList;
                          photoList.forEach((photo) {
                            BlocProvider.of<PhotoCubit>(context)
                                .movePhotoOutOfTrashBin(photo);
                            cubit.setModeView();
                            Navigator.of(context).pop();
                          });
                        });
                      },
                    )
                  ],
                ),
                body: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: PhotoGroupedView(
                              photos: state.deletedPhotoList,
                              onTap: (photo, index, sortedPhotoList) {})),
                      BlocBuilder<PhotoListCubit, PhotoListState>(
                          builder: (context, listState) => InkWell(
                                child: SizedBox(
                                  height: 80,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                        listState.mode == ListMode.View
                                            ? "Clear trash bin"
                                            : "Delete selected photos",
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.white)),
                                    decoration:
                                        BoxDecoration(color: Colors.red),
                                  ),
                                ),
                                onTap: () {
                                  DialogUtil.showConfirmDialog(
                                      context,
                                      "Restore from trash bin",
                                      "Are you sure?", () {
                                    context.read<PhotoCubit>().deletePhoto(
                                        listState.mode == ListMode.Selection
                                            ? listState.selectedItems.toList()
                                            : state.deletedPhotoList);
                                    context
                                        .read<PhotoListCubit>()
                                        .setModeView();
                                    Navigator.of(context).pop();
                                  });
                                },
                              ))
                    ]))));
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
