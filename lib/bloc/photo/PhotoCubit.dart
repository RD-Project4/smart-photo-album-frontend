import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:quiver/collection.dart';
import 'package:smart_album/bloc/user/UserCubit.dart';
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

  // Need context because we need to access the UserCubit
  refresh(BuildContext context) async {
    Map<Permission, PermissionStatus> permissionMap =
        await [Permission.storage, Permission.accessMediaLocation].request();
    for (PermissionStatus status in permissionMap.values) {
      if (status.isDenied) {
        throw new Exception(); // TODO 弹出提示
      }
    }

    List<AssetPathEntity> entityList = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        hasAll: false,
        filterOption:
            FilterOptionGroup(imageOption: FilterOption(needTitle: true)));

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

    Map<String, Photo> photoMapFromCloud = new Map();
    try {
      UserCubit userCubit = context.read<UserCubit>();
      List<Photo> photoListFromCloud = await userCubit.getCloudPhotoList();
      photoListFromCloud
          .forEach((photo) => photoMapFromCloud[photo.cloudId!] = photo);
    } catch (e) {
      log("Get cloud photo error, loading local photos");
    }

    // 检查数据库中的照片，是否在本地或云端存在
    List<int> photoToRemoveList = [];
    List<Photo> photoListFromDatabase =
        state.photoList ?? ObjectStore.get().getPhotoList();
    for (Photo photo in photoListFromDatabase) {
      if (photoMapFromLocal.containsKey(photo.entityId)) {
        // no need to update
        photoMapFromLocal.remove(photo.entityId);
      } else if (photoMapFromCloud.containsKey(photo.cloudId)) {
        photoMapFromCloud.remove(photo.entityId);
      } else
        photoToRemoveList.add(photo.id);
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
          entity.title!,
          path,
          labelsString,
          entity.createDateTime,
          entity.width,
          entity.height,
          location,
          false,
          true));
    }
    photoToStoreList.addAll(photoMapFromCloud.values);

    ObjectStore.get().storePhoto(photoToStoreList);
    ObjectStore.get().removePhoto(photoToRemoveList);
  }

  LruMap<String, List<Photo>> cachePhoto = LruMap(maximumSize: 10);

  Map<String, List<Photo>> getPhotoGroupedByLabel(List<String> labelList) {
    Map<String, List<Photo>> map = Map();
    labelList.forEach((label) {
      if (cachePhoto.containsKey(label))
        map[label] = cachePhoto[label]!;
      else {
        var photoList = ObjectStore.get().getPhotoBy(labelList: [label]);
        if (photoList.length < 1) return;
        map[label] = photoList;
      }
    });
    cachePhoto.addAll(map);
    return map;
  }
}
