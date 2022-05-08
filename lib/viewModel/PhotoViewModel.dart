import 'package:photo_manager/photo_manager.dart';
import 'package:smart_album/database/ObjectStore.dart';
import 'package:smart_album/database/Photo.dart';
import 'package:smart_album/tensorflow/TensorflowProvider.dart';
import 'package:smart_album/util/PermissionUtil.dart';
import 'package:smart_album/widgets/QueryStreamBuilder.dart';

class PhotoViewModel {
  static init() async {
    if (!(await PermissionUtil.checkStoragePermission())) {
      var res = await PermissionUtil.requestStoragePermission();
      if (res == false) {
        throw new Error(); // TODO 提示用户没有权限
      }
    }

    // 检查数据库中的照片，是否在本地或云端存在
    List<AssetPathEntity> entityList =
        await PhotoManager.getAssetPathList(onlyAll: true);

    Map<int, AssetEntity> photoMapFromLocal = new Map();
    for (AssetEntity photo in await entityList[0].assetList) {
      photoMapFromLocal[int.parse(photo.id)] = photo;
    }

    List<int> photoToRemoveList = [];
    List<Photo> photoListFromDataset = ObjectStore.get().getPhoto();
    for (Photo photo in photoListFromDataset) {
      if (photoMapFromLocal.containsKey(photo.entity_id))
        photoMapFromLocal.remove(photo.entity_id);
      else if (!photo.is_cloud) {
        photoToRemoveList.add(photo.id);
      }
    }

    List<Photo> photoToStoreList = [];
    for (AssetEntity entity in photoMapFromLocal.values) {
      var path = (await entity.file)?.path ?? "";
      photoToStoreList.add(Photo(
          int.parse(entity.id),
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

    ObjectStore.get().storePhoto(photoToStoreList);
    ObjectStore.get().removePhoto(photoToRemoveList);
  }

  static QueryStream<Photo> getPhotoList() {
    return ObjectStore.get().getPhotoStream();
  }

  static savePhoto() {}
}
