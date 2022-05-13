import 'package:smart_album/model/Photo.dart';

class PhotoState {
  List<Photo>? photoList = [];

  PhotoState clone() {
    return PhotoState()..photoList = photoList;
  }
}
