part of 'PhotoListCubit.dart';

class PhotoListState {
  late PhotoListMode mode;
  late List<Photo> selectedPhotos;
  late List<Photo> photos;

  PhotoListState init() {
    return PhotoListState()
      ..mode = PhotoListMode.View
      ..selectedPhotos = []
      ..photos = [];
  }

  PhotoListState clone() {
    return PhotoListState()
      ..mode = mode
      ..selectedPhotos = selectedPhotos
      ..photos = photos;
  }
}
