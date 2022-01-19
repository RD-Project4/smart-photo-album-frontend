part of 'PhotoListCubit.dart';

class PhotoListState {
  late PhotoListMode mode;
  late List<AssetEntity> selectedPhotos;
  late List<AssetEntity> photos;

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
