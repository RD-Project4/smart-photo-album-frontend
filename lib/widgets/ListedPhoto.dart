import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_album/bloc/SelectableList/SelectableListCubit.dart';
import 'package:smart_album/bloc/photo_list/PhotoListCubit.dart';
import 'package:smart_album/model/Photo.dart';
import 'package:smart_album/util/Global.dart';
import 'package:smart_album/widgets/ThumbnailImageProvider.dart';

import '../Events.dart';

/// 首页照片墙中的单个照片
class ListedPhoto extends StatefulWidget {
  final path;
  final onTap;
  final Photo entity;

  late ThumbnailImageProvider imageProvider;

  ListedPhoto({Key? key, required this.path, required this.entity, this.onTap})
      : super(key: key) {
    imageProvider = ThumbnailImageProvider(entity);
  }

  @override
  State<StatefulWidget> createState() => _ListedPhotoState();
}

class _ListedPhotoState extends State<ListedPhoto> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhotoListCubit, PhotoListState>(
        builder: (context, state) {
      final photoListMode = state.mode;
      // 当照片在选择模式下被点击
      void onPhotoTappedInSelectionMode() {
        var cubit = context.read<PhotoListCubit>();
        cubit.addOrRemoveSelectedItem(widget.entity);
        if (state.selectedItems.length < 1) cubit.setModeView();
      }

      bool isSelectedMode = photoListMode == ListMode.Selection;
      bool isSelected = state.selectedItems.contains(widget.entity);

      return InkWell(
        child: Opacity(
            opacity: isSelectedMode & !isSelected ? 0.6 : 1,
            child: Container(
                margin: EdgeInsets.all(isSelectedMode ? 14.0 : 6.0),
                child: Stack(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                      border: isSelected
                          ? Border.all(
                              color: Colors.blueAccent.shade200, width: 8)
                          : null,
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                        image: widget.imageProvider,
                        fit: BoxFit.cover,
                      ),
                    )),
                    photoListMode == ListMode.Selection
                        ? Checkbox(
                            value: isSelected,
                            side: BorderSide(color: Colors.white, width: 2),
                            onChanged: (status) {},
                          )
                        : Container(),
                    Positioned(
                      child: Row(
                        children: [
                          widget.entity.isCloud
                              ? Icon(
                                  Icons.cloud_done_outlined,
                                  color: Colors.white,
                                )
                              : Container(),
                          widget.entity.isFavorite
                              ? Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                )
                              : Container()
                        ],
                      ),
                      right: 5,
                      bottom: 5,
                    )
                  ],
                ))),
        onTap: () {
          if (photoListMode == ListMode.View) {
            widget.onTap();
          } else if (photoListMode == ListMode.Selection) {
            onPhotoTappedInSelectionMode();
          }
        },
        onLongPress: () {
          context.read<PhotoListCubit>().setModeSelection();
          onPhotoTappedInSelectionMode();
        },
      );
    });
  }
}
