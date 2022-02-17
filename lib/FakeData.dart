import 'package:photo_manager/photo_manager.dart';
import 'package:smart_album/tensorflow/TensorflowProvider.dart';
import 'package:smart_album/util/Global.dart';

class DataProvider {
  static List<Map> _photoList = [];

  static List<Map> getElements() {
    return _photoList;
  }

  static Future<void> setElements(List<AssetEntity> elements) async {
    if (_photoList.isNotEmpty) {
      return;
    }

    for (AssetEntity entity in elements) {
      var path =
          Global.ROOT_PATH + (entity.relativePath ?? "") + (entity.title ?? "");
      _photoList.add({
        "entity": entity,
        "path": path,
        "labels": (await TensorflowProvider.recognizeObjectInFile(path))
            .where((element) => element.score > 1000)
            .take(5)
            .map((element) => element.label)
            .toList()
      });
    }
  }
}
