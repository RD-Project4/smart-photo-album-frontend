import 'dart:io';

import 'package:flutter/material.dart';

class PhotoFolderGridView<T extends Map> extends StatelessWidget {
  final List<T> photoList;
  final void Function(MapEntry<String, List<Map>> entry)? onTap;

  const PhotoFolderGridView({required this.photoList, this.onTap});

  @override
  Widget build(BuildContext context) {
    Map<String, List<T>> folderList = Map();
    photoList.forEach((photo) {
      if (photo["labels"] != null && photo["labels"] is List)
        for (var tag in photo["labels"]) {
          if (folderList[tag] == null) {
            folderList[tag] = [];
          }
          folderList[tag]!.add(photo);
        }
    });

    return GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        children: folderList.entries
            .map((entry) => Padding(
                padding: EdgeInsets.all(10),
                child: Stack(
                  children: [
                    ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: <Color>[Colors.black, Colors.white],
                        ).createShader(bounds);
                      },
                      child: InkWell(
                        child: Container(
                            decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          image: DecorationImage(
                            image: FileImage(File(entry.value[0]['path'])),
                            fit: BoxFit.cover,
                          ),
                        )),
                        onTap: () {
                          if (onTap != null) onTap!(entry);
                        },
                      ),
                    ),
                    Positioned(
                        bottom: 20,
                        left: 20,
                        child: Text(entry.key,
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)))
                  ],
                )))
            .toList());
  }
}
