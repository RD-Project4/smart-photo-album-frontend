part of 'PhotoListCubit.dart';

class PhotoListState {
  late PhotoListMode mode;
  late List<AssetEntity> selectedPhotos;

  PhotoListState init() {
    return PhotoListState()
      ..mode = PhotoListMode.View
      ..selectedPhotos = [];
  }

  PhotoListState clone() {
    return PhotoListState()
      ..mode = mode
      ..selectedPhotos = selectedPhotos;
  }
}
