import 'package:smart_album/model/Photo.dart';

class PhotoState {
  List<Photo> photoList = [];
  List<Photo> photoListWithoutDeleted = [];
  List<Photo> deletedPhotoList = [];
  List<Photo> favoritePhotoList = [];

  PhotoState clone() {
    return PhotoState()
      ..photoList = photoList
      ..photoListWithoutDeleted = photoListWithoutDeleted
      ..deletedPhotoList = deletedPhotoList
      ..favoritePhotoList = favoritePhotoList;
  }
}
