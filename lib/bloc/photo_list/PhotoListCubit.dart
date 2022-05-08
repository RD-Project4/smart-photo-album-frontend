import 'package:bloc/bloc.dart';
import 'package:smart_album/DataProvider.dart';

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
    print('setPhotoList');
    emit(state.clone()..photos = list);
  }
}
