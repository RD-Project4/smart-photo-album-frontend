import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smart_album/DataProvider.dart';

class FolderPageArguments {
  final String title;
  List<Photo>? photoList;

  FolderPageArguments({required this.title, this.photoList});
}

class FolderPage extends StatelessWidget {
  final FolderPageArguments arguments;

  const FolderPage({Key? key, required this.arguments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (arguments.photoList == null) {
      arguments.photoList = DataProvider.getPhotoList()
          .where((element) => element.labels.contains(arguments.title))
          .toList();
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(arguments.title),
        ),
        body: GridView.count(
            // 照片
            crossAxisCount: 2,
            shrinkWrap: true,
            children: arguments.photoList!
                .map((element) => Container(
                    margin: EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(File(element.path)),
                        fit: BoxFit.cover,
                      ),
                    )))
                .toList()));
  }
}
