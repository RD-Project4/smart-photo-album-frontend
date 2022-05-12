import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_album/bloc/categoryFolder/CategoryFolderCubit.dart';
import 'package:smart_album/bloc/categoryFolder/CategoryFolderState.dart';
import 'package:smart_album/bloc/photo/PhotoCubit.dart';
import 'package:smart_album/bloc/photo/PhotoState.dart';
import 'package:smart_album/model/Photo.dart';
import 'package:smart_album/widgets/LoadingCircle.dart';
import 'package:smart_album/widgets/ThumbnailImageProvider.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import '../util/CommonUtil.dart';

class PhotoCategoryGridView extends StatelessWidget {
  final void Function(MapEntry<String, List<Photo>> entry)? onTap;

  final EdgeInsets? padding;

  const PhotoCategoryGridView({this.onTap, this.padding});

  @override
  Widget build(BuildContext context) {
    Random random = Random();

    return BlocBuilder<CategoryFolderCubit, CategoryFolderState>(
        builder: (context, categoryState) =>
            BlocBuilder<PhotoCubit, PhotoState>(
                builder: ((context, photoState) {
              if (photoState.photoList == null) return LoadingCircle();
              var folderMap =
                  categoryState.groupPhotoByCategory(photoState.photoList!);
              if (folderMap == null) return LoadingCircle();
              var folderNameList = folderMap.entries.toList();

              return WaterfallFlow.builder(
                padding: this.padding ?? EdgeInsets.all(10.0),
                itemCount: folderNameList.length,
                itemBuilder: (context, index) {
                  var folderEntry = folderNameList[index];
                  var previewPhoto = folderEntry.value.length > 0
                      ? folderEntry
                          .value[random.nextInt(folderEntry.value.length)]
                      : Photo.placeholder();
                  return AspectRatio(
                    aspectRatio: index % 3 == 0 ? 0.76 : 0.62,
                    child: Card(
                      elevation: 10,
                      clipBehavior: Clip.antiAlias,
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
                                      folderEntry.key),
                                ),
                                subtitle: Text(
                                  'There are ${folderEntry.value.length} items',
                                  style: Theme.of(context).textTheme.caption,
                                )),
                          ],
                        ),
                        onTap: () {
                          if (onTap != null) onTap!(folderEntry);
                        },
                      ),
                    ),
                  );
                },
                gridDelegate:
                    SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  lastChildLayoutTypeBuilder: (index) =>
                      index == folderNameList.length
                          ? LastChildLayoutType.foot
                          : LastChildLayoutType.none,
                ),
              );
            })));

    // return GridView.count(
    //     crossAxisCount: 2,
    //     shrinkWrap: true,
    //     children: folderMap.entries
    //         .map((entry) => Padding(
    //             padding: EdgeInsets.all(10),
    //             child: Stack(
    //               children: [
    //                 ShaderMask(
    //                   shaderCallback: (Rect bounds) {
    //                     return LinearGradient(
    //                       begin: Alignment.bottomCenter,
    //                       end: Alignment.topCenter,
    //                       colors: <Color>[Colors.black, Colors.white],
    //                     ).createShader(bounds);
    //                   },
    //                   child: InkWell(
    //                     child: Container(
    //                         decoration: BoxDecoration(
    //                       borderRadius: BorderRadius.circular(5),
    //                       image: DecorationImage(
    //                         image: FileImage(File(entry.value[0].path)),
    //                         fit: BoxFit.cover,
    //                       ),
    //                     )),
    //                     onTap: () {
    //                       if (onTap != null) onTap!(entry);
    //                     },
    //                   ),
    //                 ),
    //                 Positioned(
    //                     bottom: 20,
    //                     left: 20,
    //                     child: Text(entry.key,
    //                         style:
    //                             TextStyle(color: Colors.white, fontSize: 20)))
    //               ],
    //             )))
    //         .toList());
  }
}
