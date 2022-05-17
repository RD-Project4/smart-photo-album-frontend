import 'dart:io';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_album/bloc/categoryFolder/CategoryFolderCubit.dart';
import 'package:smart_album/bloc/categoryFolder/CategoryFolderState.dart';
import 'package:smart_album/model/Folder.dart';
import 'package:smart_album/util/CommonUtil.dart';
import 'package:smart_album/widgets/LightAppBar.dart';
import 'package:smart_album/widgets/ThumbnailImageProvider.dart';

import 'model/Photo.dart';

class FolderManagePage extends StatelessWidget {
  final Folder currentFolder;
  final List<Photo> photoList;

  FolderManagePage(this.currentFolder, this.photoList);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryFolderCubit, CategoryFolderState>(
        builder: (context, state) => Scaffold(
            appBar: LightAppBar(context, currentFolder.name),
            body: SizedBox.expand(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Swiper(
                  axisDirection: AxisDirection.right,
                  itemCount: photoList.length,
                  itemWidth: 300,
                  itemHeight: 500,
                  layout: SwiperLayout.STACK,
                  itemBuilder: (context, index) {
                    var photo = photoList[index];

                    return InkWell(
                        child: Container(
                            decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                        image: photo.isLocal
                            ? FileImage(File(photo.path))
                            : NetworkImage(photo.path) as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    )));
                  },
                ),
                SizedBox(
                    height: 150,
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                            children: state.categoryList!
                                .map((folder) => AspectRatio(
                                    aspectRatio: 0.76,
                                    child: Card(
                                        elevation: 6,
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        child: InkWell(
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                    child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 10.0,
                                                                left: 10.0,
                                                                right: 10.0),
                                                        child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                5),
                                                                    image:
                                                                        DecorationImage(
                                                                      image: ThumbnailImageProvider(folder
                                                                              .previewPhoto ??
                                                                          Photo
                                                                              .placeholder()),
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ))))),
                                                Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10),
                                                    child: Text(
                                                      CommonUtil
                                                          .capitalizeFirstLetter(
                                                              folder.name),
                                                    )),
                                              ]),
                                        ))))
                                .toList())))
              ],
            ))));
  }
}
