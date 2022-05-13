import 'package:smart_album/database/ObjectStore.dart';
import 'package:smart_album/model/Category.dart';
import 'package:smart_album/model/Photo.dart';

class CategoryFolderState {
  List<Category>? categoryList;

  CategoryFolderState clone() {
    return CategoryFolderState()..categoryList = categoryList;
  }

  Map<String, List<Photo>>? groupPhotoByCategory(List<Photo> allPhoto) {
    if (categoryList == null) return null;
    Map<String, List<Photo>> map = Map();
    categoryList!.forEach((category) {
      map[category.name] = ObjectStore.get().getPhotoBy(
          labelList: category.labelList,
          locationList: category.locationList,
          dateRange: category.dateRange);
    });
    return map;
  }
}
