import 'dart:convert';
import 'dart:io';

import 'CommonUtil.dart';

/// 用于图片收藏
class FavoritesUtil {
  static Future<List> getFavoritesList() async {
    final _dirPath = await CommonUtil.getDirPath();
    final _filePath = '$_dirPath/favorite_list.json';

    File jsonFile = new File(_filePath);
    if (!jsonFile.existsSync()) {
      jsonFile.createSync();
      print('favorite_list.json 文件创建成功！');
      return [];
    } else {
      print('favorite_list.json 文件已存在');
      String jsonStr = await jsonFile.readAsString();
      return json.decode(jsonStr) as List;
    }
  }

  /// 判断图片是否被收藏
  static Future<bool> isFavorite(id) async {
    final list = await getFavoritesList();
    return list.contains(id);
  }

  static Future<bool> addToFavoritesList(id) async {
    if (await isFavorite(id)) {
      return false;
    }

    final _dirPath = await CommonUtil.getDirPath();
    final _filePath = '$_dirPath/favorite_list.json';

    File jsonFile = new File(_filePath);
    var list = await getFavoritesList();
    list.add(id);

    jsonFile.writeAsString(jsonEncode(list));
    return true;
  }
}
