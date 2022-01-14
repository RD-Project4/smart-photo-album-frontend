import 'package:meta/meta.dart';

enum Action { setModeView, setModeMultipleSelection }
// 图片列表的模式
enum PhotoListMode {
  View, // 查看模式,默认
  MultipleSelection // 多选模式,长按一张图片进入
}

@immutable
class PhotoListModeState {
  final PhotoListMode _mode;

  get mode => _mode;

  PhotoListModeState(this._mode);

  PhotoListModeState.initState() : _mode = PhotoListMode.View;

  static PhotoListModeState reducer(PhotoListModeState state, action) {
    if (action == Action.setModeView) {
      return PhotoListModeState(PhotoListMode.View);
    } else if (action == Action.setModeMultipleSelection) {
      return PhotoListModeState(PhotoListMode.MultipleSelection);
    }
    return state;
  }
}
