import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:smart_album/widgets/GroupedView.dart';

import 'PhotoView.dart';
import 'package:collection/collection.dart';

import 'common/Global.dart';
import 'util/PermissionUtil.dart';

class PhotoList extends StatefulWidget {
  final bool isHasTopBar;

  const PhotoList({Key? key, this.isHasTopBar = false}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PhotoListState();
}

class _PhotoListState extends State<PhotoList> {
  var photos;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    photos = await _loadPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return GroupedView<dynamic, DateTime>(
        padding: widget.isHasTopBar
            ? const EdgeInsets.only(top: kToolbarHeight)
            : null,
        elements: photos,
        groupBy: (element) {
          // 分类
          DateTime time = element['time'];
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
                  .mapIndexed((index, element) => InkWell(
                      child: Container(
                          margin: EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              // image: AssetImage(element['name']),
                              image: FileImage(
                                  File(Global.ROOT_PATH + element['name'])),
                              fit: BoxFit.cover,
                            ),
                          )),
                      onTap: () =>
                          _open(context, allElement, overallIndex + index)))
                  .toList());
        });
  }

  Future<List?> _loadPhotos() async {
    if (!(await PermissionUtil.checkStoragePermission())) {
      PermissionUtil.requestStoragePermission();
      return null;
    }
    var res = [];

    List<AssetPathEntity> list =
        await PhotoManager.getAssetPathList(onlyAll: true);

    await Future.forEach(list, (e) async {
      e = e as AssetPathEntity;
      if (e.name == "Recent") {
        var imgList = await e.assetList;
        imgList.forEach((img) {
          res.add({
            "time": img.createDateTime,
            "name": '${img.relativePath}${img.title}'
          });
        });
      }
    });

    return res;
  }

  void _open(BuildContext context, List elements, final int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoView<dynamic>(
          imageBuilder: (item) =>
              FileImage(File(Global.ROOT_PATH + item['name'])),
          descBuilder: (item) => Padding(
              padding: const EdgeInsets.all(12),
              child: Wrap(
                spacing: 10,
                children: (item['tag'] as List<String>)
                    .map((element) => Chip(label: Text(element)))
                    .toList(),
              )),
          galleryItems: elements,
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          initialIndex: index,
        ),
      ),
    );
  }
}
