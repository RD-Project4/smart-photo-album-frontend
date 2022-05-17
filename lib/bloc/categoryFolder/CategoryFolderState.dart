import 'package:smart_album/bloc/SelectableList/SelectableListCubit.dart';
import 'package:smart_album/database/ObjectStore.dart';
import 'package:smart_album/model/Folder.dart';
import 'package:smart_album/model/Photo.dart';

class CategoryFolderState extends SelectableListState<Folder> {
  List<Folder>? categoryList;

  List<Photo>? getPhotoByCategory(Folder category, List<Photo> allPhoto) {
    if (categoryList == null) return null;
    return ObjectStore.get().getPhotoBy(
        labelList: category.labelList,
        locationList: category.locationList,
        dateRange: category.dateRange);
  }

  @override
  SelectableListState<Folder> subClassClone() {
    return CategoryFolderState()..categoryList = categoryList;
  }
}
