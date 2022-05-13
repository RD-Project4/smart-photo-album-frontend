import 'package:smart_album/bloc/SelectableList/SelectableListCubit.dart';
import 'package:smart_album/database/ObjectStore.dart';
import 'package:smart_album/model/Category.dart';
import 'package:smart_album/model/Photo.dart';

class CategoryFolderState extends SelectableListState<Category> {
  List<Category>? categoryList;

  List<Photo>? getPhotoByCategory(Category category, List<Photo> allPhoto) {
    if (categoryList == null) return null;
    return ObjectStore.get().getPhotoBy(
        labelList: category.labelList,
        locationList: category.locationList,
        dateRange: category.dateRange);
  }

  @override
  SelectableListState<Category> subClassClone() {
    return CategoryFolderState()..categoryList = categoryList;
  }
}
