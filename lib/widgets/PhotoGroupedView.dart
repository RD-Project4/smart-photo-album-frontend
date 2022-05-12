import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:smart_album/model/Photo.dart';

import 'GroupedView.dart';
import 'ListedPhoto.dart';

class PhotoGroupedView extends StatelessWidget {
  final bool isHasTopBar;
  final List<Photo> photos;
  final void Function(Photo, int, List<Photo>)? onTap;

  const PhotoGroupedView(
      {Key? key, this.isHasTopBar = false, required this.photos, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GroupedView<Photo, DateTime>(
        padding:
            isHasTopBar ? const EdgeInsets.only(top: kToolbarHeight) : null,
        elements: photos,
        groupBy: (element) {
          // 分类
          DateTime time = element.creationDateTime;
          return DateTime(time.year, time.month, time.day);
        },
        groupComparator: (value1, value2) => -value2.compareTo(value1),
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
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
        sectionBuilder:
            (context, currentSectionElementList, allElement, overallIndex) {
          return GridView.count(
              // 照片
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: currentSectionElementList
                  .mapIndexed((index, element) => ListedPhoto(
                        path: element.path,
                        entity: element,
                        onTap: () => onTap?.call(element, index, allElement),
                      ))
                  .toList());
        });
  }
}
