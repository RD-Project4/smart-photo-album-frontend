import 'dart:convert';
import 'dart:io';

import 'package:smart_album/Events.dart';

import 'CommonUtil.dart';
import 'Global.dart';

/// 用于图片收藏
class FavoritesUtil {
  static Future<File> getFavoritesListFile() async{
    final _dirPath = await CommonUtil.getDirPath();
    final _filePath = '$_dirPath/favorite_list.json';

    return new File(_filePath);
  }


  static Future<List> getFavoritesList() async {

    File jsonFile = await getFavoritesListFile();
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

    File jsonFile = await getFavoritesListFile();

    var list = await getFavoritesList();
    list.add(id);

    jsonFile.writeAsString(jsonEncode(list));
    Global.eventBus.fire(RefreshFavoritesEvent());
    return true;
  }

  static Future<bool> removeFromFavoritesList(id) async {
    if(!(await isFavorite(id))){
      return false;
    }

    File jsonFile = await getFavoritesListFile();

    var list = await getFavoritesList();
    list.remove(id);
    jsonFile.writeAsString(jsonEncode(list));
    Global.eventBus.fire(RefreshFavoritesEvent());
    return true;
  }
}
