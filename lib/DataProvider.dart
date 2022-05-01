import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:smart_album/tensorflow/TensorflowProvider.dart';
import 'package:smart_album/util/Global.dart';

class Photo {
  AssetEntity entity;
  String path;
  List<String> labels;
  DateTime createDateTime;
  int width;
  int height;

  Photo(this.entity, this.path, this.labels, this.createDateTime, this.width,
      this.height);
}

class DataProvider {
  static List<Photo> _photoList = [];

  static List<Photo> getPhotoList() {
    return _photoList;
  }

  static Future<List<Photo>> retrievePhoto() async {
    if (_photoList.isNotEmpty) {
      return _photoList;
    }

    List<AssetPathEntity> entityList =
        await PhotoManager.getAssetPathList(onlyAll: true);

    for (AssetEntity entity in await entityList[0].assetList) {
      var path = (await entity.file)?.path ?? "";
      _photoList.add(Photo(
          entity,
          path,
          (await TensorflowProvider.recognizeObjectInFile(path))
              .take(5)
              .where((element) => element.score > 0.01)
              .map((element) => element.label)
              .toList(),
          entity.createDateTime,
          entity.width,
          entity.height));
    }
    return _photoList;
  }
}
