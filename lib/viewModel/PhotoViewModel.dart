import 'package:photo_manager/photo_manager.dart';
import 'package:smart_album/database/ObjectStore.dart';
import 'package:smart_album/database/Photo.dart';
import 'package:smart_album/tensorflow/TensorflowProvider.dart';
import 'package:smart_album/util/PermissionUtil.dart';
import 'package:smart_album/widgets/QueryStreamBuilder.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

class PhotoViewModel {
  static refresh() async {
    if (!(await PermissionUtil.checkStoragePermission())) {
      var res = await PermissionUtil.requestStoragePermission();
      if (res == false) {
        throw new Error(); // TODO 提示用户没有权限
      }
    }

    // 检查数据库中的照片，是否在本地或云端存在
    List<AssetPathEntity> entityList = await PhotoManager.getAssetPathList(
        type: RequestType.image, hasAll: false);

    // Filter only DCIM folder
    List<AssetEntity> dcimFolder = [];
    for (AssetPathEntity entity in entityList) {
      if (entity.name == "DCIM") {
        dcimFolder = await entity.assetList;
        break;
      }
    }

    Map<int, AssetEntity> photoMapFromLocal = new Map();
    for (AssetEntity photo in dcimFolder) {
      photoMapFromLocal[int.parse(photo.id)] = photo;
    }

    List<int> photoToRemoveList = [];
    List<Photo> photoListFromDataset = ObjectStore.get().getPhoto();
    for (Photo photo in photoListFromDataset) {
      if (photoMapFromLocal.containsKey(photo.entity_id)) {
        // no need to update
        photoMapFromLocal.remove(photo.entity_id);
      } else if (!photo.is_cloud) {
        photoToRemoveList.add(photo.id);
      }
    }

    List<Photo> photoToStoreList = [];
    for (AssetEntity entity in photoMapFromLocal.values) {
      var path = (await entity.file)?.path;
      if (path == null) continue;
      List<Category> labels =
          (await TensorflowProvider.recognizeObjectInFile(path));
      var labelsString = labels
          .take(3)
          .where((e) => e.score > 0.0001)
          .map((e) => e.label)
          .toList();
      photoToStoreList.add(Photo(int.parse(entity.id), path, labelsString,
          entity.createDateTime, entity.width, entity.height));
    }

    ObjectStore.get().storePhoto(photoToStoreList);
    ObjectStore.get().removePhoto(photoToRemoveList);
  }

  static QueryStream<Photo> getPhotoList() {
    return ObjectStore.get().getPhotoStream();
  }

  static savePhoto() {}

  static List<Photo> getPhotoBy({List<String>? labelList, DateTime? dateTime}) {
    return ObjectStore.get()
        .getPhotoBy(labelList: labelList, dateTime: dateTime);
  }
}
