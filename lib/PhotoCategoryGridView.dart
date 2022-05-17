import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_album/bloc/SelectableList/SelectableListCubit.dart';
import 'package:smart_album/bloc/categoryFolder/CategoryFolderCubit.dart';
import 'package:smart_album/bloc/categoryFolder/CategoryFolderState.dart';
import 'package:smart_album/bloc/photo/PhotoCubit.dart';
import 'package:smart_album/bloc/photo/PhotoState.dart';
import 'package:smart_album/model/Folder.dart';
import 'package:smart_album/model/Photo.dart';
import 'package:smart_album/util/Labels.dart';
import 'package:smart_album/widgets/LoadingCircle.dart';
import 'package:smart_album/widgets/ThumbnailImageProvider.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import '../util/CommonUtil.dart';

class PhotoCategoryGridView extends StatelessWidget {
  final SuperCategory superCategory;
  final void Function(Folder, List<Photo>)? onTap;
  final EdgeInsets? padding;

  const PhotoCategoryGridView(this.superCategory, {this.onTap, this.padding});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryFolderCubit, CategoryFolderState>(
        builder: (context, categoryState) =>
            BlocBuilder<PhotoCubit, PhotoState>(
                builder: ((context, photoState) {
              if (categoryState.categoryList == null) return LoadingCircle();
              var categoryList = categoryState.categoryList!
                  .where((category) => category.labelList
                      .any((label) => superCategory.labels.contains(label)))
                  .toList();
              var photoListList = categoryList.map((category) {
                return categoryState.getPhotoByCategory(
                    category, photoState.photoListWithoutDeleted)!;
              }).toList();

              return WaterfallFlow.builder(
                padding: this.padding ?? EdgeInsets.all(10.0),
                itemCount: photoListList.length,
                itemBuilder: (context, index) {
                  var category = categoryList[index];
                  var photoList = photoListList[index]
                      .where((photo) => !category.excludeList
                          .any((exclude) => exclude.id == photo.id))
                      .toList();
                  var includeList = category.includeList.where((include) =>
                      !photoList.any((photo) => photo.id == include.id));
                  photoList.addAll(includeList);
                  var previewPhoto = photoList.length > 0
                      ? photoList[photoList.length - 1]
                      : Photo.placeholder();
                  category.previewPhoto = previewPhoto;

                  bool isSelectedMode =
                      categoryState.mode == ListMode.Selection;
                  bool isSelected =
                      categoryState.selectedItems.contains(category);

                  return AspectRatio(
                      aspectRatio: index % 2 == 0 ? 0.76 : 0.64,
                      child: Opacity(
                        opacity: isSelectedMode & !isSelected ? 0.6 : 1,
                        child: Card(
                          shape: isSelected
                              ? RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.blueAccent.shade200,
                                      width: 8),
                                  borderRadius: BorderRadius.circular(4.0))
                              : null,
                          elevation: isSelected ? 10 : 6,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: InkWell(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 10.0, left: 10.0, right: 10.0),
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                image: DecorationImage(
                                                  image: ThumbnailImageProvider(
                                                      previewPhoto),
                                                  fit: BoxFit.cover,
                                                ))))),
                                ListTile(
                                    title: Text(
                                      CommonUtil.capitalizeFirstLetter(
                                          category.name),
                                    ),
                                    subtitle: Text(
                                      'There are ${photoList.length} items',
                                      style:
                                          Theme.of(context).textTheme.caption,
                                    )),
                              ],
                            ),
                            onTap: () {
                              if (categoryState.mode == ListMode.View) {
                                if (onTap != null) onTap!(category, photoList);
                              } else if (categoryState.mode ==
                                  ListMode.Selection) {
                                _onPhotoTappedInSelectionMode(
                                    context, category);
                              }
                            },
                            onLongPress: () {
                              _onPhotoTappedInSelectionMode(context, category);
                            },
                          ),
                        ),
                      ));
                },
                gridDelegate:
                    SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  lastChildLayoutTypeBuilder: (index) =>
                      index == photoListList.length
                          ? LastChildLayoutType.foot
                          : LastChildLayoutType.none,
                ),
              );
            })));
  }

  void _onPhotoTappedInSelectionMode(BuildContext context, Folder category) {
    var cubit = context.read<CategoryFolderCubit>();
    cubit.setModeSelection();
    cubit.addOrRemoveSelectedItem(category);
    if (cubit.state.selectedItems.length < 1) cubit.setModeView();
  }
}
