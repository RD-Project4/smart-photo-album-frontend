import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:smart_album/bloc/photo_list/PhotoListCubit.dart';
import 'package:smart_album/viewModel/PhotoViewModel.dart';
import 'package:smart_album/widgets/GroupedView.dart';
import 'package:smart_album/widgets/ListedPhoto.dart';
import 'package:smart_album/widgets/LoadingCircle.dart';
import 'package:smart_album/widgets/QueryStreamBuilder.dart';

import 'PhotoView.dart';
import 'database/Photo.dart';

class PhotoList extends StatelessWidget {
  final bool isHasTopBar;

  const PhotoList({Key? key, this.isHasTopBar = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    return QueryStreamBuilder(
        queryStream: PhotoViewModel.getPhotoList(),
        loadingWidget: LoadingCircle(),
        builder: (context, data) {
          var photos = data;
          return RefreshIndicator(
              onRefresh: () => PhotoViewModel.refresh(),
              child: GroupedView<Photo, DateTime>(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: isHasTopBar
                      ? EdgeInsets.only(
                          top: kToolbarHeight,
                          bottom: mediaQuery.padding.bottom)
                      : null,
                  elements: photos,
                  groupBy: (element) {
                    // 分类
                    DateTime time = element.creationDateTime;
                    return DateTime(time.year, time.month, time.day);
                  },
                  groupComparator: (value1, value2) =>
                      -value2.compareTo(value1),
                  order: GroupedListOrder.DESC,
                  floatingHeader: false,
                  groupSeparatorBuilder: (DateTime date) => Padding(
                        // 日期栏
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          (() {
                            DateFormat formatter = DateFormat.yMMMEd('en_US');
                            return formatter.format(date);
                          }()),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                  sectionBuilder: (context, currentSectionElementList,
                      allElement, overallIndex) {
                    var blocPhotos =
                        BlocProvider.of<PhotoListCubit>(context).state.photos;
                    if ((blocPhotos.length != photos.length) ||
                        (blocPhotos.length == 0 && allElement.length != 0)) {
                      BlocProvider.of<PhotoListCubit>(context)
                          .setPhotoList(allElement);
                    }

                    return GridView.count(
                        // 照片
                        padding: EdgeInsets.zero,
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: currentSectionElementList
                            .mapIndexed((index, element) => ListedPhoto(
                                  path: element.path,
                                  entity: element,
                                  onTap: () {
                                    _open(context, allElement,
                                        overallIndex + index);
                                    // _showPic();
                                  },
                                ))
                            .toList());
                  }));
        });
  }

  void _open(BuildContext context, List<Photo> elements, final int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) {
          return BlocProvider.value(
            value: BlocProvider.of<PhotoListCubit>(context),
            child: PhotoView<Photo>(
              imageBuilder: (item) {
                return FileImage(File(item.path));
              },
              galleryItems: elements,
              backgroundDecoration: const BoxDecoration(
                color: Colors.black,
              ),
              initialIndex: index,
            ),
          );
        },
      ),
    );
  }
}
