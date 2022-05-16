import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_album/api/api.dart';
import 'package:smart_album/bloc/photo/PhotoCubit.dart';
import 'package:smart_album/bloc/uploadManager/UploadState.dart';
import 'package:smart_album/database/ObjectStore.dart';
import 'package:smart_album/model/Photo.dart';

class UploadCubit extends Cubit<UploadState> {
  UploadCubit() : super(UploadState());

  setAutoBackup() {
    emit((state..isUploadAll = !state.isUploadAll).clone());
  }

  uploadPhoto(BuildContext context, Photo photo) async {
    state.uploadList.add(UploadPhoto(photo, UploadStatus.Uploading));
    emit(state.clone());
    await Api.get().uploadPic([photo]);
    for (UploadPhoto tuple in state.uploadList) {
      if (tuple.photo == photo) {
        tuple.status = UploadStatus.Done;
        break;
      }
    }
    emit(state.clone());
    context.read<PhotoCubit>().refresh(context);
    ObjectStore.get().storePhoto(photo);
  }

  uploadPhotoList(BuildContext context, List<Photo> photoList) async {
    state.uploadList.addAll(
        photoList.map((photo) => UploadPhoto(photo, UploadStatus.Uploading)));
    emit(state.clone());
    await Api.get().uploadPic(photoList);
    for (UploadPhoto tuple in state.uploadList) {
      for (Photo photo in photoList) {
        if (tuple.photo == photo) {
          tuple.status = UploadStatus.Done;
          break;
        }
      }
    }
    context.read<PhotoCubit>().refresh(context);
    emit(state.clone());
  }

  removePhotoFromCloud(BuildContext context, Photo photo) async {
    await Api.get().deletePic(photo);
    state.uploadList.removeWhere((tuple) => tuple.photo == photo);
    photo.isCloud = false;
    context.read<PhotoCubit>().refresh(context);
    emit(state.clone());
  }

  removeUploadedPhotoFromCloud(BuildContext context) async {
    for (var tuple in state.uploadList.where((tuple) => tuple.photo.isCloud)) {
      await Api.get().deletePic(tuple.photo);
      tuple.photo.isCloud = false;
    }
    state.uploadList.clear();
    context.read<PhotoCubit>().refresh(context);
    emit(state.clone());
  }
}
