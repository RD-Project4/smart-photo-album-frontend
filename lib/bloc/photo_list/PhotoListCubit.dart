import 'package:bloc/bloc.dart';

enum PhotoListMode { View, Selection }

class PhotoListCubit extends Cubit<PhotoListMode> {
  PhotoListCubit() : super(PhotoListMode.View);

  void setModeView() => emit(PhotoListMode.View);

  void setModeSelection() => emit(PhotoListMode.Selection);

  // 切换模式（不确定将来是否只有这两个模式，如果有多个则可以通过传参来解决）
  void switchMode() {
    if (state == PhotoListMode.View) {
      setModeSelection();
    } else if (state == PhotoListMode.Selection) {
      setModeView();
    }
  }
}
