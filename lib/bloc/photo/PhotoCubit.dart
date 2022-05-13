import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:smart_album/database/ObjectStore.dart';
import 'package:smart_album/model/Photo.dart';
import 'package:smart_album/tensorflow/TensorflowProvider.dart';
import 'package:smart_album/util/CommonUtil.dart';
import 'package:smart_album/util/GeoUtil.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

import 'PhotoState.dart';

class PhotoCubit extends Cubit<PhotoState> {
  PhotoCubit() : super(PhotoState()) {
    ObjectStore.get().getPhotoStream().listen((photoList) {
      emit(state.clone()..photoList = photoList);
    });
  }

  refresh() async {
    Map<Permission, PermissionStatus> permissionMap =
        await [Permission.storage, Permission.accessMediaLocation].request();
    for (PermissionStatus status in permissionMap.values) {
      if (status.isDenied) {
        throw new Exception(); // TODO 弹出提示
      }
    }

    // 检查数据库中的照片，是否在本地或云端存在
    List<AssetPathEntity> entityList = await PhotoManager.getAssetPathList(
        type: RequestType.image, hasAll: false);

    // Filter only DCIM folder
    List<AssetEntity> dcimFolder = [];
    for (AssetPathEntity entity in entityList) {
      if (entity.name == "DCIM") {
        dcimFolder =
            await entity.getAssetListRange(start: 0, end: entity.assetCount);
        break;
      }
    }

    Map<String, AssetEntity> photoMapFromLocal = new Map();
    for (AssetEntity photo in dcimFolder) {
      photoMapFromLocal[photo.id] = photo;
    }

    List<int> photoToRemoveList = [];
    List<Photo> photoListFromDataset =
        state.photoList ?? ObjectStore.get().getPhotoList();
    for (Photo photo in photoListFromDataset) {
      if (photoMapFromLocal.containsKey(photo.entityId)) {
        // no need to update
        photoMapFromLocal.remove(photo.entityId);
      } else if (!photo.isCloud) {
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

      var latLng = await entity.latlngAsync();
      String? location;
      if (CommonUtil.notNonOr0(latLng.latitude) &&
          CommonUtil.notNonOr0(latLng.longitude))
        location = await GeoUtil.locationFromCoordinates(
            latLng.latitude!, latLng.longitude!);

      photoToStoreList.add(Photo(
          entity.id,
          path,
          labelsString,
          entity.createDateTime,
          entity.width,
          entity.height,
          location,
          false,
          true));
    }

    ObjectStore.get().storePhoto(photoToStoreList);
    ObjectStore.get().removePhoto(photoToRemoveList);
  }
}
