part of 'PhotoListCubit.dart';

enum GroupByOption { CREATE_TIME, LABEL, LOCATION, IMAGE_SIZE }

class PhotoListState {
  late PhotoListMode mode;
  late List<Photo> selectedPhotos;
  late List<Photo> photos;

  GroupByOption groupBy = GroupByOption.CREATE_TIME;

  static PhotoListState init() {
    return PhotoListState()
      ..mode = PhotoListMode.View
      ..selectedPhotos = []
      ..photos = []
      ..groupBy = GroupByOption.CREATE_TIME;
  }

  PhotoListState clone() {
    return PhotoListState()
      ..mode = mode
      ..selectedPhotos = selectedPhotos
      ..photos = photos
      ..groupBy = groupBy;
  }
}
