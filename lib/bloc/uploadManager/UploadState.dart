import 'package:smart_album/model/Photo.dart';

class UploadPhoto {
  Photo photo;
  UploadStatus status;

  UploadPhoto(this.photo, this.status);
}

enum UploadStatus { Uploading, Done }

class UploadState {
  bool isUploadAll = false;

  List<UploadPhoto> uploadList = [];

  UploadState clone() {
    return UploadState()
      ..isUploadAll = isUploadAll
      ..uploadList = uploadList;
  }
}
