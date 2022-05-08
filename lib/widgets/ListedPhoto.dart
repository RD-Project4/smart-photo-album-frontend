import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:smart_album/DataProvider.dart';
import 'package:smart_album/bloc/photo_list/PhotoListCubit.dart';
import 'package:smart_album/util/FavoritesUtil.dart';
import 'package:smart_album/util/Global.dart';

import '../Events.dart';

/// 首页照片墙中的单个照片
class ListedPhoto extends StatefulWidget {
  final path;
  final onTap;
  final Photo entity;

  const ListedPhoto(
      {Key? key, required this.path, required this.entity, this.onTap})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ListedPhotoState();
}

class _ListedPhotoState extends State<ListedPhoto> {
  var isFavorite = false;

  void _setIsFavorite() {
    FavoritesUtil.isFavorite(widget.entity.id).then((value) {
      if (!mounted) {
        return;
      }
      setState(() {
        isFavorite = value;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _setIsFavorite();

    Global.eventBus.on<RefreshFavoritesEvent>().listen((event) {
      _setIsFavorite();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhotoListCubit, PhotoListState>(
        builder: (context, state) {
      final photoListMode = state.mode;
      final selectedPhotos = state.selectedPhotos;
      // 当照片在选择模式下被点击
      void onPhotoTappedInSelectionMode() {
        var cubit = context.read<PhotoListCubit>();
        setState(() {
          if (selectedPhotos.indexOf(widget.entity) == -1) {
            // 如果照片不在选中列表中
            cubit.addSelectedPhoto(widget.entity);
          } else {
            cubit.removeSelectedPhoto(widget.entity);
            if (state.selectedPhotos.length == 0) {
              cubit.setModeView();
            }
          }
        });
      }

      return InkWell(
          child: GestureDetector(
        child: Stack(
          children: [
            Container(
                margin: EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(File(widget.path)),
                    fit: BoxFit.cover,
                  ),
                )),
            photoListMode == PhotoListMode.Selection
                ? Checkbox(
                    value: selectedPhotos.contains(widget.entity),
                    side: BorderSide(color: Colors.white, width: 2),
                    onChanged: (status) {},
                  )
                : Container(),
            isFavorite
                ? Positioned(
                    child: Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    right: 5,
                    bottom: 5,
                  )
                : Container()
          ],
        ),
        onTap: () {
          if (photoListMode == PhotoListMode.View) {
            widget.onTap();
          } else if (photoListMode == PhotoListMode.Selection) {
            onPhotoTappedInSelectionMode();
          }
        },
        onLongPress: () {
          context.read<PhotoListCubit>().setModeSelection();
          onPhotoTappedInSelectionMode();
        },
      ));
    });
  }
}
