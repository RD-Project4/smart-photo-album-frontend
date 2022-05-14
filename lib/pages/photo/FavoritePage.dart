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

class FavoritePage extends StatelessWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => PhotoListCubit(),
        child: BlocBuilder<PhotoCubit, PhotoState>(
          builder: (context, state) => Scaffold(
              appBar: LightAppBar(context, "My favorite", actions: [
                IconButton(
                  icon: Icon(Icons.remove_circle_outline),
                  onPressed: () {
                    DialogUtil.showConfirmDialog(
                        context, "Remove from favorite", "Are you sure?", () {
                      var cubit = context.read<PhotoListCubit>();
                      var listState = cubit.state;
                      var photoList = listState.mode == ListMode.Selection
                          ? listState.selectedItems.toList()
                          : state.deletedPhotoList;
                      photoList.forEach((photo) {
                        BlocProvider.of<PhotoCubit>(context)
                            .markOrUnMarkPhotoAsFavorite(photo);
                        cubit.setModeView();
                      });
                    });
                  },
                )
              ]),
              body: PhotoGroupedView(
                  photos: state.favoritePhotoList,
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
