import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_album/bloc/photo_list/PhotoListCubit.dart';
import 'package:smart_album/model/Photo.dart';
import 'package:smart_album/util/FavoritesUtil.dart';
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
        if (selectedPhotos.indexOf(widget.entity) == -1) {
          // 如果照片不在选中列表中
          cubit.addSelectedPhoto(widget.entity);
        } else {
          cubit.removeSelectedPhoto(widget.entity);
          if (state.selectedPhotos.length == 0) {
            cubit.setModeView();
          }
        }
      }

      bool isSelected = selectedPhotos.contains(widget.entity);

      return InkWell(
          child: GestureDetector(
        child: Container(
            margin: EdgeInsets.all(isSelected ? 14.0 : 6.0),
            child: Stack(
              children: [
                Container(
                    decoration: BoxDecoration(
                  border: isSelected
                      ? Border.all(color: Colors.blueAccent.shade200, width: 10)
                      : null,
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                    image: widget.imageProvider,
                    fit: BoxFit.cover,
                  ),
                )),
                photoListMode == PhotoListMode.Selection
                    ? Checkbox(
                        value: isSelected,
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
            )),
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
