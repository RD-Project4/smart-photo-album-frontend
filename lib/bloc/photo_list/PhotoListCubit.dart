import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:smart_album/model/Photo.dart';

part 'PhotoListState.dart';

enum PhotoListMode { View, Selection }

class PhotoListCubit extends Cubit<PhotoListState> {
  PhotoListCubit() : super(PhotoListState.init());

  void setModeView() => emit(state.clone()..mode = PhotoListMode.View);

  void setModeSelection() =>
      emit(state.clone()..mode = PhotoListMode.Selection);

  void addSelectedPhoto(Photo photo) {
    var newList = state.clone().selectedPhotos;
    newList.add(photo);
    emit(state.clone()..selectedPhotos = newList);
  }

  void removeSelectedPhoto(Photo photo) {
    var newList = state.clone().selectedPhotos;
    newList.remove(photo);
    emit(state.clone()..selectedPhotos = newList);
  }

  // 清空选中列表
  void clearSelectedPhotos() {
    emit(state.clone()..selectedPhotos = <Photo>[]);
  }

  void setPhotoList(list) {
    state.photos = list;
  }

  setGroupBy(GroupByOption groupBy) => emit(state.clone()..groupBy = groupBy);

  // The map indicts the photos after group by
  // See the example in lib\SearchResult.dart
  Map<dynamic, List<Photo>> groupByPhotos(List<Photo> photoList) {
    Map<dynamic, List<Photo>> groupedPhotos;
    switch (state.groupBy) {
      case GroupByOption.CREATE_TIME:
        groupedPhotos = photoList.groupListsBy((photo) {
          DateTime dateTime = photo.creationDateTime;
          return DateTime(dateTime.year, dateTime.month, dateTime.day);
        });
        break;
      case GroupByOption.LABEL:
        groupedPhotos = photoList.groupListsBy(
            (photo) => photo.labels.length > 0 ? photo.labels[0] : "Unlabeled");
        break;
      case GroupByOption.LOCATION:
        groupedPhotos = photoList
            .where((photo) => photo.location != null)
            .groupListsBy((photo) => photo.location!);
        break;
      case GroupByOption.IMAGE_SIZE:
        groupedPhotos = photoList.groupListsBy((photo) =>
            (photo.width > 800 && photo.height > 800) ? "Large" : "Small");
        break;
      default:
        groupedPhotos = Map();
    }
    return groupedPhotos;
  }
}
