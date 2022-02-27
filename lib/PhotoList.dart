import 'dart:io';

import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:smart_album/bloc/photo_list/PhotoListCubit.dart';
import 'package:smart_album/pages/tabs/Setting.dart';
import 'package:smart_album/widgets/GroupedView.dart';
import 'package:smart_album/widgets/ListedPhoto.dart';

import 'PhotoView.dart';
import 'package:collection/collection.dart';

import 'util/Global.dart';
import 'util/PermissionUtil.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;

class PhotoList extends StatefulWidget {
  final bool isHasTopBar;
  static String photopath = '';
  static var picId = '';
  const PhotoList({Key? key, this.isHasTopBar = false}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PhotoListState();
}

class _PhotoListState extends State<PhotoList> {
  var photos;
  var isReady = false;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    photos = await _loadPhotos() ?? [];

    setState(() {
      isReady = true;
    });
  }

  var _status = 4;
  var _msg = '';
  @override
  Widget build(BuildContext context) {
    return isReady
        ? GroupedView<dynamic, DateTime>(
            padding: widget.isHasTopBar
                ? const EdgeInsets.only(top: kToolbarHeight)
                : null,
            elements: photos,
            groupBy: (element) {
              // 分类
              DateTime time = element.createDateTime;
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
              BlocProvider.of<PhotoListCubit>(context).setPhotoList(allElement);
              return GridView.count(
                  // 照片
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: currentSectionElementList
                      .mapIndexed((index, element) => ListedPhoto(
                            path: Global.ROOT_PATH +
                                element.relativePath +
                                element.title,
                            entity: element,
                            onTap: () {
                              _open(context, allElement, overallIndex + index);
                              _showPic();
                            },
                          ))
                      .toList());
            })
        : Scaffold();
  }

  Future<List?> _loadPhotos() async {
    if (!(await PermissionUtil.checkStoragePermission())) {
      var res = await PermissionUtil.requestStoragePermission();
      if (res == false) {
        return [];
      }
    }
    // var res = [];

    List<AssetPathEntity> list =
        await PhotoManager.getAssetPathList(onlyAll: true);

    var imgList;
    await Future.forEach(list, (e) async {
      // 遍历图片文件夹
      e = e as AssetPathEntity;

      if (e.name == "Recent") {
        // 只处理名为Recent的文件夹（后期可能处理其他的）
        imgList = await e.assetList;
      }
    });
    print(imgList);
    return imgList;
  }

  void _open(BuildContext context, List elements, final int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) {
          return BlocProvider.value(
            value: BlocProvider.of<PhotoListCubit>(context),
            child: PhotoView<dynamic>(
              context: context,
              imageBuilder: (item) {
                PhotoList.photopath =
                    Global.ROOT_PATH + item.relativePath + item.title;

                print(PhotoList.photopath);
                return FileImage(
                    File(Global.ROOT_PATH + item.relativePath + item.title));
              },
              descBuilder: (item) => Padding(
                  padding: const EdgeInsets.all(12),
                  child: Wrap(
                    spacing: 10,
                    // children: (item['tag'] as List<String>)
                    //     .map((element) => Chip(label: Text(element)))
                    //     .toList(),
                  )),
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

  _showPic() async {
    print('uploading clouds');
    // print(Setting.userAccount);
    var apiurl = Uri.parse('http://124.223.68.12:8233/smartAlbum/showpic.do');
    var response = await http.post(apiurl, body: {
      "picOwner": Setting.userEmail,
    });

    print('Response status : ${response.statusCode}');
    print('Response status : ${response.body}');
    setState(() {
      // PhotoList.picId = jsonDecode(response.body)["data"][];
      this._status = jsonDecode(response.body)["status"];
      this._msg = jsonDecode(response.body)["msg"];
      PhotoList.picId = jsonDecode(response.body)["data"][0]["picId"];
      print(PhotoList.picId);
    });
  }
}
